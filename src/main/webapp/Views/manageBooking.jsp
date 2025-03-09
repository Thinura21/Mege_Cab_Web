<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session check: Only allow Staff
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

    // Optional message from the servlet
    String message = (String) request.getAttribute("message");

    // Prepare formatted booking date for the form (24-hour format: "MM/dd/yyyy HH:mm")
    java.text.SimpleDateFormat sdf = new java.text.SimpleDateFormat("MM/dd/yyyy HH:mm");
    String bookingDateStr = "";
    if (isEdit && booking.getBookingDate() != null) {
        bookingDateStr = sdf.format(booking.getBookingDate());
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Bookings (Staff) - MegaCityCab</title>
    
    <%@ include file="/Assets/CDN_Links.jsp" %>
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/dashboard_styles.css">
</head>
<body>
    <!-- Mobile Menu Toggle -->
    <button class="btn btn-light d-md-none" id="menuToggle">
        <i class="bi bi-list fs-4"></i>
    </button>
    
    <div class="container-fluid">
        <div class="row">
            <%@ include file="sidebar.jsp" %>
            <!-- Main Content -->
            <div class="col main-content">
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mt-4 mb-3">
                    <h2 class="mb-0">
                        <i class="bi bi-list-check me-2"></i>Booking Management
                    </h2>
                    <!-- Button to trigger the Booking Modal -->
                    <button class="btn btn-warning text-white" id="addBookingBtn">
                        <i class="bi bi-plus-circle me-1"></i>Add New Booking
                    </button>
                </div>
                <hr>
                <!-- Optional message -->
                <% if (message != null) { %>
                    <div class="alert alert-success" role="alert">
                        <%= message %>
                    </div>
                <% } %>
                <!-- Booking List Table (Card) -->
                <div class="mb-4 p-3 bg-white rounded shadow-sm">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">Booking List</h5>
                        <input type="text" id="searchInput" class="form-control w-auto" placeholder="Search...">
                    </div>
                    <div class="table-responsive">
                        <table class="table table-hover align-middle" id="bookingTable">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Customer ID</th>
                                    <th>Driver ID</th>
                                    <th>Pickup</th>
                                    <th>Destination</th>
                                    <th>Distance (km)</th>
                                    <th>Booking Date</th>
                                    <th>Status</th>
                                    <th>Vehicle Type</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <% if (bookingList == null || bookingList.isEmpty()) { %>
                                <tr>
                                    <td colspan="10" class="text-center">No bookings found.</td>
                                </tr>
                                <% } else { 
                                       for (com.megacitycab.model.Booking b : bookingList) { %>
                                <tr>
                                    <td><%= b.getBookingId() %></td>
                                    <td><%= b.getCustomerId() %></td>
                                    <td><%= (b.getDriverId() == null) ? "-" : b.getDriverId() %></td>
                                    <td><%= b.getPickupLocation() %></td>
                                    <td><%= b.getDestination() %></td>
                                    <td><%= b.getDistanceKm() %></td>
                                    <td><%= (b.getBookingDate() != null) ? b.getBookingDate().toString() : "-" %></td>
                                    <td><%= b.getStatus() %></td>
                                    <td><%= b.getVehicleTypeId() %></td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/manageBooking?action=edit&id=<%= b.getBookingId() %>" class="btn btn-sm btn-primary">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <a href="<%= request.getContextPath() %>/manageBooking?action=delete&bookingId=<%= b.getBookingId() %>" class="btn btn-sm btn-danger" onclick="return confirm('Are you sure you want to delete this booking?');">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                        <% if (!"Completed".equalsIgnoreCase(b.getStatus())) { %>
                                        <a href="<%= request.getContextPath() %>/manageBooking?action=cancel&bookingId=<%= b.getBookingId() %>" class="btn btn-sm btn-warning text-white" onclick="return confirm('Are you sure you want to cancel this booking?');">
                                            <i class="bi bi-x-circle"></i>
                                        </a>
                                        <% } %>
                                    </td>
                                </tr>
                                <% } } %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div> <!-- End main-content -->
        </div> <!-- End row -->
    </div> <!-- End container-fluid -->
    
    <!-- Booking Modal -->
    <div class="modal fade" id="bookingModal" tabindex="-1" aria-labelledby="bookingModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <!-- Modal Header (Warning style) -->
                <div class="modal-header bg-warning text-white">
                    <h5 class="modal-title" id="bookingModalLabel">
                        <i class="bi bi-plus-circle me-1"></i>
                        <span id="modalTitleText"><%= isEdit ? "Edit Booking" : "Add New Booking" %></span>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" aria-label="Close"></button>
                </div>
                <!-- Modal Body (Form) -->
                <form id="bookingForm" action="<%= request.getContextPath() %>/manageBooking" method="post" class="row g-3 p-3">
                    <input type="hidden" name="action" id="bookingAction" value="<%= isEdit ? "update" : "add" %>">
                    <% if (isEdit) { %>
                        <input type="hidden" name="bookingId" value="<%= booking.getBookingId() %>">
                    <% } %>
                    <!-- Customer ID -->
                    <div class="col-12 col-md-6">
                        <label for="customerId" class="form-label">Customer ID</label>
                        <input type="number" id="customerId" name="customerId" class="form-control" value="<%= isEdit ? booking.getCustomerId() : "" %>" required>
                    </div>
                    <!-- Booking Date/Time -->
                    <div class="col-12 col-md-6">
                        <label for="bookingDate" class="form-label">Booking Date/Time</label>
                        <div class="input-group" id="bookingDatePicker">
                            <input type="text" id="bookingDate" name="bookingDate" class="form-control" placeholder="MM/dd/yyyy HH:mm" value="<%= bookingDateStr %>">
                            <span class="input-group-text"><i class="bi bi-calendar"></i></span>
                        </div>
                    </div>
                    <!-- Pickup Location -->
                    <div class="col-12 col-md-6">
                        <label for="pickupLocation" class="form-label">Pickup Location</label>
                        <select id="pickupLocation" name="pickupLocation" class="form-select" required>
                            <option value="">-- Select Pickup --</option>
                        </select>
                    </div>
                    <!-- Destination -->
                    <div class="col-12 col-md-6">
                        <label for="destination" class="form-label">Destination</label>
                        <select id="destination" name="destination" class="form-select" required>
                            <option value="">-- Select Destination --</option>
                        </select>
                    </div>
                    <!-- Distance (read-only) -->
                    <div class="col-12 col-md-6">
                        <label for="distanceKm" class="form-label">Distance (km)</label>
                        <input type="text" id="distanceKm" name="distanceKm" class="form-control" value="<%= isEdit ? booking.getDistanceKm() : "0" %>" readonly required>
                    </div>
                    <!-- Status -->
                    <div class="col-12 col-md-6">
                        <label for="status" class="form-label">Status</label>
                        <select id="status" name="status" class="form-select">
                            <option value="Pending" <%= isEdit && "Pending".equalsIgnoreCase(booking.getStatus()) ? "selected" : "" %>>Pending</option>
                            <option value="Ongoing" <%= isEdit && "Ongoing".equalsIgnoreCase(booking.getStatus()) ? "selected" : "" %>>Ongoing</option>
                            <option value="Completed" <%= isEdit && "Completed".equalsIgnoreCase(booking.getStatus()) ? "selected" : "" %>>Completed</option>
                            <option value="Canceled" <%= isEdit && "Canceled".equalsIgnoreCase(booking.getStatus()) ? "selected" : "" %>>Canceled</option>
                        </select>
                    </div>
                    <!-- Vehicle Type -->
                    <div class="col-12 col-md-6">
                        <label for="vehicleTypeId" class="form-label">Vehicle Type</label>
                        <select id="vehicleTypeId" name="vehicleTypeId" class="form-select">
                            <option value="1" <%= isEdit && booking.getVehicleTypeId() == 1 ? "selected" : "" %>>Mini Car (2) - 80.00</option>
							<option value="2" <%= isEdit && booking.getVehicleTypeId() == 2 ? "selected" : "" %>>Normal Car (3) - 95.00</option>
							<option value="3" <%= isEdit && booking.getVehicleTypeId() == 3 ? "selected" : "" %>>SUV (3) - 120.00</option>
							<option value="4" <%= isEdit && booking.getVehicleTypeId() == 4 ? "selected" : "" %>>Large Car (4) - 115.00</option>
							<option value="5" <%= isEdit && booking.getVehicleTypeId() == 5 ? "selected" : "" %>>Minivan (6) - 120.00</option>
							<option value="6" <%= isEdit && booking.getVehicleTypeId() == 6 ? "selected" : "" %>>Large Van (10) - 130.00</option>
							<option value="7" <%= isEdit && booking.getVehicleTypeId() == 7 ? "selected" : "" %>>Minibus (15) - 150.00</option>
                        </select>
                    </div>
                    <!-- Driver ID (optional) -->
                    <div class="col-12 col-md-6">
                        <label for="driverId" class="form-label">Driver ID (optional)</label>
                        <input type="number" id="driverId" name="driverId" class="form-control" value="<%= (isEdit && booking.getDriverId() != null) ? booking.getDriverId() : "" %>">
                    </div>
                    <!-- Modal Footer -->
                    <div class="col-12 d-flex justify-content-end mt-3">
                        <button type="button" class="btn btn-secondary me-2" data-bs-dismiss="modal">
                            <i class="bi bi-x-circle me-1"></i>Cancel
                        </button>
                        <button type="submit" class="btn btn-warning text-white">
                            <i class="bi bi-check-circle me-1"></i>
                            <span id="modalSubmitText"><%= isEdit ? "Update Booking" : "Add Booking" %></span>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- End Booking Modal -->
    
    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Tempus Dominus JS (Date/Time Picker) -->
    <script src="https://cdn.jsdelivr.net/npm/@eonasdan/tempus-dominus@latest/dist/js/tempus-dominus.min.js"></script>
    
    <script>
        // Sidebar toggle for mobile view
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        if (menuToggle && sidebar) {
            menuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('show');
            });
        }
        
        // Initialize Tempus Dominus date/time picker (24-hour format)
        document.addEventListener('DOMContentLoaded', function() {
            const bookingDatePickerElem = document.getElementById('bookingDatePicker');
            const bookingDatePicker = new tempusDominus.TempusDominus(bookingDatePickerElem, {
                display: {
                    components: {
                        calendar: true,
                        clock: true
                    }
                },
                localization: {
                    format: 'MM/dd/yyyy HH:mm'
                }
            });
        });
        
        // Cities dictionary for pickup and destination
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
        
        async function calculateDistance() {
            const pickup = document.getElementById("pickupLocation").value;
            const dest = document.getElementById("destination").value;
            const distanceField = document.getElementById("distanceKm");
            if (!pickup || !dest || pickup === dest) {
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
                    const distKm = route.distance / 1000;
                    distanceField.value = distKm.toFixed(2);
                } else {
                    distanceField.value = "0";
                }
            } catch (error) {
                distanceField.value = "0";
            }
        }
        
        document.addEventListener('DOMContentLoaded', () => {
            populateDropdowns();
            document.getElementById("pickupLocation").addEventListener("change", calculateDistance);
            document.getElementById("destination").addEventListener("change", calculateDistance);
            
            // If editing, pre-select the pickup and destination values (after trimming)
            <% if(isEdit) { %>
                const pickupVal = "<%= booking.getPickupLocation() != null ? booking.getPickupLocation().trim() : "" %>";
                const destVal = "<%= booking.getDestination() != null ? booking.getDestination().trim() : "" %>";
                if (pickupVal) document.getElementById("pickupLocation").value = pickupVal;
                if (destVal) document.getElementById("destination").value = destVal;
                
                // Also open the modal automatically for edit mode.
                const bookingModal = new bootstrap.Modal(document.getElementById('bookingModal'));
                bookingModal.show();
            <% } %>
        });
        
        // Simple search filter for booking table
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const filter = this.value.toLowerCase();
            const rows = document.querySelectorAll('#bookingTable tbody tr');
            rows.forEach(row => {
                const pickupText = row.cells[3].innerText.toLowerCase();
                const destinationText = row.cells[4].innerText.toLowerCase();
                row.style.display = (pickupText.indexOf(filter) > -1 || destinationText.indexOf(filter) > -1) ? '' : 'none';
            });
        });
        
        // "Add New Booking" button - open modal in 'add' mode
        const addBookingBtn = document.getElementById('addBookingBtn');
        addBookingBtn.addEventListener('click', function() {
            // Reset the form
            document.getElementById('bookingForm').reset();
            document.getElementById('bookingAction').value = 'add';
            document.getElementById('modalTitleText').innerHTML = 'Add New Booking';
            document.getElementById('modalSubmitText').innerHTML = 'Add Booking';
            const bookingIdField = document.querySelector('input[name="bookingId"]');
            if (bookingIdField) bookingIdField.remove();
            const bookingModal = new bootstrap.Modal(document.getElementById('bookingModal'));
            bookingModal.show();
        });
    </script>
</body>
</html>
