package org.example.qlst.dao;

import org.example.qlst.model.ImportReceipt;

import java.sql.*;

public class ImportReceiptDAO extends DAO {

    public ImportReceiptDAO() {
        super();
    }

    public ImportReceiptDAO(java.sql.Connection con) {
        super(con);
    }

    public int addImportReceipt(ImportReceipt importReceipt) {
        String sql = "INSERT INTO tblImportReceipt (Date, SupplierId, StaffId, TotalPrice) VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setDate(1, (Date) importReceipt.getDate());
            ps.setInt(2, importReceipt.getSupplierId());
            ps.setInt(3, importReceipt.getStaffId());
            ps.setDouble(4, importReceipt.getTotalPrice());

            int result = ps.executeUpdate();
            if (result > 0) {
                // Lấy ID vừa tạo
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        return rs.getInt(1);
                    }
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return -1;
    }

}
