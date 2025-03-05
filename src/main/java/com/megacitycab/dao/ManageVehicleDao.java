package com.megacitycab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;
import com.megacitycab.model.Vehicle;
import com.megacitycab.util.DBConnection;

public class ManageVehicleDao {

    // Retrieve all vehicles
    public List<Vehicle> getAllVehicles() {
        List<Vehicle> list = new ArrayList<>();
        String sql = "SELECT * FROM Vehicles";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Vehicle vehicle = new Vehicle();
                vehicle.setVehicleId(rs.getInt("vehicle_id"));
                vehicle.setVehiclePhoto(rs.getBytes("vehicle_photo"));
                vehicle.setModel(rs.getString("model"));
                vehicle.setLicensePlate(rs.getString("license_plate"));
                vehicle.setLicensePlatePhoto(rs.getBytes("license_plate_photo"));
                vehicle.setType(rs.getString("type"));
                vehicle.setColor(rs.getString("color"));
                vehicle.setStatus(rs.getString("status"));
                vehicle.setDriverId(rs.getInt("driver_id"));
                list.add(vehicle);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Retrieve a single vehicle by vehicle_id
    public Vehicle getVehicleById(int vehicleId) {
        Vehicle vehicle = null;
        String sql = "SELECT * FROM Vehicles WHERE vehicle_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    vehicle = new Vehicle();
                    vehicle.setVehicleId(rs.getInt("vehicle_id"));
                    vehicle.setVehiclePhoto(rs.getBytes("vehicle_photo"));
                    vehicle.setModel(rs.getString("model"));
                    vehicle.setLicensePlate(rs.getString("license_plate"));
                    vehicle.setLicensePlatePhoto(rs.getBytes("license_plate_photo"));
                    vehicle.setType(rs.getString("type"));
                    vehicle.setColor(rs.getString("color"));
                    vehicle.setStatus(rs.getString("status"));
                    vehicle.setDriverId(rs.getInt("driver_id"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return vehicle;
    }
    
    // Add a new vehicle
    public int addVehicle(Vehicle vehicle) {
        String sql = "INSERT INTO Vehicles (vehicle_photo, model, license_plate, license_plate_photo, type, color, status, driver_id) VALUES (?, ?, ?, ?, ?, ?, ?, ?)";
        int rowsInserted = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBytes(1, vehicle.getVehiclePhoto());
            ps.setString(2, vehicle.getModel());
            ps.setString(3, vehicle.getLicensePlate());
            ps.setBytes(4, vehicle.getLicensePlatePhoto());
            ps.setString(5, vehicle.getType());
            ps.setString(6, vehicle.getColor());
            ps.setString(7, vehicle.getStatus());
            ps.setInt(8, vehicle.getDriverId());
            rowsInserted = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rowsInserted;
    }
    
    // Update an existing vehicle
    public int editVehicle(Vehicle vehicle) {
        String sql = "UPDATE Vehicles SET vehicle_photo=?, model=?, license_plate=?, license_plate_photo=?, type=?, color=?, status=? WHERE vehicle_id=?";
        int rowsUpdated = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setBytes(1, vehicle.getVehiclePhoto());
            ps.setString(2, vehicle.getModel());
            ps.setString(3, vehicle.getLicensePlate());
            ps.setBytes(4, vehicle.getLicensePlatePhoto());
            ps.setString(5, vehicle.getType());
            ps.setString(6, vehicle.getColor());
            ps.setString(7, vehicle.getStatus());
            ps.setInt(8, vehicle.getVehicleId());
            rowsUpdated = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rowsUpdated;
    }
    
    // Delete a vehicle by vehicle_id
    public int deleteVehicle(int vehicleId) {
        String sql = "DELETE FROM Vehicles WHERE vehicle_id = ?";
        int rows = 0;
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleId);
            rows = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rows;
    }
}
