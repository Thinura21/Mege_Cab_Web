package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import com.megacitycab.dao.DriverBookingDao;
import com.megacitycab.dao.DriverDao;
import com.megacitycab.dao.VehicleDao;
import com.megacitycab.model.Booking;
import com.megacitycab.model.Driver;
import com.megacitycab.model.Vehicle;

@WebServlet("/manageDriverBooking")
public class ManageDriverBookingServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DriverBookingDao driverBookingDao;
    private DriverDao driverDao;
    private VehicleDao vehicleDao;
    
    @Override
    public void init() {
        driverBookingDao = new DriverBookingDao();
        driverDao = new DriverDao();
        vehicleDao = new VehicleDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        // Session check: only drivers allowed
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
            !((String) session.getAttribute("role")).equalsIgnoreCase("Driver")) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }
        
        // Retrieve driver bookings (both pending and accepted)
        listDriverBookings(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        // Session check: only drivers allowed
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null ||
            !((String) session.getAttribute("role")).equalsIgnoreCase("Driver")) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if ("updateStatus".equalsIgnoreCase(action)) {
            updateBookingStatus(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    // Fetch both pending and accepted bookings and forward to the JSP.
    private void listDriverBookings(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("userId");
        
        // Retrieve driver record
        Driver driver = driverDao.getDriverByUserId(userId);
        if (driver == null) {
            request.setAttribute("message", "Driver profile not found. Please complete your profile.");
            request.getRequestDispatcher("/Views/driverBooking.jsp").forward(request, response);
            return;
        }
        
        // Retrieve vehicle to get vehicle type
        Vehicle vehicle = vehicleDao.getVehicleByDriverId(driver.getDriverId());
        String driverVehicleType = (vehicle != null) ? vehicle.getType() : "";
        
        // Get pending bookings for driver's vehicle type
        List<Booking> pendingBookings = driverBookingDao.getPendingBookingsForDriver(driverVehicleType);
        // Get accepted bookings (Active/Ongoing) for this driver
        List<Booking> acceptedBookings = driverBookingDao.getAcceptedBookingsForDriver(driver.getDriverId());
        
        request.setAttribute("pendingBookings", pendingBookings);
        request.setAttribute("acceptedBookings", acceptedBookings);
        request.getRequestDispatcher("/Views/driverBooking.jsp").forward(request, response);
    }
    
    // Update booking status and assign the driver.
    private void updateBookingStatus(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String newStatus = request.getParameter("newStatus"); // e.g., "Active", "Ongoing", "Completed"
        HttpSession session = request.getSession();
        int userId = (Integer) session.getAttribute("userId");
        Driver driver = driverDao.getDriverByUserId(userId);
        int driverId = driver.getDriverId();
        
        int rows = driverBookingDao.updateBookingStatusForDriver(bookingId, newStatus, driverId);
        if (rows > 0) {
            request.setAttribute("message", "Booking updated successfully.");
        } else {
            request.setAttribute("message", "Failed to update booking.");
        }
        listDriverBookings(request, response);
    }
}
