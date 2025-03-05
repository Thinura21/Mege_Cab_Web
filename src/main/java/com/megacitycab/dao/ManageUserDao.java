package com.megacitycab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.megacitycab.model.Users;
import com.megacitycab.model.Customer;
import com.megacitycab.model.Driver;
import com.megacitycab.util.DBConnection;

public class ManageUserDao {

    // Retrieve all users
    public List<Users> getAllUsers() {
        List<Users> list = new ArrayList<>();
        String sql = "SELECT * FROM user";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()){
            while(rs.next()){
                Users user = new Users();
                user.setUser_id(rs.getInt("user_id"));
                user.setF_name(rs.getString("f_name"));
                user.setAddress(rs.getString("Address"));
                user.setContact(rs.getString("Contact"));
                user.setUser_name(rs.getString("user_name"));
                user.setPassword(rs.getString("password"));
                user.setRole(rs.getString("role"));
                list.add(user);
            }
        } catch(SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return list;
    }
    
    // Retrieve a user by user_id
    public Users getUserById(int userId) {
        Users user = null;
        String sql = "SELECT * FROM user WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){
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
        } catch(SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return user;
    }
    
    // Insert a new user record and return the generated user ID.
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
            if (rows > 0) {
                ResultSet keys = ps.getGeneratedKeys();
                if (keys.next()) {
                    newUserId = keys.getInt(1);
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }
        return newUserId;
    }

    // Update the user record and update related fields if the role is Customer or Driver.
    public int updateUserAndRelated(Users user) {
        int rows = 0;
        // Update the user record in the user table.
        String sql = "UPDATE user SET f_name = ?, Address = ?, Contact = ?, user_name = ?, password = ?, role = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setString(1, user.getF_name());
            ps.setString(2, user.getAddress());
            ps.setString(3, user.getContact());
            ps.setString(4, user.getUser_name());
            ps.setString(5, user.getPassword());
            ps.setString(6, user.getRole());
            ps.setInt(7, user.getUser_id());
            rows = ps.executeUpdate();
        } catch(SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        // Update related table if role is Customer.
        if("Customer".equalsIgnoreCase(user.getRole())){
            ManageCustomerDao custDao = new ManageCustomerDao();
            Customer cust = custDao.getCustomerByUserId(user.getUser_id());
            if(cust != null){
                cust.setName(user.getF_name());
                cust.setAddress(user.getAddress());
                cust.setContact(user.getContact());
                int r = custDao.editCustomer(cust);
                rows += r;
            }
        }
        // Update related table if role is Driver.
        else if("Driver".equalsIgnoreCase(user.getRole())){
            com.megacitycab.dao.DriverDao driverDao = new com.megacitycab.dao.DriverDao();
            Driver drv = driverDao.getDriverByUserId(user.getUser_id());
            if(drv != null){
                drv.setFName(user.getF_name());
                drv.setAddress(user.getAddress());
                drv.setContact(user.getContact());
                int r = driverDao.updateDriver(drv);
                rows += r;
            }
        }
        return rows;
    }
    
    // Delete a user record (related records in Customers/Drivers will be deleted via ON DELETE CASCADE)
    public int deleteUser(int userId) {
        int rows = 0;
        String sql = "DELETE FROM user WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, userId);
            rows = ps.executeUpdate();
        } catch(SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return rows;
    }
}
