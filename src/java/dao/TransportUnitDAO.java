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
import model.TransportUnit;

/**
 *
 * @author LiusDev
 */
public class TransportUnitDAO extends DBContext {
    public ArrayList<TransportUnit> getTransportUnits(int limit) {
        ArrayList<TransportUnit> transportUnits = new ArrayList<>();
        try {
            String sql = "SELECT TOP(?) * FROM transport_units WHERE storage = 0";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, limit);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                TransportUnit transportUnit = new TransportUnit();
                transportUnit.setId(rs.getInt("id"));
                transportUnit.setCreatedAt(rs.getString("created_at"));
                transportUnit.setName(rs.getNString("name"));
                transportUnit.setType(rs.getNString("type"));
                transportUnit.setPrice(rs.getInt("price"));
                transportUnit.setFastestShipping(rs.getInt("fastest_shipping"));
                transportUnit.setSlowestShipping(rs.getInt("slowest_shipping"));
                
                transportUnits.add(transportUnit);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return transportUnits;
    }
    
    public void deleteTransportUnit(int id) {
        try {
            String sql = "UPDATE transport_units\n" +
                        "SET storage = 1\n" +
                        "WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void updateTransportUnit(int id, String name, String type, int price, int fastestShipping, int slowestShipping) {
        try {
            String sql = "UPDATE transport_units\n" + 
                        "SET\n" + 
                        "   name = ?,\n" +
                        "   type = ?,\n" +
                        "   price = ?,\n" +
                        "   fastest_shipping = ?,\n" +
                        "   slowest_shipping = ?\n" + 
                        "WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, name);
            ps.setNString(2, type);
            ps.setInt(3, price);
            ps.setInt(4, fastestShipping);
            ps.setInt(5, slowestShipping);
            ps.setInt(6, id);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public int addTransportUnit(String name, String type, int price, int fastestShipping, int slowestShipping) {
        try {
            String sql = "INSERT INTO transport_units\n" +
                        "(\n" +
                        "    name,\n" +
                        "    type,\n" +
                        "    price,\n" +
                        "    fastest_shipping,\n" +
                        "    slowest_shipping\n" +
                        ")\n" +
                        "VALUES \n" +
                        "(\n" +
                        "    ?,\n" +
                        "    ?,\n" +
                        "    ?,\n" +
                        "    ?,\n" +
                        "    ?\n" +
                        ")";
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setNString(1, name);
            ps.setNString(2, type);
            ps.setInt(3, price);
            ps.setInt(4, fastestShipping);
            ps.setInt(5, slowestShipping);
            
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
}
