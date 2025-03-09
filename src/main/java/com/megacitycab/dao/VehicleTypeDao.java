package com.megacitycab.dao;

import java.sql.*;
import com.megacitycab.util.DBConnection;

public class VehicleTypeDao {
    public double getCostPerKm(int vehicleTypeId) {
        double costPerKm = 0.0;
        String sql = "SELECT cost_per_km FROM vehicle_types WHERE id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleTypeId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                costPerKm = rs.getDouble("cost_per_km");
            }
        } catch(SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return costPerKm;
    }
}
