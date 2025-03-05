package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import com.megacitycab.dao.BookingDao;

@WebServlet("/DriverBookingServlet")
public class DriverBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDao bookingDao;
    
    public void init() {
        bookingDao = new BookingDao();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String action = request.getParameter("action");
        if ("accept".equals(action)) {
            acceptBooking(request, response);
        } else if ("reject".equals(action)) {
            rejectBooking(request, response);
        } else {
            // List pending bookings for the driver
            // (Not fully implemented here)
            response.sendRedirect(request.getContextPath() + "/driverBookings.jsp");
        }
    }
    
    private void acceptBooking(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        // Assume driver's id is stored in session as "driverId"
        int driverId = (int) request.getSession().getAttribute("driverId");
        bookingDao.updateBookingStatus(bookingId, "Accepted", driverId);
        // After acceptance, generate a bill etc. (Not shown here)
        response.sendRedirect(request.getContextPath() + "/DriverBookingServlet");
    }
    
    private void rejectBooking(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        // For simplicity, we just update status to "Rejected" without assigning driverId
        bookingDao.updateBookingStatus(bookingId, "Rejected", 0);
        response.sendRedirect(request.getContextPath() + "/DriverBookingServlet");
    }
}
