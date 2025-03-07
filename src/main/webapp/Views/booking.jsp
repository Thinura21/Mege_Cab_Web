<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Retrieve booking list and messages, if any.
    Integer bookingId = (Integer) request.getAttribute("bookingId");
    String bookingStatus = (String) request.getAttribute("bookingStatus");
    java.util.List<com.megacitycab.model.Booking> bookingList = 
        (java.util.List<com.megacitycab.model.Booking>) request.getAttribute("bookingList");
    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8" />
    <title>Booking - Mega City Cab</title>
    <%@ include file="/Assets/CDN_Links.jsp" %>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/styles.css">
    <!-- Leaflet CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/leaflet/leaflet.css" />
</head>
<body>
    <div class="container my-5">
        <h1 class="text-center fw-bold mb-4">Book Your Ride</h1>
        
        <!-- Optionally show any messages -->
        <%
            if (bookingId != null) {
        %>
        <div class="alert alert-success alert-dismissible fade show" role="alert">
            Booking <strong><%= bookingId %></strong>
            <% if ("Canceled".equalsIgnoreCase(bookingStatus)) { %>
                was canceled.
            <% } else { %>
                created with status: <strong><%= bookingStatus == null ? "Pending" : bookingStatus %></strong>
            <% } %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <%
            }
            if (message != null) {
        %>
        <div class="alert alert-info alert-dismissible fade show" role="alert">
            <%= message %>
            <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
        </div>
        <%
            }
        %>
        
        <!-- Booking Form Card -->
        <div class="card mb-4">
            <div class="card-header bg-warning text-dark fw-bold">New Booking</div>
            <div class="card-body">
                <form id="bookingForm" action="<%= request.getContextPath() %>/BookingServlet" method="post">
                    <input type="hidden" id="distanceKm" name="distanceKm" value="0">
                    
                    <div class="mb-3">
                        <label for="origin" class="form-label fw-semibold">Select Origin:</label>
                        <select id="origin" name="originCity" class="form-select">
                            <option value="">-- Select Origin --</option>
                            <!-- Options will be populated by JavaScript -->
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="destination" class="form-label fw-semibold">Select Destination:</label>
                        <select id="destination" name="destinationCity" class="form-select">
                            <option value="">-- Select Destination --</option>
                            <!-- Options will be populated by JavaScript -->
                        </select>
                    </div>
                    <div class="mb-3">
                        <label for="vehicleTypeId" class="form-label fw-semibold">Vehicle Type:</label>
                        <select id="vehicleTypeId" name="vehicleTypeId" class="form-select">
                            <option value="1">Mini Car (2) - 80.00</option>
                            <option value="2">Normal Car (3) - 95.00</option>
                            <option value="3">SUV (3) - 120.00</option>
                        </select>
                    </div>
                    
                    <!-- Display calculated distance and time -->
                    <div id="output" class="mb-3 fs-5 fw-semibold"></div>
                    
                    <button type="submit" class="btn btn-success w-100">Submit Booking</button>
                </form>
            </div>
        </div>
        
        <!-- Map Card -->
        <div class="card">
            <div class="card-header bg-warning text-dark fw-bold">Map & Route</div>
            <div class="card-body p-0">
                <div id="map"></div>
            </div>
        </div>
        
        <!-- Existing Bookings Table -->
        <hr class="my-4">
        <h2 class="fw-bold mb-3">My Bookings</h2>
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
                    <div class="table-responsive">
                        <table class="table table-bordered align-middle">
                            <thead class="table-dark">
                                <tr>
                                    <th>ID</th>
                                    <th>Pickup</th>
                                    <th>Destination</th>
                                    <th>Distance (km)</th>
                                    <th>Status</th>
                                    <th>Action</th>
                                </tr>
                            </thead>
                            <tbody>
                            <%
                                for (com.megacitycab.model.Booking b : visibleBookings) {
                            %>
                                <tr>
                                    <td><%= b.getBookingId() %></td>
                                    <td><%= b.getPickupLocation() %></td>
                                    <td><%= b.getDestination() %></td>
                                    <td><%= b.getDistanceKm() %></td>
                                    <td><%= b.getStatus() %></td>
                                    <td>
                                        <%
                                            if (!"Completed".equalsIgnoreCase(b.getStatus())) {
                                        %>
                                            <a href="<%= request.getContextPath() %>/BookingServlet?action=cancel&bookingId=<%= b.getBookingId() %>" 
                                               onclick="return confirm('Are you sure you want to cancel this booking?');" 
                                               class="btn btn-danger btn-sm">Cancel</a>
                                            <!-- Instead of directly displaying the bill, redirect to bill.jsp -->
                                            <a href="<%= request.getContextPath() %>/bill.jsp?bookingId=<%= b.getBookingId() %>" 
                                               class="btn btn-primary btn-sm ms-1">View Bill</a>
                                        <%
                                            } else {
                                        %>
                                            <span class="text-muted">No action</span>
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
                    </div>
        <%
                }
            }
        %>
    </div>

    <!-- Include Leaflet and Bootstrap JS -->
    <script src="<%= request.getContextPath() %>/leaflet/leaflet.js"></script>
    <%@ include file="/Assets/scripts.jsp" %>

    <script>
        // List of cities with approximate coordinates
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

        document.addEventListener("DOMContentLoaded", () => {
            populateDropdowns();
            initMap();
            document.getElementById("origin").addEventListener("change", calculateDistance);
            document.getElementById("destination").addEventListener("change", calculateDistance);
        });
    </script>
</body>
</html>
