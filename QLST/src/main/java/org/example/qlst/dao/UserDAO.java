package org.example.qlst.dao;

import org.example.qlst.model.User;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

public class UserDAO extends DAO{
    public UserDAO() {
        super();
    }
    public boolean updateUserInfo(User user) {
        String sql = "UPDATE tblUser SET Fullname = ?, Email = ?, Phone = ? WHERE UserId = ?";
        try (PreparedStatement stmt = con.prepareStatement(sql)) {
            stmt.setString(1, user.getName());
            stmt.setString(2, user.getEmail());
            stmt.setString(3, user.getPhone());
            stmt.setInt(4, user.getId());
            return stmt.executeUpdate() > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }
    public User login(String username, String password) {
        String query = "SELECT * FROM tblUser WHERE username = ? AND password = ?";
        User user = null;

        try (PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setString(1, username);
            stmt.setString(2, password);

            try (ResultSet rs = stmt.executeQuery()) {
                if (rs.next()) {
                    user = new User();
                    user.setId(rs.getInt("UserID"));
                    user.setName(rs.getString("FullName"));
                    user.setUsername(rs.getString("username"));
                    user.setPassword(rs.getString("password"));
                    user.setEmail(rs.getString("email"));
                    user.setPhone(rs.getString("phone"));
                    user.setRole(rs.getString("role"));
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        } catch (Exception ex) {
            ex.printStackTrace();
        }

        return user;
    }

}
