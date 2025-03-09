<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Bill & Booking from request
    com.megacitycab.model.Bill bill = (com.megacitycab.model.Bill) request.getAttribute("bill");
    com.megacitycab.model.Booking billBooking = (com.megacitycab.model.Booking) request.getAttribute("billBooking");

    // Real driver & customer from the DB
    com.megacitycab.model.Driver driver = (com.megacitycab.model.Driver) request.getAttribute("driver");
    com.megacitycab.model.Customer customer = (com.megacitycab.model.Customer) request.getAttribute("customer");

    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Bill Details</title>
    <!-- Bootstrap CSS -->
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
    <style>
        .bill-card {
            border: 1px solid #e2e8f0;
            border-radius: 0.5rem;
            padding: 1rem;
            background-color: #fff;
        }
    </style>
</head>
<body>
    <!-- Optional: A button to manually trigger the modal for testing -->
    <button type="button" class="btn btn-primary" data-bs-toggle="modal" data-bs-target="#billModal">
        View Bill
    </button>

    <!-- Bill Modal -->
    <div class="modal fade" id="billModal" tabindex="-1" aria-labelledby="billModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg modal-dialog-centered">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title" id="billModalLabel">
              Bill for Booking #<%= (billBooking != null) ? billBooking.getBookingId() : "" %>
            </h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>

          <div class="modal-body">
            <!-- If we have Bill and Booking, show the info -->
            <%
              if (bill != null && billBooking != null) {
            %>
              <div class="bill-card">
                <h4 class="mb-3">Trip Details</h4>
                <p><strong>Pickup Location:</strong> <%= billBooking.getPickupLocation() %></p>
                <p><strong>Destination:</strong> <%= billBooking.getDestination() %></p>
                <p><strong>Distance (km):</strong> <%= billBooking.getDistanceKm() %></p>
                <hr>
                <h4 class="mb-3">Billing Information</h4>
                <p><strong>Base Amount:</strong> <%= bill.getBaseAmount() %></p>
                <p><strong>Discount:</strong> <%= bill.getDiscount() %></p>
                <p><strong>Total Amount:</strong> <%= bill.getTotalAmount() %></p>
                <hr>
                <h4 class="mb-3">Driver &amp; Vehicle Information</h4>
                <%
                  if (driver != null) {
                %>
                  <p><strong>Driver Name:</strong> <%= driver.getFName() %></p>
                  <p><strong>Driver Phone:</strong> <%= driver.getContact() %></p>
                  <p><strong>Vehicle Type:</strong> 
                    <!-- If you have a separate method to retrieve the vehicle type name, do so here -->
                    <!-- Or if your Booking has a vehicle_type_id, you can load it from your VehicleTypeDao. -->
                    <%= "Vehicle Type ID: " + billBooking.getVehicleTypeId() %>
                  </p>
                <%
                  } else {
                %>
                  <p class="text-muted">No driver assigned yet.</p>
                <%
                  }
                %>
                <hr>
                <h4 class="mb-3">Customer Information</h4>
                <%
                  if (customer != null) {
                %>
                  <p><strong>Customer Name:</strong> <%= customer.getName() %></p>
                  <p><strong>Contact:</strong> <%= customer.getContact() %></p>
                  <p><strong>Email:</strong> <%= customer.getEmail() %></p>
                <%
                  } else {
                %>
                  <p class="text-muted">No customer data found.</p>
                <%
                  }
                %>
              </div>
            <%
              } else {
            %>
              <p class="text-muted">No bill information available.</p>
            <%
              }
            %>
          </div>

          <div class="modal-footer">
            <!-- Payment successful logic -->
            <% if ("Payment successful!".equals(message)) { %>
              <button onclick="window.print()" class="btn btn-success">Print Receipt</button>
            <% } %>
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">Close</button>
          </div>

        </div>
      </div>
    </div>

    <!-- Auto-open the modal if a Bill is available -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <script>
      document.addEventListener("DOMContentLoaded", function() {
          <% if (bill != null && billBooking != null) { %>
              var billModal = new bootstrap.Modal(document.getElementById('billModal'));
              billModal.show();
          <% } %>
      });
    </script>
</body>
</html>
