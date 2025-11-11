package org.example.qlst.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;
import org.example.qlst.dao.MembershipCardDAO;
import org.example.qlst.dao.UserDAO;
import org.example.qlst.model.MembershipCard;
import org.example.qlst.model.User;

import java.io.IOException;

@WebServlet("/membership-card")
public class MembershipCardServlet extends HttpServlet {

    private MembershipCardDAO membershipCardDAO = new MembershipCardDAO();
    private UserDAO userDAO = new UserDAO();

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("user") == null) {
            response.sendRedirect("Login.jsp?error=unauthorized");
            return;
        }

        User user = (User) session.getAttribute("user");
        String action = request.getParameter("action");

        if ("create".equalsIgnoreCase(action)) {

            String name = request.getParameter("name");
            String email = request.getParameter("email");
            String phone = request.getParameter("phone");

            user.setName(name);
            user.setEmail(email);
            user.setPhone(phone);
            userDAO.updateUserInfo(user);

            MembershipCard existingCard = membershipCardDAO.findByUserId(user.getId());
            if (existingCard != null) {
                response.sendRedirect("InforFormView.jsp?status=exists");
                return;
            }

            MembershipCard card = new MembershipCard();
            card.setCustomerId(user.getId());
            card.setStatus("active");
            card.setPoint(0);

            boolean created = membershipCardDAO.createCard(card);

            if (created) {
                response.sendRedirect("InforFormView.jsp?status=success");
            } else {
                response.sendRedirect("InforFormView.jsp?status=error");
            }
        } else {
            response.sendRedirect("InforFormView.jsp?status=invalid_action");
        }
    }
}