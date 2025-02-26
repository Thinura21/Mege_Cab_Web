<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.datapackage.model.Booking" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1">
  <title>Booking Management - Mega City Cab</title>
  
  <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/leaflet/leaflet.css">
  <script src="<%= request.getContextPath() %>/Assets/leaflet/leaflet.js"></script>
  
  <!-- Include any other CDN or local references -->
    <%@ include file="../Assests/CDN_Links.jsp" %>
  
</head>
<body>
  <%@ include file="Navigation/d_hedding.jsp" %>
  
  <div class="container-lg py-3">
    <h2 class="fw-bold">Your Bookings</h2>
    
    <!-- Booking Form -->
    <div class="bg-white shadow rounded p-4 mb-4">
      <form action="<%= request.getContextPath() %>/manageBookings" method="post">
        <input type="hidden" name="action" value="add">
        
        <div class="row">
          <div class="col-md-6 mb-3">
            <label class="form-label">Name</label>
            <input type="text" name="name" class="form-control" required>
          </div>
          <div class="col-md-6 mb-3">
            <label class="form-label">Address</label>
            <input type="text" name="address" class="form-control" required>
          </div>
          <div class="col-md-4 mb-3">
            <label class="form-label">NIC</label>
            <input type="text" name="nic" class="form-control" required>
          </div>
          <div class="col-md-4 mb-3">
            <label class="form-label">Contact</label>
            <input type="text" name="contact" class="form-control" required>
          </div>
          <div class="col-md-4 mb-3">
            <label class="form-label">Date & Time</label>
            <input type="datetime-local" name="dateTime" class="form-control" required>
          </div>
          <div class="col-md-6 mb-3">
            <label class="form-label">Pickup Location</label>
            <input type="text" name="pickup" class="form-control" required>
          </div>
          <div class="col-md-6 mb-3">
            <label class="form-label">Destination</label>
            <input type="text" name="destination" class="form-control" required>
          </div>
        </div>
        
        <button type="submit" class="btn btn-warning w-100">Book Now</button>
      </form>
    </div>
    
    <!-- Booking History Table -->
    <div class="card">
      <div class="card-body">
        <h4 class="mb-3">Your Booking History</h4>
        <div class="table-responsive">
          <table class="table table-hover">
            <thead>
              <tr>
                <th>ID</th>
                <th>Date & Time</th>
                <th>Pickup</th>
                <th>Destination</th>
                <th>Status</th>
                <th>Actions</th>
              </tr>
            </thead>
            <tbody>
<%
  // The servlet sets "bookingList" as a request attribute, a List<Booking>
  List<Booking> bookingList = (List<Booking>) request.getAttribute("bookingList");
  if (bookingList != null && !bookingList.isEmpty()) {
    for (Booking b : bookingList) {
%>
              <tr>
                <td><%= b.getId() %></td>
                <td><%= b.getDateTime() %></td>
                <td><%= b.getPickup() %></td>
                <td><%= b.getDestination() %></td>
                <td><%= b.getStatus() %></td>
                <td>
                  <!-- Example: Only show "Pay & Print Bill" if status is Pending or Confirmed -->
                  <% if("Confirmed".equalsIgnoreCase(b.getStatus()) || "Pending".equalsIgnoreCase(b.getStatus())) { %>
                  <form action="<%= request.getContextPath() %>/manageBookings" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="pay">
                    <input type="hidden" name="bookingId" value="<%= b.getId() %>">
                    <button type="submit" class="btn btn-sm btn-success">
                      Pay & Print Bill
                    </button>
                  </form>
                  <% } %>
                  <!-- Optionally a delete button -->
                  <form action="<%= request.getContextPath() %>/manageBookings" method="post" style="display:inline;">
                    <input type="hidden" name="action" value="delete">
                    <input type="hidden" name="bookingId" value="<%= b.getId() %>">
                    <button type="submit" class="btn btn-sm btn-dark" onclick="return confirm('Are you sure?');">
                      <i class="fas fa-trash"></i>
                    </button>
                  </form>
                </td>
              </tr>
<%
    }
  } else {
%>
              <tr>
                <td colspan="6" class="text-center">No bookings found.</td>
              </tr>
<%
  }
%>
            </tbody>
          </table>
        </div>
      </div>
    </div>
  </div>
  
  <!-- Additional scripts if needed -->
    <%@ include file="../Assests/scripts.jsp" %>

</body>
</html>
