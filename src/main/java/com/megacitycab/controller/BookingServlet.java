package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import com.megacitycab.dao.BookingDao;
import com.megacitycab.model.Booking;

@WebServlet("/BookingServlet")
public class BookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDao bookingDao;
    
    @Override
    public void init() {
        bookingDao = new BookingDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customerId") == null) {
            request.getRequestDispatcher("/Views/login.jsp").forward(request, response);
            return;
        }
        
        String action = request.getParameter("action");
        if ("cancel".equalsIgnoreCase(action)) {
            cancelBooking(request, response);
        } else {
            displayBookingPage(request, response);
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customerId") == null) {
            request.getRequestDispatcher("/Views/login.jsp").forward(request, response);
            return;
        }
        
        int customerId = (int) session.getAttribute("customerId");
        
        // Read form parameters
        String origin = request.getParameter("originCity");
        String destination = request.getParameter("destinationCity");
        double distanceKm = 0.0;
        try {
            String distanceParam = request.getParameter("distanceKm");
            if(distanceParam != null && !distanceParam.isEmpty()) {
                distanceKm = Double.parseDouble(distanceParam);
            }
        } catch (NumberFormatException e) {
            distanceKm = 0.0;
        }
        
        int vehicleTypeId = Integer.parseInt(request.getParameter("vehicleTypeId"));
        
        Booking booking = new Booking();
        booking.setCustomerId(customerId);
        booking.setPickupLocation(origin);
        booking.setDestination(destination);
        booking.setDistanceKm(distanceKm);
        booking.setVehicleTypeId(vehicleTypeId);
        booking.setStatus("Pending");
        
        int bookingId = bookingDao.createBooking(booking);
        
        request.setAttribute("bookingId", bookingId);
        request.setAttribute("bookingStatus", "Pending");
        
        displayBookingPage(request, response);
    }
    
    private void cancelBooking(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        bookingDao.updateBookingStatus(bookingId, "Canceled");
        
        request.setAttribute("bookingId", bookingId);
        request.setAttribute("bookingStatus", "Canceled");
        displayBookingPage(request, response);
    }
    
    private void displayBookingPage(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customerId") == null) {
            request.getRequestDispatcher("/Views/login.jsp").forward(request, response);
            return;
        }
        
        int customerId = (int) session.getAttribute("customerId");
        
        List<Booking> bookingList = bookingDao.getBookingsByCustomerId(customerId);
        request.setAttribute("bookingList", bookingList);
        
        request.getRequestDispatcher("/Views/bookingForm.jsp").forward(request, response);
    }
}
