/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import java.util.HashMap;
import model.Category;

/**
 *
 * @author LiusDev
 */
public class CategoryDAO extends DBContext {
    public ArrayList<Category> getAllCategories(Integer limit) {
        if(limit == null) limit = 100;
        ArrayList<Category> categories = new ArrayList<>();
        try {
            String sql = "SELECT TOP (?) * FROM categories;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category c = new Category();
                c.setId(rs.getInt("id"));
                c.setCreatedAt(rs.getString("created_at"));
                c.setName(rs.getString("name"));
                c.setSlug(rs.getString("slug"));
                categories.add(c);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return categories;
    }
    
    public Category getCategoryById(int categoryId) {
        Category category = new Category();
        try {
            String sql = "SELECT * FROM categories "
                         + "WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, categoryId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                category.setId(rs.getInt("id"));
                category.setCreatedAt(rs.getString("created_at"));
                category.setName(rs.getString("name"));
                category.setSlug(rs.getString("slug"));
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return category;
    }
    
    public HashMap<Category, Integer> getProductCountByCategories(Integer limit) {
        if(limit == null) limit = 10;
        HashMap<Category, Integer> counts = new HashMap<>();
        try {
            String sql = "SELECT TOP(?)\n" +
                        "    categories.id,\n" +
                        "    categories.created_at,\n" +
                        "    categories.name,\n" +
                        "    categories.slug,\n" +
                        "    COUNT(*) as total\n" +
                        "FROM categories\n" +
                        "JOIN products ON categories.id = products.category_id\n" +
                        "WHERE products.storage = 0\n" +
                        "GROUP BY categories.id, categories.created_at, categories.name, categories.slug";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Category category = new Category();
                category.setId(rs.getInt("id"));
                category.setCreatedAt(rs.getString("created_at"));
                category.setName(rs.getNString("name"));
                category.setSlug(rs.getString("slug"));
                int count = rs.getInt("total");
                
                counts.put(category, count);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return counts;
    }
    
    public void updateCategory(int id, String name, String slug) {
        try {
            String sql = "UPDATE categories\n" +
                        "SET\n" +
                        "    name = ?,\n" +
                        "    slug = ?\n" +
                        "WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, name);
            ps.setString(2, slug);
            ps.setInt(3, id);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public int addCategory(String name, String slug) {
        try {
            String sql = "INSERT INTO categories ( name, slug ) VALUES ( ?, ? )";
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setNString(1, name);
            ps.setString(2, slug);
            
            ps.executeUpdate();
            
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
                }
            }
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return -1;
    }
    
    public void deleteCategory(int id) {
        try {
            String sql = "DELETE FROM categories WHERE id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            
            ps.executeUpdate();

        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
}
