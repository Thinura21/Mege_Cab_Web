<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="com.datapackage.dao.BookingDao" %>
<%@ page import="com.datapackage.model.Booking" %>
<%@ page import="java.sql.SQLException" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Booking Bill - Mega City Cab</title>
  <%@ include file="../Assests/scripts.jsp" %>
  <link rel="stylesheet" href="../Assets/d_styles.css">
  <style>
    .bill-container {
      max-width: 600px;
      margin: 2rem auto;
      padding: 1.5rem;
      border: 1px solid #ddd;
      background: #fff;
      border-radius: 10px;
    }
    .bill-header {
      text-align: center;
      margin-bottom: 1rem;
    }
    .bill-details {
      font-size: 1.1rem;
    }
    .print-button {
      margin-top: 1rem;
    }
  </style>
</head>
<body>
  <div class="bill-container">
    <div class="bill-header">
      <h2>Mega City Cab - Booking Bill</h2>
    </div>
    <%
      String bookingId = request.getParameter("bookingId");
      Booking booking = null;
      try {
          BookingDao bookingDao = new BookingDao();
          // For simplicity, assume we have a method to get booking by ID.
          // If not, you could search from a list. Here, we'll simulate:
          List<Booking> bookings = bookingDao.getBookingsForCustomer((Integer) session.getAttribute("customerID"));
          for(Booking b : bookings) {
              if(b.getId().equals(bookingId)) {
                  booking = b;
                  break;
              }
          }
      } catch(SQLException | ClassNotFoundException e) {
          e.printStackTrace();
      }
      if(booking != null) {
    %>
    <div class="bill-details">
      <p><strong>Booking ID:</strong> <%= booking.getId() %></p>
      <p><strong>Name:</strong> <%= booking.getName() %></p>
      <p><strong>Date & Time:</strong> <%= booking.getDateTime() %></p>
      <p><strong>Pickup:</strong> <%= booking.getPickup() %></p>
      <p><strong>Destination:</strong> <%= booking.getDestination() %></p>
      <p><strong>Status:</strong> <%= booking.getStatus() %></p>
      <!-- Add any other billing details (e.g., fare amount) as needed -->
    </div>
    <button class="btn btn-primary print-button" onclick="window.print()">Print Bill</button>
    <%
      } else {
    %>
    <p class="text-center">Booking not found.</p>
    <%
      }
    %>
  </div>
</body>
</html>
