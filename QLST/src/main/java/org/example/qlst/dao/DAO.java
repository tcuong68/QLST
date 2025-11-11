package org.example.qlst.dao;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.SQLException;

public class DAO {
    protected Connection con;

    public DAO() {
        try {
            String url = "jdbc:mysql://localhost:3306/qlst";
            String user = "root";
            String pass = "tuancuong@1";

            Class.forName("com.mysql.cj.jdbc.Driver");
            con = DriverManager.getConnection(url, user, pass);
        } catch (ClassNotFoundException | SQLException e) {
            throw new RuntimeException("Kết nối DB thất bại", e);
        }
    }

    public DAO(Connection existing) {
        this.con = existing;
    }

    public static Connection openConnection() {
        try {
            String url = "jdbc:mysql://localhost:3306/qlst";
            String user = "root";
            String pass = "tuancuong@1";

            Class.forName("com.mysql.cj.jdbc.Driver");
            return DriverManager.getConnection(url, user, pass);
        } catch (Exception e) {
            throw new RuntimeException("Không thể kết nối đến DB", e);
        }
    }
}
