/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package model;

import dao.ProductPreviewDTO;
import java.util.ArrayList;

/**
 *
 * @author LiusDev
 */

public class Product {
    private int id;
    private String createdAt;
    private String name;
    private String slug;
    private String description;
    private Category category;
    private ArrayList<ProductImage> images;
    private ArrayList<ProductOption> options;
    private ArrayList<ProductVariant> variants;

    public Product(int id, String createdAt, String name, String slug, String description, Category category, ArrayList<ProductImage> images, ArrayList<ProductOption> options, ArrayList<ProductVariant> variants) {
        this.id = id;
        this.createdAt = createdAt;
        this.name = name;
        this.slug = slug;
        this.description = description;
        this.category = category;
        this.images = images;
        this.options = options;
        this.variants = variants;
    }
    
    public Product(ProductPreviewDTO productDTO) {
        this.id = productDTO.getId();
        this.createdAt = productDTO.getCreatedAt();
        this.name = productDTO.getName();
        this.slug = productDTO.getSlug();
        this.category = productDTO.getCategory();
    }

    public Product() {
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

    public String getDescription() {
        return description;
    }

    public void setDescription(String description) {
        this.description = description;
    }

    public Category getCategory() {
        return category;
    }

    public void setCategory(Category category) {
        this.category = category;
    }

    public ArrayList<ProductImage> getImages() {
        return images;
    }

    public void setImages(ArrayList<ProductImage> images) {
        this.images = images;
    }

    public ArrayList<ProductOption> getOptions() {
        return options;
    }

    public void setOptions(ArrayList<ProductOption> options) {
        this.options = options;
    }

    public ArrayList<ProductVariant> getVariants() {
        return variants;
    }

    public void setVariants(ArrayList<ProductVariant> variants) {
        this.variants = variants;
    }

    public ProductPreviewDTO toPreviewDTO() {
        ProductPreviewDTO productPreviewDTO = new ProductPreviewDTO();
        productPreviewDTO.setId(id);
        productPreviewDTO.setCreatedAt(createdAt);
        productPreviewDTO.setName(name);
        productPreviewDTO.setSlug(slug);
        productPreviewDTO.setCategory(category);
        productPreviewDTO.setImage(images.get(0));
        int minPrice = variants.get(0).getPrice();
        int maxPrice = variants.get(0).getPrice();
        int totalQuantity = 0;
        int totalSoldQuantity = 0;
        for(ProductVariant v : variants) {
            if(v.getPrice() < minPrice) minPrice = v.getPrice();
            if(v.getPrice() > maxPrice) maxPrice = v.getPrice();
            totalQuantity += v.getQuantity();
            totalSoldQuantity += v.getSoldQuantity();
        }
        productPreviewDTO.setMinPrice(minPrice);
        productPreviewDTO.setMaxPrice(maxPrice);
        productPreviewDTO.setTotalQuantity(totalQuantity);
        productPreviewDTO.setTotalSoldQuantity(totalSoldQuantity);
        return productPreviewDTO;
    }
}
