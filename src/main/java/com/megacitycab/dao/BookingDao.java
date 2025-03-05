package com.megacitycab.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.megacitycab.model.Booking;
import com.megacitycab.util.DBConnection;

public class BookingDao {
    public int createBooking(Booking booking) {
        int generatedId = 0;
        String sql = "INSERT INTO Bookings (customer_id, booking_date, pickup_location, destination, distance_km, status, vehicle_type_id) " +
                     "VALUES (?, NOW(), ?, ?, ?, 'Pending', ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getCustomerId());
            ps.setString(2, booking.getPickupLocation());
            ps.setString(3, booking.getDestination());
            ps.setDouble(4, booking.getDistanceKm());
            ps.setInt(5, booking.getVehicleTypeId());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()) {
                    generatedId = rs.getInt(1);
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
            ResultSet rs = ps.executeQuery();
            if (rs.next()) {
                b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerId(rs.getInt("customer_id"));
                b.setDriverId(rs.getInt("driver_id"));
                b.setPickupLocation(rs.getString("pickup_location"));
                b.setDestination(rs.getString("destination"));
                b.setDistanceKm(rs.getDouble("distance_km"));
                b.setStatus(rs.getString("status"));
                b.setVehicleTypeId(rs.getInt("vehicle_type_id"));
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return b;
    }
    
    // List bookings by status (for driver view)
    public List<Booking> getBookingsByStatus(String status) {
        List<Booking> list = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE status = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, status);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerId(rs.getInt("customer_id"));
                b.setDriverId(rs.getInt("driver_id"));
                b.setPickupLocation(rs.getString("pickup_location"));
                b.setDestination(rs.getString("destination"));
                b.setDistanceKm(rs.getDouble("distance_km"));
                b.setStatus(rs.getString("status"));
                b.setVehicleTypeId(rs.getInt("vehicle_type_id"));
                list.add(b);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return list;
    }
    
    // Update booking status (for driver acceptance)
    public int updateBookingStatus(int bookingId, String newStatus, int driverId) {
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
    
    public List<Booking> getBookingsByCustomerId(int customerId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE customer_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()) {
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerId(rs.getInt("customer_id"));
                b.setDriverId(rs.getInt("driver_id"));
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

   
    public int updateBookingStatus(int bookingId, String newStatus) {
        int rows = 0;
        String sql = "UPDATE Bookings SET status = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, bookingId);
            rows = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        return rows;
    }
}
