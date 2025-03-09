package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.sql.Timestamp;
import java.text.ParseException;
import java.text.SimpleDateFormat;
import java.util.List;
import com.megacitycab.dao.ManageBookingDao;
import com.megacitycab.model.Booking;

@WebServlet("/manageBooking")
@MultipartConfig(maxFileSize = 16177215) // approx 16MB
public class ManageBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ManageBookingDao manageBookingDao;
    
    public void init() {
        manageBookingDao = new ManageBookingDao();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        switch(action) {
            case "add":
                request.setAttribute("booking", null);
                request.getRequestDispatcher("/Views/manageBooking.jsp").forward(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteBooking(request, response);
                break;
            case "cancel":
                updateBookingStatus(request, response, "Canceled");
                break;
            case "list":
            default:
                listBookings(request, response);
                break;
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String action = request.getParameter("action");
        if(action == null) {
            action = "";
        }
        switch(action) {
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
    
    private void listBookings(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        List<Booking> bookingList = manageBookingDao.getAllBookings();
        request.setAttribute("bookingList", bookingList);
        request.getRequestDispatcher("/Views/manageBooking.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("id"));
        Booking booking = manageBookingDao.getBookingById(bookingId);
        request.setAttribute("booking", booking);
        request.getRequestDispatcher("/Views/manageBooking.jsp").forward(request, response);
    }
    
    private void insertBooking(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String pickupLocation = request.getParameter("pickupLocation");
        String destination = request.getParameter("destination");
        double distanceKm = Double.parseDouble(request.getParameter("distanceKm"));
        String status = request.getParameter("status");
        int vehicleTypeId = Integer.parseInt(request.getParameter("vehicleTypeId"));
        
        // Parse bookingDate from form using 24-hour format ("MM/dd/yyyy HH:mm")
        String bookingDateStr = request.getParameter("bookingDate");
        Timestamp bookingDate = parseBookingDate(bookingDateStr);
        
        Booking b = new Booking();
        b.setCustomerId(customerId);
        b.setPickupLocation(pickupLocation);
        b.setDestination(destination);
        b.setDistanceKm(distanceKm);
        b.setStatus(status);
        b.setVehicleTypeId(vehicleTypeId);
        b.setBookingDate(bookingDate);
        
        int newId = manageBookingDao.insertBooking(b);
        response.sendRedirect(request.getContextPath() + "/manageBooking?action=list");
    }
    
    private void updateBooking(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        String pickupLocation = request.getParameter("pickupLocation");
        String destination = request.getParameter("destination");
        double distanceKm = Double.parseDouble(request.getParameter("distanceKm"));
        String status = request.getParameter("status");
        int vehicleTypeId = Integer.parseInt(request.getParameter("vehicleTypeId"));
        
        // Parse bookingDate from form using 24-hour format ("MM/dd/yyyy HH:mm")
        String bookingDateStr = request.getParameter("bookingDate");
        Timestamp bookingDate = parseBookingDate(bookingDateStr);
        
        Booking b = new Booking();
        b.setBookingId(bookingId);
        b.setCustomerId(customerId);
        b.setPickupLocation(pickupLocation);
        b.setDestination(destination);
        b.setDistanceKm(distanceKm);
        b.setStatus(status);
        b.setVehicleTypeId(vehicleTypeId);
        b.setBookingDate(bookingDate);
        
        String driverIdStr = request.getParameter("driverId");
        if (driverIdStr != null && !driverIdStr.trim().isEmpty()) {
            b.setDriverId(Integer.valueOf(driverIdStr));
        } else {
            b.setDriverId(null);
        }
        
        manageBookingDao.updateBooking(b);
        response.sendRedirect(request.getContextPath() + "/manageBooking?action=list");
    }
    
    private void deleteBooking(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        manageBookingDao.deleteBooking(bookingId);
        response.sendRedirect(request.getContextPath() + "/manageBooking?action=list");
    }
    
    private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response, String newStatus)
         throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        manageBookingDao.updateBookingStatus(bookingId, newStatus);
        response.sendRedirect(request.getContextPath() + "/manageBooking?action=list");
    }
    
    // Helper method: Parse a booking date from the form.
    // Expected input format: "MM/dd/yyyy HH:mm" (24-hour clock, e.g., "03/10/2025 14:30")
    private Timestamp parseBookingDate(String bookingDateStr) {
        if (bookingDateStr != null && !bookingDateStr.trim().isEmpty()) {
            bookingDateStr = bookingDateStr.trim();
            SimpleDateFormat sdf = new SimpleDateFormat("MM/dd/yyyy HH:mm");
            try {
                java.util.Date parsedDate = sdf.parse(bookingDateStr);
                return new Timestamp(parsedDate.getTime());
            } catch (ParseException e) {
                e.printStackTrace();
            }
        }
        return null;
    }
    
    // Utility to get bytes from an uploaded part
    private byte[] getBytesFromPart(Part part) throws IOException {
        if (part != null && part.getSize() > 0) {
            try (InputStream is = part.getInputStream();
                 ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {
                int nRead;
                byte[] data = new byte[1024];
                while ((nRead = is.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, nRead);
                }
                return buffer.toByteArray();
            }
        }
        return null;
    }
}
