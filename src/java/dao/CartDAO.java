/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;

/**
 *
 * @author LiusDev
 */
public class CartDAO extends DBContext{
    public void addToCart(int userId, int productVariantId, int quantity) {
        try {
            String sql = "INSERT INTO carts(user_id, product_variant_id, quantity)\n" +
                        "VALUES\n" +
                        "    (\n" +
                        "        ?,\n" +
                        "        ?,\n" +
                        "        ?\n" +
                        "    )";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productVariantId);
            ps.setInt(3, quantity);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void updateCartQuantity(int userId, int productVariantId, int quantity) {
        if(quantity < 1) quantity = 1;
        try {
            String sql = "UPDATE carts\n" +
                        "SET quantity = ?\n" +
                        "WHERE user_id = ?\n" +
                        "AND product_variant_id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, quantity);
            ps.setInt(2, userId);
            ps.setInt(3, productVariantId);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public ArrayList<ProductOrderDTO> getCartProductByUserId(int userId) {
        ArrayList<ProductOrderDTO> cartProducts = new ArrayList<>();
        try {
            String sql = "WITH tmp(id)\n" +
                        "	AS (SELECT MIN(id) AS id FROM product_images GROUP BY product_id),\n" +
                        "images(id, product_id, alt)\n" +
                        "	AS (SELECT product_images.id, product_id, alt FROM product_images JOIN tmp ON tmp.id = product_images.id)\n" +
                        "SELECT\n" +
                        "	products.id AS product_id,\n" +
                        "	products.name AS product_name,\n" +
                        "	products.slug AS product_slug,\n" +
                        "	images.id AS image_id,\n" +
                        "	images.alt AS image_alt,\n" +
                        "	product_variants.id AS product_variant_id,\n" +
                        "	(SELECT dbo.GetVariantText(products.id, sku)) AS variant,\n" +
                        "	product_variants.storage AS variant_storage,\n" +
                        "	carts.quantity AS cart_quantity,\n" +
                        "	product_variants.quantity AS max_quantity,\n" +
                        "	product_variants.sold_quantity AS sold_quantity,\n" +
                        "	price,\n" +
                        "	products.storage AS storage\n" +
                        "FROM carts\n" +
                        "JOIN product_variants ON product_variants.id = carts.product_variant_id\n" +
                        "JOIN products ON products.id = product_variants.product_id\n" +
                        "JOIN images ON images.product_id = products.id\n" +
                        "WHERE user_id = ?\n" +
                        "ORDER BY carts.created_at DESC";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductOrderDTO cp = new ProductOrderDTO();
                cp.setProductId(rs.getInt("product_id"));
                cp.setName(rs.getNString("product_name"));
                cp.setSlug(rs.getString("product_slug"));
                cp.setImageId(rs.getInt("image_id"));
                cp.setAlt(rs.getNString("image_alt"));
                cp.setProductVariantId(rs.getInt("product_variant_id"));
                cp.setVariant(rs.getNString("variant"));
                cp.setVariantStorage(rs.getBoolean("variant_storage"));
                cp.setCartQuantity(rs.getInt("cart_quantity"));
                cp.setMaxQuantity(rs.getInt("max_quantity"));
                cp.setSoldQuantity(rs.getInt("sold_quantity"));
                cp.setPrice(rs.getInt("price"));
                cp.setStorage(rs.getBoolean("storage"));
                cartProducts.add(cp);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return cartProducts;
    }
    
    public void deleteCartItem(int userId, int productVariantId) {
        try {
            String sql = "DELETE FROM carts\n" +
                        "WHERE user_id = ?\n" +
                        "AND product_variant_id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, productVariantId);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void removeUserCart(int userId) {
        try {
            String sql = "DELETE FROM carts WHERE user_id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
}
