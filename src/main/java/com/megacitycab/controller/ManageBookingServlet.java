package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import com.megacitycab.dao.ManageBookingDao;
import com.megacitycab.model.Booking;

@WebServlet("/manageBooking")
public class ManageBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ManageBookingDao manageBookingDao;
    
    @Override
    public void init() {
        manageBookingDao = new ManageBookingDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        // For staff, we assume they are logged in; no session check for customerId is required.
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        switch (action) {
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBooking(request, response);
                break;
            case "cancel":
                cancelBooking(request, response);
                break;
            case "list":
            default:
                listBookings(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            case "add":
                insertBooking(request, response);
                break;
            case "update":
                updateBooking(request, response);
                break;
            default:
                doGet(request, response);
                break;
        }
    }
    
    // List all bookings for staff view
    private void listBookings(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        List<Booking> bookingList = manageBookingDao.getAllBookings();
        request.setAttribute("bookingList", bookingList);
        request.getRequestDispatcher("/Views/manageBooking.jsp").forward(request, response);
    }
    
    // Show edit form for a booking
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        Booking booking = manageBookingDao.getBookingById(bookingId);
        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/Views/manageBooking.jsp").forward(request, response);
    }
    
    // Insert a new booking (staff manually enters customer ID)
    private void insertBooking(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String pickupLocation = request.getParameter("pickupLocation");
        String destination = request.getParameter("destination");
        double distanceKm = Double.parseDouble(request.getParameter("distanceKm"));
        int vehicleTypeId = Integer.parseInt(request.getParameter("vehicleTypeId"));
        
        Booking booking = new Booking();
        booking.setCustomerId(customerId);
        booking.setPickupLocation(pickupLocation);
        booking.setDestination(destination);
        booking.setDistanceKm(distanceKm);
        booking.setVehicleTypeId(vehicleTypeId);
        booking.setStatus("Pending");
        
        int bookingId = manageBookingDao.insertBooking(booking);
        request.setAttribute("message", "Booking added successfully with ID " + bookingId);
        listBookings(request, response);
    }
    
    // Update an existing booking
    private void updateBooking(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String pickupLocation = request.getParameter("pickupLocation");
        String destination = request.getParameter("destination");
        double distanceKm = Double.parseDouble(request.getParameter("distanceKm"));
        String status = request.getParameter("status");
        int vehicleTypeId = Integer.parseInt(request.getParameter("vehicleTypeId"));
        
        Integer driverId = null;
        String driverParam = request.getParameter("driverId");
        if (driverParam != null && !driverParam.isEmpty()) {
            try {
                driverId = Integer.valueOf(driverParam);
            } catch (NumberFormatException e) {
                driverId = null;
            }
        }
        
        Booking booking = new Booking();
        booking.setBookingId(bookingId);
        booking.setCustomerId(customerId);
        booking.setPickupLocation(pickupLocation);
        booking.setDestination(destination);
        booking.setDistanceKm(distanceKm);
        booking.setStatus(status);
        booking.setVehicleTypeId(vehicleTypeId);
        booking.setDriverId(driverId);
        
        manageBookingDao.updateBooking(booking);
        listBookings(request, response);
    }
    
    // Cancel a booking (update its status to "Canceled")
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        manageBookingDao.updateBookingStatus(bookingId, "Canceled");
        listBookings(request, response);
    }
    
    // Delete a booking
    private void deleteBooking(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        manageBookingDao.deleteBooking(bookingId);
        listBookings(request, response);
    }
}
