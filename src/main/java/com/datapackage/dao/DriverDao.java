package com.datapackage.dao;

import com.datapackage.model.Driver;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class DriverDao {

    // Register a new driver (inserts into Users then Driver)
    public int registerDriver(Driver driver) throws ClassNotFoundException, SQLException {
        int result = 0;
        Connection con = null;
        PreparedStatement psUsers = null;
        PreparedStatement psDriver = null;
        ResultSet generatedKeys = null;
        try {
            con = DBConnection.getConnection();
            con.setAutoCommit(false);

            // Insert into Users table
            String sqlUsers = "INSERT INTO Users (Email, Password, Role) VALUES (?, ?, ?)";
            psUsers = con.prepareStatement(sqlUsers, Statement.RETURN_GENERATED_KEYS);
            psUsers.setString(1, driver.getEmail());
            psUsers.setString(2, driver.getPassword());
            psUsers.setString(3, "Driver");

            int userRows = psUsers.executeUpdate();
            if (userRows > 0) {
                generatedKeys = psUsers.getGeneratedKeys();
                if (generatedKeys.next()) {
                    int userID = generatedKeys.getInt(1);

                    // Insert into Driver table using userID
                    String sqlDriver = "INSERT INTO Driver (UserID, Email, Name, Address, NIC, Contact) "
                                     + "VALUES (?, ?, ?, ?, ?, ?)";
                    psDriver = con.prepareStatement(sqlDriver);
                    psDriver.setInt(1, userID);
                    psDriver.setString(2, driver.getEmail());
                    psDriver.setString(3, driver.getName());
                    psDriver.setString(4, driver.getAddress());
                    psDriver.setString(5, driver.getNic());
                    psDriver.setString(6, driver.getContact());

                    int driverRows = psDriver.executeUpdate();
                    if (driverRows > 0) {
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
            if(con != null) con.rollback();
            throw e;
        } finally {
            if(generatedKeys != null) generatedKeys.close();
            if(psDriver != null) psDriver.close();
            if(psUsers != null) psUsers.close();
            if(con != null) {
                con.setAutoCommit(true);
                con.close();
            }
        }
        return result;
    }

    // Retrieve all drivers
    public List<Driver> getAllDrivers() throws ClassNotFoundException, SQLException {
        List<Driver> list = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM Driver";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Driver driver = new Driver();
                driver.setUserID(String.valueOf(rs.getInt("UserID")));
                driver.setEmail(rs.getString("Email"));
                driver.setName(rs.getString("Name"));
                driver.setAddress(rs.getString("Address"));
                driver.setNic(rs.getString("NIC"));
                driver.setContact(rs.getString("Contact"));
                list.add(driver);
            }
        } finally {
            con.close();
        }
        return list;
    }

    // Update an existing driver
    public int updateDriver(int userID, String name, String address, String nic, String contact)
            throws ClassNotFoundException, SQLException {
        Connection con = DBConnection.getConnection();
        String sql = "UPDATE Driver SET Name = ?, Address = ?, NIC = ?, Contact = ? WHERE UserID = ?";
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

    // Delete a driver
    public int deleteDriver(int userID) throws ClassNotFoundException, SQLException {
        Connection con = DBConnection.getConnection();
        String sql = "DELETE FROM Driver WHERE UserID = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, userID);
            return ps.executeUpdate();
        } finally {
            con.close();
        }
    }
}
