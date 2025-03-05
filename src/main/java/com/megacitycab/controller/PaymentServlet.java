package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

import com.megacitycab.dao.BillDao;
import com.megacitycab.dao.PaymentDao;
import com.megacitycab.dao.BookingDao;
import com.megacitycab.dao.VehicleTypeDao;
import com.megacitycab.model.Bill;
import com.megacitycab.model.Booking;
import com.megacitycab.model.Payment;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BillDao billDao;
    private PaymentDao paymentDao;
    private BookingDao bookingDao;
    private VehicleTypeDao vehicleTypeDao; 
    
    @Override
    public void init() {
        billDao = new BillDao();
        paymentDao = new PaymentDao();
        bookingDao = new BookingDao();
        vehicleTypeDao = new VehicleTypeDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        // Check that the user is logged in as a Customer
        if (session == null || session.getAttribute("customerId") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }
        
        // Display the bill in bookingForm.jsp
        showBillOnBookingForm(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        // Check that the user is logged in as a Customer
        if (session == null || session.getAttribute("customerId") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if ("pay".equalsIgnoreCase(action)) {
            processPayment(request, response);
        } else {
            doGet(request, response);
        }
    }
    
    /**
     * This method retrieves (or creates) a Bill for the given booking,
     * then sets attributes so the "bill card" is displayed in bookingForm.jsp.
     */
    private void showBillOnBookingForm(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        Booking booking = bookingDao.getBookingById(bookingId);
        if (booking == null) {
            request.setAttribute("message", "Invalid booking.");
            // Forward back to bookingForm.jsp
            request.getRequestDispatcher("/Views/bookingForm.jsp").forward(request, response);
            return;
        }
        
        // Check if there's already a Bill
        Bill existingBill = billDao.getBillByBookingId(bookingId);
        if (existingBill == null) {
            // Calculate cost from distance & cost_per_km
            double distance = booking.getDistanceKm();
            double costPerKm = vehicleTypeDao.getCostPerKm(booking.getVehicleTypeId());
            
            double baseAmount = distance * costPerKm;
            double discount = 0; // or your own logic
            double total = baseAmount - discount;
            
            // Insert a new Bill
            Bill newBill = new Bill();
            newBill.setBookingId(bookingId);
            newBill.setBaseAmount(baseAmount);
            newBill.setDiscount(discount);
            newBill.setTotalAmount(total);
            
            billDao.insertBill(newBill);
            existingBill = billDao.getBillByBookingId(bookingId);
        }
        
        // Place the Bill and Booking objects into request scope
        request.setAttribute("bill", existingBill);
        request.setAttribute("billBooking", booking);
        
        // Forward to the same bookingForm.jsp (the one with the embedded bill card)
        request.getRequestDispatcher("/Views/bookingForm.jsp").forward(request, response);
    }
    
    /**
     * Processes the payment (on-hand or bank transfer), inserts a Payment record,
     * then re-shows the bill card on bookingForm.jsp with a success/fail message.
     */
    private void processPayment(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        int customerId = (Integer) session.getAttribute("customerId");
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String paymentMethod = request.getParameter("paymentMethod"); // "On-hand" or "Bank Transfer"
        
        // Retrieve the Bill
        Bill bill = billDao.getBillByBookingId(bookingId);
        if (bill == null) {
            request.setAttribute("message", "No bill found for this booking.");
            request.getRequestDispatcher("/Views/bookingForm.jsp").forward(request, response);
            return;
        }
        
        // Insert a Payment record
        Payment payment = new Payment();
        payment.setBookingId(bookingId);
        payment.setCustomerId(customerId);
        payment.setAmount(bill.getTotalAmount());
        payment.setPaymentMethod(paymentMethod);
        payment.setStatus("Completed"); // or "Paid"
        
        int paymentId = paymentDao.insertPayment(payment);
        
        if (paymentId > 0) {
            request.setAttribute("message", "Payment successful!");
        } else {
            request.setAttribute("message", "Payment failed.");
        }
        
        // After payment, re-display the Bill card in bookingForm.jsp
        showBillOnBookingForm(request, response);
    }
}
