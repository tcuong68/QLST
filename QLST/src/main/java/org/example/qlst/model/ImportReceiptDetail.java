package org.example.qlst.model;

public class ImportReceiptDetail {
    private int id;
    private int quantity;
    private double price;
    private int importReceiptId;
    private int productId;

    public ImportReceiptDetail() {}

    public ImportReceiptDetail(int id, int quantity, double price, int importReceiptId, int productId) {
        this.id = id;
        this.quantity = quantity;
        this.price = price;
        this.importReceiptId = importReceiptId;
        this.productId = productId;
    }

    // Getters and Setters
    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public int getQuantity() {
        return quantity;
    }

    public void setQuantity(int quantity) {
        this.quantity = quantity;
    }

    public double getPrice() {
        return price;
    }

    public void setPrice(double price) {
        this.price = price;
    }

    public int getImportReceiptId() {
        return importReceiptId;
    }

    public void setImportReceiptId(int importReceiptId) {
        this.importReceiptId = importReceiptId;
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
    }


}