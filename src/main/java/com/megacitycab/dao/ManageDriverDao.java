package com.megacitycab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.megacitycab.model.Driver;
import com.megacitycab.model.Vehicle;
import com.megacitycab.util.DBConnection;

public class ManageDriverDao {

    // Retrieve all drivers from the Drivers table
    public List<Driver> getAllDrivers() {
        List<Driver> list = new ArrayList<>();
        String sql = "SELECT * FROM Drivers";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Driver driver = new Driver();
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
                list.add(driver);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Retrieve a driver by driver_id
    public Driver getDriverById(int driverId) {
        Driver driver = null;
        String sql = "SELECT * FROM Drivers WHERE driver_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
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
    
    // Retrieve the vehicle associated with a driver (using VehicleDao)
    public Vehicle getVehicleByDriverId(int driverId) {
        VehicleDao vehicleDao = new VehicleDao();
        return vehicleDao.getVehicleByDriverId(driverId);
    }
    
    // Add a new driver and the associated vehicle
    public int addDriver(Driver driver, Vehicle vehicle) {
        int rows = 0;
        // Insert the driver using DriverDao
        DriverDao driverDao = new DriverDao();
        rows = driverDao.insertDriver(driver);
        if (rows > 0) {
            // Retrieve the inserted driver by userId to get generated driver_id
            driver = driverDao.getDriverByUserId(driver.getUserId());
            if (driver != null && vehicle != null) {
                vehicle.setDriverId(driver.getDriverId());
                VehicleDao vehicleDao = new VehicleDao();
                rows += vehicleDao.insertVehicle(vehicle);
            }
        }
        return rows;
    }
    
    // Update driver details and associated vehicle details
    public int updateDriver(Driver driver, Vehicle vehicle) {
        int rows = 0;
        DriverDao driverDao = new DriverDao();
        rows = driverDao.updateDriver(driver);
        VehicleDao vehicleDao = new VehicleDao();
        Vehicle existingVehicle = vehicleDao.getVehicleByDriverId(driver.getDriverId());
        if (existingVehicle == null) {
            if (vehicle != null) {
                vehicle.setDriverId(driver.getDriverId());
                rows += vehicleDao.insertVehicle(vehicle);
            }
        } else {
            if (vehicle != null) {
                vehicle.setVehicleId(existingVehicle.getVehicleId());
                vehicle.setDriverId(driver.getDriverId());
                rows += vehicleDao.updateVehicle(vehicle);
            }
        }
        return rows;
    }
    
    // Delete driver and associated vehicle records
    public int deleteDriverAndVehicle(int driverId) {
        int rows = 0;
        // Delete vehicles associated with the driver
        String sqlVehicle = "DELETE FROM Vehicles WHERE driver_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlVehicle)) {
            ps.setInt(1, driverId);
            rows += ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        // Delete driver record
        String sqlDriver = "DELETE FROM Drivers WHERE driver_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sqlDriver)) {
            ps.setInt(1, driverId);
            rows += ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rows;
    }
    

    public int updateUser(String userName, String password, int userId) {
        int rows = 0;
        String sql = "UPDATE user SET user_name = ?, password = ? WHERE user_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, userName);
            ps.setString(2, password);
            ps.setInt(3, userId);
            rows = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rows;
    }
}
