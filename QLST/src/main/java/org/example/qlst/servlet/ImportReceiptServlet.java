package org.example.qlst.servlet;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.qlst.model.User;
import org.example.qlst.model.ImportReceiptDetail;
import org.example.qlst.model.ImportReceipt;
import org.example.qlst.dao.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.Date;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

@WebServlet("/importReceipt")
public class ImportReceiptServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        @SuppressWarnings("unchecked")
        List<ImportReceiptDetail> items = (List<ImportReceiptDetail>) session.getAttribute("pendingImportItems");

        if (items == null || items.isEmpty()) {
            request.setAttribute("error", "Danh sách nhập đang trống.");
            request.setAttribute("hasSearched", true);
            request.setAttribute("products", new ArrayList<>());
            request.getRequestDispatcher("/SearchProductView.jsp").forward(request, response);
            return;
        }

        Integer supplierId = (Integer) session.getAttribute("selectedSupplierId");
        if (supplierId == null) {
            String supplierName = (String) session.getAttribute("selectedSupplierName");
            if (supplierName != null && !supplierName.trim().isEmpty()) {
                try {
                    supplierId = new SupplierDAO().getIdByName(supplierName);
                } catch (Exception ignore) {}
            }
        }

        if (supplierId == null) {
            request.setAttribute("error", "Không xác định được nhà cung cấp (thiếu supplierId). Vui lòng chọn lại.");
            request.getRequestDispatcher("/ImportReceiptView.jsp").forward(request, response);
            return;
        }

        User user = (User) session.getAttribute("user");
        Integer staffId = new StaffDAO().getStaff(user.getId());
        if (staffId == null) {
            request.setAttribute("error", "Không xác định được nhân viên tạo phiếu.");
            request.getRequestDispatcher("/ImportReceiptView.jsp").forward(request, response);
            return;
        }

        Connection conn = null;
        try {
            conn = DAO.openConnection();
            conn.setAutoCommit(false);

            ImportReceiptDAO receiptDAO = new ImportReceiptDAO(conn);
            ImportReceipt receipt = new ImportReceipt();
            receipt.setDate(new Date(System.currentTimeMillis()));
            receipt.setSupplierId(supplierId);
            receipt.setStaffId(staffId);
            double totalPrice = 0.0;
            for (ImportReceiptDetail item : items) {
                totalPrice += item.getPrice() * item.getQuantity();
            }
            receipt.setTotalPrice(totalPrice);
            int importReceiptId = receiptDAO.importProduct(receipt);
            if (importReceiptId <= 0) {
                throw new RuntimeException("Không thể tạo phiếu nhập hàng");
            }

            ImportReceiptDetailDAO detailDAO = new ImportReceiptDetailDAO(conn);
            for (ImportReceiptDetail item : items) {
                item.setImportReceiptId(importReceiptId);
                boolean itemAdded = detailDAO.addImportReceiptDetail(item);
                if (!itemAdded) {
                    throw new RuntimeException("Không thể thêm chi tiết sản phẩm ID: " + item.getProductId());
                }
            }
            ProductDAO productDAO = new ProductDAO(conn);
            for (ImportReceiptDetail item : items) {
                boolean stockUpdated = productDAO.updateStockAfterImport(item.getProductId(), item.getQuantity());
                if (!stockUpdated) {
                    throw new RuntimeException("Không thể cập nhật tồn kho cho sản phẩm ID: " + item.getProductId());
                }
            }

            conn.commit();

            session.removeAttribute("pendingImportItems");
            session.removeAttribute("pendingImportNames");
            session.setAttribute("lastSavedImportReceiptId", importReceiptId);
            request.setAttribute("importReceiptId", importReceiptId);
            request.setAttribute("success", "Đã tạo phiếu nhập #" + importReceiptId + " thành công.");

            session.removeAttribute("pendingImportItems");
            session.removeAttribute("pendingImportNames");
            session.setAttribute("lastSavedImportReceiptId", importReceiptId);

            request.setAttribute("importReceiptId", importReceiptId);
            request.setAttribute("success", "Đã tạo phiếu nhập #" + importReceiptId + " thành công.");

            request.getRequestDispatcher("/ImportReceiptView.jsp").forward(request, response);

        } catch (Exception e) {

            if (conn != null) {
                try {
                    conn.rollback();
                } catch (SQLException rollbackEx) {
                    System.err.println("Lỗi rollback: " + rollbackEx.getMessage());
                }
            }
            e.printStackTrace();
            request.setAttribute("error", "Lỗi nghiêm trọng khi lưu phiếu: " + e.getMessage());
            request.getRequestDispatcher("/ImportReceiptView.jsp").forward(request, response);
        } finally {
            if (conn != null) {
                try {
                    conn.setAutoCommit(true);
                    conn.close();
                } catch (SQLException closeEx) {
                    System.err.println("Lỗi đóng connection: " + closeEx.getMessage());
                }
            }
        }
    }
}