package com.megacitycab.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.megacitycab.model.VehicleType;
import com.megacitycab.util.DBConnection;

public class VehicleTypeDao {

    // 1) Get all vehicle types
    public List<VehicleType> getAllVehicleTypes() {
        List<VehicleType> list = new ArrayList<>();
        String sql = "SELECT * FROM vehicle_types";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            
            while(rs.next()) {
                VehicleType vt = new VehicleType();
                vt.setId(rs.getInt("id"));
                vt.setVehicleName(rs.getString("vehicle_name"));
                vt.setCostPerKm(rs.getDouble("cost_per_km"));
                list.add(vt);
            }
        } catch(SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }

    // 2) Get a single vehicle type by ID
    public VehicleType getVehicleTypeById(int id) {
        VehicleType vt = null;
        String sql = "SELECT * FROM vehicle_types WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    vt = new VehicleType();
                    vt.setId(rs.getInt("id"));
                    vt.setVehicleName(rs.getString("vehicle_name"));
                    vt.setCostPerKm(rs.getDouble("cost_per_km"));
                }
            }
        } catch(SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return vt;
    }

    // 3) Get cost_per_km given a vehicle type ID
    public double getCostPerKm(int id) {
        double cost = 0.0;
        String sql = "SELECT cost_per_km FROM vehicle_types WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            try (ResultSet rs = ps.executeQuery()) {
                if(rs.next()) {
                    cost = rs.getDouble("cost_per_km");
                }
            }
        } catch(SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return cost;
    }

    // 4) Insert a new vehicle type
    public int insertVehicleType(VehicleType vt) {
        int rowsInserted = 0;
        String sql = "INSERT INTO vehicle_types (vehicle_name, cost_per_km) VALUES (?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, vt.getVehicleName());
            ps.setDouble(2, vt.getCostPerKm());
            rowsInserted = ps.executeUpdate();
        } catch(SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rowsInserted;
    }

    // 5) Update an existing vehicle type
    public int updateVehicleType(VehicleType vt) {
        int rowsUpdated = 0;
        String sql = "UPDATE vehicle_types SET vehicle_name = ?, cost_per_km = ? WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, vt.getVehicleName());
            ps.setDouble(2, vt.getCostPerKm());
            ps.setInt(3, vt.getId());
            rowsUpdated = ps.executeUpdate();
        } catch(SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rowsUpdated;
    }

    // 6) (Optional) Delete a vehicle type
    public int deleteVehicleType(int id) {
        int rowsDeleted = 0;
        String sql = "DELETE FROM vehicle_types WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, id);
            rowsDeleted = ps.executeUpdate();
        } catch(SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rowsDeleted;
    }
}
