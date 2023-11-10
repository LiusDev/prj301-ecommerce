/*
 * Click nbfs://nbhost/SystemFileSystem/Templates/Licenses/license-default.txt to change this license
 * Click nbfs://nbhost/SystemFileSystem/Templates/Classes/Class.java to edit this template
 */
package dao;

import context.DBContext;
import java.io.InputStream;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.sql.Statement;
import java.util.ArrayList;
import model.User;
import org.mindrot.jbcrypt.BCrypt;

/**
 *
 * @author LiusDev
 */
public class UserDAO extends DBContext{
    public void newUser(String firstName, String lastName, String email, String password, String bio, InputStream avatar, String role, int status) {
        try {
            String sql = "INSERT INTO users (\n" +
                        "    first_name,\n" +
                        "    last_name,\n" +
                        "    email,\n" +
                        "    password,\n" +
                        "    bio,\n" +
                        "    role,\n" +
                        "    is_banned,\n" +
                        "    avatar\n" +
                        ") VALUES (\n" +
                        "    ?,\n" +
                        "    ?,\n" +
                        "    ?,\n" +
                        "    ?,\n" +
                        "    ?,\n" +
                        "    ?,\n" +
                        "    ?,\n" +
                        "    ?\n" +
                        ")";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, firstName);
            ps.setNString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, password);
            ps.setNString(5, bio);
            ps.setNString(6, role);
            ps.setInt(7, status);
            ps.setBlob(8, avatar);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    public int register(String email, String password, String firstName, String lastName) {
        try {
            String sql = "INSERT INTO users (\n" +
                        "    first_name,\n" +
                        "    last_name,\n" +
                        "    email,\n" +
                        "    password\n" +
                        ") VALUES (\n" +
                        "    ?,\n" +
                        "    ?,\n" +
                        "    ?,\n" +
                        "    ?\n" +
                        ")";
            PreparedStatement ps = connection.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS);
            ps.setNString(1, firstName);
            ps.setNString(2, lastName);
            ps.setString(3, email);
            ps.setString(4, password);
            
            ps.executeUpdate();
            try (ResultSet generatedKeys = ps.getGeneratedKeys()) {
                if (generatedKeys.next()) {
                    return generatedKeys.getInt(1);
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
    
    public User getUserByEmail(String email) {
        try {
            String sql = "SELECT * FROM users WHERE email = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, email);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setCreatedAt(rs.getString("created_at"));
                user.setFirstName(rs.getNString("first_name"));
                user.setLastName(rs.getNString("last_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setBio(rs.getNString("bio"));
                user.setRole(rs.getString("role"));
                user.setIsBanned(rs.getBoolean("is_banned"));
                return user;
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }
    
    public User getUserById(int id) {
        try {
            String sql = "SELECT * FROM users WHERE id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setCreatedAt(rs.getString("created_at"));
                user.setFirstName(rs.getNString("first_name"));
                user.setLastName(rs.getNString("last_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setBio(rs.getNString("bio"));
                user.setRole(rs.getString("role"));
                user.setIsBanned(rs.getBoolean("is_banned"));
                return user;
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }
    
    public byte[] getUserAvatar(int id) {
        try {
            String sql = "SELECT * FROM users "
                        + "WHERE id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                return rs.getBytes("avatar");
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return null;
    }
    
    public void updateUserInfo(int userId, String firstName, String lastName, String email, String bio, String role, InputStream avatar) {
        try {
            String sql;
            if(avatar != null) {
                sql = "UPDATE users\n" +
                        "SET\n" +
                        "    first_name = ?,\n" +
                        "    last_name = ?,\n" +
                        "    email = ?,\n" +
                        "    bio = ?,\n" +
                        "    role = ?,\n" +
                        "    avatar = ?\n" +
                        "WHERE id = ?;";
            } else {
                sql = "UPDATE users\n" +
                        "SET\n" +
                        "    first_name = ?,\n" +
                        "    last_name = ?,\n" +
                        "    email = ?,\n" +
                        "    bio = ?,\n" +
                        "    role = ?\n" +
                        "WHERE id = ?;";
            }
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setNString(1, firstName);
            ps.setNString(2, lastName);
            ps.setString(3, email);
            ps.setNString(4, bio);
            ps.setNString(5, role);
            if(avatar != null) {
                ps.setBlob(6, avatar);
                ps.setInt(7, userId);
            } else {
                ps.setInt(6, userId);
            }
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void updateUserStatus(int userId, int status) {
        try {
            String sql = "UPDATE users\n" +
                        "SET is_banned = ?\n" +
                        "WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, status);
            ps.setInt(2, userId);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void resetDefaultPassword(int userId) {
        String defaultPassword = BCrypt.hashpw("123456", BCrypt.gensalt(10));
        try {
            String sql = "UPDATE users\n" +
                        "SET password = N'" + defaultPassword + "'\n" +
                        "WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, userId);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public void updatePassword(int userId, String password) {
        try {
            String sql = "UPDATE users\n" +
                        "SET password = ?\n" +
                        "WHERE id = ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setString(1, password);
            ps.setInt(2, userId);
            
            ps.executeUpdate();
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
    
    public ArrayList<User> getAllUser(Integer limit, String keyword, String role, String status) {
        if(limit == null) limit = 1000;
        ArrayList<User> allUser = new ArrayList<>();
        try {
            String sql = "SELECT TOP(?) *\n" +
                        "FROM users\n" +
                        "WHERE (\n" +
                        "    first_name LIKE ? OR\n" +
                        "    last_name LIKE ? OR\n" +
                        "    email LIKE ?\n" +
                        ") AND\n" +
                        "users.role LIKE ? AND\n" +
                        "is_banned LIKE ?";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, limit);
            if(keyword != null) {
                ps.setString(2, "%" + keyword + "%");
                ps.setString(3, "%" + keyword + "%");
                ps.setString(4, "%" + keyword + "%");
            } else {
                ps.setString(2, "%%");
                ps.setString(3, "%%");
                ps.setString(4, "%%");
            }
            if(role != null) {
                ps.setString(5, role);
            } else {
                ps.setString(5, "%%");
            }
            if(status != null) {
                ps.setString(6, status);
            } else {
                ps.setString(6, "%%");
            }
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                User user = new User();
                user.setId(rs.getInt("id"));
                user.setCreatedAt(rs.getString("created_at"));
                user.setFirstName(rs.getNString("first_name"));
                user.setLastName(rs.getNString("last_name"));
                user.setEmail(rs.getString("email"));
                user.setPassword(rs.getString("password"));
                user.setBio(rs.getNString("bio"));
                user.setRole(rs.getString("role"));
                user.setIsBanned(rs.getBoolean("is_banned"));
                
                allUser.add(user);
            }
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
        return allUser;
    }
    
    public void deleteUser(int id) {
        try {
            String sql = "DELETE FROM users WHERE id = ?;";
            PreparedStatement ps = connection.prepareStatement(sql);
            ps.setInt(1, id);
            
            ps.executeUpdate();
            
            
        } catch (SQLException ex) {
            System.out.println(ex);
        }
    }
}
