package com.datapackage.dao;

import com.datapackage.model.Customer;
import java.sql.*;

public class CustomerDao {

    public int registerCustomer(Customer customer) throws ClassNotFoundException, SQLException {
        int result = 0;
        Connection con = null;
        PreparedStatement psUsers = null;
        PreparedStatement psCustomer = null;
        ResultSet generatedKeys = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // 1) Insert into Users table (auto-generated ID)
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
                    
                    // 2) Insert into Customer table using the generated userID
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
}
