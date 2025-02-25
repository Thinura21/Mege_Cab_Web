package com.datapackage.dao;

import com.datapackage.model.Customer;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class CustomerDao {

    // Register a new customer (inserts into Users then Customer)
    public int registerCustomer(Customer customer) throws ClassNotFoundException, SQLException {
        int result = 0;
        Connection con = null;
        PreparedStatement psUsers = null;
        PreparedStatement psCustomer = null;
        ResultSet generatedKeys = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Insert into Users table (ID auto-generated)
            String sqlUsers = "INSERT INTO Users (Email, Password, Role) VALUES (?, ?, ?)";
            psUsers = con.prepareStatement(sqlUsers, Statement.RETURN_GENERATED_KEYS);
            psUsers.setString(1, customer.getEmail());
            psUsers.setString(2, customer.getPassword());
            psUsers.setString(3, "Customer");

            int userRows = psUsers.executeUpdate();
            if (userRows > 0) {
                generatedKeys = psUsers.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userID = generatedKeys.getInt(1);

                    // Insert into Customer table using generated userID
                    String sqlCustomer = "INSERT INTO Customer (UserID, Email, Name, Address, NIC, Contact) VALUES (?, ?, ?, ?, ?, ?)";
                    psCustomer = con.prepareStatement(sqlCustomer);
                    psCustomer.setInt(1, userID);
                    psCustomer.setString(2, customer.getEmail());
                    psCustomer.setString(3, customer.getName());
                    psCustomer.setString(4, customer.getAddress());
                    psCustomer.setString(5, customer.getNic());
                    psCustomer.setString(6, customer.getContact());

                    int custRows = psCustomer.executeUpdate();
                    if (custRows > 0) {
                        con.commit();
                        result = 1;
                    } else {
                        con.rollback();
                    }
                } else {
                    con.rollback();
                }
            } else {
                con.rollback();
            }
        } catch (SQLException e) {
            if (con != null) con.rollback();
            throw e;
        } finally {
            if (generatedKeys != null) generatedKeys.close();
            if (psCustomer != null) psCustomer.close();
            if (psUsers != null) psUsers.close();
            if (con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
        return result;
    }

    // Retrieve all customers
    public List<Customer> getAllCustomers() throws ClassNotFoundException, SQLException {
        List<Customer> list = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM Customer";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Customer customer = new Customer();
                customer.setUserID(String.valueOf(rs.getInt("UserID")));
                customer.setEmail(rs.getString("Email"));
                customer.setName(rs.getString("Name"));
                customer.setAddress(rs.getString("Address"));
                customer.setNic(rs.getString("NIC"));
                customer.setContact(rs.getString("Contact"));
                list.add(customer);
            }
        } finally {
            con.close();
        }
        return list;
    }

    // Search customers based on query (searches across Email, Name, Address, NIC, and Contact)
    public List<Customer> searchCustomers(String query) throws ClassNotFoundException, SQLException {
        List<Customer> list = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM Customer WHERE Email LIKE ? OR Name LIKE ? OR Address LIKE ? OR NIC LIKE ? OR Contact LIKE ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            String wildcardQuery = "%" + query + "%";
            ps.setString(1, wildcardQuery);
            ps.setString(2, wildcardQuery);
            ps.setString(3, wildcardQuery);
            ps.setString(4, wildcardQuery);
            ps.setString(5, wildcardQuery);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Customer customer = new Customer();
                    customer.setUserID(String.valueOf(rs.getInt("UserID")));
                    customer.setEmail(rs.getString("Email"));
                    customer.setName(rs.getString("Name"));
                    customer.setAddress(rs.getString("Address"));
                    customer.setNic(rs.getString("NIC"));
                    customer.setContact(rs.getString("Contact"));
                    list.add(customer);
                }
            }
        } finally {
            con.close();
        }
        return list;
    }

    // Update an existing customer
    public int updateCustomer(int userID, String name, String address, String nic, String contact) throws ClassNotFoundException, SQLException {
        Connection con = DBConnection.getConnection();
        String sql = "UPDATE Customer SET Name = ?, Address = ?, NIC = ?, Contact = ? WHERE UserID = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, name);
            ps.setString(2, address);
            ps.setString(3, nic);
            ps.setString(4, contact);
            ps.setInt(5, userID);
            return ps.executeUpdate();
        } finally {
            con.close();
        }
    }

    // Delete a customer
    public int deleteCustomer(int userID) throws ClassNotFoundException, SQLException {
        Connection con = DBConnection.getConnection();
        String sql = "DELETE FROM Customer WHERE UserID = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userID);
            return ps.executeUpdate();
        } finally {
            con.close();
        }
    }
}
