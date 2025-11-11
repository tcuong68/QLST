package org.example.qlst.model;

import java.util.Date;

public class ImportReceipt {
    private int id;
    private double totalPrice;
    private Date date;
    private int supplierId;
    private int staffId;

    public ImportReceipt() {
    }

    public ImportReceipt(int id, double totalPrice, Date date, int supplierId, int staffId) {
        this.id = id;
        this.totalPrice = totalPrice;
        this.date = date;
        this.supplierId = supplierId;
        this.staffId = staffId;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public double getTotalPrice() {
        return totalPrice;
    }

    public void setTotalPrice(double totalPrice) {
        this.totalPrice = totalPrice;
    }

    public Date getDate() {
        return date;
    }

    public void setDate(Date date) {
        this.date = date;
    }

    public int getSupplierId() {
        return supplierId;
    }

    public void setSupplierId(int supplierId) {
        this.supplierId = supplierId;
    }

    public int getStaffId() {
        return staffId;
    }

    public void setStaffId(int staffId) {
        this.staffId = staffId;
    }
}