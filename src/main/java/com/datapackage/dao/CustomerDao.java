package com.datapackage.dao;

import com.datapackage.model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDao {

    public int addCustomer(Customer customer) {
        String sql = "INSERT INTO customer (nic, name, address, contact, password, usertype) VALUES (?, ?, ?, ?, ?, ?)";
        int result = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getNic());
            ps.setString(2, customer.getName());
            ps.setString(3, customer.getAddress());
            ps.setString(4, customer.getContact());
            ps.setString(5, customer.getPassword());
            ps.setString(6, customer.getUserType());
            result = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return result;
    }

    public List<Customer> getAllCustomers() {
        List<Customer> customers = new ArrayList<>();
        String sql = "SELECT * FROM customer";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setId(rs.getInt("id"));
                customer.setNic(rs.getString("nic"));
                customer.setName(rs.getString("name"));
                customer.setAddress(rs.getString("address"));
                customer.setContact(rs.getString("contact"));
                customer.setUserType(rs.getString("usertype"));
                customers.add(customer);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return customers;
    }

    // New Method: Delete Customer
    public boolean deleteCustomer(int id) {
        String sql = "DELETE FROM customer WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    // New Method: Update Customer
    public boolean updateCustomer(Customer customer) {
        String sql = "UPDATE customer SET nic=?, name=?, address=?, contact=?, usertype=? WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, customer.getNic());
            ps.setString(2, customer.getName());
            ps.setString(3, customer.getAddress());
            ps.setString(4, customer.getContact());
            ps.setString(5, customer.getUserType());
            ps.setInt(6, customer.getId());
            return ps.executeUpdate() > 0;
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return false;
    }

    // New Method: Get Customer By ID
    public Customer getCustomerById(int id) {
        String sql = "SELECT * FROM customer WHERE id=?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, id);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                Customer customer = new Customer();
                customer.setId(rs.getInt("id"));
                customer.setNic(rs.getString("nic"));
                customer.setName(rs.getString("name"));
                customer.setAddress(rs.getString("address"));
                customer.setContact(rs.getString("contact"));
                customer.setUserType(rs.getString("usertype"));
                return customer;
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return null;
    }
}
