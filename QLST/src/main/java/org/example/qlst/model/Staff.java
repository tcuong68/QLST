package org.example.qlst.model;

public class Staff {
    private User member;
    private String position;

    public Staff() {
    }

    public Staff(User member, String position) {
        this.member = member;
        this.position = position;
    }

    public User getMember() {
        return member;
    }

    public void setMember(User member) {
        this.member = member;
    }

    public String getPosition() {
        return position;
    }

    public void setPosition(String position) {
        this.position = position;
    }
}
