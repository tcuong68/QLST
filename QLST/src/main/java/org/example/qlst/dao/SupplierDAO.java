package org.example.qlst.dao;

import org.example.qlst.model.Supplier;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class SupplierDAO extends DAO {

    public SupplierDAO() {
        super();
    }

    public Integer getIdByName(String name) {
        String sql = "SELECT id FROM tblSupplier WHERE name = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    return rs.getInt("id");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public List<Supplier> getAllSuppliers() {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT id, name, phone, email, address FROM tblSupplier ORDER BY name";

        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {

            while (rs.next()) {
                Supplier supplier = new Supplier();
                supplier.setId(rs.getInt("id"));
                supplier.setName(rs.getString("name"));
                supplier.setPhone(rs.getString("phone"));
                supplier.setEmail(rs.getString("email"));
                supplier.setAddress(rs.getString("address"));
                suppliers.add(supplier);
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return suppliers;
    }

    public List<Supplier> searchByName(String keyword) {
        List<Supplier> suppliers = new ArrayList<>();
        String sql = "SELECT id, name, phone, email, address FROM tblSupplier WHERE name LIKE ? ORDER BY name";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            String searchPattern = "%" + keyword + "%";
            ps.setString(1, searchPattern);


            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Supplier supplier = new Supplier();
                    supplier.setId(rs.getInt("id"));
                    supplier.setName(rs.getString("name"));
                    supplier.setPhone(rs.getString("phone"));
                    supplier.setEmail(rs.getString("email"));
                    supplier.setAddress(rs.getString("address"));
                    suppliers.add(supplier);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return suppliers;
    }

    public boolean addSupplier(Supplier supplier) {
        String sql = "INSERT INTO tblSupplier (name, phone, email, address) VALUES (?, ?, ?, ?)";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, supplier.getName());
            ps.setString(2, supplier.getPhone());
            ps.setString(3, supplier.getEmail());
            ps.setString(4, supplier.getAddress());

            int result = ps.executeUpdate();
            return result > 0;
        } catch (SQLException e) {
            e.printStackTrace();
            return false;
        }
    }

    public Supplier findByName(String name) {
        String sql = "SELECT id, name, phone, email, address FROM tblSupplier WHERE name = ?";

        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    Supplier supplier = new Supplier();
                    supplier.setId(rs.getInt("id"));
                    supplier.setName(rs.getString("name"));
                    supplier.setPhone(rs.getString("phone"));
                    supplier.setEmail(rs.getString("email"));
                    supplier.setAddress(rs.getString("address"));
                    return supplier;
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return null;
    }

    public boolean isSupplierExists(String name) {
        return findByName(name) != null;
    }
}
