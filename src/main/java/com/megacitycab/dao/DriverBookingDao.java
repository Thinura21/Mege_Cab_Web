package com.megacitycab.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.megacitycab.model.Booking;
import com.megacitycab.util.DBConnection;

public class DriverBookingDao {

    // (Existing method to retrieve pending bookings)
    public List<Booking> getPendingBookingsForDriver(String driverVehicleType) {
        List<Booking> bookings = new ArrayList<>();
        int vehicleTypeId = mapVehicleTypeToId(driverVehicleType);
        String sql = "SELECT * FROM Bookings WHERE status = 'Pending' AND vehicle_type_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, vehicleTypeId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerId(rs.getInt("customer_id"));
                int driverId = rs.getInt("driver_id");
                if (rs.wasNull()) {
                    b.setDriverId(null);
                } else {
                    b.setDriverId(driverId);
                }
                b.setPickupLocation(rs.getString("pickup_location"));
                b.setDestination(rs.getString("destination"));
                b.setDistanceKm(rs.getDouble("distance_km"));
                b.setStatus(rs.getString("status"));
                b.setVehicleTypeId(rs.getInt("vehicle_type_id"));
                bookings.add(b);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    // New method: Retrieve accepted (Active/Ongoing) bookings for a given driver.
    public List<Booking> getAcceptedBookingsForDriver(int driverId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE driver_id = ? AND status IN ('Active','Ongoing') ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, driverId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerId(rs.getInt("customer_id"));
                int dbDriverId = rs.getInt("driver_id");
                if (rs.wasNull()) {
                    b.setDriverId(null);
                } else {
                    b.setDriverId(dbDriverId);
                }
                b.setPickupLocation(rs.getString("pickup_location"));
                b.setDestination(rs.getString("destination"));
                b.setDistanceKm(rs.getDouble("distance_km"));
                b.setStatus(rs.getString("status"));
                b.setVehicleTypeId(rs.getInt("vehicle_type_id"));
                bookings.add(b);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    // Helper: Map vehicle type text to an id (if needed elsewhere)
    private int mapVehicleTypeToId(String vehicleType) {
        if(vehicleType.equals("Mini Car (2)")) return 1;
        if(vehicleType.equals("Normal Car (3)")) return 2;
        if(vehicleType.equals("SUV (3)")) return 3;
        if(vehicleType.equals("Large Car (4)")) return 4;
        if(vehicleType.equals("Minivan (6)")) return 5;
        if(vehicleType.equals("Large Van (10)")) return 6;
        if(vehicleType.equals("Minibus (15)")) return 7;
        return 0;
    }

    // Existing method for updating booking status for a driver remains here…
    public int updateBookingStatusForDriver(int bookingId, String newStatus, int driverId) {
        int rows = 0;
        String sql = "UPDATE Bookings SET status = ?, driver_id = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, driverId);
            ps.setInt(3, bookingId);
            rows = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rows;
    }
}
