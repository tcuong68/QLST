package org.example.qlst.dao;

import org.example.qlst.model.ImportReceiptDetail;

import java.sql.PreparedStatement;
import java.sql.SQLException;

public class ImportReceiptDetailDAO extends DAO {
    public ImportReceiptDetailDAO() { super(); }
    public ImportReceiptDetailDAO(java.sql.Connection con) { super(con); }


    public boolean importProductDetail(ImportReceiptDetail item) {
        String sql = "INSERT INTO tblImportReceiptDetail (quantity, price, ImportReceiptId, ProductID) VALUES (?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, item.getQuantity());
            ps.setDouble(2, item.getPrice());
            ps.setInt(3, item.getImportReceiptId());
            ps.setInt(4, item.getProductId());
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("❌ Lỗi thêm sản phẩm: " + e.getMessage());
        }
        return false;
    }

}