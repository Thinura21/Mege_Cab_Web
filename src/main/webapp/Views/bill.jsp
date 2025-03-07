<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    com.megacitycab.model.Bill bill = (com.megacitycab.model.Bill) request.getAttribute("bill");
    com.megacitycab.model.Booking billBooking = (com.megacitycab.model.Booking) request.getAttribute("billBooking");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Bill - Mega City Cab</title>
    <%@ include file="/Assets/CDN_Links.jsp" %>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/styles.css">
</head>
<body>
    <!-- You can include your navbar if needed -->
    <div class="container my-5">
        <!-- A simple header or instructions -->
        <h1 class="text-center fw-bold mb-4">Bill Details</h1>
    </div>
    
    <!-- Bill Modal -->
    <div class="modal fade" id="billModal" tabindex="-1" aria-labelledby="billModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          
          <!-- Modal Header -->
          <div class="modal-header bg-warning text-dark">
            <h5 class="modal-title fw-bold" id="billModalLabel">
              Bill for Booking #<%= billBooking != null ? billBooking.getBookingId() : "N/A" %>
            </h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close" onclick="window.location.href='<%= request.getContextPath() %>/booking.jsp'"></button>
          </div>
          
          <!-- Modal Body -->
          <div class="modal-body">
            <% if (bill != null && billBooking != null) { %>
                <p><strong>Pickup:</strong> <%= billBooking.getPickupLocation() %></p>
                <p><strong>Destination:</strong> <%= billBooking.getDestination() %></p>
                <p><strong>Distance (km):</strong> <%= billBooking.getDistanceKm() %></p>
                <p><strong>Base Amount:</strong> <%= bill.getBaseAmount() %></p>
                <p><strong>Discount:</strong> <%= bill.getDiscount() %></p>
                <p><strong>Total Amount:</strong> <%= bill.getTotalAmount() %></p>
                
                <!-- Payment form -->
                <form action="<%= request.getContextPath() %>/PaymentServlet" method="post" class="mt-3">
                  <input type="hidden" name="action" value="pay">
                  <input type="hidden" name="bookingId" value="<%= billBooking.getBookingId() %>">
    
                  <div class="mb-3">
                    <label for="paymentMethod" class="form-label fw-semibold">Choose Payment Method:</label>
                    <select id="paymentMethod" name="paymentMethod" class="form-select" onchange="toggleBankDetails()">
                      <option value="On-hand">On-hand (Cash)</option>
                      <option value="Bank Transfer">Bank Transfer</option>
                    </select>
                  </div>
    
                  <div id="bankDetails" class="bank-details ms-1">
                    <p><strong>Bank:</strong> People’s Bank</p>
                    <p><strong>Account Name:</strong> Mega Cab City PVT</p>
                    <p><strong>Account Number:</strong> 1234567890</p>
                  </div>
                  
                  <button type="submit" class="btn btn-success mt-2">
                    Pay Now
                  </button>
                </form>
    
                <% if("Payment successful!".equals(message)) { %>
                    <button onclick="window.print()" class="btn btn-info mt-3">
                      Print Receipt
                    </button>
                <% } %>
            <% } else { %>
                <p>No bill data available.</p>
            <% } %>
          </div>
          
          <!-- Modal Footer -->
          <div class="modal-footer">
            <button type="button" class="btn btn-secondary" data-bs-dismiss="modal" onclick="window.location.href='<%= request.getContextPath() %>/booking.jsp'">
              Close
            </button>
          </div>
        </div>
      </div>
    </div>
    
    <%@ include file="/Assets/scripts.jsp" %>
    <script>
      // Auto-open the modal if bill data exists
      document.addEventListener("DOMContentLoaded", function() {
        var billModalElement = document.getElementById('billModal');
        var billModal = new bootstrap.Modal(billModalElement);
        billModal.show();
      });
    
      // Toggle bank details if user chooses Bank Transfer
      function toggleBankDetails() {
        const method = document.getElementById("paymentMethod").value;
        const bankDiv = document.querySelector(".bank-details");
        bankDiv.style.display = (method === "Bank Transfer") ? "block" : "none";
      }
    </script>
</body>
</html>
