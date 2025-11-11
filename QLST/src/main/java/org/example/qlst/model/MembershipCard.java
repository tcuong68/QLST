package org.example.qlst.model;

public class MembershipCard {
    private int cardId;
    private String status;
    private int customerId;
    private int point;

    public int getPoint() {
        return point;
    }

    public void setPoint(int point) {
        this.point = point;
    }

    public MembershipCard() {
    }

    public int getCardId() {
        return cardId;
    }

    public MembershipCard(int cardId, String status, int customerId, int point) {
        this.cardId = cardId;
        this.status = status;
        this.customerId = customerId;
        this.point = point;
    }

    public void setCardId(int cardId) {
        this.cardId = cardId;
    }

    public String getStatus() {
        return status;
    }

    public void setStatus(String status) {
        this.status = status;
    }

    public int getCustomerId() {
        return customerId;
    }

    public void setCustomerId(int userId) {
        this.customerId = userId;
    }
}
