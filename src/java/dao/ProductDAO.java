/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import context.DBContext;
import java.io.ByteArrayInputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import model.*;

/**
 *
 * @author LiusDev
 */
public class ProductDAO extends DBContext{
    public Product getProductById(int productId) {
        try {
            String sql = "select * from products where id = ? and storage = 0;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setCreatedAt(rs.getString("created_at"));
                product.setName(rs.getNString("name"));
                product.setSlug(rs.getString("slug"));
                product.setDescription(rs.getNString("description"));
                
                Category category = new CategoryDAO().getCategoryById(rs.getInt("category_id"));
                product.setCategory(category);
                
                ArrayList<ProductImage> images = getImagesByProductId(product.getId());
                product.setImages(images);
                
                ArrayList<ProductOption> options = getOptionsByProductId(product.getId());
                product.setOptions(options);
                
                ArrayList<ProductVariant> variants = getVariantsByProductId(product.getId());
                product.setVariants(variants);
                return product;
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }
    public Product getProductBySlug(String slug) {
        try {
            String sql = "select * from products where slug = ? and storage = 0;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, slug);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Product product = new Product();
                product.setId(rs.getInt("id"));
                product.setCreatedAt(rs.getString("created_at"));
                product.setName(rs.getNString("name"));
                product.setSlug(rs.getString("slug"));
                product.setDescription(rs.getNString("description"));
                
                Category category = new CategoryDAO().getCategoryById(rs.getInt("category_id"));
                product.setCategory(category);
                
                ArrayList<ProductImage> images = getImagesByProductId(product.getId());
                product.setImages(images);
                
                ArrayList<ProductOption> options = getOptionsByProductId(product.getId());
                product.setOptions(options);
                
                ArrayList<ProductVariant> variants = getVariantsByProductId(product.getId());
                product.setVariants(variants);
                return product;
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }
    
    public ArrayList<ProductOptionValue> getValuesByOptionId(int optionId) {
        ArrayList<ProductOptionValue> optionValues = new ArrayList<>();
        try {
            String sql = "SELECT * FROM product_option_values "
                         + "WHERE product_option_id = ?\n"
                         + "AND storage = 0";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, optionId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductOptionValue optionValue = new ProductOptionValue();
                optionValue.setId(rs.getInt("id"));
                optionValue.setCreatedAt(rs.getString("created_at"));
                optionValue.setValue(rs.getString("value"));
                optionValue.setSku(rs.getString("sku"));
                
                optionValues.add(optionValue);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return optionValues;
    }
    
    public ArrayList<ProductOption> getOptionsByProductId(int productId) {
        ArrayList<ProductOption> options = new ArrayList<>();
        try {
            String sql = "SELECT * FROM product_options "
                         + "WHERE product_id = ?\n"
                         + "AND storage = 0";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductOption option = new ProductOption();
                option.setId(rs.getInt("id"));
                option.setCreatedAt(rs.getString("created_at"));
                option.setOption(rs.getString("option"));
                option.setSku(rs.getString("sku"));
                
                ArrayList<ProductOptionValue> values = this.getValuesByOptionId(option.getId());
                option.setValues(values);
                
                options.add(option);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return options;
    }
    
    public void addProductValue(int optionId, ProductOptionValue value) {
        try {
            String sql = "INSERT INTO product_option_values\n" +
                        "    (\n" +
                        "     product_option_id,\n" +
                        "     value,\n" +
                        "     sku\n" +
                        "    )\n" +
                        "VALUES\n" +
                        "    (\n" +
                        "     ?,\n" +
                        "     ?,\n" +
                        "     ?\n" +
                        "    );";
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, optionId);
            ps.setNString(2, value.getValue());
            ps.setString(3, value.getSku());
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void addProductOption(int productId, ProductOption option) {
        try {
            String sql = "INSERT INTO product_options\n" +
                        "    (\n" +
                        "     product_id,\n" +
                        "     [option],\n" +
                        "     sku\n" +
                        "    )\n" +
                        "VALUES\n" +
                        "    (\n" +
                        "     ?,\n" +
                        "     ?,\n" +
                        "     ?\n" +
                        "    );";
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, productId);
            ps.setNString(2, option.getOption());
            ps.setString(3, option.getSku());
            
            ps.executeUpdate();
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    for(ProductOptionValue value : option.getValues()) {
                        addProductValue(generatedKeys.getInt(1), value);
                    }
                }
                else {
                    throw new SQLException("Creating invoice detail failed, no ID obtained.");
                }
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public ArrayList<ProductVariant> getVariantsByProductId(int productId) {
        ArrayList<ProductVariant> variants = new ArrayList<>();
        try {
            String sql = "SELECT * FROM product_variants "
                         + "WHERE product_id = ?\n"
                         + "AND storage = 0;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductVariant variant = new ProductVariant();
                variant.setId(rs.getInt("id"));
                variant.setCreatedAt(rs.getString("created_at"));
                variant.setSku(rs.getString("sku"));
                variant.setPrice(rs.getInt("price"));
                variant.setQuantity(rs.getInt("quantity"));
                variant.setSoldQuantity(rs.getInt("sold_quantity"));
                
                variants.add(variant);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return variants;
    }
    
    public void addProductVariant(int productId, ProductVariant variant) {
        try {
            String sql = "INSERT INTO product_variants\n" +
                        "(\n" +
                        "   product_id,\n" +
                        "   sku,\n" +
                        "   price,\n" +
                        "   quantity\n" +
                        ")\n" +
                        "VALUES\n" +
                        "(\n" +
                        "   ?,\n" +
                        "   ?,\n" +
                        "   ?,\n" +
                        "   ?\n" +
                        ");";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.setString(2, variant.getSku());
            ps.setInt(3, variant.getPrice());
            ps.setInt(4, variant.getQuantity());
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public ArrayList<ProductImage> getImagesByProductId(int id) {
        ArrayList<ProductImage> images = new ArrayList<>();
        try {
            String sql = "SELECT * FROM product_images "
                        + "WHERE product_id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductImage image = new ProductImage();
                image.setId(rs.getInt("id"));
                image.setCreatedAt(rs.getString("created_at"));
                image.setAlt(rs.getString("alt"));
                
                images.add(image);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return images;
    }
    
    public ProductImage getProductImage(int id) {
        try {
            String sql = "SELECT * FROM product_images "
                        + "WHERE id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductImage image = new ProductImage();
                image.setId(rs.getInt("id"));
                image.setCreatedAt(rs.getString("created_at"));
                image.setImage(rs.getBytes("image"));
                image.setAlt(rs.getString("alt"));
                return image;
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }
    
    public void addProductImages(int productId, ProductImage image) {
        try {
            String sql = "INSERT INTO product_images\n" +
                        "    (\n" +
                        "     product_id,\n" +
                        "     image,\n" +
                        "     alt\n" +
                        "    )\n" +
                        "VALUES\n" +
                        "    (\n" +
                        "     ?,\n" +
                        "     ?,\n" +
                        "     ?\n" +
                        "    );";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, productId);
            ps.setBlob(2, new ByteArrayInputStream(image.getImage()));
            ps.setString(3, image.getAlt());
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public ArrayList<ProductPreviewDTO> getRelatedProductsByProduct(Product product, Integer limit) {
        if(limit == null) limit = 10;
        
        ArrayList<ProductPreviewDTO> productsDTO = new ArrayList<>();
        try {
            String sql = "WITH variants(product_id, min_price, max_price, quantity, sold_quantity) \n" +
                        "	AS (SELECT product_id, MIN(price), MAX(price), SUM(quantity), SUM(sold_quantity) FROM product_variants GROUP BY [product_id]),\n" +
                        "tmp(id)\n" +
                        "	AS (SELECT MIN(id) AS id FROM product_images GROUP BY product_id),\n" +
                        "images(id, product_id, image, alt)\n" +
                        "	AS (SELECT product_images.id, product_id, image, alt FROM product_images JOIN tmp ON tmp.id = product_images.id)\n" +
                        "SELECT\n" +
                        "	products.id AS product_id,\n" +
                        "	products.created_at,\n" +
                        "	products.name AS product_name,\n" +
                        "	products.slug AS product_slug,\n" +
                        "	categories.id AS category_id,\n" +
                        "	categories.name AS category_name,\n" +
                        "	categories.slug AS category_slug,\n" +
                        "	images.id AS image,\n" +
                        "	images.alt AS alt,\n" +
                        "	variants.min_price,\n" +
                        "	variants.max_price,\n" +
                        "	variants.quantity AS total_quantity,\n" +
                        "	variants.sold_quantity AS total_sold_quantity\n" +
                        "FROM products\n" +
                        "JOIN variants ON id = variants.product_id\n" +
                        "JOIN categories ON categories.id = products.category_id\n" +
                        "JOIN images ON images.product_id = products.id\n" +
                        "WHERE categories.slug LIKE ?\n" +
                        "AND products.id != ?\n" +
                        "AND variants.quantity > 0\n" +
                        "AND products.storage = 0\n" +
                        "ORDER BY product_id ASC\n" +
                        "OFFSET 0 ROWS \n" +
                        "FETCH NEXT ? ROWS ONLY;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, product.getCategory().getSlug());
            ps.setInt(2, product.getId());
            ps.setInt(3, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductPreviewDTO p = new ProductPreviewDTO();
                p.setId(rs.getInt("product_id"));
                p.setCreatedAt(rs.getString("created_at"));
                p.setName(rs.getString("product_name"));
                p.setSlug(rs.getString("product_slug"));
                
                Category category = new Category();
                category.setId(rs.getInt("category_id"));
                category.setName(rs.getString("category_name"));
                category.setSlug(rs.getString("category_slug"));
                p.setCategory(category);
                
                ProductImage image = new ProductImage();
                image.setId(rs.getInt("image"));
                image.setAlt(rs.getString("alt"));
                p.setImage(image);
                
                p.setMinPrice(rs.getInt("min_price"));
                p.setMaxPrice(rs.getInt("max_price"));
                p.setTotalQuantity(rs.getInt("total_quantity"));
                p.setTotalSoldQuantity(rs.getInt("total_sold_quantity"));
                
                productsDTO.add(p);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return productsDTO;
    }
    
    public ArrayList<ProductPreviewDTO> getFilterResults(String keyword, String categorySlug, String minPrice, String maxPrice, String sortBy, String page, String pageSize, boolean isOutStock) {
        if(keyword == null) keyword = "";
        if(categorySlug == null) categorySlug = "%%";
        if(minPrice == null || minPrice.equals("")) minPrice = "0";
        if(maxPrice == null || maxPrice.equals("")) maxPrice = "99999999";
        if(sortBy == null) sortBy = "";
        if(page == null || page.equals("")) page = "1";
        if(pageSize == null || pageSize.equals("")) pageSize = "16";

        switch (sortBy) {
            case "createdAt":
                sortBy = "ORDER BY created_at DESC\n";
                break;
            case "sales":
                sortBy = "ORDER BY total_quantity DESC\n";
                break;
            case "priceAsc":
                sortBy = "ORDER BY min_price ASC\n";
                break;
            case "priceDesc":
                sortBy = "ORDER BY min_price DESC\n";
                break;
            default:
                sortBy = "ORDER BY product_id ASC\n";
        }
        
        ArrayList<ProductPreviewDTO> productsDTO = new ArrayList<>();
        try {
            String sql = "WITH variants(product_id, min_price, max_price, quantity, sold_quantity) \n" +
                        "	AS (SELECT product_id, MIN(price), MAX(price), SUM(quantity), SUM(sold_quantity) FROM product_variants WHERE product_variants.storage = 0 GROUP BY [product_id]),\n" +
                        "tmp(id)\n" +
                        "	AS (SELECT MIN(id) AS id FROM product_images GROUP BY product_id),\n" +
                        "images(id, product_id, image, alt)\n" +
                        "	AS (SELECT product_images.id, product_id, image, alt FROM product_images JOIN tmp ON tmp.id = product_images.id)\n" +
                        "SELECT\n" +
                        "	products.id AS product_id,\n" +
                        "	products.created_at,\n" +
                        "	products.name AS product_name,\n" +
                        "	products.slug AS product_slug,\n" +
                        "	categories.id AS category_id,\n" +
                        "	categories.name AS category_name,\n" +
                        "	categories.slug AS category_slug,\n" +
                        "	images.id AS image,\n" +
                        "	images.alt AS alt,\n" +
                        "	variants.min_price,\n" +
                        "	variants.max_price,\n" +
                        "	variants.quantity AS total_quantity,\n" +
                        "	variants.sold_quantity AS total_sold_quantity\n" +
                        "FROM products\n" +
                        "JOIN variants ON id = variants.product_id\n" +
                        "JOIN categories ON categories.id = products.category_id\n" +
                        "JOIN images ON images.product_id = products.id\n" +
                        "WHERE products.name LIKE ?\n" +
                        "AND categories.slug LIKE ?\n" +
                        "AND min_price >= ?\n" +
                        "AND min_price <= ?\n" +
                        (isOutStock ? "" : "AND variants.quantity > 0\n") +
                        "AND products.storage = 0\n" +
                        sortBy +
                        "OFFSET ? ROWS \n" +
                        "FETCH NEXT ? ROWS ONLY";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, "%" + keyword + "%");
            ps.setString(2, categorySlug);
            ps.setInt(3, Integer.parseInt(minPrice));
            ps.setInt(4, Integer.parseInt(maxPrice));
            ps.setInt(5, (Integer.parseInt(page)-1) * Integer.parseInt(pageSize));
            ps.setInt(6, Integer.parseInt(pageSize));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductPreviewDTO p = new ProductPreviewDTO();
                p.setId(rs.getInt("product_id"));
                p.setCreatedAt(rs.getString("created_at"));
                p.setName(rs.getString("product_name"));
                p.setSlug(rs.getString("product_slug"));
                
                Category category = new Category();
                category.setId(rs.getInt("category_id"));
                category.setName(rs.getString("category_name"));
                category.setSlug(rs.getString("category_slug"));
                p.setCategory(category);
                
                ProductImage image = new ProductImage();
                image.setId(rs.getInt("image"));
                image.setAlt(rs.getString("alt"));
                p.setImage(image);
                
                p.setMinPrice(rs.getInt("min_price"));
                p.setMaxPrice(rs.getInt("max_price"));
                p.setTotalQuantity(rs.getInt("total_quantity"));
                p.setTotalSoldQuantity(rs.getInt("total_sold_quantity"));
                
                productsDTO.add(p);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return productsDTO;
    }
    public int getFilterResultCount(String keyword, String categorySlug, String minPrice, String maxPrice) {
        if(keyword == null) keyword = "";
        if(categorySlug == null) categorySlug = "%%";
        if(minPrice == null || minPrice.equals("")) minPrice = "0";
        if(maxPrice == null || maxPrice.equals("")) maxPrice = "99999999";
        
        int count = 0;
        try {
            String sql = "WITH variants(product_id, min_price, max_price, quantity, sold_quantity) \n" +
                        "	AS (SELECT product_id, MIN(price), MAX(price), SUM(quantity), SUM(sold_quantity) FROM product_variants WHERE product_variants.storage = 0 GROUP BY [product_id])\n" +
                        "SELECT\n" +
                        "	COUNT(*) AS total_product\n" +
                        "FROM products\n" +
                        "JOIN variants ON id = variants.product_id\n" +
                        "JOIN categories ON categories.id = products.category_id\n" +
                        "WHERE products.name LIKE ?\n" +
                        "AND categories.slug LIKE ?\n" +
                        "AND min_price >= ?\n" +
                        "AND min_price <= ?\n" +
                        "AND products.storage = 0\n" +
                        "AND variants.quantity > 0";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, "%" + keyword + "%");
            ps.setString(2, categorySlug);
            ps.setInt(3, Integer.parseInt(minPrice));
            ps.setInt(4, Integer.parseInt(maxPrice));
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                count = rs.getInt("total_product");
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return count;
    }
    
    public void addProduct(Product product) {
        try {
            String sql = "INSERT INTO products\n" +
                        "    (\n" +
                        "     name,\n" +
                        "     slug,\n" +
                        "     description,\n" +
                        "     category_id\n" +
                        "    )\n" +
                        "VALUES\n" +
                        "    (\n" +
                        "     ?,\n" +
                        "     ?,\n" +
                        "     ?,\n" +
                        "     ?\n" +
                        "    );";
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setNString(1, product.getName());
            ps.setString(2, product.getSlug());
            ps.setNString(3, product.getDescription());
            ps.setInt(4, product.getCategory().getId());
            
            ps.executeUpdate();
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    for(ProductImage image : product.getImages()) {
                        addProductImages(generatedKeys.getInt(1), image);
                    }
                    if(product.getOptions().size() > 0) {
                        for(ProductOption option : product.getOptions()) {
                            addProductOption(generatedKeys.getInt(1), option);
                        }
                    }
                    for(ProductVariant variant : product.getVariants()) {
                        addProductVariant(generatedKeys.getInt(1), variant);
                    }
                }
                else {
                    throw new SQLException("Creating invoice detail failed, no ID obtained.");
                }
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void removeImage(ProductImage image) {
        try {
            String sql = "DELETE FROM product_images WHERE id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, image.getId());
            
            ps.executeUpdate();
            
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void removeValue(ProductOptionValue value) {
        try {
            String sql = "UPDATE product_option_values\n" +
                        "SET storage = 1\n" +
                        "WHERE id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, value.getId());
            
            ps.executeUpdate();
            
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void removeOption(ProductOption option) {
        try {
            String sql = "UPDATE product_options\n" +
                        "SET storage = 1\n" +
                        "WHERE id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, option.getId());
            
            ps.executeUpdate();
            for(ProductOptionValue value : option.getValues()) {
                removeValue(value);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void removeVariant(ProductVariant variant) {
        try {
            String sql = "UPDATE product_variants\n" +
                        "SET storage = 1\n" +
                        "WHERE id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, variant.getId());
            
            ps.executeUpdate();
            
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void removeProduct(String slug) {
        Product p = getProductBySlug(slug);
        try {
            String sql = "UPDATE products\n" +
                        "SET storage = 1\n" +
                        "WHERE products.id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, p.getId());
            
            ps.executeUpdate();
            for(ProductOption option : p.getOptions()) {
                removeOption(option);
            }

            for(ProductVariant variant : p.getVariants()) {
                removeVariant(variant);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }    
    
    public void updateProduct(int productId, Product oldProduct, Product newProduct) {
        try {
            String sql = "UPDATE products\n" +
                        "SET\n" +
                        "    name = ?,\n" +
                        "    description = ?,\n" +
                        "    category_id = ?\n" +
                        "WHERE products.id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, newProduct.getName());
            ps.setNString(2, newProduct.getDescription());
            ps.setInt(3, newProduct.getCategory().getId());
            ps.setInt(4, productId);
            
            ps.executeUpdate();
            for(ProductImage image : oldProduct.getImages()) {
                removeImage(image);
            }
            for(ProductOption option : oldProduct.getOptions()) {
                removeOption(option);
            }
            for(ProductVariant variant : oldProduct.getVariants()) {
                removeVariant(variant);
            }
            for(ProductImage image : newProduct.getImages()) {
                addProductImages(productId, image);
            }
            if(newProduct.getOptions().size() > 0) {
                for(ProductOption option : newProduct.getOptions()) {
                    addProductOption(productId, option);
                }
            }
            for(ProductVariant variant : newProduct.getVariants()) {
                addProductVariant(productId, variant);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void updateProductQuantity(ProductOrderDTO cartProduct) {
        try {
            String sql = "UPDATE product_variants\n" +
                        "SET\n" +
                        "    quantity = ?,\n" +
                        "    sold_quantity = ?\n" +
                        "WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, cartProduct.getMaxQuantity() - cartProduct.getCartQuantity());
            ps.setInt(2, cartProduct.getSoldQuantity() + cartProduct.getCartQuantity());
            ps.setInt(3, cartProduct.getProductVariantId());
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
}
