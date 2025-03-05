<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
  <meta charset="UTF-8">
  <title>Booking Success</title>
</head>
<body>
  <h2>Booking Successful!</h2>
  <p>Your booking has been created successfully. Your booking ID is: <strong><%= request.getParameter("bookingId") %></strong></p>
  <a href="customerDashboard.jsp">Go to Dashboard</a>
</body>
</html>
