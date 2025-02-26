package com.datapackage.dao;

import com.datapackage.model.Booking;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;
import java.util.UUID;

public class BookingDao {

    // Register a new booking. Generates a UUID for the booking and sets the status to "Pending".
    public int registerBooking(Booking booking) throws ClassNotFoundException, SQLException {
        int result = 0;
        Connection con = DBConnection.getConnection();
        String sql = "INSERT INTO Bookings (ID, Name, Address, NIC, Contact, DateTime, Pickup, Destination, Status, CustomerID, DriverID, VehicleID) " +
                     "VALUES (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            if (booking.getId() == null || booking.getId().isEmpty()) {
                booking.setId(UUID.randomUUID().toString());
            }
            ps.setString(1, booking.getId());
            ps.setString(2, booking.getName());
            ps.setString(3, booking.getAddress());
            ps.setString(4, booking.getNic());
            ps.setString(5, booking.getContact());
            ps.setTimestamp(6, booking.getDateTime());
            ps.setString(7, booking.getPickup());
            ps.setString(8, booking.getDestination());  // updated column
            ps.setString(9, booking.getStatus());
            ps.setInt(10, booking.getCustomerID());
            ps.setString(11, booking.getDriverID());
            ps.setString(12, booking.getVehicleID());
            result = ps.executeUpdate();
        } finally {
            con.close();
        }
        return result;
    }

    // Retrieve all bookings for a given customer
    public List<Booking> getBookingsForCustomer(int customerID) throws ClassNotFoundException, SQLException {
        List<Booking> list = new ArrayList<>();
        Connection con = DBConnection.getConnection();
        String sql = "SELECT * FROM Bookings WHERE CustomerID = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setInt(1, customerID);
            try (ResultSet rs = ps.executeQuery()) {
                while (rs.next()) {
                    Booking booking = new Booking();
                    booking.setId(rs.getString("ID"));
                    booking.setName(rs.getString("Name"));
                    booking.setAddress(rs.getString("Address"));
                    booking.setNic(rs.getString("NIC"));
                    booking.setContact(rs.getString("Contact"));
                    booking.setDateTime(rs.getTimestamp("DateTime"));
                    booking.setPickup(rs.getString("Pickup"));
                    booking.setDestination(rs.getString("Destination"));
                    booking.setStatus(rs.getString("Status"));
                    booking.setCustomerID(rs.getInt("CustomerID"));
                    booking.setDriverID(rs.getString("DriverID"));
                    booking.setVehicleID(rs.getString("VehicleID"));
                    list.add(booking);
                }
            }
        } finally {
            con.close();
        }
        return list;
    }

    // Update booking status (e.g., after payment)
    public int updateBookingStatus(String bookingId, String status) throws ClassNotFoundException, SQLException {
        int result = 0;
        Connection con = DBConnection.getConnection();
        String sql = "UPDATE Bookings SET Status = ? WHERE ID = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, status);
            ps.setString(2, bookingId);
            result = ps.executeUpdate();
        } finally {
            con.close();
        }
        return result;
    }

    // Delete a booking
    public int deleteBooking(String bookingId) throws ClassNotFoundException, SQLException {
        int result = 0;
        Connection con = DBConnection.getConnection();
        String sql = "DELETE FROM Bookings WHERE ID = ?";
        try (PreparedStatement ps = con.prepareStatement(sql)) {
            ps.setString(1, bookingId);
            result = ps.executeUpdate();
        } finally {
            con.close();
        }
        return result;
    }
}
