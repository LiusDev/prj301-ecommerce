package dao;


import context.DBContext;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import model.Invoice;
import model.TransportUnit;

/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */

/**
 *
 * @author LiusDev
 */
public class InvoiceDAO extends DBContext{
    public long addInvoice(int userId, String firstName, String lastName, String phone, String email, String address, int transportUnitId, String message, ArrayList<ProductOrderDTO> cartProducts) {
        try {
            String sql = "INSERT INTO invoices\n" +
                        "    (\n" +
                        "     user_id,\n" +
                        "     first_name,\n" +
                        "     last_name,\n" +
                        "     phone,\n" +
                        "     email,\n" +
                        "     address,\n" +
                        "     transport_unit_id,\n" +
                        "     message)\n" +
                        "VALUES\n" +
                        "    (\n" +
                        "        ?,\n" +
                        "        ?,\n" +
                        "        ?,\n" +
                        "        ?,\n" +
                        "        ?,\n" +
                        "        ?,\n" +
                        "        ?,\n" +
                        "        ?\n" +
                        "    );";
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setInt(1, userId);
            ps.setNString(2, firstName);
            ps.setNString(3, lastName);
            ps.setString(4, phone);
            ps.setString(5, email);
            ps.setNString(6, address);
            ps.setInt(7, transportUnitId);
            ps.setNString(8, message);
            
            ps.executeUpdate();
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    for(ProductOrderDTO product : cartProducts) {
                        addInvoiceDetail(generatedKeys.getLong(1), product.getProductVariantId(), product.getCartQuantity());
                        new ProductDAO().updateProductQuantity(product);
                    }
                    new CartDAO().removeUserCart(userId);
                    return generatedKeys.getLong(1);
                }
                else {
                    throw new SQLException("Creating invoice detail failed, no ID obtained.");
                }
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return -1;
    }
    
    public void addInvoiceDetail(long invoiceId, int productVariantId, int quantity){
        try {
            String sql = "INSERT INTO invoice_details\n" +
                        "(\n" +
                        "    invoice_id,\n" +
                        "    product_variant_id,\n" +
                        "    quantity\n" +
                        ")\n" +
                        "VALUES\n" +
                        "(\n" +
                        "    ?,       -- invoice_id - bigint\n" +
                        "    ?,       -- product_variant_id - bigint\n" +
                        "    ?        -- quantity - int\n" +
                        ")";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setLong(1, invoiceId);
            ps.setInt(2, productVariantId);
            ps.setInt(3, quantity);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public ArrayList<Invoice> getInvoices(Integer userId, String keyword, String paymentStatus, String status, String userCanceled) {
        ArrayList<Invoice> invoices = new ArrayList<>();
        try {
            String sql = "SELECT\n" +
                        "    invoices.id as id,\n" +
                        "    invoices.created_at as created_at,\n" +
                        "    first_name,\n" +
                        "    last_name,\n" +
                        "    phone,\n" +
                        "    email,\n" +
                        "    address,\n" +
                        "    transport_unit_id,\n" +
                        "    transport_units.name as transport_unit_name,\n" +
                        "    transport_units.type as transport_unit_type,\n" +
                        "    transport_units.price as transport_unit_price,\n" +
                        "    transport_units.fastest_shipping as fastest_shipping,\n" +
                        "    transport_units.slowest_shipping as slowest_shipping,\n" +
                        "    discount,\n" +
                        "    message,\n" +
                        "    status,\n" +
                        "    invoice_states.name as status_name,\n" +
                        "    payment_status,\n" +
                        "    user_canceled\n" +
                        "FROM invoices\n" +
                        "JOIN transport_units ON invoices.transport_unit_id = transport_units.id\n" +
                        "JOIN invoice_states ON invoices.status = invoice_states.id\n" +
                        "WHERE user_id LIKE ?\n" +
                        "AND (\n" +
                        "    first_name LIKE ? OR\n" +
                        "    last_name LIKE ? OR\n" +
                        "    phone LIKE ? OR\n" +
                        "    email LIKE ? OR\n" +
                        "    address LIKE ?\n" +
                        ")\n" +
                        "AND payment_status LIKE ?\n" +
                        "AND status LIKE ?\n" +
                        "AND user_canceled LIKE ?\n" +
                        "ORDER BY created_at DESC";
            PreparedStatement ps = connection.prepareStatement(sql);
            if(userId != null) {
                ps.setString(1, userId.toString());
            } else {
                ps.setString(1, "%%");
            }
            if(keyword != null) {
                ps.setString(2, "%" + keyword + "%");
                ps.setString(3, "%" + keyword + "%");
                ps.setString(4, "%" + keyword + "%");
                ps.setString(5, "%" + keyword + "%");
                ps.setString(6, "%" + keyword + "%");
            } else {
                ps.setString(2, "%%");
                ps.setString(3, "%%");
                ps.setString(4, "%%");
                ps.setString(5, "%%");
                ps.setString(6, "%%");
            }
            if(paymentStatus != null) {
                ps.setString(7, paymentStatus);
            } else {
                ps.setString(7, "%%");
            }
            if(status != null) {
                ps.setString(8, status);
            } else {
                ps.setString(8, "%%");
            }
            if(userCanceled != null) {
                ps.setString(9, userCanceled);
            } else {
                ps.setString(9, "%%");
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setId(rs.getInt("id"));
                invoice.setCreatedAt(rs.getString("created_at"));
                invoice.setFirstName(rs.getNString("first_name"));
                invoice.setLastName(rs.getNString("last_name"));
                invoice.setPhone(rs.getString("phone"));
                invoice.setEmail(rs.getString("email"));
                invoice.setAddress(rs.getNString("address"));
                
                TransportUnit transportUnit = new TransportUnit();
                transportUnit.setId(rs.getInt("transport_unit_id"));
                transportUnit.setName(rs.getNString("transport_unit_name"));
                transportUnit.setType(rs.getNString("transport_unit_type"));
                transportUnit.setPrice(rs.getInt("transport_unit_price"));
                transportUnit.setFastestShipping(rs.getInt("fastest_shipping"));
                transportUnit.setSlowestShipping(rs.getInt("slowest_shipping"));
                invoice.setTransportUnit(transportUnit);
                
                invoice.setDiscount(rs.getInt("discount"));
                invoice.setMessage(rs.getNString("message"));
                invoice.setStatus(rs.getInt("status"));
                invoice.setStatusName(rs.getNString("status_name"));
                invoice.setPaymentStatus(rs.getBoolean("payment_status"));
                invoice.setUserCanceled(rs.getBoolean("user_canceled"));
                
                ArrayList<ProductOrderDTO> invoiceDetails = getInvoiceDetails(invoice.getId());
                invoice.setInvoiceDetails(invoiceDetails);
                        
                invoices.add(invoice);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return invoices;
    }
    
    public Invoice getInvoice(Integer userId, int invoiceId) {
        try {
            String sql = "SELECT\n" +
                        "    invoices.id as id,\n" +
                        "    invoices.created_at as created_at,\n" +
                        "    first_name,\n" +
                        "    last_name,\n" +
                        "    phone,\n" +
                        "    email,\n" +
                        "    address,\n" +
                        "    transport_unit_id,\n" +
                        "    transport_units.name as transport_unit_name,\n" +
                        "    transport_units.type as transport_unit_type,\n" +
                        "    transport_units.price as transport_unit_price,\n" +
                        "    transport_units.fastest_shipping as fastest_shipping,\n" +
                        "    transport_units.slowest_shipping as slowest_shipping,\n" +
                        "    discount,\n" +
                        "    message,\n" +
                        "    status,\n" +
                        "    invoice_states.name as status_name,\n" +
                        "    payment_status,\n" +
                        "    user_canceled\n" +
                        "FROM invoices\n" +
                        "JOIN transport_units ON invoices.transport_unit_id = transport_units.id\n" +
                        "JOIN invoice_states ON invoices.status = invoice_states.id\n" +
                        "WHERE user_id LIKE ?\n" +
                        "AND invoices.id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            if(userId != null) {
                ps.setString(1, userId.toString());
            } else {
                ps.setString(1, "%%");
            }
            ps.setInt(2, invoiceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Invoice invoice = new Invoice();
                invoice.setId(rs.getInt("id"));
                invoice.setCreatedAt(rs.getString("created_at"));
                invoice.setFirstName(rs.getNString("first_name"));
                invoice.setLastName(rs.getNString("last_name"));
                invoice.setPhone(rs.getString("phone"));
                invoice.setEmail(rs.getString("email"));
                invoice.setAddress(rs.getNString("address"));
                
                TransportUnit transportUnit = new TransportUnit();
                transportUnit.setId(rs.getInt("transport_unit_id"));
                transportUnit.setName(rs.getNString("transport_unit_name"));
                transportUnit.setType(rs.getNString("transport_unit_type"));
                transportUnit.setPrice(rs.getInt("transport_unit_price"));
                transportUnit.setFastestShipping(rs.getInt("fastest_shipping"));
                transportUnit.setSlowestShipping(rs.getInt("slowest_shipping"));
                invoice.setTransportUnit(transportUnit);
                
                invoice.setDiscount(rs.getInt("discount"));
                invoice.setMessage(rs.getNString("message"));
                invoice.setStatus(rs.getInt("status"));
                invoice.setStatusName(rs.getNString("status_name"));
                invoice.setPaymentStatus(rs.getBoolean("payment_status"));
                invoice.setUserCanceled(rs.getBoolean("user_canceled"));
                
                ArrayList<ProductOrderDTO> invoiceDetails = getInvoiceDetails(invoice.getId());
                invoice.setInvoiceDetails(invoiceDetails);
                        
                return invoice;
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }
    
    public ArrayList<ProductOrderDTO> getInvoiceDetails(int invoiceId) {
        ArrayList<ProductOrderDTO> products = new ArrayList<>();
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
                        "	invoice_details.quantity AS quantity,\n" +
                        "	price\n" +
                        "FROM invoice_details\n" +
                        "JOIN product_variants ON invoice_details.product_variant_id = product_variants.id\n" +
                        "JOIN products ON products.id = product_variants.product_id\n" +
                        "JOIN images ON images.product_id = products.id\n" +
                        "WHERE invoice_id = ?\n" +
                        "ORDER BY invoice_details.created_at DESC";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, invoiceId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                ProductOrderDTO product = new ProductOrderDTO();
                product.setProductId(rs.getInt("product_id"));
                product.setName(rs.getNString("product_name"));
                product.setSlug(rs.getString("product_slug"));
                product.setImageId(rs.getInt("image_id"));
                product.setAlt(rs.getString("image_alt"));
                product.setProductVariantId(rs.getInt("product_variant_id"));
                product.setVariant(rs.getNString("variant"));
                product.setCartQuantity(rs.getInt("quantity"));
                product.setPrice(rs.getInt("price"));
                        
                products.add(product);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return products;
    }
    
    public void updatePaymentStatus(int invoiceId, int paymentStatus) {
        try {
            String sql = "UPDATE invoices\n" +
                        "SET payment_status = ?\n" +
                        "WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, paymentStatus);
            ps.setInt(2, invoiceId);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void updateStatus(int invoiceId, int status) {
        Invoice invoice = getInvoice(null, invoiceId);
        if(invoice.isUserCanceled()) return;
        
        try {
            String sql = "UPDATE invoices\n" +
                        "SET status = ?\n" +
                        "WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, invoiceId);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void userCancelOrder(int userId, int invoiceId){
        
        try {
            String sql = "UPDATE invoices\n" +
                        "SET status = 1,\n" +
                        "   user_canceled = 1\n" +
                        "WHERE user_id = ?\n" +
                        "AND id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            ps.setInt(2, invoiceId);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
}
