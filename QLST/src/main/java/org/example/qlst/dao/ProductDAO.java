package org.example.qlst.dao;

import org.example.qlst.model.Product;

import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

public class ProductDAO extends DAO {
    public ProductDAO() {
        super();
    }

    public ProductDAO(java.sql.Connection con) {
        super(con);
    }

    public List<Product> searchProduct(String name) {
        List<Product> list = new ArrayList<>();
        String sql = "SELECT id, name, salePrice, quantity FROM tblProduct WHERE name LIKE ? ORDER BY name";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, "%" + name + "%");
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Product p = new Product();
                    p.setId(rs.getInt("id"));
                    p.setName(rs.getString("name"));
                    p.setPrice(rs.getDouble("salePrice"));
                    p.setQuantity(rs.getInt("quantity"));
                    list.add(p);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return list;
    }

    public boolean addProduct(Product product) {
        // SỬA LỖI: Thêm các cột mới (code, unit, description) vào câu SQL
        String sql = "INSERT INTO tblProduct(code, name, unit, description, salePrice, quantity) VALUES (?, ?, ?, ?, ?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql)) {

            ps.setString(1, product.getCode());
            ps.setString(2, product.getName());
            ps.setString(3, product.getUnit());
            ps.setString(4, product.getDescription());
            ps.setDouble(5, product.getPrice());
            ps.setInt(6, product.getQuantity());

            return ps.executeUpdate() > 0;

        } catch (SQLException e) {

            System.err.println("Lỗi thêm mặt hàng mới: " + e.getMessage());
        }
        return false;
    }

    public boolean updateStockAfterImport(int productId, int quantityToAdd) {
        // SQL này sẽ lấy số lượng HIỆN TẠI cộng thêm số lượng MỚI
        String sql = "UPDATE tblProduct SET quantity = quantity + ? WHERE id = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, quantityToAdd);
            ps.setInt(2, productId);
            return ps.executeUpdate() > 0;
        } catch (SQLException e) {
            System.err.println("Lỗi cập nhật tồn kho sau khi nhập: " + e.getMessage());
        }
        return false;
    }
}
