<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Ensure only Staff can access
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equalsIgnoreCase("Staff")) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
        return;
    }

    // bookingList is set by the servlet, containing all bookings
    java.util.List<com.megacitycab.model.Booking> bookingList = 
        (java.util.List<com.megacitycab.model.Booking>) request.getAttribute("bookingList");
    
    // booking is set by the servlet if we're editing an existing booking
    com.megacitycab.model.Booking booking = (com.megacitycab.model.Booking) request.getAttribute("booking");
    boolean isEdit = (booking != null);

    // Optional message from the servlet (e.g. "Booking added" or "Deleted successfully")
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Bookings (Staff)</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
</head>
<body class="bg-gray-100">
<div class="max-w-4xl mx-auto py-8">
    <h1 class="text-2xl font-bold mb-4">Manage Bookings (Staff)</h1>
    
    <!-- Display any optional message -->
    <%
        if (message != null) {
    %>
        <div class="bg-green-100 text-green-800 p-4 mb-4 rounded">
            <%= message %>
        </div>
    <%
        }
    %>
    
    <!-- Booking List Table -->
    <h2 class="text-xl font-semibold mb-2">All Bookings</h2>
    <%
        if (bookingList == null || bookingList.isEmpty()) {
    %>
        <p>No bookings found.</p>
    <%
        } else {
    %>
        <table class="min-w-full bg-white border border-gray-300 mb-8">
            <thead class="bg-gray-200">
                <tr>
                    <th class="px-4 py-2">ID</th>
                    <th class="px-4 py-2">Customer ID</th>
                    <th class="px-4 py-2">Driver ID</th>
                    <th class="px-4 py-2">Pickup</th>
                    <th class="px-4 py-2">Destination</th>
                    <th class="px-4 py-2">Distance (km)</th>
                    <th class="px-4 py-2">Status</th>
                    <th class="px-4 py-2">Vehicle Type</th>
                    <th class="px-4 py-2">Actions</th>
                </tr>
            </thead>
            <tbody>
            <%
                for (com.megacitycab.model.Booking b : bookingList) {
            %>
                <tr class="border-b border-gray-300">
                    <td class="px-4 py-2"><%= b.getBookingId() %></td>
                    <td class="px-4 py-2"><%= b.getCustomerId() %></td>
                    <td class="px-4 py-2"><%= b.getDriverId() == null ? "-" : b.getDriverId() %></td>
                    <td class="px-4 py-2"><%= b.getPickupLocation() %></td>
                    <td class="px-4 py-2"><%= b.getDestination() %></td>
                    <td class="px-4 py-2"><%= b.getDistanceKm() %></td>
                    <td class="px-4 py-2"><%= b.getStatus() %></td>
                    <td class="px-4 py-2"><%= b.getVehicleTypeId() %></td>
                    <td class="px-4 py-2">
                        <a href="<%= request.getContextPath() %>/manageBooking?action=edit&id=<%= b.getBookingId() %>" 
                           class="bg-blue-500 text-white px-3 py-1 rounded">Edit</a>
                        |
                        <a href="<%= request.getContextPath() %>/manageBooking?action=delete&bookingId=<%= b.getBookingId() %>" 
                           onclick="return confirm('Are you sure you want to delete this booking?');" 
                           class="bg-red-500 text-white px-3 py-1 rounded">Delete</a>
                        <% if (!"Completed".equalsIgnoreCase(b.getStatus())) { %>
                        |
                        <a href="<%= request.getContextPath() %>/manageBooking?action=cancel&bookingId=<%= b.getBookingId() %>" 
                           onclick="return confirm('Are you sure you want to cancel this booking?');" 
                           class="bg-yellow-500 text-white px-3 py-1 rounded">Cancel</a>
                        <% } %>
                    </td>
                </tr>
            <%
                }
            %>
            </tbody>
        </table>
    <%
        }
    %>
    
    <!-- Add/Edit Booking Form -->
    <h2 class="text-xl font-semibold mb-2"><%= isEdit ? "Edit Booking" : "Add New Booking" %></h2>
    <form action="<%= request.getContextPath() %>/manageBooking" method="post" class="bg-white p-4 border rounded">
        <!-- If we're editing, we pass "update" action; otherwise "add" -->
        <input type="hidden" name="action" value="<%= isEdit ? "update" : "add" %>">
        <% if (isEdit) { %>
            <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
        <% } %>
        
        <!-- Staff can manually enter the customer ID -->
        <div class="mb-2">
            <label for="customerId" class="block font-medium">Customer ID:</label>
            <input type="number" id="customerId" name="customerId" class="border p-2 w-full" 
                   value="<%= isEdit ? booking.getCustomerId() : "" %>" required>
        </div>
        
        <!-- Pickup (select) -->
        <div class="mb-2">
            <label for="pickupLocation" class="block font-medium">Pickup Location:</label>
            <select id="pickupLocation" name="pickupLocation" class="border p-2 w-full" required>
                <option value="">-- Select Pickup --</option>
            </select>
        </div>
        
        <!-- Destination (select) -->
        <div class="mb-2">
            <label for="destination" class="block font-medium">Destination:</label>
            <select id="destination" name="destination" class="border p-2 w-full" required>
                <option value="">-- Select Destination --</option>
            </select>
        </div>
        
        <!-- Distance auto-calculated -->
        <div class="mb-2">
            <label for="distanceKm" class="block font-medium">Distance (km):</label>
            <input type="text" id="distanceKm" name="distanceKm" class="border p-2 w-full" 
                   value="<%= isEdit ? booking.getDistanceKm() : "0" %>" readonly required>
        </div>
        
        <!-- Status -->
        <div class="mb-2">
            <label for="status" class="block font-medium">Status:</label>
            <select id="status" name="status" class="border p-2 w-full">
                <option value="Pending" <%= isEdit && "Pending".equalsIgnoreCase(booking.getStatus()) ? "selected" : "" %>>Pending</option>
                <option value="Ongoing" <%= isEdit && "Ongoing".equalsIgnoreCase(booking.getStatus()) ? "selected" : "" %>>Ongoing</option>
                <option value="Completed" <%= isEdit && "Completed".equalsIgnoreCase(booking.getStatus()) ? "selected" : "" %>>Completed</option>
                <option value="Canceled" <%= isEdit && "Canceled".equalsIgnoreCase(booking.getStatus()) ? "selected" : "" %>>Canceled</option>
            </select>
        </div>
        
        <!-- Vehicle Type -->
        <div class="mb-2">
            <label for="vehicleTypeId" class="block font-medium">Vehicle Type:</label>
            <select id="vehicleTypeId" name="vehicleTypeId" class="border p-2 w-full">
                <option value="1" <%= isEdit && booking.getVehicleTypeId() == 1 ? "selected" : "" %>>Mini Car (2) - 80.00</option>
                <option value="2" <%= isEdit && booking.getVehicleTypeId() == 2 ? "selected" : "" %>>Normal Car (3) - 95.00</option>
                <option value="3" <%= isEdit && booking.getVehicleTypeId() == 3 ? "selected" : "" %>>SUV (3) - 120.00</option>
            </select>
        </div>
        
        <!-- Driver ID (optional) -->
        <div class="mb-2">
            <label for="driverId" class="block font-medium">Driver ID (optional):</label>
            <input type="number" id="driverId" name="driverId" class="border p-2 w-full" 
                   value="<%= isEdit && booking.getDriverId() != null ? booking.getDriverId() : "" %>">
        </div>
        
        <button type="submit" class="bg-green-500 text-white px-4 py-2 rounded">
            <%= isEdit ? "Update Booking" : "Add Booking" %>
        </button>
    </form>
    
    <br>
    <a href="<%= request.getContextPath() %>/Views/home.jsp" class="bg-blue-500 text-white px-4 py-2 rounded">Back to Home</a>
</div>

<script>
    // Ensure only staff can access (the check is done in the JSP above, but you can also do it in the servlet if you prefer)
    
    // City list for distance calculation
    const cities = {
      "Colombo": {lat: 6.9271, lon: 79.8612},
      "Kandy": {lat: 7.2906, lon: 80.6337},
      "Galle": {lat: 6.0320, lon: 80.2160},
      "Jaffna": {lat: 9.6615, lon: 80.0255},
      "Matara": {lat: 5.9496, lon: 80.5357},
      "Negombo": {lat: 7.2082, lon: 79.8379}
      // add more if needed
    };

    // Populate pickup and destination dropdowns
    function populateDropdowns() {
      const pickupSelect = document.getElementById("pickupLocation");
      const destinationSelect = document.getElementById("destination");
      for (const city in cities) {
        let opt = document.createElement("option");
        opt.value = city;
        opt.text = city;
        pickupSelect.add(opt.cloneNode(true));
        destinationSelect.add(opt.cloneNode(true));
      }
    }

    let calculatedDistance = 0;

    // Calculate distance via OSRM
    async function calculateDistance() {
      const pickup = document.getElementById("pickupLocation").value;
      const dest = document.getElementById("destination").value;
      const distanceField = document.getElementById("distanceKm");
      
      if (!pickup || !dest) {
        distanceField.value = "0";
        return;
      }
      if (pickup === dest) {
        distanceField.value = "0";
        return;
      }
      const pCoords = cities[pickup];
      const dCoords = cities[dest];
      if (!pCoords || !dCoords) {
        distanceField.value = "0";
        return;
      }
      const url = "https://router.project-osrm.org/route/v1/driving/" +
                  pCoords.lon + "," + pCoords.lat + ";" +
                  dCoords.lon + "," + dCoords.lat +
                  "?overview=full&geometries=geojson";
      try {
        const response = await fetch(url);
        const data = await response.json();
        if (data.code === "Ok") {
          const route = data.routes[0];
          calculatedDistance = route.distance / 1000;
          distanceField.value = calculatedDistance.toFixed(2);
        } else {
          distanceField.value = "0";
        }
      } catch (error) {
        distanceField.value = "0";
      }
    }

    document.addEventListener("DOMContentLoaded", () => {
      populateDropdowns();
      document.getElementById("pickupLocation").addEventListener("change", calculateDistance);
      document.getElementById("destination").addEventListener("change", calculateDistance);
    });
</script>
</body>
</html>
