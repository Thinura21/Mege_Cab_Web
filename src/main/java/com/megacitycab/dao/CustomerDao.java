package com.megacitycab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import com.megacitycab.model.Customer;
import com.megacitycab.util.DBConnection;

public class CustomerDao {

    public Customer getCustomerByUserId(int userId) {
        Customer customer = null;
        String sql = "SELECT * FROM Customers WHERE user_id = ?";

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();

            if (rs.next()) {
                customer = new Customer();
                customer.setCustomerId(rs.getInt("customer_id"));
                customer.setUserId(rs.getInt("user_id"));
                customer.setName(rs.getString("name"));
                customer.setAddress(rs.getString("address"));
                customer.setNic(rs.getString("nic"));
                customer.setContact(rs.getString("contact"));
                customer.setEmail(rs.getString("email"));
                customer.setProfilePicture(rs.getBytes("profile_picture"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return customer;
    }

    public int insertCustomer(Customer customer) {
        String sql = "INSERT INTO Customers (user_id, name, address, nic, contact, email, profile_picture) "
                   + "VALUES (?, ?, ?, ?, ?, ?, ?)";
        int rowsInserted = 0;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setInt(1, customer.getUserId());
            ps.setString(2, customer.getName());
            ps.setString(3, customer.getAddress());
            ps.setString(4, customer.getNic());
            ps.setString(5, customer.getContact());
            ps.setString(6, customer.getEmail());
            ps.setBytes(7, customer.getProfilePicture());

            rowsInserted = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rowsInserted;
    }

    public int updateCustomer(Customer customer) {
        String sql = "UPDATE Customers SET name=?, address=?, nic=?, contact=?, email=?, profile_picture=? "
                   + "WHERE customer_id=?";
        int rowsUpdated = 0;

        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {

            ps.setString(1, customer.getName());
            ps.setString(2, customer.getAddress());
            ps.setString(3, customer.getNic());
            ps.setString(4, customer.getContact());
            ps.setString(5, customer.getEmail());
            ps.setBytes(6, customer.getProfilePicture());
            ps.setInt(7, customer.getCustomerId());

            rowsUpdated = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rowsUpdated;
    }
}
