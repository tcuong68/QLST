package org.example.qlst.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.qlst.dao.UserDAO;
import org.example.qlst.dao.StaffDAO;
import org.example.qlst.model.User;

import java.io.IOException;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {

    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        request.getRequestDispatcher("/Login.jsp").forward(request, response);
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String username = request.getParameter("username");
        String password = request.getParameter("password");

        User user = userDAO.login(username, password);

        if (user != null) {
            HttpSession session = request.getSession();
            session.setAttribute("user", user);

            String role = user.getRole();
            String position = null;

            if ("staff".equalsIgnoreCase(role)) {
                StaffDAO staffDAO = new StaffDAO();
                position = staffDAO.getStaffPosition(user.getId());
                session.setAttribute("position", position);
            }

            if ("customer".equalsIgnoreCase(role)) {
                response.sendRedirect("MainScreenView.jsp");

            } else if ("staff".equalsIgnoreCase(role)) {

                if (position != null && (position.equalsIgnoreCase("manager") || position.equalsIgnoreCase("warehouse"))) {
                    response.sendRedirect("WarehouseStaffView.jsp");
                } else {

                    response.sendRedirect("Login.jsp?error=unauthorized");
                }
            } else {
                response.sendRedirect("Login.jsp?error=role");
            }

        } else {
            response.sendRedirect("Login.jsp?error=invalid");
        }
    }
}