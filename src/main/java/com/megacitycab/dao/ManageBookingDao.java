package com.megacitycab.dao;

import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import com.megacitycab.model.Booking;
import com.megacitycab.util.DBConnection;

public class ManageBookingDao {

    // Retrieve all bookings (for staff, not filtering by customer)
    public List<Booking> getAllBookings() {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql);
             ResultSet rs = ps.executeQuery()){
            while (rs.next()){
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerId(rs.getInt("customer_id"));
                int driverId = rs.getInt("driver_id");
                if (rs.wasNull()){
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
        } catch (SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return bookings;
    }
    
    // Retrieve bookings for a given customer (if needed)
    public List<Booking> getBookingsByCustomerId(int customerId) {
        List<Booking> bookings = new ArrayList<>();
        String sql = "SELECT * FROM Bookings WHERE customer_id = ? ORDER BY booking_date DESC";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)){
            ps.setInt(1, customerId);
            ResultSet rs = ps.executeQuery();
            while (rs.next()){
                Booking b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerId(rs.getInt("customer_id"));
                int driverId = rs.getInt("driver_id");
                if (rs.wasNull()){
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
        } catch (SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return bookings;
    }
    
    // Retrieve a single booking by booking_id
    public Booking getBookingById(int bookingId) {
        Booking b = null;
        String sql = "SELECT * FROM Bookings WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if (rs.next()){
                b = new Booking();
                b.setBookingId(rs.getInt("booking_id"));
                b.setCustomerId(rs.getInt("customer_id"));
                int driverId = rs.getInt("driver_id");
                if (rs.wasNull()){
                    b.setDriverId(null);
                } else {
                    b.setDriverId(driverId);
                }
                b.setPickupLocation(rs.getString("pickup_location"));
                b.setDestination(rs.getString("destination"));
                b.setDistanceKm(rs.getDouble("distance_km"));
                b.setStatus(rs.getString("status"));
                b.setVehicleTypeId(rs.getInt("vehicle_type_id"));
            }
        } catch (SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return b;
    }
    
    // Insert a new booking and return its generated booking_id
    public int insertBooking(Booking booking) {
        int generatedId = 0;
        String sql = "INSERT INTO Bookings (customer_id, booking_date, pickup_location, destination, distance_km, status, vehicle_type_id) " +
                     "VALUES (?, NOW(), ?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, booking.getCustomerId());
            ps.setString(2, booking.getPickupLocation());
            ps.setString(3, booking.getDestination());
            ps.setDouble(4, booking.getDistanceKm());
            ps.setString(5, booking.getStatus());
            ps.setInt(6, booking.getVehicleTypeId());
            int rows = ps.executeUpdate();
            if (rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if (rs.next()){
                    generatedId = rs.getInt(1);
                }
            }
        } catch (SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return generatedId;
    }
    
    // Update an existing booking
    public int updateBooking(Booking booking) {
        int rows = 0;
        String sql = "UPDATE Bookings SET pickup_location = ?, destination = ?, distance_km = ?, status = ?, vehicle_type_id = ?, driver_id = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, booking.getPickupLocation());
            ps.setString(2, booking.getDestination());
            ps.setDouble(3, booking.getDistanceKm());
            ps.setString(4, booking.getStatus());
            ps.setInt(5, booking.getVehicleTypeId());
            if (booking.getDriverId() == null) {
                ps.setNull(6, java.sql.Types.INTEGER);
            } else {
                ps.setInt(6, booking.getDriverId());
            }
            ps.setInt(7, booking.getBookingId());
            rows = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return rows;
    }
    
    // Delete a booking
    public int deleteBooking(int bookingId) {
        int rows = 0;
        String sql = "DELETE FROM Bookings WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            rows = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return rows;
    }
    
    // Update booking status (e.g., cancel a booking)
    public int updateBookingStatus(int bookingId, String newStatus) {
        int rows = 0;
        String sql = "UPDATE Bookings SET status = ? WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setString(1, newStatus);
            ps.setInt(2, bookingId);
            rows = ps.executeUpdate();
        } catch (SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return rows;
    }
}
