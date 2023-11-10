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
public class AddressDAO extends DBContext{
    public ArrayList<String> getProvinces() {
        ArrayList<String> provinces = new ArrayList<>();
        try {
            String sql = "SELECT * FROM provinces";
            PreparedStatement ps = connection.prepareStatement(sql);
            
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                provinces.add(rs.getNString("name"));
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return provinces;
    }
}
