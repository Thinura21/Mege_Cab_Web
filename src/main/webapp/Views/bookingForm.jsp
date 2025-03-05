<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // These attributes come from your BookingServlet or other logic:
    Integer bookingId = (Integer) request.getAttribute("bookingId");
    String bookingStatus = (String) request.getAttribute("bookingStatus");
    
    // The list of existing bookings
    java.util.List<com.megacitycab.model.Booking> bookingList = 
        (java.util.List<com.megacitycab.model.Booking>) request.getAttribute("bookingList");

    // Optionally, the Bill object to display if we want a “bill card”
    com.megacitycab.model.Bill bill = (com.megacitycab.model.Bill) request.getAttribute("bill");
    // Optionally, the related Booking (for showing pickup/destination, etc.)
    com.megacitycab.model.Booking billBooking = (com.megacitycab.model.Booking) request.getAttribute("billBooking");

    // A message for after payment or other actions
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Sri Lanka Road Distance Calculator & Booking</title>
  
  <!-- Tailwind CSS -->
  <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
  <!-- Leaflet CSS -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/leaflet/leaflet.css" />
  
  <style>
    /* Set the map height */
    #map { height: 400px; }
    /* Simple styling for the bill card */
    .bill-card {
      border: 1px solid #e2e8f0; /* gray-200 */
      border-radius: 0.5rem;
      padding: 1rem;
      margin-top: 2rem;
      background-color: #fff;
    }
    .bank-details { display: none; }
  </style>
</head>
<body class="bg-gray-100">
  <div class="max-w-4xl mx-auto py-8">
    <h1 class="text-3xl font-bold text-center mb-8">New Booking</h1>
    
    <!-- If a bookingId was set, show success/cancel message -->
    <%
      if (bookingId != null) {
    %>
      <div class="bg-green-100 text-green-800 p-4 mb-4 rounded">
        Booking <strong><%= bookingId %></strong> 
        <% if ("Canceled".equalsIgnoreCase(bookingStatus)) { %>
          was canceled.
        <% } else { %>
          created with status: <strong><%= bookingStatus == null ? "Pending" : bookingStatus %></strong>
        <% } %>
      </div>
    <%
      }
    %>

    <!-- Optionally show a message (e.g. after payment) -->
    <%
      if (message != null) {
    %>
      <div class="bg-blue-100 text-blue-800 p-4 mb-4 rounded">
        <%= message %>
      </div>
    <%
      }
    %>
    
    <!-- Booking form -->
    <form id="bookingForm" action="<%= request.getContextPath() %>/BookingServlet" method="post" class="mb-8">
      <input type="hidden" id="distanceKm" name="distanceKm" value="0">
      
      <!-- Origin and Destination -->
      <div class="mb-4">
        <label class="block mb-2 font-medium" for="origin">Select Origin:</label>
        <select id="origin" name="originCity" class="w-full p-2 border rounded">
          <option value="">-- Select Origin --</option>
        </select>
      </div>
      <div class="mb-4">
        <label class="block mb-2 font-medium" for="destination">Select Destination:</label>
        <select id="destination" name="destinationCity" class="w-full p-2 border rounded">
          <option value="">-- Select Destination --</option>
        </select>
      </div>
      
      <!-- Vehicle Type -->
      <div class="mb-4">
        <label class="block mb-2 font-medium" for="vehicleTypeId">Vehicle Type:</label>
        <select id="vehicleTypeId" name="vehicleTypeId" class="w-full p-2 border rounded">
          <!-- Example options: from vehicle_types table -->
          <option value="1">Mini Car (2) - 80.00</option>
          <option value="2">Normal Car (3) - 95.00</option>
          <option value="3">SUV (3) - 120.00</option>
        </select>
      </div>
      
      <!-- Display calculated distance and time -->
      <div id="output" class="mb-4 text-lg"></div>
      
      <button type="submit" class="w-full bg-green-500 text-white py-2 rounded">Submit Booking</button>
    </form>
    
    <!-- The map container -->
    <div id="map" class="rounded shadow-md mb-8"></div>
    
    <!-- Existing bookings section -->
    <hr class="my-8">
    <h2 class="text-2xl font-bold mb-4">My Bookings</h2>
    <%
      if (bookingList == null || bookingList.isEmpty()) {
    %>
      <p>You have no bookings yet.</p>
    <%
      } else {
        // Filter out "Canceled" bookings
        java.util.List<com.megacitycab.model.Booking> visibleBookings = new java.util.ArrayList<>();
        for (com.megacitycab.model.Booking b : bookingList) {
            if (!"Canceled".equalsIgnoreCase(b.getStatus())) {
                visibleBookings.add(b);
            }
        }
        if (visibleBookings.isEmpty()) {
    %>
          <p>You have no active bookings.</p>
    <%
        } else {
    %>
          <table class="min-w-full bg-white border border-gray-300">
            <thead class="bg-gray-200">
              <tr>
                <th class="px-4 py-2">ID</th>
                <th class="px-4 py-2">Pickup</th>
                <th class="px-4 py-2">Destination</th>
                <th class="px-4 py-2">Distance</th>
                <th class="px-4 py-2">Status</th>
                <th class="px-4 py-2">Action</th>
              </tr>
            </thead>
            <tbody>
            <%
              for (com.megacitycab.model.Booking b : visibleBookings) {
            %>
              <tr class="border-b border-gray-300">
                <td class="px-4 py-2"><%= b.getBookingId() %></td>
                <td class="px-4 py-2"><%= b.getPickupLocation() %></td>
                <td class="px-4 py-2"><%= b.getDestination() %></td>
                <td class="px-4 py-2"><%= b.getDistanceKm() %></td>
                <td class="px-4 py-2"><%= b.getStatus() %></td>
                <td class="px-4 py-2">
                  <!-- Cancel button if not completed -->
                  <%
                    if (!"Completed".equalsIgnoreCase(b.getStatus())) {
                  %>
                    <a href="<%= request.getContextPath() %>/BookingServlet?action=cancel&bookingId=<%= b.getBookingId() %>"
                       onclick="return confirm('Are you sure you want to cancel this booking?');"
                       class="bg-red-500 text-white px-3 py-1 rounded">
                       Cancel
                    </a>
                    <!-- Example: Show a "View Bill" link that sets 'bookingId' to a Payment/Bill flow -->
                    <a href="<%= request.getContextPath() %>/PaymentServlet?bookingId=<%= b.getBookingId() %>"
                       class="bg-blue-500 text-white px-3 py-1 rounded ml-2">
                       View Bill
                    </a>
                  <%
                    } else {
                  %>
                    <span class="text-gray-500">No action</span>
                  <%
                    }
                  %>
                </td>
              </tr>
            <%
              }
            %>
            </tbody>
          </table>
    <%
        }
      }
    %>

    <!-- 
         -------------- 
         BILL CARD SECTION
         --------------
         If a Bill object is in request scope, show the Bill + Payment form
    -->
    <%
      if (bill != null && billBooking != null) {
    %>
      <div class="bill-card">
        <h2 class="text-xl font-semibold mb-2">Bill for Booking #<%= billBooking.getBookingId() %></h2>
        <p><strong>Pickup:</strong> <%= billBooking.getPickupLocation() %></p>
        <p><strong>Destination:</strong> <%= billBooking.getDestination() %></p>
        <p><strong>Distance (km):</strong> <%= billBooking.getDistanceKm() %></p>
        <p><strong>Base Amount:</strong> <%= bill.getBaseAmount() %></p>
        <p><strong>Discount:</strong> <%= bill.getDiscount() %></p>
        <p><strong>Total Amount:</strong> <%= bill.getTotalAmount() %></p>
        
        <!-- Payment form embedded here -->
        <form action="<%= request.getContextPath() %>/PaymentServlet" method="post" class="mt-4">
          <input type="hidden" name="action" value="pay">
          <input type="hidden" name="bookingId" value="<%= billBooking.getBookingId() %>">
          <label for="paymentMethod" class="block font-medium mb-1">Choose Payment Method:</label>
          <select id="paymentMethod" name="paymentMethod" class="border p-2 rounded" onchange="toggleBankDetails()">
            <option value="On-hand">On-hand (Cash)</option>
            <option value="Bank Transfer">Bank Transfer</option>
          </select>
          
          <div id="bankDetails" class="bank-details mt-2">
            <p><strong>Bank:</strong> People’s Bank</p>
            <p><strong>Account Name:</strong> Mega Cab City PVT</p>
            <p><strong>Account Number:</strong> 1234567890</p>
          </div>
          
          <button type="submit" class="bg-green-500 text-white px-4 py-2 rounded mt-3">
            Pay Now
          </button>
        </form>
        
        <!-- If payment is successful, you might show a print button, etc. -->
        <%
          if("Payment successful!".equals(message)) {
        %>
            <button onclick="window.print()" class="bg-blue-500 text-white px-4 py-2 rounded mt-3">
              Print Receipt
            </button>
        <%
          }
        %>
      </div>
    <%
      }
    %>

  </div>
  
  <!-- Leaflet JS -->
  <script src="<%= request.getContextPath() %>/leaflet/leaflet.js"></script>
  <script>
    // List of cities with approximate coords
    const cities = {
      "Colombo": {lat: 6.9271, lon: 79.8612},
      "Kandy": {lat: 7.2906, lon: 80.6337},
      "Galle": {lat: 6.0320, lon: 80.2160},
      "Jaffna": {lat: 9.6615, lon: 80.0255},
      "Matara": {lat: 5.9496, lon: 80.5357},
      "Negombo": {lat: 7.2082, lon: 79.8379}
    };

    function populateDropdowns() {
      const originSelect = document.getElementById("origin");
      const destinationSelect = document.getElementById("destination");
      for (const city in cities) {
        let opt = document.createElement("option");
        opt.value = city;
        opt.text = city;
        originSelect.add(opt.cloneNode(true));
        destinationSelect.add(opt.cloneNode(true));
      }
    }

    let map, routeLayer;
    let calculatedDistance = 0;

    function initMap() {
      map = L.map('map').setView([7.0, 80.0], 7);
      L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
        attribution: 'Map data © OpenStreetMap contributors'
      }).addTo(map);
    }

    async function calculateDistance() {
      const origin = document.getElementById("origin").value;
      const dest = document.getElementById("destination").value;
      const outputDiv = document.getElementById("output");

      if (!origin || !dest) {
        outputDiv.innerText = "Please select both origin and destination.";
        calculatedDistance = 0;
        updateHiddenDistance();
        return;
      }
      if (origin === dest) {
        outputDiv.innerText = "Origin and destination cannot be the same.";
        calculatedDistance = 0;
        updateHiddenDistance();
        return;
      }
      
      const oCoords = cities[origin];
      const dCoords = cities[dest];
      if (!oCoords || !dCoords) {
        outputDiv.innerText = "Coordinates not found for the selected city.";
        calculatedDistance = 0;
        updateHiddenDistance();
        return;
      }

      const url = "https://router.project-osrm.org/route/v1/driving/" +
                  oCoords.lon + "," + oCoords.lat + ";" +
                  dCoords.lon + "," + dCoords.lat +
                  "?overview=full&geometries=geojson";

      try {
        const response = await fetch(url);
        const data = await response.json();
        if (data.code === "Ok") {
          const route = data.routes[0];
          calculatedDistance = route.distance / 1000;
          outputDiv.innerHTML = "Distance: <strong>" + calculatedDistance.toFixed(2) +
                                " km</strong><br>Estimated travel time: <strong>" +
                                (route.duration / 60).toFixed(2) + " minutes</strong>";
          if (routeLayer) { map.removeLayer(routeLayer); }
          routeLayer = L.geoJSON(route.geometry, { style: { color: 'blue', weight: 5, opacity: 0.7 } }).addTo(map);
          map.fitBounds(routeLayer.getBounds(), { padding: [50, 50] });
        } else {
          outputDiv.innerText = "Error calculating route: " + data.message;
          calculatedDistance = 0;
        }
      } catch (error) {
        outputDiv.innerText = "Error: " + error;
        calculatedDistance = 0;
      }
      updateHiddenDistance();
    }

    function updateHiddenDistance() {
      document.getElementById("distanceKm").value = calculatedDistance.toFixed(2);
    }

    // Toggle bank details if user chooses Bank Transfer
    function toggleBankDetails() {
      const method = document.getElementById("paymentMethod").value;
      const bankDiv = document.querySelector(".bank-details");
      if(method === "Bank Transfer") {
        bankDiv.style.display = "block";
      } else {
        bankDiv.style.display = "none";
      }
    }

    document.addEventListener("DOMContentLoaded", () => {
      populateDropdowns();
      initMap();
      document.getElementById("origin").addEventListener("change", calculateDistance);
      document.getElementById("destination").addEventListener("change", calculateDistance);
    });
  </script>
</body>
</html>
