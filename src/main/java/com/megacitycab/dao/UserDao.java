package com.megacitycab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.megacitycab.model.Users;
import com.megacitycab.util.DBConnection;


public class UserDao {
    
    public int register_Users(Users users) throws ClassNotFoundException {
        String sql = "INSERT IGNORE INTO user (f_name, Address, Contact, user_name, password, role) "
                   + "VALUES (?, ?, ?, ?, ?, ?)";
        
        int result = 0;
        try (Connection con = DBConnection.getConnection();
             PreparedStatement ps = con.prepareStatement(sql)) {
            
            ps.setString(1, users.getF_name());
            ps.setString(2, users.getAddress());
            ps.setString(3, users.getContact());
            ps.setString(4, users.getUser_name());
            ps.setString(5, users.getPassword());
            ps.setString(6, users.getRole()); // role

            result = ps.executeUpdate();
            System.out.println("Insert Result: " + result);

        } catch (SQLException e) {
            e.printStackTrace();
        }

        return result;
    }
    
    public Users validate(String uname, String password) throws ClassNotFoundException {
        Users user = null;
        String sql = "SELECT * FROM user WHERE user_name = ? AND password = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, uname);
            ps.setString(2, password);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                user = new Users();
                user.setUser_id(rs.getInt("user_id"));
                user.setF_name(rs.getString("f_name"));
                user.setAddress(rs.getString("Address"));
                user.setContact(rs.getString("Contact"));
                user.setUser_name(rs.getString("user_name"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return user;
    }
    
    // New method to retrieve a user by user_id
    public Users getUserById(int userId) throws ClassNotFoundException {
        Users user = null;
        String sql = "SELECT * FROM user WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                user = new Users();
                user.setUser_id(rs.getInt("user_id"));
                user.setF_name(rs.getString("f_name"));
                user.setAddress(rs.getString("Address"));
                user.setContact(rs.getString("Contact"));
                user.setUser_name(rs.getString("user_name"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return user;
    }
    
    // New method to insert a new user record and return the generated user ID
    public int insertUser(Users user) throws ClassNotFoundException {
        int newUserId = 0;
        String sql = "INSERT INTO user (f_name, Address, Contact, user_name, password, role) VALUES (?, ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, PreparedStatement.RETURN_GENERATED_KEYS)) {
            ps.setString(1, user.getF_name());
            ps.setString(2, user.getAddress());
            ps.setString(3, user.getContact());
            ps.setString(4, user.getUser_name());
            ps.setString(5, user.getPassword());
            ps.setString(6, user.getRole());
            int rows = ps.executeUpdate();
            if(rows > 0){
                ResultSet keys = ps.getGeneratedKeys();
                if(keys.next()){
                    newUserId = keys.getInt(1);
                }
            }
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return newUserId;
    }
    
    // Existing updateUser method
    public int updateUser(String userName, String password, int userId) throws ClassNotFoundException {
        int rows = 0;
        String sql = "UPDATE user SET user_name = ?, password = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userName);
            ps.setString(2, password);
            ps.setInt(3, userId);
            rows = ps.executeUpdate();
        } catch(SQLException e) {
            e.printStackTrace();
        }
        return rows;
    }
}
