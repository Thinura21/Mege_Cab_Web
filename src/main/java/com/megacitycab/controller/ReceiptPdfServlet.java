package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;

import com.itextpdf.text.Document;
import com.itextpdf.text.DocumentException;
import com.itextpdf.text.Paragraph;
import com.itextpdf.text.pdf.PdfWriter;
import com.megacitycab.dao.BillDao;
import com.megacitycab.dao.BookingDao;
import com.megacitycab.dao.DriverDao;
import com.megacitycab.model.Bill;
import com.megacitycab.model.Booking;
import com.megacitycab.model.Driver;

@WebServlet("/ReceiptPdfServlet")
public class ReceiptPdfServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private BillDao billDao = new BillDao();
    private BookingDao bookingDao = new BookingDao();
    private DriverDao driverDao = new DriverDao();
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
        throws ServletException, IOException {
        
        String bookingIdStr = request.getParameter("bookingId");
        if (bookingIdStr == null) {
            response.sendError(HttpServletResponse.SC_BAD_REQUEST, "Missing bookingId");
            return;
        }
        int bookingId = Integer.parseInt(bookingIdStr);
        Bill bill = billDao.getBillByBookingId(bookingId);
        Booking booking = bookingDao.getBookingById(bookingId);
        if (bill == null || booking == null) {
            response.sendError(HttpServletResponse.SC_NOT_FOUND, "Bill or Booking not found");
            return;
        }
        
        // Retrieve driver details if assigned. (Assumes booking.getDriverId() returns an Integer)
        Driver driver = null;
        if (booking.getDriverId() != null) {
            driver = driverDao.getDriverByUserId(booking.getDriverId());
        }
        
        response.setContentType("application/pdf");
        response.setHeader("Content-Disposition", "attachment; filename=Receipt_" + bookingId + ".pdf");
        OutputStream out = response.getOutputStream();
        
        Document document = new Document();
        try {
            PdfWriter.getInstance(document, out);
            document.open();
            document.add(new Paragraph("TAXI RECEIPT"));
            document.add(new Paragraph("Receipt Number: " + bookingId));
            document.add(new Paragraph("Booking Date/Time: " + booking.getBookingDate().toString()));
            document.add(new Paragraph("Pickup Location: " + booking.getPickupLocation()));
            document.add(new Paragraph("Destination: " + booking.getDestination()));
            document.add(new Paragraph("Distance (km): " + booking.getDistanceKm()));
            document.add(new Paragraph("Base Amount: $" + bill.getBaseAmount()));
            document.add(new Paragraph("Discount: " + (bill.getDiscount() * 100) + "%"));
            document.add(new Paragraph("Total Amount: $" + bill.getTotalAmount()));
            document.add(new Paragraph(" "));
            
            // Include driver details if available
            if (driver != null) {
                document.add(new Paragraph("Driver Details:"));
                document.add(new Paragraph("Name: " + driver.getFName()));
                document.add(new Paragraph("Contact: " + driver.getContact()));
                document.add(new Paragraph("Email: " + driver.getEmail()));
                document.add(new Paragraph("License Number: " + driver.getLicenseNumber()));
            } else {
                document.add(new Paragraph("Driver Details: Not assigned"));
            }
        } catch (DocumentException e) {
            throw new IOException(e.getMessage());
        } finally {
            document.close();
        }
        out.close();
    }
}
