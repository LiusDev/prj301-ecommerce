/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import model.Category;
import model.ProductImage;

/**
 *
 * @author LiusDev
 */
public class ProductPreviewDTO {
    private int id;
    private String createdAt;
    private String name;
    private String slug;
    private Category category;
    private ProductImage image;
    private int minPrice;
    private int maxPrice;
    private int totalQuantity;
    private int totalSoldQuantity;

    public ProductPreviewDTO(int id, String createdAt, String name, String slug, Category category, ProductImage image, int minPrice, int maxPrice, int totalQuantity, int totalSoldQuantity) {
        this.id = id;
        this.createdAt = createdAt;
        this.name = name;
        this.slug = slug;
        this.category = category;
        this.image = image;
        this.minPrice = minPrice;
        this.maxPrice = maxPrice;
        this.totalQuantity = totalQuantity;
        this.totalSoldQuantity = totalSoldQuantity;
    }

    public ProductPreviewDTO() {
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

    public String getName() {
        return name;
    }

    public void setName(String name) {
        this.name = name;
    }

    public String getSlug() {
        return slug;
    }

    public void setSlug(String slug) {
        this.slug = slug;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public ProductImage getImage() {
        return image;
    }

    public void setImage(ProductImage image) {
        this.image = image;
    }

    public int getMinPrice() {
        return minPrice;
    }

    public void setMinPrice(int minPrice) {
        this.minPrice = minPrice;
    }

    public int getMaxPrice() {
        return maxPrice;
    }

    public void setMaxPrice(int maxPrice) {
        this.maxPrice = maxPrice;
    }

    public int getTotalQuantity() {
        return totalQuantity;
    }

    public void setTotalQuantity(int totalQuantity) {
        this.totalQuantity = totalQuantity;
    }

    public int getTotalSoldQuantity() {
        return totalSoldQuantity;
    }

    public void setTotalSoldQuantity(int totalSoldQuantity) {
        this.totalSoldQuantity = totalSoldQuantity;
    }
    
    
}
