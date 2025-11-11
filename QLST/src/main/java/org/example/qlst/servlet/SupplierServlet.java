package org.example.qlst.servlet;


import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.qlst.dao.SupplierDAO;
import org.example.qlst.model.Supplier;

import java.io.IOException;
import java.util.List;

@WebServlet("/supplier")
public class SupplierServlet extends HttpServlet {
    private SupplierDAO supplierDAO;

    @Override
    public void init() throws ServletException {
        supplierDAO = new SupplierDAO();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Kiểm tra session
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login.jsp");
            return;
        }

        String action = request.getParameter("action");

        if ("search".equals(action)) {
            String query = request.getParameter("q");
            List<Supplier> suppliers;

            if (query != null && !query.trim().isEmpty()) {
                suppliers = supplierDAO.searchByName(query.trim());
            } else {
                suppliers = supplierDAO.getAllSuppliers();
            }
            request.setAttribute("suppliers", suppliers);
        }

        request.getRequestDispatcher("/SearchSupplierView.jsp").forward(request, response);
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

        if ("add".equals(action)) {
            String name = request.getParameter("name");
            String phone = request.getParameter("phone");
            String email = request.getParameter("email");
            String address = request.getParameter("address");

            if (name == null || name.trim().isEmpty()) {
                request.setAttribute("error", "Tên nhà cung cấp không được để trống!");
                request.getRequestDispatcher("/AddSupplierView.jsp").forward(request, response);
                return;
            }

            if (supplierDAO.isSupplierExists(name.trim())) {
                request.setAttribute("error", "Nhà cung cấp đã tồn tại!");
                request.getRequestDispatcher("/AddSupplierView.jsp").forward(request, response);
                return;
            }

            Supplier newSupplier = new Supplier();
            newSupplier.setName(name.trim());
            newSupplier.setPhone(phone != null ? phone.trim() : "");
            newSupplier.setEmail(email != null ? email.trim() : "");
            newSupplier.setAddress(address != null ? address.trim() : "");

            boolean success = supplierDAO.addSupplier(newSupplier);

            if (success) {
                request.setAttribute("newSupplier", newSupplier);
                request.getRequestDispatcher("/SearchSupplierView.jsp").forward(request, response);
            } else {
                request.setAttribute("error", "Có lỗi xảy ra khi thêm nhà cung cấp!");
                request.getRequestDispatcher("/AddSupplierView.jsp").forward(request, response);
            }
        }
    }
}

