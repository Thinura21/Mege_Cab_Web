package com.megacitycab.dao;

import java.sql.Connection;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;
import com.megacitycab.model.Vehicle;
import com.megacitycab.util.DBConnection;

public class VehicleDao {

    public Vehicle getVehicleByDriverId(int driverId) {
        Vehicle vehicle = null;
        String sql = "SELECT * FROM Vehicles WHERE driver_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
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
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return vehicle;
    }

    public int insertVehicle(Vehicle vehicle) {
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

    public int updateVehicle(Vehicle vehicle) {
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
}
