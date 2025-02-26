package com.datapackage.controler;

import com.datapackage.dao.BookingDao;
import com.datapackage.model.Booking;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.sql.Timestamp;
import java.util.List;
import java.util.UUID;

@WebServlet("/manageBookings")
@MultipartConfig
public class BookingManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BookingDao bookingDao;

    @Override
    public void init() {
        bookingDao = new BookingDao();
    }

    // GET: List bookings for the logged-in customer
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Assume customerID is stored in session (as an Integer)
            Integer customerID = (Integer) request.getSession().getAttribute("customerID");
            if (customerID == null) {
                response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
                return;
            }
            List<Booking> bookingList = bookingDao.getBookingsForCustomer(customerID);
            request.setAttribute("bookingList", bookingList);
            RequestDispatcher rd = request.getRequestDispatcher("/Views/bookingManagement.jsp");
            rd.forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Views/error.jsp");
        }
    }

    // POST: Handle booking creation, payment (status update), and deletion.
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if(action == null) action = "";
        try {
            // Retrieve customerID from session
            Integer customerID = (Integer) request.getSession().getAttribute("customerID");
            if (customerID == null) {
                response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
                return;
            }
            if(action.equals("add")) {
                Booking booking = new Booking();
                booking.setId(UUID.randomUUID().toString());
                booking.setName(request.getParameter("name"));
                booking.setAddress(request.getParameter("address"));
                booking.setNic(request.getParameter("nic"));
                booking.setContact(request.getParameter("contact"));
                // Parse datetime from input (format: "yyyy-MM-ddTHH:mm")
                String dt = request.getParameter("dateTime");
                booking.setDateTime(Timestamp.valueOf(dt.replace("T", " ") + ":00"));
                booking.setPickup(request.getParameter("pickup"));
                booking.setDestination(request.getParameter("destination")); // updated field name
                booking.setStatus("Pending");
                booking.setCustomerID(customerID);
                // Optionally, DriverID and VehicleID can be set later
                booking.setDriverID(request.getParameter("driverID"));
                booking.setVehicleID(request.getParameter("vehicleID"));
                
                bookingDao.registerBooking(booking);
            } else if(action.equals("pay")) {
                String bookingId = request.getParameter("bookingId");
                bookingDao.updateBookingStatus(bookingId, "Completed");
                RequestDispatcher rd = request.getRequestDispatcher("/Views/printBill.jsp");
                request.setAttribute("bookingId", bookingId);
                rd.forward(request, response);
                return;
            } else if(action.equals("delete")) {
                String bookingId = request.getParameter("bookingId");
                bookingDao.deleteBooking(bookingId);
            }
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/manageBookings");
    }
}
