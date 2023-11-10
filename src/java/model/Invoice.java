/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import dao.ProductOrderDTO;
import java.util.ArrayList;

/**
 *
 * @author LiusDev
 */
public class Invoice {
    private int id;
    private String createdAt;
    private String firstName;
    private String lastName;
    private String phone;
    private String email;
    private String address;
    private TransportUnit transportUnit;
    private int discount;
    private String message;
    private int status;
    private String statusName;
    private boolean paymentStatus;
    private boolean userCanceled;
    private ArrayList<ProductOrderDTO> invoiceDetails;

    public Invoice(int id, String createdAt, String firstName, String lastName, String phone, String email, String address, TransportUnit transportUnit, int discount, String message, int status, String statusName, boolean paymentStatus, boolean userCanceled, ArrayList<ProductOrderDTO> invoiceDetails) {
        this.id = id;
        this.createdAt = createdAt;
        this.firstName = firstName;
        this.lastName = lastName;
        this.phone = phone;
        this.email = email;
        this.address = address;
        this.transportUnit = transportUnit;
        this.discount = discount;
        this.message = message;
        this.status = status;
        this.statusName = statusName;
        this.paymentStatus = paymentStatus;
        this.userCanceled = userCanceled;
        this.invoiceDetails = invoiceDetails;
    }

    public Invoice() {
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getCreatedAt() {
        return createdAt;
    }

    public void setCreatedAt(String createdAt) {
        this.createdAt = createdAt;
    }

    public String getFirstName() {
        return firstName;
    }

    public void setFirstName(String firstName) {
        this.firstName = firstName;
    }

    public String getLastName() {
        return lastName;
    }

    public void setLastName(String lastName) {
        this.lastName = lastName;
    }

    public String getPhone() {
        return phone;
    }

    public void setPhone(String phone) {
        this.phone = phone;
    }

    public String getEmail() {
        return email;
    }

    public void setEmail(String email) {
        this.email = email;
    }

    public String getAddress() {
        return address;
    }

    public void setAddress(String address) {
        this.address = address;
    }

    public TransportUnit getTransportUnit() {
        return transportUnit;
    }

    public void setTransportUnit(TransportUnit transportUnit) {
        this.transportUnit = transportUnit;
    }

    public int getDiscount() {
        return discount;
    }

    public void setDiscount(int discount) {
        this.discount = discount;
    }

    public String getMessage() {
        return message;
    }

    public void setMessage(String message) {
        this.message = message;
    }

    public int getStatus() {
        return status;
    }

    public void setStatus(int status) {
        this.status = status;
    }

    public String getStatusName() {
        return statusName;
    }

    public void setStatusName(String statusName) {
        this.statusName = statusName;
    }

    public boolean isPaymentStatus() {
        return paymentStatus;
    }

    public void setPaymentStatus(boolean paymentStatus) {
        this.paymentStatus = paymentStatus;
    }

    public boolean isUserCanceled() {
        return userCanceled;
    }

    public void setUserCanceled(boolean userCanceled) {
        this.userCanceled = userCanceled;
    }

    public ArrayList<ProductOrderDTO> getInvoiceDetails() {
        return invoiceDetails;
    }

    public void setInvoiceDetails(ArrayList<ProductOrderDTO> invoiceDetails) {
        this.invoiceDetails = invoiceDetails;
    }

    public int getSubTotal() {
        int sum = 0;
        for(ProductOrderDTO product: invoiceDetails) {
            sum += product.getPrice() * product.getCartQuantity();
        }
        return sum;
    }
    
    public int getTotalPrice() {
        int sum = 0;
        for(ProductOrderDTO product: invoiceDetails) {
            sum += product.getPrice() * product.getCartQuantity();
        }
        return (int) (sum + sum*0.1 + transportUnit.getPrice());
    }
    
    public String getCanceledBy() {
        return userCanceled ? "Canceled by you" : "Canceled by admin";
    }
    
    public String getPaymentStatusInfo() {
        return paymentStatus ? "Paid" : "Unpaid";
    }
}
