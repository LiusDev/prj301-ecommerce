/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

/**
 *
 * @author LiusDev
 */
public class ProductOptionValue {
    private int id;
    private String createdAt;
    private String value;
    private String sku;

    public ProductOptionValue(int id, String createdAt, String value, String sku) {
        this.id = id;
        this.createdAt = createdAt;
        this.value = value;
        this.sku = sku;
    }

    public ProductOptionValue() {
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

    public String getValue() {
        return value;
    }

    public void setValue(String value) {
        this.value = value;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }
}
