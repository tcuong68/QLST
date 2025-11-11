package org.example.qlst.dao;


import java.sql.PreparedStatement;
import java.sql.ResultSet;

public class StaffDAO extends DAO {

    public StaffDAO() {
        super();
    }

    public  String getStaffPosition(int memberId) {
        String query = "SELECT position FROM tblstaff WHERE UserId = ?";
        try (PreparedStatement stmt = con.prepareStatement(query)) {

            stmt.setInt(1, memberId);
            ResultSet rs = stmt.executeQuery();

            if (rs.next()) {
                String pos = rs.getString("position");
                return pos;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

    public Integer getStaff(int userId) {
        String query = "SELECT UserId FROM tblStaff WHERE UserId = ?";
        try (PreparedStatement stmt = con.prepareStatement(query)) {
            stmt.setInt(1, userId);
            ResultSet rs = stmt.executeQuery();
            if (rs.next()) {
                return rs.getInt("UserId");
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        return null;
    }

}