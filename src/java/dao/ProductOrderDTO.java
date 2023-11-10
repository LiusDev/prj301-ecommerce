/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

/**
 *
 * @author LiusDev
 */
public class ProductOrderDTO {
    private int productId;
    private String name;
    private String slug;
    private int imageId;
    private String alt;
    private int productVariantId;
    private String variant;
    private boolean variantStorage;
    private int cartQuantity;
    private int maxQuantity;
    private int soldQuantity;
    private int price;
    private boolean storage;

    public ProductOrderDTO(int productId, String name, String slug, int imageId, String alt, int productVariantId, String variant, boolean variantStorage, int cartQuantity, int maxQuantity, int soldQuantity, int price, boolean storage) {
        this.productId = productId;
        this.name = name;
        this.slug = slug;
        this.imageId = imageId;
        this.alt = alt;
        this.productVariantId = productVariantId;
        this.variant = variant;
        this.variantStorage = variantStorage;
        this.cartQuantity = cartQuantity;
        this.maxQuantity = maxQuantity;
        this.soldQuantity = soldQuantity;
        this.price = price;
        this.storage = storage;
    }

    public ProductOrderDTO() {
    }

    public int getProductId() {
        return productId;
    }

    public void setProductId(int productId) {
        this.productId = productId;
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

    public int getImageId() {
        return imageId;
    }

    public void setImageId(int imageId) {
        this.imageId = imageId;
    }

    public String getAlt() {
        return alt;
    }

    public void setAlt(String alt) {
        this.alt = alt;
    }

    public int getProductVariantId() {
        return productVariantId;
    }

    public void setProductVariantId(int productVariantId) {
        this.productVariantId = productVariantId;
    }

    public String getVariant() {
        return variant;
    }

    public void setVariant(String variant) {
        this.variant = variant;
    }

    public boolean isVariantStorage() {
        return variantStorage;
    }

    public void setVariantStorage(boolean variantStorage) {
        this.variantStorage = variantStorage;
    }

    public int getCartQuantity() {
        return cartQuantity;
    }

    public void setCartQuantity(int cartQuantity) {
        this.cartQuantity = cartQuantity;
    }

    public int getMaxQuantity() {
        return maxQuantity;
    }

    public void setMaxQuantity(int maxQuantity) {
        this.maxQuantity = maxQuantity;
    }

    public int getPrice() {
        return price;
    }

    public void setPrice(int price) {
        this.price = price;
    }

    public boolean isStorage() {
        return storage;
    }

    public void setStorage(boolean storage) {
        this.storage = storage;
    }

    public int getSoldQuantity() {
        return soldQuantity;
    }

    public void setSoldQuantity(int soldQuantity) {
        this.soldQuantity = soldQuantity;
    }
}
