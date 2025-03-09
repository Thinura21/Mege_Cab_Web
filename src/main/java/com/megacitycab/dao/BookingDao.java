package com.megacitycab.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.megacitycab.model.Booking;
import com.megacitycab.util.DBConnection;

public class BookingDao {

    public int createBooking(Booking booking) {
        int generatedId = 0;
        String sql = "INSERT INTO Bookings (customer_id, booking_date, pickup_location, destination, distance_km, status, vehicle_type_id) "
                   + "VALUES (?, ?, ?, ?, ?, 'Pending', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            
            ps.setInt(1, booking.getCustomerId());
            ps.setTimestamp(2, booking.getBookingDate());
            ps.setString(3, booking.getPickupLocation());
            ps.setString(4, booking.getDestination());
            ps.setDouble(5, booking.getDistanceKm());
            ps.setInt(6, booking.getVehicleTypeId());
            
            int rows = ps.executeUpdate();
            if (rows > 0) {
                try (ResultSet rs = ps.getGeneratedKeys()) {
                    if (rs.next()) {
                        generatedId = rs.getInt(1);
                    }
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return generatedId;
    }

    public Booking getBookingById(int bookingId) {
        Booking b = null;
        String sql = "SELECT * FROM Bookings WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, bookingId);
            try (ResultSet rs = ps.executeQuery()) {
                if (rs.next()) {
                    b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setCustomerId(rs.getInt("customer_id"));
                    
                    // driver_id can be null in DB
                    int driverId = rs.getInt("driver_id");
                    if (!rs.wasNull()) {
                        b.setDriverId(driverId);
                    } else {
                        b.setDriverId(null);
                    }
                    
                    b.setPickupLocation(rs.getString("pickup_location"));
                    b.setDestination(rs.getString("destination"));
                    b.setDistanceKm(rs.getDouble("distance_km"));
                    b.setStatus(rs.getString("status"));
                    b.setVehicleTypeId(rs.getInt("vehicle_type_id"));
                    b.setBookingDate(rs.getTimestamp("booking_date"));
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return b;
    }

    public List<Booking> getBookingsByCustomerId(int customerId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE customer_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setInt(1, customerId);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking b = new Booking();
                    b.setBookingId(rs.getInt("booking_id"));
                    b.setCustomerId(rs.getInt("customer_id"));
                    
                    int driverId = rs.getInt("driver_id");
                    if (!rs.wasNull()) {
                        b.setDriverId(driverId);
                    } else {
                        b.setDriverId(null);
                    }
                    
                    b.setPickupLocation(rs.getString("pickup_location"));
                    b.setDestination(rs.getString("destination"));
                    b.setDistanceKm(rs.getDouble("distance_km"));
                    b.setStatus(rs.getString("status"));
                    b.setVehicleTypeId(rs.getInt("vehicle_type_id"));
                    b.setBookingDate(rs.getTimestamp("booking_date"));
                    bookings.add(b);
                }
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return bookings;
    }

    /**
     * updateBookingStatus sets status and driver_id. 
     * Pass driverId as null to clear driver or for cancellations.
     */
    public int updateBookingStatus(int bookingId, String newStatus, Integer driverId) {
        int rows = 0;
        String sql = "UPDATE Bookings SET status = ?, driver_id = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            
            ps.setString(1, newStatus);
            if (driverId == null) {
                ps.setNull(2, Types.INTEGER);
            } else {
                ps.setInt(2, driverId);
            }
            ps.setInt(3, bookingId);
            rows = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rows;
    }
}
