package com.megacitycab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.megacitycab.model.Driver;
import com.megacitycab.util.DBConnection;

public class DriverDao {

    public Driver getDriverByUserId(int userId) {
        Driver driver = null;
        String sql = "SELECT * FROM Drivers WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, userId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                driver = new Driver();
                driver.setDriverId(rs.getInt("driver_id"));
                driver.setUserId(rs.getInt("user_id"));
                driver.setProfilePicture(rs.getBytes("profile_picture"));
                driver.setFName(rs.getString("f_name"));
                driver.setAddress(rs.getString("Address"));
                driver.setContact(rs.getString("Contact"));
                driver.setEmail(rs.getString("email"));
                driver.setLicenseNumber(rs.getString("license_number"));
                driver.setLicencePhoto(rs.getBytes("licence_photo"));
                driver.setStatus(rs.getString("status"));
                driver.setVerified(rs.getBoolean("verified"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return driver;
    }

    public int insertDriver(Driver driver) {
        String sql = "INSERT INTO Drivers (user_id, profile_picture, f_name, Address, Contact, email, license_number, licence_photo, status, verified) VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        int rowsInserted = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driver.getUserId());
            ps.setBytes(2, driver.getProfilePicture());
            ps.setString(3, driver.getFName());
            ps.setString(4, driver.getAddress());
            ps.setString(5, driver.getContact());
            ps.setString(6, driver.getEmail());
            ps.setString(7, driver.getLicenseNumber());
            ps.setBytes(8, driver.getLicencePhoto());
            ps.setString(9, driver.getStatus());
            ps.setBoolean(10, false);
            rowsInserted = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rowsInserted;
    }

    public int updateDriver(Driver driver) {
        String sql = "UPDATE Drivers SET profile_picture=?, f_name=?, Address=?, Contact=?, email=?, license_number=?, licence_photo=?, status=? WHERE driver_id=?";
        int rowsUpdated = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBytes(1, driver.getProfilePicture());
            ps.setString(2, driver.getFName());
            ps.setString(3, driver.getAddress());
            ps.setString(4, driver.getContact());
            ps.setString(5, driver.getEmail());
            ps.setString(6, driver.getLicenseNumber());
            ps.setBytes(7, driver.getLicencePhoto());
            ps.setString(8, driver.getStatus());
            ps.setInt(9, driver.getDriverId());
            rowsUpdated = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rowsUpdated;
    }
}
