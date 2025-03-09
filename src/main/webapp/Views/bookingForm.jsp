<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    Integer bookingId = (Integer) request.getAttribute("bookingId");
    String bookingStatus = (String) request.getAttribute("bookingStatus");
    java.util.List<com.megacitycab.model.Booking> bookingList =
        (java.util.List<com.megacitycab.model.Booking>) request.getAttribute("bookingList");
    
    com.megacitycab.model.Bill bill = (com.megacitycab.model.Bill) request.getAttribute("bill");
    com.megacitycab.model.Booking billBooking = (com.megacitycab.model.Booking) request.getAttribute("billBooking");
    
    // Driver and Customer objects (if set by your servlet)
    com.megacitycab.model.Driver driver = (com.megacitycab.model.Driver) request.getAttribute("driver");
    com.megacitycab.model.Customer customer = (com.megacitycab.model.Customer) request.getAttribute("customer");

    String message = (String) request.getAttribute("message");
%>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8" />
  <title>Mega City Cab - Book Your Ride</title>
   <%@ include file="/Assets/CDN_Links.jsp" %>
  <!-- Leaflet CSS -->
  <link rel="stylesheet" href="<%= request.getContextPath() %>/leaflet/leaflet.css" />
  <style>
    :root {
      --primary-yellow: #FFC107;
      --primary-dark: #212529;
      --secondary-gray: #6c757d;
    }
    
    body {
      font-family: 'Segoe UI', Tahoma, Geneva, Verdana, sans-serif;
    }
    
    .btn-primary {
      background-color: var(--primary-yellow);
      border-color: var(--primary-yellow);
      color: var(--primary-dark);
      font-weight: 600;
    }
    
    .btn-primary:hover {
      background-color: #e0a800;
      border-color: #e0a800;
      color: var(--primary-dark);
    }
    
    .text-primary {
      color: var(--primary-yellow) !important;
    }
    
    #map { 
      height: 400px;
      border-radius: 10px;
      box-shadow: 0 2px 15px rgba(0,0,0,0.1);
    }
    
    .card {
      border-radius: 10px;
      border: none;
      box-shadow: 0 2px 15px rgba(0,0,0,0.1);
      overflow: hidden;
    }
    
    .card-header {
      background-color: white;
      border-bottom: 1px solid #eee;
      padding: 15px 20px;
    }
    
    .form-control, .form-select {
      padding: 10px 15px;
      border-radius: 8px;
      border: 1px solid #e0e0e0;
    }
    
    .section-title {
      position: relative;
      padding-bottom: 15px;
      margin-bottom: 25px;
    }
    
    .section-title::after {
      content: '';
      position: absolute;
      left: 0;
      bottom: 0;
      width: 50px;
      height: 3px;
      background-color: var(--primary-yellow);
    }
    
    .bill-card {
      border: 1px solid #e2e8f0;
      border-radius: 0.5rem;
      padding: 1.5rem;
      margin-top: 2rem;
      background-color: #fff;
      box-shadow: 0 4px 10px rgba(0,0,0,0.05);
    }
    
    .bank-details { 
      display: none;
      padding: 15px;
      background-color: #f8f9fa;
      border-radius: 8px;
      margin-top: 15px;
    }
    
    .bill-header {
      padding-bottom: 15px;
      border-bottom: 2px solid var(--primary-yellow);
      margin-bottom: 20px;
    }
    
    .bill-section {
      margin-bottom: 20px;
      padding-bottom: 15px;
      border-bottom: 1px solid #eee;
    }
    
    .bill-total {
      font-size: 1.2em;
      font-weight: bold;
      color: var(--primary-dark);
      padding: 10px;
      background-color: #f8f9fa;
      border-radius: 5px;
    }
    
    .full-width-container { 
      padding-left: 0;
      padding-right: 0; 
    }
    
    .table-booking {
      border-collapse: separate;
      border-spacing: 0;
    }
    
    .table-booking thead th {
      background-color: #f8f9fa;
      border-bottom: 2px solid var(--primary-yellow);
      padding: 12px 15px;
    }
    
    .booking-icon {
      width: 40px;
      height: 40px;
      background-color: rgba(255, 193, 7, 0.2);
      color: var(--primary-yellow);
      display: flex;
      align-items: center;
      justify-content: center;
      border-radius: 50%;
      margin-right: 10px;
    }
    
    .main-heading {
      font-weight: 700;
      color: var(--primary-dark);
    }
    
    .modal-header {
      background-color: var(--primary-yellow);
      color: var(--primary-dark);
    }
    
    .bill-company-info {
      text-align: center;
      margin-bottom: 20px;
    }
    
    .bill-company-info h3 {
      color: var(--primary-dark);
      margin-bottom: 5px;
    }
    
    .bill-company-info p {
      color: var(--secondary-gray);
      margin-bottom: 5px;
    }
    
    .bill-data-row {
      display: flex;
      justify-content: space-between;
      margin-bottom: 10px;
    }
    
    .bill-label {
      font-weight: 600;
      color: var(--secondary-gray);
    }
    
    .bill-value {
      font-weight: 600;
      color: var(--primary-dark);
    }
  </style>
</head>
<body class="bg-light">
 <%@ include file="Navigation/navbar_noSessions.jsp" %>

  <div class="container-fluid full-width-container py-3">
    <section id="booking-interface" class="bg-light">
      <div class="container">
        <div class="text-center mb-5">
          <h2 class="main-heading"><span class="text-primary">Your Trusted Ride</span> in Colombo</h2>
          <p class="text-muted">Mega City Cab offers fast, safe, and affordable taxi services. With our new digital booking system, you can schedule your ride in seconds.</p>
        </div>
        
        <div class="row g-4">
          <!-- Map Column -->
          <div class="col-lg-8">
            <div class="card shadow">
              <div class="card-body">
                <h4 class="fw-bold text-dark mb-3">
                  <div class="d-flex align-items-center">
                    <span class="booking-icon"><i class="fas fa-map-marker-alt"></i></span>
                    <span>Find Your Route</span>
                  </div>
                </h4>
                <div id="map" class="rounded"></div>
              </div>
            </div>
          </div>
          
          <!-- Booking Form Column -->
          <div class="col-lg-4">
            <div class="card shadow">
              <div class="card-body">
                <h4 class="fw-bold text-dark mb-3">
                  <div class="d-flex align-items-center">
                    <span class="booking-icon"><i class="fas fa-taxi"></i></span>
                    <span>Book Your Ride</span>
                  </div>
                </h4>
                <% if (bookingId != null) { %>
                  <div class="alert alert-success">
                    Booking <strong><%= bookingId %></strong>
                    <% if ("Canceled".equalsIgnoreCase(bookingStatus)) { %>
                      was canceled.
                    <% } else { %>
                      created with status: <strong><%= bookingStatus == null ? "Pending" : bookingStatus %></strong>
                    <% } %>
                  </div>
                <% } %>
                <% if (message != null) { %>
                  <div class="alert alert-info"><%= message %></div>
                <% } %>
                
                <form id="bookingForm" action="<%= request.getContextPath() %>/BookingServlet" method="post">
                  <input type="hidden" id="distanceKm" name="distanceKm" value="0">
                  <!-- Origin -->
                  <div class="mb-3">
                    <label for="origin" class="form-label"><i class="fas fa-map-pin me-2 text-primary"></i>Select Origin:</label>
                    <select id="origin" name="originCity" class="form-select">
                      <option value="">--  Pickup Location --</option>
                    </select>
                  </div>
                  <!-- Destination -->
                  <div class="mb-3">
                    <label for="destination" class="form-label"><i class="fas fa-map-pin me-2 text-primary"></i>Select Destination:</label>
                    <select id="destination" name="destinationCity" class="form-select">
                      <option value="">-- Destination --</option>
                    </select>
                  </div>
                  <!-- Vehicle Type -->
                  <div class="mb-3">
                    <label for="vehicleTypeId" class="form-label"><i class="fas fa-car me-2 text-primary"></i>Vehicle Type:</label>
                    <select id="vehicleTypeId" name="vehicleTypeId" class="form-select">
                      <option value="1">Mini Car (2) - 80.00</option>
                      <option value="2">Normal Car (3) - 95.00</option>
                      <option value="3">SUV (3) - 120.00</option>
                      <option value="4">Large Car (4) - 115.00</option>
                      <option value="5">Minivan (6) - 120.00</option>
                      <option value="6">Large Van (10) - 130.00</option>
                      <option value="7">Minibus (15) - 150.00</option>
                    </select>
                  </div>
                  <!-- Booking Date & Time -->
                  <div class="mb-3">
                    <label for="bookingDateTime" class="form-label"><i class="fas fa-calendar-alt me-2 text-primary"></i>Booking Date & Time:</label>
                    <input type="datetime-local" id="bookingDateTime" name="bookingDateTime" class="form-control" required>
                  </div>
                  <!-- Distance/Time Output -->
                  <div id="output" class="mb-3 p-3 bg-light rounded">
                    <div class="d-flex align-items-center mb-2">
                      <div class="booking-icon"><i class="fas fa-route"></i></div>
                      <div class="fw-bold">Trip Information</div>
                    </div>
                    <p class="mb-0 text-muted">Select origin and destination to calculate distance</p>
                  </div>
                  <button type="submit" class="btn btn-primary w-100 py-2">
                    <i class="fas fa-check-circle me-2"></i>Book Now
                  </button>
                </form>
              </div>
            </div>
          </div>
        </div><!-- End Row: Map & Booking Form -->

        <!-- Existing Bookings Section -->
        <div class="row mt-5">
          <div class="col-12">
            <div class="card shadow">
              <div class="card-body">
                <h4 class="fw-bold text-dark mb-3">
                  <div class="d-flex align-items-center">
                    <span class="booking-icon"><i class="fas fa-list"></i></span>
                    <span>My Bookings</span>
                  </div>
                </h4>
                <% if (bookingList == null || bookingList.isEmpty()) { %>
                  <p class="text-muted">You have no bookings yet.</p>
                <% } else { 
                     java.util.List<com.megacitycab.model.Booking> visibleBookings = new java.util.ArrayList<>();
                     for (com.megacitycab.model.Booking b : bookingList) {
                         if (!"Canceled".equalsIgnoreCase(b.getStatus())) {
                             visibleBookings.add(b);
                         }
                     }
                     if (visibleBookings.isEmpty()) { %>
                  <p class="text-muted">You have no active bookings.</p>
                <% } else { 
                     java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("yyyy-MM-dd HH:mm");
                %>
                  <div class="table-responsive">
                    <table class="table table-booking table-hover align-middle">
                      <thead>
                        <tr>
                          <th>ID</th>
                          <th>Booking Date/Time</th>
                          <th>Pickup</th>
                          <th>Destination</th>
                          <th>Status</th>
                          <th>Action</th>
                        </tr>
                      </thead>
                      <tbody>
                        <% for (com.megacitycab.model.Booking b : visibleBookings) { %>
                          <tr>
                            <td><%= b.getBookingId() %></td>
                            <td><%= sdf.format(b.getBookingDate()) %></td>
                            <td><%= b.getPickupLocation() %></td>
                            <td><%= b.getDestination() %></td>
                            <td>
                              <span class="badge <%= "Completed".equalsIgnoreCase(b.getStatus()) ? "bg-success" : "bg-warning text-dark" %>">
                                <%= b.getStatus() %>
                              </span>
                            </td>
                            <td>
                              <% if (!"Completed".equalsIgnoreCase(b.getStatus())) { %>
                                <a href="<%= request.getContextPath() %>/BookingServlet?action=cancel&bookingId=<%= b.getBookingId() %>" onclick="return confirm('Are you sure you want to cancel this booking?');" class="btn btn-outline-danger btn-sm">
                                  <i class="fas fa-times"></i> Cancel
                                </a>
                                <a href="<%= request.getContextPath() %>/PaymentServlet?bookingId=<%= b.getBookingId() %>" class="btn btn-warning btn-sm ms-2">
                                  <i class="fas fa-receipt"></i> View Bill
                                </a>
                              <% } else { %>
                                <span class="text-muted">No action</span>
                              <% } %>
                            </td>
                          </tr>
                        <% } %>
                      </tbody>
                    </table>
                  </div>
                <% } } %>
              </div>
            </div>
          </div>
        </div>
                
        <!-- BILL CARD SECTION as a Bootstrap Modal -->
        <% if (bill != null && billBooking != null) { %>
          <div class="modal fade" id="billModal" tabindex="-1" aria-labelledby="billModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-lg modal-dialog-centered">
              <div class="modal-content">
                <div class="modal-header">
                  <h5 class="modal-title" id="billModalLabel">
                    <i class="fas fa-file-invoice me-2"></i> Invoice
                  </h5>
                  <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <div class="modal-body p-4">
                  <div class="bill-card">
                    <div class="bill-company-info">
                      <h3><i class="fas fa-taxi text-warning me-2"></i> Mega City Cab</h3>
                      <p>123 Main Street, Colombo, Sri Lanka</p>
                      <p>Tel: (+94) 0-765-7825 | Email: info@megacitycab.com</p>
                    </div>
                    
                    <div class="row mb-4">
                      <div class="col-md-6">
                        <div class="mb-3">
                          <strong>INVOICE #<%= billBooking.getBookingId() %></strong>
                        </div>
                        <div class="text-muted">
                          Date: <%= new java.text.SimpleDateFormat("yyyy-MM-dd").format(new java.util.Date()) %>
                        </div>
                      </div>
                      <div class="col-md-6 text-end">
                        <div class="badge bg-warning text-dark p-2">
                          Status: <%= billBooking.getStatus() %>
                        </div>
                      </div>
                    </div>
                    
                    <!-- Customer Information -->
                    <div class="bill-section">
                      <h5 class="mb-3"><i class="fas fa-user me-2 text-warning"></i> Customer Information</h5>
                      <% if (customer != null) { %>
                        <div class="row">
                          <div class="col-md-6">
                            <div class="mb-2">
                              <span class="bill-label">Name:</span>
                              <span class="bill-value"><%= customer.getName() %></span>
                            </div>
                            <div class="mb-2">
                              <span class="bill-label">Contact:</span>
                              <span class="bill-value"><%= customer.getContact() %></span>
                            </div>
                          </div>
                          <div class="col-md-6">
                            <div class="mb-2">
                              <span class="bill-label">Email:</span>
                              <span class="bill-value"><%= customer.getEmail() %></span>
                            </div>
                          </div>
                        </div>
                      <% } else { %>
                        <p class="text-muted">No customer data found.</p>
                      <% } %>
                    </div>
                    
                    <!-- Trip Details -->
                    <div class="bill-section">
                      <h5 class="mb-3"><i class="fas fa-route me-2 text-warning"></i> Trip Details</h5>
                      <div class="row">
                        <div class="col-md-6">
                          <div class="mb-2">
                            <span class="bill-label">Pickup:</span>
                            <span class="bill-value"><%= billBooking.getPickupLocation() %></span>
                          </div>
                          <div class="mb-2">
                            <span class="bill-label">Destination:</span>
                            <span class="bill-value"><%= billBooking.getDestination() %></span>
                          </div>
                        </div>
                        <div class="col-md-6">
                          <div class="mb-2">
                            <span class="bill-label">Distance:</span>
                            <span class="bill-value"><%= billBooking.getDistanceKm() %> km</span>
                          </div>
                          <div class="mb-2">
                            <span class="bill-label">Vehicle Type:</span>
                            <span class="bill-value">
                              <% 
                                String vehicleType = "Unknown";
                                switch(billBooking.getVehicleTypeId()) {
                                  case 1: vehicleType = "Mini Car"; break;
                                  case 2: vehicleType = "Normal Car"; break;
                                  case 3: vehicleType = "SUV"; break;
                                  case 4: vehicleType = "Large Car"; break;
                                  case 5: vehicleType = "Minivan"; break;
                                  case 6: vehicleType = "Large Van"; break;
                                  case 7: vehicleType = "Minibus"; break;
                                }
                              %>
                              <%= vehicleType %>
                            </span>
                          </div>
                        </div>
                      </div>
                    </div>
                    
                    <!-- Driver Information -->
                    <div class="bill-section">
                      <h5 class="mb-3"><i class="fas fa-id-card me-2 text-warning"></i> Driver Information</h5>
                      <% if (driver != null) { %>
                        <div class="row">
                          <div class="col-md-6">
                            <div class="mb-2">
                              <span class="bill-label">Driver Name:</span>
                              <span class="bill-value"><%= driver.getFName() %></span>
                            </div>
                          </div>
                          <div class="col-md-6">
                            <div class="mb-2">
                              <span class="bill-label">Contact:</span>
                              <span class="bill-value"><%= driver.getContact() %></span>
                            </div>
                          </div>
                        </div>
                      <% } else { %>
                        <p class="text-muted">No driver assigned yet.</p>
                      <% } %>
                    </div>
                    
                    <!-- Billing Information -->
                    <div class="bill-section">
                      <h5 class="mb-3"><i class="fas fa-calculator me-2 text-warning"></i> Cost Breakdown</h5>
                      <div class="row">
                        <div class="col-12">
                          <div class="table-responsive">
                            <table class="table table-borderless">
                              <tbody>
                                <tr>
                                  <td>Base Amount</td>
                                  <td class="text-end"><%= bill.getBaseAmount() %> LKR</td>
                                </tr>
                                <tr>
                                  <td>Discount</td>
                                  <td class="text-end">- <%= bill.getDiscount() %> LKR</td>
                                </tr>
                                <tr>
                                  <td colspan="2"><hr></td>
                                </tr>
                                <tr class="bill-total">
                                  <td>Total Amount</td>
                                  <td class="text-end"><%= bill.getTotalAmount() %> LKR</td>
                                </tr>
                              </tbody>
                            </table>
                          </div>
                        </div>
                      </div>
                    </div>
                  </div>
                </div>
                <div class="modal-footer">
                  <form action="<%= request.getContextPath() %>/PaymentServlet" method="post" class="w-100">
                    <input type="hidden" name="action" value="pay">
                    <input type="hidden" name="bookingId" value="<%= billBooking.getBookingId() %>">
                    
                    <div class="mb-3">
                      <label for="paymentMethod" class="form-label">
                        <i class="fas fa-credit-card me-2 text-warning"></i> Choose Payment Method:
                      </label>
                      <select id="paymentMethod" name="paymentMethod" class="form-select" onchange="toggleBankDetails()">
                        <option value="On-hand">On-hand (Cash)</option>
                        <option value="Bank Transfer">Bank Transfer</option>
                      </select>
                    </div>
                    
                    <div id="bankDetails" class="bank-details">
                      <h6 class="mb-3 fw-bold"><i class="fas fa-university me-2"></i> Bank Transfer Details</h6>
                      <div class="row">
                        <div class="col-md-6">
                          <p><strong>Bank:</strong> People's Bank</p>
                          <p><strong>Account Name:</strong> Mega Cab City PVT</p>
                        </div>
                        <div class="col-md-6">
                          <p><strong>Account Number:</strong> 1234567890</p>
                          <p><strong>Branch:</strong> Colombo Main</p>
                        </div>
                      </div>
                    </div>
                    
                    <div class="d-flex justify-content-between mt-3">
                      <button type="submit" class="btn btn-primary">
                        <i class="fas fa-money-bill-wave me-2"></i> Pay Now
                      </button>
                      
                      <% if ("Payment successful!".equals(message)) { %>
                        <button onclick="window.print()" class="btn btn-outline-dark">
                          <i class="fas fa-print me-2"></i> Print Receipt
                        </button>
                      <% } %>
                      
                      <button type="button" class="btn btn-outline-secondary" data-bs-dismiss="modal">
                        <i class="fas fa-times me-2"></i> Close
                      </button>
                    </div>
                  </form>
                </div>
              </div>
            </div>
          </div>
          <script>
            document.addEventListener("DOMContentLoaded", function() {
              var billModal = new bootstrap.Modal(document.getElementById('billModal'));
              billModal.show();
            });
          </script>
        <% } %>
      </div>
    </section>
  </div><!-- End Container -->

  <!-- Leaflet JS -->
  <script src="<%= request.getContextPath() %>/leaflet/leaflet.js"></script>
  <script>
//City coordinates data with many Sri Lankan cities
  const cities = {
    "Colombo": {lat: 6.9271, lon: 79.8612},
    "Sri Jayawardenepura Kotte": {lat: 6.8941, lon: 79.9020},
    "Kandy": {lat: 7.2906, lon: 80.6337},
    "Galle": {lat: 6.0320, lon: 80.2160},
    "Jaffna": {lat: 9.6615, lon: 80.0255},
    "Matara": {lat: 5.9496, lon: 80.5357},
    "Negombo": {lat: 7.2082, lon: 79.8379},
    "Anuradhapura": {lat: 8.3114, lon: 80.4037},
    "Trincomalee": {lat: 8.5870, lon: 81.2152},
    "Kurunegala": {lat: 7.4860, lon: 80.3600},
    "Ratnapura": {lat: 6.6860, lon: 80.3828},
    "Matale": {lat: 7.4700, lon: 80.6500},
    "Badulla": {lat: 6.9897, lon: 81.0557},
    "Nuwara Eliya": {lat: 6.9667, lon: 80.7833},
    "Hambantota": {lat: 6.1231, lon: 81.1122},
    "Vavuniya": {lat: 8.7539, lon: 80.4740},
    "Mannar": {lat: 8.9974, lon: 79.8978},
    "Kilinochchi": {lat: 9.4000, lon: 80.3833},
    "Batticaloa": {lat: 7.7100, lon: 81.6938},
    "Polonnaruwa": {lat: 7.9361, lon: 81.0050},
    "Ampara": {lat: 7.2888, lon: 81.6836},
    "Dehiwala": {lat: 6.8347, lon: 79.8857},
    "Moratuwa": {lat: 6.7706, lon: 79.9097}
  };

  // Populate origin and destination dropdowns
  function populateDropdowns() {
    const originSelect = document.getElementById("origin");
    const destinationSelect = document.getElementById("destination");
    
    // Clear existing options first
    originSelect.innerHTML = '<option value="">-- Select Origin --</option>';
    destinationSelect.innerHTML = '<option value="">-- Select Destination --</option>';
    
    // Add city options
    for (const city in cities) {
      let origOpt = document.createElement("option");
      origOpt.value = city;
      origOpt.textContent = city;
      originSelect.appendChild(origOpt);
      
      let destOpt = document.createElement("option");
      destOpt.value = city;
      destOpt.textContent = city;
      destinationSelect.appendChild(destOpt);
    }
  }

  let map, routeLayer;
  let calculatedDistance = 0;

  function initMap() {
    // Initialize the map centered on Sri Lanka
    map = L.map('map').setView([7.8731, 80.7718], 8);
    
    // Add the OpenStreetMap tiles
    L.tileLayer('https://{s}.tile.openstreetmap.org/{z}/{x}/{y}.png', {
      attribution: '&copy; <a href="https://www.openstreetmap.org/copyright">OpenStreetMap</a> contributors'
    }).addTo(map);
    
    // Initialize the route layer
    routeLayer = L.layerGroup().addTo(map);
  }

  // Calculate road distance and route between two cities using OSRM API
  async function calculateRoute() {
    const originCity = document.getElementById("origin").value;
    const destinationCity = document.getElementById("destination").value;
    const output = document.getElementById("output");
    
    if (!originCity || !destinationCity) {
      output.innerHTML = '<p class="mb-0 text-danger">Please select both origin and destination.</p>';
      return;
    }
    
    if (originCity === destinationCity) {
      output.innerHTML = '<p class="mb-0 text-danger">Origin and destination cannot be the same.</p>';
      return;
    }
    
    const origin = cities[originCity];
    const destination = cities[destinationCity];
    
    // Clear previous route
    routeLayer.clearLayers();
    
    // Add markers for origin and destination
    L.marker([origin.lat, origin.lon])
      .bindPopup(originCity)
      .addTo(routeLayer);
    
    L.marker([destination.lat, destination.lon])
      .bindPopup(destinationCity)
      .addTo(routeLayer);
    
    try {
      // Use OSRM API to get actual road distance
      const url = `https://router.project-osrm.org/route/v1/driving/${origin.lon},${origin.lat};${destination.lon},${destination.lat}?overview=full&geometries=geojson`;
      
      const response = await fetch(url);
      const data = await response.json();
      
      if (data.code === "Ok") {
        const route = data.routes[0];
        const distanceKm = (route.distance / 1000).toFixed(2);
        const durationMin = Math.round(route.duration / 60);
        
        // Draw the actual route polyline
        L.geoJSON(route.geometry, {
          style: {
            color: 'blue',
            weight: 3,
            opacity: 0.7
          }
        }).addTo(routeLayer);
        
        // Fit the map to show the route
        map.fitBounds(routeLayer.getBounds(), { padding: [50, 50] });
        
        // Set the distance value to be used for booking
        document.getElementById("distanceKm").value = distanceKm;
        
        // Update the output div with trip information (removed Estimated Fare as requested)
        output.innerHTML = `
          <div class="d-flex align-items-center mb-2">
            <div class="booking-icon"><i class="fas fa-route"></i></div>
            <div class="fw-bold">Trip Information</div>
          </div>
          <p class="mb-1"><i class="fas fa-road me-2 text-primary"></i> Distance: <strong>${distanceKm} km</strong></p>
          <p class="mb-1"><i class="fas fa-clock me-2 text-primary"></i> Estimated Time: <strong>${durationMin} min</strong></p>
        `;
      } else {
        // If OSRM API fails, fallback to a simpler calculation
        fallbackRouteCalculation(origin, destination, originCity, destinationCity);
      }
    } catch (error) {
      // API request failed, use fallback calculation
      console.error("Error fetching route data:", error);
      fallbackRouteCalculation(origin, destination, originCity, destinationCity);
    }
  }

  // Fallback calculation if the OSRM API fails
  function fallbackRouteCalculation(origin, destination, originCity, destinationCity) {
    // Draw a simple line between the points
    const routeLine = L.polyline([
      [origin.lat, origin.lon],
      [destination.lat, destination.lon]
    ], {
      color: 'blue',
      weight: 3,
      opacity: 0.7,
      dashArray: '5, 10'
    }).addTo(routeLayer);
    
    // Fit the map to show the route
    map.fitBounds(routeLine.getBounds(), { padding: [50, 50] });
    
    // Calculate approximate distance using Haversine formula
    const R = 6371; // Radius of Earth in km
    const dLat = (destination.lat - origin.lat) * Math.PI / 180;
    const dLon = (destination.lon - origin.lon) * Math.PI / 180;
    const a = 
      Math.sin(dLat/2) * Math.sin(dLat/2) +
      Math.cos(origin.lat * Math.PI / 180) * Math.cos(destination.lat * Math.PI / 180) * 
      Math.sin(dLon/2) * Math.sin(dLon/2);
    const c = 2 * Math.atan2(Math.sqrt(a), Math.sqrt(1-a));
    const distanceKm = R * c;
    
    // Add 30% to account for road routes vs straight line
    const roadDistanceKm = (distanceKm * 1.3).toFixed(2);
    
    // Calculate estimated travel time (rough approximation)
    const avgSpeedKmph = 60; // Average speed in km/h
    const durationHours = roadDistanceKm / avgSpeedKmph;
    const durationMinutes = Math.round(durationHours * 60);
    
    // Set the distance value to be used for booking
    document.getElementById("distanceKm").value = roadDistanceKm;
    
    // Update the output div with trip information (removed Estimated Fare as requested)
    const output = document.getElementById("output");
    output.innerHTML = `
      <div class="d-flex align-items-center mb-2">
        <div class="booking-icon"><i class="fas fa-route"></i></div>
        <div class="fw-bold">Trip Information</div>
      </div>
      <p class="mb-1"><i class="fas fa-road me-2 text-primary"></i> Distance: <strong>${roadDistanceKm} km</strong></p>
      <p class="mb-1"><i class="fas fa-clock me-2 text-primary"></i> Estimated Time: <strong>${durationMinutes} min</strong></p>
    `;
  }

  // Function to toggle bank details visibility
  function toggleBankDetails() {
    const paymentMethod = document.getElementById('paymentMethod').value;
    const bankDetails = document.getElementById('bankDetails');
    
    if (paymentMethod === 'Bank Transfer') {
      bankDetails.style.display = 'block';
    } else {
      bankDetails.style.display = 'none';
    }
  }

  // Set min date for booking to be current date and time
  document.addEventListener("DOMContentLoaded", function() {
    populateDropdowns();
    initMap();
    
    // Initialize event listeners
    document.getElementById("origin").addEventListener("change", calculateRoute);
    document.getElementById("destination").addEventListener("change", calculateRoute);
    document.getElementById("vehicleTypeId").addEventListener("change", calculateRoute);
    
    // Set minimum date for booking datetime
    const now = new Date();
    const year = now.getFullYear();
    const month = (now.getMonth() + 1).toString().padStart(2, '0');
    const day = now.getDate().toString().padStart(2, '0');
    const hours = now.getHours().toString().padStart(2, '0');
    const minutes = now.getMinutes().toString().padStart(2, '0');
    
    const minDateTime = `${year}-${month}-${day}T${hours}:${minutes}`;
    document.getElementById("bookingDateTime").min = minDateTime;
 	 });
</script>

<!-- Bootstrap JS Bundle with Popper -->
<script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>