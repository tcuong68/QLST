package org.example.qlst.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.qlst.dao.ProductDAO;
import org.example.qlst.model.ImportReceiptDetail;
import org.example.qlst.model.Product;

import java.io.IOException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/product")
public class ProductServlet extends HttpServlet {
    private ProductDAO productDAO;

    @Override
    public void init() throws ServletException {
        productDAO = new ProductDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("search".equals(action)) {
            String query = request.getParameter("q");
            List<Product> products;

            if (query == null) {
                query = "";
            }

            products = productDAO.searchProduct(query.trim());

            request.setAttribute("products", products);
        } else if ("clearPending".equals(action)) {
            session.removeAttribute("pendingImportItems");
            session.removeAttribute("pendingImportNames");
            session.removeAttribute("lastSavedGrnId"); // 'grn' là GoodsReceiptNote, có thể bạn muốn đổi tên này
            request.setAttribute("success", "Đã xóa danh sách nhập.");
        }

        String supplierName = request.getParameter("supplierName");
        if (supplierName != null) {
            session.setAttribute("selectedSupplierName", supplierName);
        }
        String supplierIdParam = request.getParameter("supplierId");
        if (supplierIdParam != null && !supplierIdParam.trim().isEmpty()) {
            try {
                int sid = Integer.parseInt(supplierIdParam.trim());
                session.setAttribute("selectedSupplierId", sid);
            } catch (NumberFormatException ignore) {
            }
        }

        request.getRequestDispatcher("/SearchProductView.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String action = request.getParameter("action");
        if ("add".equalsIgnoreCase(action)) {
            handleAddProduct(request, response);
            return;
        }
        if ("prepareImport".equalsIgnoreCase(action)) {
            handlePrepareImport(request, response);
            return;
        }
        if ("finalizeImport".equalsIgnoreCase(action)) {
            handleConfirmImport(request, response);
            return;
        }

        response.sendRedirect("product?action=search");
    }


    private void handleConfirmImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        java.util.List<ImportReceiptDetail> items = (java.util.List<ImportReceiptDetail>) session.getAttribute("pendingImportItems");
        if (items == null || items.isEmpty()) {
            request.setAttribute("error", "Danh sách nhập đang trống. Vui lòng thêm sản phẩm trước khi hoàn thành.");
            request.setAttribute("hasSearched", true);
            request.setAttribute("products", new java.util.ArrayList<Product>());
            request.getRequestDispatcher("/SearchProductView.jsp").forward(request, response);
            return;
        }

        request.getRequestDispatcher("/ImportReceiptView.jsp").forward(request, response);
    }

    private void handleAddProduct(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String code = safeTrim(request.getParameter("code"));
        String name = safeTrim(request.getParameter("name"));
        String unit = safeTrim(request.getParameter("unit"));
        String description = safeTrim(request.getParameter("description"));
        String priceStr = safeTrim(request.getParameter("price"));
        String error = null;
        if (code == null || code.length() < 3) {
            error = "Mã sản phẩm (SKU) phải có ít nhất 3 ký tự";
        } else if (name == null || name.length() < 3) {
            error = "Tên sản phẩm phải có ít nhất 3 ký tự";
        } else if (unit == null || unit.isEmpty()) {
            error = "Đơn vị tính không được để trống";
        }

        double price = 0;
        if (error == null) {
            try {
                price = Double.parseDouble(priceStr);
                if (price <= 0) error = "Giá bán phải lớn hơn 0";
            } catch (Exception e) {
                error = "Giá bán không hợp lệ";
            }
        }


        int quantity = 0;

        if (error != null) {
            request.setAttribute("error", error);
            // SỬA LỖI: Tên file JSP
            request.getRequestDispatcher("/AddProductView.jsp").forward(request, response);
            return;
        }

        Product product = new Product();
        product.setName(name);
        product.setPrice(price);
        product.setQuantity(quantity);

        boolean ok = productDAO.addProduct(product);
        if (ok) {
            request.setAttribute("success", "Đã thêm sản phẩm mới: " + name);
            request.getRequestDispatcher("/SearchProductView.jsp").forward(request, response);
        } else {
            request.setAttribute("error", "Có lỗi khi lưu sản phẩm. Vui lòng thử lại");
            request.getRequestDispatcher("/AddProductView.jsp").forward(request, response);
        }
    }

    private String safeTrim(String s) {
        return s == null ? null : s.trim();
    }

    private void handlePrepareImport(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String[] ids = request.getParameterValues("itemId");
        String[] names = request.getParameterValues("itemName");
        String[] prices = request.getParameterValues("importPrice");
        String[] qtys = request.getParameterValues("importQty");

        HttpSession session = request.getSession();
        java.util.List<ImportReceiptDetail> items = (java.util.List<ImportReceiptDetail>) session.getAttribute("pendingImportItems");
        if (items == null) {
            items = new java.util.ArrayList<>();
        }

        java.util.Map<Integer, String> nameMap = (java.util.Map<Integer, String>) session.getAttribute("pendingImportNames");
        if (nameMap == null) {
            nameMap = new java.util.HashMap<>();
        }

        int addedCount = 0;
        if (ids != null && prices != null && qtys != null) {
            int n = Math.min(ids.length, Math.min(prices.length, qtys.length));
            for (int i = 0; i < n; i++) {
                try {
                    String idRaw = ids[i] != null ? ids[i].trim() : "";
                    String priceRaw = prices[i] != null ? prices[i].trim() : "";
                    String qtyRaw = qtys[i] != null ? qtys[i].trim() : "";

                    if (idRaw.isEmpty() || priceRaw.isEmpty() || qtyRaw.isEmpty()) {
                        continue; // Bỏ qua dòng không đầy đủ dữ liệu
                    }

                    int id = Integer.parseInt(idRaw);
                    double price = Double.parseDouble(priceRaw);
                    int qty = Integer.parseInt(qtyRaw);

                    ImportReceiptDetail importReceiptDetail = new ImportReceiptDetail();
                    importReceiptDetail.setProductId(id); // Đây là ID sản phẩm
                    importReceiptDetail.setPrice(price);
                    importReceiptDetail.setQuantity(qty);
                    importReceiptDetail.setImportReceiptId(0); // chưa có phiếu
                    items.add(importReceiptDetail);
                    addedCount++;
                    if (names != null && i < names.length) {
                        String nameRaw = names[i] != null ? names[i].trim() : "";
                        if (!nameRaw.isEmpty()) {
                            nameMap.put(id, nameRaw);
                        }
                    }
                } catch (Exception e) {
                    System.err.println("❌ Lỗi parse dữ liệu nhập hàng tại dòng " + (i + 1) + ": " + e.getMessage());
                }
            }
        }

        session.setAttribute("pendingImportItems", items);
        session.setAttribute("pendingImportNames", nameMap);

        if (addedCount > 0) {
            request.setAttribute("success", "Đã thêm " + addedCount + " sản phẩm vào danh sách nhập.");
        } else {
            request.setAttribute("error", "Không có sản phẩm nào được thêm. Vui lòng kiểm tra lại dữ liệu.");
        }

        request.setAttribute("hasSearched", true);

        List<Product> products = new ArrayList<>();
        request.setAttribute("products", products);

        request.getRequestDispatcher("/SearchProductView.jsp").forward(request, response);
    }
}