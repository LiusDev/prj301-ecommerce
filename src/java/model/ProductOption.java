/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import java.util.ArrayList;

/**
 *
 * @author LiusDev
 */
public class ProductOption {
    private int id;
    private String createdAt;
    private String option;
    private String sku;
    private ArrayList<ProductOptionValue> values;

    public ProductOption(int id, String createdAt, String option, String sku, ArrayList<ProductOptionValue> values) {
        this.id = id;
        this.createdAt = createdAt;
        this.option = option;
        this.sku = sku;
        this.values = values;
    }

    public ProductOption() {
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

    public String getOption() {
        return option;
    }

    public void setOption(String option) {
        this.option = option;
    }

    public String getSku() {
        return sku;
    }

    public void setSku(String sku) {
        this.sku = sku;
    }

    public ArrayList<ProductOptionValue> getValues() {
        return values;
    }

    public void setValues(ArrayList<ProductOptionValue> values) {
        this.values = values;
    }
}
