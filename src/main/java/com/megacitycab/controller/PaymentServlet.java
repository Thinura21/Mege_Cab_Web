package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import com.megacitycab.dao.*;
import com.megacitycab.model.*;

@WebServlet("/PaymentServlet")
public class PaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    private BillDao billDao;
    private PaymentDao paymentDao;
    private BookingDao bookingDao;
    private VehicleTypeDao vehicleTypeDao;
    private DriverDao driverDao;
    private ManageCustomerDao ManageCustomerDao;
    
    @Override
    public void init() {
        billDao = new BillDao();
        paymentDao = new PaymentDao();
        bookingDao = new BookingDao();
        vehicleTypeDao = new VehicleTypeDao();
        driverDao = new DriverDao();
        ManageCustomerDao = new ManageCustomerDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("customerId") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }
        showBillCard(request, response);
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        HttpSession session = request.getSession(false);
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
    
    private void showBillCard(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        Booking booking = bookingDao.getBookingById(bookingId);
        if (booking == null) {
            request.setAttribute("message", "Invalid booking.");
            request.getRequestDispatcher("/Views/bookingForm.jsp").forward(request, response);
            return;
        }
        
        // Retrieve or create the Bill
        Bill bill = billDao.getBillByBookingId(bookingId);
        if (bill == null) {
            double distance = booking.getDistanceKm();
            double costPerKm = vehicleTypeDao.getCostPerKm(booking.getVehicleTypeId());
            double baseAmount = distance * costPerKm;
            
            double discountRate = 0.0;
            if (distance > 500) {
                discountRate = 0.07;
            } else if (distance > 300) {
                discountRate = 0.05;
            } else if (distance > 200) {
                discountRate = 0.02;
            }
            double discount = baseAmount * discountRate;
            double total = baseAmount - discount;
            
            Bill newBill = new Bill();
            newBill.setBookingId(bookingId);
            newBill.setBaseAmount(baseAmount);
            newBill.setDiscount(discount);
            newBill.setTotalAmount(total);
            billDao.insertBill(newBill);
            bill = billDao.getBillByBookingId(bookingId);
        }
        
        // Retrieve driver if assigned
        Driver driver = null;
        if (booking.getDriverId() != null) {
            driver = driverDao.getDriverByDriverId(booking.getDriverId());
        }
        
        // Retrieve customer
        Customer customer = ManageCustomerDao.getCustomerById(booking.getCustomerId());
        
        // Pass objects to JSP
        request.setAttribute("bill", bill);
        request.setAttribute("billBooking", booking);
        request.setAttribute("driver", driver);
        request.setAttribute("customer", customer);
        
        request.getRequestDispatcher("/Views/bookingForm.jsp").forward(request, response);
    }
    
    private void processPayment(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        int customerId = (Integer) session.getAttribute("customerId");
        int bookingId = Integer.parseInt(request.getParameter("bookingId"));
        String paymentMethod = request.getParameter("paymentMethod");
        
        Bill bill = billDao.getBillByBookingId(bookingId);
        if (bill == null) {
            request.setAttribute("message", "No bill found for this booking.");
            request.getRequestDispatcher("/Views/bookingForm.jsp").forward(request, response);
            return;
        }
        
        Payment payment = new Payment();
        payment.setBookingId(bookingId);
        payment.setCustomerId(customerId);
        payment.setAmount(bill.getTotalAmount());
        payment.setPaymentMethod(paymentMethod);
        payment.setStatus("Completed");
        
        int paymentId = paymentDao.insertPayment(payment);
        if (paymentId > 0) {
            request.setAttribute("message", "Payment successful!");
        } else {
            request.setAttribute("message", "Payment failed.");
        }
        showBillCard(request, response);
    }
}
