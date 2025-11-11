package org.example.qlst.dao;

import org.example.qlst.model.MembershipCard;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class MembershipCardDAO extends DAO {

    public MembershipCardDAO() {
        super();
    }

    public boolean createCard(MembershipCard card) {
        String query = "INSERT INTO tblMembershipCard (UserId, Status, Point) VALUES (?, ?, ?)";
        try (PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setInt(1, card.getCustomerId());       // hoặc getCustomerId() nếu bạn đặt tên vậy trong model
            stmt.setString(2, card.getStatus());    // ví dụ: "active", "inactive", "pending"
            stmt.setInt(3, card.getPoint());

            int rows = stmt.executeUpdate();
            return rows > 0;

        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public MembershipCard findByUserId(int customerId) {
        String query = "SELECT * FROM tblMembershipCard WHERE UserId = ?";
        try (PreparedStatement stmt = con.prepareStatement(query)) {
            stmt.setInt(1, customerId);
            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    MembershipCard card = new MembershipCard();
                    card.setCustomerId(rs.getInt("CustomerId"));
                    card.setStatus(rs.getString("Status"));
                    card.setPoint(rs.getInt("Point"));
                    return card;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }
}
