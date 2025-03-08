<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session check: Only allow Staff or Admin
    String role = (String) session.getAttribute("role");
    if (role == null || (!role.equalsIgnoreCase("Staff") && !role.equalsIgnoreCase("Admin"))) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
        return;
    }
    
    // Determine if we are editing – if a "driver" attribute exists.
    com.megacitycab.model.Driver driver = (com.megacitycab.model.Driver) request.getAttribute("driver");
    boolean isEdit = (driver != null);
    
    // Retrieve vehicle details if available
    com.megacitycab.model.Vehicle vehicle = (com.megacitycab.model.Vehicle) request.getAttribute("vehicle");
    if (vehicle == null) {
        vehicle = new com.megacitycab.model.Vehicle();
    }
    
    // Retrieve driver's linked username and password from request attributes
    String userNameVal = isEdit && request.getAttribute("userName") != null ? (String) request.getAttribute("userName") : "";
    String passwordVal = isEdit && request.getAttribute("password") != null ? (String) request.getAttribute("password") : "";
    
    // Retrieve the list of drivers from the servlet
    java.util.List<com.megacitycab.model.Driver> driverList =
            (java.util.List<com.megacitycab.model.Driver>) request.getAttribute("driverList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Manage Drivers (Staff) - MegaCityCab</title>

    <!-- Include Bootstrap and other CDN-based CSS/JS -->
    <%@ include file="/Assets/CDN_Links.jsp" %>
    
    <!-- Link to merged dashboard styles -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/dashboard_styles.css">
    
</head>
<body>
    <!-- Mobile Menu Toggle (if you have a sidebar) -->
    <button class="btn btn-light d-md-none" id="menuToggle">
        <i class="bi bi-list fs-4"></i>
    </button>
    
    <div class="container-fluid">
        <div class="row">
            <!-- Include the sidebar if needed -->
            <%@ include file="sidebar.jsp" %>
            
            <!-- Main Content -->
            <div class="col main-content">
                
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mt-4 mb-3">
                    <h2 class="mb-0">
                        <i class="bi bi-truck me-2"></i>Driver Management
                    </h2>
                    <button class="btn btn-warning" id="addDriverBtn">
                        <i class="bi bi-person-plus me-1"></i>Add New Driver
                    </button>
                </div>
                
                <hr>
                
                <!-- Driver List Table -->
                <div class="mb-4 p-3 bg-white rounded shadow-sm">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">Driver List</h5>
                        <input type="text" id="searchInput" class="form-control w-auto" placeholder="Search...">
                    </div>
                    <div class="table-responsive mb-5">
                        <table class="table table-hover align-middle" id="driverTable">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Personal Details</th>
                                    <th>License Number</th>
                                    <th>Contact</th>
                                    <th>Email</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if (driverList != null && !driverList.isEmpty()) {
                                        for (com.megacitycab.model.Driver d : driverList) {
                                %>
                                <tr>
                                    <!-- ID -->
                                    <td><%= d.getDriverId() %></td>
                                    
                                    <!-- Personal Details: Profile Picture, Name, Address -->
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <!-- Photo -->
                                            <div>
                                                <%
                                                    if (d.getProfilePicture() != null) {
                                                %>
                                                    <img src="<%= request.getContextPath() %>/manageDriver?action=viewImage&id=<%= d.getDriverId() %>"
                                                         alt="Profile Picture" class="profile-img" />
                                                <%
                                                    } else {
                                                %>
                                                    <div class="no-image">
                                                        <i class="bi bi-person"></i>
                                                    </div>
                                                <%
                                                    }
                                                %>
                                            </div>
                                            <div class="ms-3">
                                                <div class="fw-bold"><%= d.getFName() %></div>
                                                <small class="text-muted">
                                                    <%= (d.getAddress() != null && !d.getAddress().trim().isEmpty()) 
                                                            ? d.getAddress() : "-" %>
                                                </small>
                                            </div>
                                        </div>
                                    </td>
                                    
                                    <!-- License Number -->
                                    <td><%= d.getLicenseNumber() %></td>
                                    
                                    <!-- Contact -->
                                    <td><%= (d.getContact() != null && !d.getContact().trim().isEmpty())
                                                ? d.getContact() : "-" %></td>
                                    
                                    <!-- Email -->
                                    <td><%= (d.getEmail() != null && !d.getEmail().trim().isEmpty()) 
                                                ? d.getEmail() : "-" %></td>
                                    
                                    <!-- Status -->
                                    <td><%= d.getStatus() %></td>
                                    
                                    <!-- Actions -->
                                    <td>
                                        <a href="<%= request.getContextPath() %>/manageDriver?action=edit&id=<%= d.getDriverId() %>"
                                           class="btn btn-sm btn-primary action-btn">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <a href="<%= request.getContextPath() %>/manageDriver?action=delete&id=<%= d.getDriverId() %>"
                                           onclick="return confirm('Are you sure you want to delete this driver?');"
                                           class="btn btn-sm btn-danger action-btn">
                                            <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <!-- If no drivers, adjust colspan to match the new column count (7) -->
                                    <td colspan="7" class="text-center">
                                        No drivers found. Click "Add New Driver" to create one.
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
            </div> <!-- End .main-content -->
        </div> <!-- End .row -->
    </div> <!-- End .container-fluid -->
    
    <!-- Modal for Add/Edit Driver -->
    <div class="modal fade" id="driverModal" tabindex="-1" aria-labelledby="driverModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <!-- Modal Header -->
                <div class="modal-header bg-warning">
                    <h5 class="modal-title" id="driverModalLabel" style="color: #fff;">
                        <i class="bi bi-person-plus me-2"></i>
                        <%= isEdit ? "Edit Driver" : "Add New Driver" %>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>
                
                <!-- Modal Body (Form) -->
                <form id="driverForm" action="<%= request.getContextPath() %>/manageDriver" 
                      method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
                        <% if (isEdit) { %>
                            <input type="hidden" name="driverId" value="<%= driver.getDriverId() %>">
                            <input type="hidden" name="userId" value="<%= driver.getUserId() %>">
                        <% } %>
                        
                        <div class="row g-3">
                            <!-- Username -->
                            <div class="col-12 col-md-6">
                                <label for="userName" class="form-label">Username</label>
                                <input type="text" id="userName" name="userName" class="form-control"
                                       required placeholder="Username" value="<%= userNameVal %>">
                            </div>
                            
                            <!-- Password -->
                            <div class="col-12 col-md-6">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" id="password" name="password" class="form-control"
                                       required placeholder="Password" value="<%= passwordVal %>">
                            </div>
                            
                            <!-- Name -->
                            <div class="col-12 col-md-6">
                                <label for="fName" class="form-label">Name</label>
                                <input type="text" id="fName" name="fName" class="form-control"
                                       required placeholder="Full Name"
                                       value="<%= isEdit ? driver.getFName() : "" %>">
                            </div>
                            
                            <!-- Address -->
                            <div class="col-12 col-md-6">
                                <label for="address" class="form-label">Address</label>
                                <input type="text" id="address" name="address" class="form-control"
                                       placeholder="Address"
                                       value="<%= isEdit ? driver.getAddress() : "" %>">
                            </div>
                            
                            <!-- Contact -->
                            <div class="col-12 col-md-6">
                                <label for="contact" class="form-label">Contact</label>
                                <input type="text" id="contact" name="contact" class="form-control"
                                       placeholder="Contact Number"
                                       value="<%= isEdit ? driver.getContact() : "" %>">
                            </div>
                            
                            <!-- Email -->
                            <div class="col-12 col-md-6">
                                <label for="email" class="form-label">Email</label>
                                <input type="email" id="email" name="email" class="form-control"
                                       placeholder="Email"
                                       value="<%= isEdit ? driver.getEmail() : "" %>">
                            </div>
                            
                            <!-- License Number -->
                            <div class="col-12 col-md-6">
                                <label for="licenseNumber" class="form-label">License Number</label>
                                <input type="text" id="licenseNumber" name="licenseNumber" class="form-control"
                                       required placeholder="License Number"
                                       value="<%= isEdit ? driver.getLicenseNumber() : "" %>">
                            </div>
                            
                            <!-- Driver Status -->
                            <div class="col-12 col-md-6">
                                <label for="status" class="form-label">Driver Status</label>
                                <select id="status" name="status" class="form-select">
                                    <option value="Pending" <%= isEdit && "Pending".equalsIgnoreCase(driver.getStatus()) ? "selected" : "" %>>Pending</option>
                                    <option value="Active" <%= isEdit && "Active".equalsIgnoreCase(driver.getStatus()) ? "selected" : "" %>>Active</option>
                                    <option value="Inactive" <%= isEdit && "Inactive".equalsIgnoreCase(driver.getStatus()) ? "selected" : "" %>>Inactive</option>
                                </select>
                            </div>
                            
                            <!-- Verified Checkbox -->
                            <div class="col-12">
                                <div class="form-check">
                                    <input type="checkbox" id="verified" name="verified" value="true"
                                           class="form-check-input" <%= isEdit && driver.isVerified() ? "checked" : "" %>>
                                    <label class="form-check-label" for="verified">
                                        Verified (Check if driver is verified)
                                    </label>
                                </div>
                            </div>
                            
                            <!-- Profile Picture -->
                            <div class="col-12 col-md-6">
                                <label for="driverProfilePicture" class="form-label">Profile Picture</label>
                                <input type="file" id="driverProfilePicture" name="driverProfilePicture"
                                       class="form-control">
                            </div>
                            
                            <!-- Licence Photo -->
                            <div class="col-12 col-md-6">
                                <label for="licencePhoto" class="form-label">Licence Photo</label>
                                <input type="file" id="licencePhoto" name="licencePhoto"
                                       class="form-control">
                            </div>
                            
                            <!-- Vehicle Details Heading -->
                            <div class="col-12 mt-4">
                                <h5>Vehicle Details</h5>
                            </div>
                            
                            <!-- Vehicle Model -->
                            <div class="col-12 col-md-6">
                                <label for="model" class="form-label">Model</label>
                                <input type="text" id="model" name="model" class="form-control"
                                       placeholder="Vehicle Model"
                                       value="<%= isEdit ? vehicle.getModel() : "" %>">
                            </div>
                            
                            <!-- License Plate -->
                            <div class="col-12 col-md-6">
                                <label for="licensePlate" class="form-label">License Plate</label>
                                <input type="text" id="licensePlate" name="licensePlate"
                                       class="form-control"
                                       placeholder="License Plate"
                                       value="<%= isEdit ? vehicle.getLicensePlate() : "" %>">
                            </div>
                            
                            <!-- Vehicle Type -->
                            <div class="col-12 col-md-6">
                                <label for="vehicleType" class="form-label">Vehicle Type</label>
                                <select id="vehicleType" name="vehicleType" class="form-select" required>
                                    <option value="Mini Car (2)" <%= isEdit && "Mini Car (2)".equals(vehicle.getType()) ? "selected" : "" %>>Mini Car (2)</option>
                                    <option value="Normal Car (3)" <%= isEdit && "Normal Car (3)".equals(vehicle.getType()) ? "selected" : "" %>>Normal Car (3)</option>
                                    <option value="SUV (3)" <%= isEdit && "SUV (3)".equals(vehicle.getType()) ? "selected" : "" %>>SUV (3)</option>
                                    <option value="Large Car (4)" <%= isEdit && "Large Car (4)".equals(vehicle.getType()) ? "selected" : "" %>>Large Car (4)</option>
                                    <option value="Minivan (6)" <%= isEdit && "Minivan (6)".equals(vehicle.getType()) ? "selected" : "" %>>Minivan (6)</option>
                                    <option value="Large Van (10)" <%= isEdit && "Large Van (10)".equals(vehicle.getType()) ? "selected" : "" %>>Large Van (10)</option>
                                    <option value="Minibus (15)" <%= isEdit && "Minibus (15)".equals(vehicle.getType()) ? "selected" : "" %>>Minibus (15)</option>
                                </select>
                            </div>
                            
                            <!-- Vehicle Color -->
                            <div class="col-12 col-md-6">
                                <label for="color" class="form-label">Color</label>
                                <input type="text" id="color" name="color" class="form-control"
                                       placeholder="Color"
                                       value="<%= isEdit ? vehicle.getColor() : "" %>">
                            </div>
                            
                            <!-- Vehicle Photo -->
                            <div class="col-12 col-md-6">
                                <label for="vehiclePhoto" class="form-label">Vehicle Photo</label>
                                <input type="file" id="vehiclePhoto" name="vehiclePhoto"
                                       class="form-control">
                            </div>
                            
                            <!-- License Plate Photo -->
                            <div class="col-12 col-md-6">
                                <label for="licensePlatePhoto" class="form-label">License Plate Photo</label>
                                <input type="file" id="licensePlatePhoto" name="licensePlatePhoto"
                                       class="form-control">
                            </div>
                            
                        </div> <!-- End .row -->
                    </div> <!-- End .modal-body -->
                    
                    <!-- Modal Footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="bi bi-x-circle me-1"></i>Cancel
                        </button>
                        <button type="submit" class="btn btn-warning text-white">
                            <i class="bi bi-check-circle me-1"></i>
                            <%= isEdit ? "Update Driver" : "Add Driver" %>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS Bundle (and any other scripts you need) -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Sidebar toggle if using a sidebar
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        if (menuToggle && sidebar) {
            menuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('show');
            });
        }
        
        // Initialize Bootstrap modal
        const driverModal = new bootstrap.Modal(document.getElementById('driverModal'));
        
        // "Add New Driver" button - open modal in 'add' mode
        document.getElementById('addDriverBtn').addEventListener('click', function() {
            // Reset the form
            document.getElementById('driverForm').reset();
            
            // Make sure we set action to "add"
            document.querySelector('input[name="action"]').value = 'add';
            
            // Remove hidden fields for driverId/userId if any
            const driverIdField = document.querySelector('input[name="driverId"]');
            const userIdField = document.querySelector('input[name="userId"]');
            if (driverIdField) driverIdField.remove();
            if (userIdField) userIdField.remove();
            
            // Update modal title
            document.getElementById('driverModalLabel').innerHTML =
                '<i class="bi bi-person-plus me-2"></i>Add New Driver';
            
            // Show the modal
            driverModal.show();
        });
        
        // If we're editing, show the modal immediately on page load
        <% if (isEdit) { %>
            document.addEventListener('DOMContentLoaded', function() {
                driverModal.show();
            });
        <% } %>
        
        // Search functionality
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const filter = this.value.toLowerCase();
            const rows = document.querySelectorAll('#driverTable tbody tr');
            
            rows.forEach(row => {
                // We want to match Name, License Number, or Address
                // "Personal Details" cell = index 1, "License Number" cell = index 2.
                const personalDetailsText = row.cells[1].innerText.toLowerCase();
                const licenseText = row.cells[2].innerText.toLowerCase();
                
                // If personal details or license text contains the filter, show the row
                if (personalDetailsText.indexOf(filter) > -1 || licenseText.indexOf(filter) > -1) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
