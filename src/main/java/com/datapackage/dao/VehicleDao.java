package com.datapackage.dao;

import com.datapackage.model.Vehicle;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

public class VehicleDao {

    // Register a new vehicle (ID is auto-increment)
    public int registerVehicle(Vehicle vehicle) throws ClassNotFoundException, SQLException {
        int result = 0;
        Connection con = DBConnection.getConnection();
        try {
            String sql = "INSERT INTO Vehicle (Model, Brand, Type, Image, Status, DriverID) "
                       + "VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, vehicle.getModel());
                ps.setString(2, vehicle.getBrand());
                ps.setString(3, vehicle.getType());
                ps.setBytes(4, vehicle.getImage());  // store image as bytes
                ps.setString(5, vehicle.getStatus());
                ps.setInt(6, vehicle.getDriverID());
                result = ps.executeUpdate();
            }
        } finally {
            con.close();
        }
        return result;
    }

    // Retrieve all vehicles
    public List<Vehicle> getAllVehicles() throws ClassNotFoundException, SQLException {
        List<Vehicle> list = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM Vehicle";
        try (PreparedStatement ps = con.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()) {
            while (rs.next()) {
                Vehicle v = new Vehicle();
                v.setId(rs.getInt("ID"));
                v.setModel(rs.getString("Model"));
                v.setBrand(rs.getString("Brand"));
                v.setType(rs.getString("Type"));
                v.setImage(rs.getBytes("Image"));
                v.setStatus(rs.getString("Status"));
                v.setDriverID(rs.getInt("DriverID"));
                list.add(v);
            }
        } finally {
            con.close();
        }
        return list;
    }

    // Search vehicles (optional)
    public List<Vehicle> searchVehicles(String query) throws ClassNotFoundException, SQLException {
        List<Vehicle> list = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM Vehicle "
                   + "WHERE Model LIKE ? OR Brand LIKE ? OR Type LIKE ? OR Status LIKE ? OR DriverID LIKE ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            String wildcard = "%" + query + "%";
            ps.setString(1, wildcard);
            ps.setString(2, wildcard);
            ps.setString(3, wildcard);
            ps.setString(4, wildcard);
            ps.setString(5, wildcard);  // might fail if DriverID is int; for simplicity we do a cast or just skip searching driverID
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Vehicle v = new Vehicle();
                    v.setId(rs.getInt("ID"));
                    v.setModel(rs.getString("Model"));
                    v.setBrand(rs.getString("Brand"));
                    v.setType(rs.getString("Type"));
                    v.setImage(rs.getBytes("Image"));
                    v.setStatus(rs.getString("Status"));
                    v.setDriverID(rs.getInt("DriverID"));
                    list.add(v);
                }
            }
        } finally {
            con.close();
        }
        return list;
    }

    // Update an existing vehicle
    public int updateVehicle(Vehicle vehicle) throws ClassNotFoundException, SQLException {
        int result = 0;
        Connection con = DBConnection.getConnection();
        try {
            String sql = "UPDATE Vehicle SET Model=?, Brand=?, Type=?, Image=?, Status=?, DriverID=? WHERE ID=?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, vehicle.getModel());
                ps.setString(2, vehicle.getBrand());
                ps.setString(3, vehicle.getType());
                ps.setBytes(4, vehicle.getImage());
                ps.setString(5, vehicle.getStatus());
                ps.setInt(6, vehicle.getDriverID());
                ps.setInt(7, vehicle.getId());
                result = ps.executeUpdate();
            }
        } finally {
            con.close();
        }
        return result;
    }

    // Delete a vehicle
    public int deleteVehicle(int id) throws ClassNotFoundException, SQLException {
        int result = 0;
        Connection con = DBConnection.getConnection();
        try {
            String sql = "DELETE FROM Vehicle WHERE ID = ?";
            try (PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setInt(1, id);
                result = ps.executeUpdate();
            }
        } finally {
            con.close();
        }
        return result;
    }
}
