<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session check: Only allow Staff or Admin
    String role = (String) session.getAttribute("role");
    if(role == null || (!role.equalsIgnoreCase("Staff") && !role.equalsIgnoreCase("Admin"))){
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
        return;
    }
    
    // Determine if we're editing – if a "vehicle" attribute exists.
    com.megacitycab.model.Vehicle vehicle = (com.megacitycab.model.Vehicle) request.getAttribute("vehicle");
    boolean isEdit = (vehicle != null);
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MegaCityCab - Vehicle Management</title>
    
    <!-- Include Bootstrap and other CDN-based CSS/JS -->
    <%@ include file="/Assets/CDN_Links.jsp" %>
    
    <!-- Link to merged dashboard styles -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/dashboard_styles.css">
    
    <!-- You can add additional custom styling here if needed -->
</head>
<body>
    <!-- Mobile Menu Toggle (if using a sidebar) -->
    <button class="btn btn-light d-md-none" id="menuToggle">
        <i class="bi bi-list fs-4"></i>
    </button>
    
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar (if needed) -->
            <%@ include file="sidebar.jsp" %>
            
            <!-- Main Content -->
            <div class="col main-content">
                
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mt-4 mb-3">
                    <h2 class="mb-0">
                        <i class="bi bi-truck me-2"></i>Vehicle Management
                    </h2>
                    <!-- "Add New Vehicle" button triggers the Bootstrap modal -->
                    <button class="btn btn-warning" id="addVehicleBtn">
                        <i class="fas fa-car-side me-1"></i>Add New Vehicle
                    </button>
                </div>
                
                <hr>
                
                <!-- Card Container for Vehicle List & Search -->
                <div class="mb-4 p-3 bg-white rounded shadow-sm">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">Vehicle List</h5>
                        <input type="text" id="searchInput" class="form-control w-auto" placeholder="Search...">
                    </div>
                    <div class="table-responsive mb-5">
                        <table class="table table-hover align-middle" id="vehicleTable">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Driver ID</th>
                                    <th>Photo</th>
                                    <th>Model</th>
                                    <th>License Plate</th>
                                    <th>Type</th>
                                    <th>Color</th>
                                    <th>Status</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    java.util.List<com.megacitycab.model.Vehicle> list = 
                                        (java.util.List<com.megacitycab.model.Vehicle>) request.getAttribute("vehicleList");
                                    if(list != null && !list.isEmpty()){
                                        for(com.megacitycab.model.Vehicle v : list){
                                %>
                                <tr>
                                    <td><%= v.getVehicleId() %></td>
                                    <td><%= v.getDriverId() %></td>
                                    <td>
                                        <% if(v.getVehiclePhoto() != null) { %>
                                            <img src="<%= request.getContextPath() %>/manageVehicle?action=viewImage&id=<%= v.getVehicleId() %>" 
                                                 alt="Vehicle Photo" class="profile-img" />
                                        <% } else { %>
                                            <div class="no-image"><i class="fas fa-car"></i></div>
                                        <% } %>
                                    </td>
                                    <td><%= v.getModel() %></td>
                                    <td><%= v.getLicensePlate() %></td>
                                    <td><%= v.getType() != null ? v.getType() : "-" %></td>
                                    <td><%= v.getColor() != null ? v.getColor() : "-" %></td>
                                    <td><%= v.getStatus() != null ? v.getStatus() : "Active" %></td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/manageVehicle?action=edit&id=<%= v.getVehicleId() %>" class="btn btn-sm btn-primary">
                                            <i class="fas fa-edit"></i>
                                        </a>
                                        <a href="<%= request.getContextPath() %>/manageVehicle?action=delete&id=<%= v.getVehicleId() %>" 
                                           class="btn btn-sm btn-danger" 
                                           onclick="return confirm('Are you sure you want to delete this vehicle?');">
                                            <i class="fas fa-trash-alt"></i>
                                        </a>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="9" class="text-center">
                                        No vehicles found. Click "Add New Vehicle" to create one.
                                    </td>
                                </tr>
                                <%
                                    }
                                %>
                            </tbody>
                        </table>
                    </div>
                </div>
                
            </div> <!-- End main-content -->
        </div> <!-- End row -->
    </div> <!-- End container-fluid -->
    
    <!-- Bootstrap Modal for Add/Edit Vehicle -->
    <div class="modal fade" id="vehicleModal" tabindex="-1" aria-labelledby="vehicleModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <!-- Modal Header -->
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="vehicleModalLabel">
                        <i class="fas fa-car-side me-2"></i><%= isEdit ? "Edit Vehicle" : "Add New Vehicle" %>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" 
                            aria-label="Close"></button>
                </div>
                
                <!-- Modal Body (Form) -->
                <form id="vehicleForm" action="<%= request.getContextPath() %>/manageVehicle" method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
                        <% if(isEdit){ %>
                            <input type="hidden" name="vehicleId" value="<%= vehicle.getVehicleId() %>">
                            <input type="hidden" name="driverId" value="<%= vehicle.getDriverId() %>">
                        <% } else { %>
                            <!-- For add mode, let staff enter the Driver ID -->
                            <div class="mb-3">
                                <label for="driverId" class="form-label">Driver ID</label>
                                <input type="number" id="driverId" name="driverId" class="form-control" required>
                            </div>
                        <% } %>
                        
                        <div class="row g-3">
                            <!-- Model -->
                            <div class="col-12 col-md-6">
                                <label for="model" class="form-label">Model</label>
                                <input type="text" id="model" name="model" class="form-control" required
                                       value="<%= isEdit && vehicle.getModel() != null ? vehicle.getModel() : "" %>">
                            </div>
                            
                            <!-- License Plate -->
                            <div class="col-12 col-md-6">
                                <label for="licensePlate" class="form-label">License Plate</label>
                                <input type="text" id="licensePlate" name="licensePlate" class="form-control" required
                                       value="<%= isEdit && vehicle.getLicensePlate() != null ? vehicle.getLicensePlate() : "" %>">
                            </div>
                            
                            <!-- Type -->
                             <div class="col-12 col-md-6">
						        <label for="vehicleType" class="form-label">Vehicle Type</label>
						        <select id="vehicleType" name="type" class="form-select" required>
						            <option value="Mini Car (2)" <%= isEdit && "Mini Car (2)".equals(vehicle.getType()) ? "selected" : "" %>>Mini Car (2)</option>
						            <option value="Normal Car (3)" <%= isEdit && "Normal Car (3)".equals(vehicle.getType()) ? "selected" : "" %>>Normal Car (3)</option>
						            <option value="SUV (3)" <%= isEdit && "SUV (3)".equals(vehicle.getType()) ? "selected" : "" %>>SUV (3)</option>
						            <option value="Large Car (4)" <%= isEdit && "Large Car (4)".equals(vehicle.getType()) ? "selected" : "" %>>Large Car (4)</option>
						            <option value="Minivan (6)" <%= isEdit && "Minivan (6)".equals(vehicle.getType()) ? "selected" : "" %>>Minivan (6)</option>
						            <option value="Large Van (10)" <%= isEdit && "Large Van (10)".equals(vehicle.getType()) ? "selected" : "" %>>Large Van (10)</option>
						            <option value="Minibus (15)" <%= isEdit && "Minibus (15)".equals(vehicle.getType()) ? "selected" : "" %>>Minibus (15)</option>
						        </select>
						    </div>
                            
                            <!-- Color -->
                            <div class="col-12 col-md-6">
                                <label for="color" class="form-label">Color</label>
                                <input type="text" id="color" name="color" class="form-control"
                                       value="<%= isEdit && vehicle.getColor() != null ? vehicle.getColor() : "" %>">
                            </div>
                            
                            <!-- Status -->
                             <div class="col-12 col-md-6">
						        <label for="status" class="form-label">Status</label>
						        <select id="status" name="status" class="form-select" required>
						            <option value="Active" <%= isEdit && "Active".equals(vehicle.getStatus()) ? "selected" : "" %>>Active</option>
						            <option value="Maintenance" <%= isEdit && "Maintenance".equals(vehicle.getStatus()) ? "selected" : "" %>>Maintenance</option>
						            <option value="Pending" <%= !isEdit || "Pending".equals(vehicle.getStatus()) ? "selected" : "" %>>Pending</option>
						        </select>
						    </div>
                            
                            <!-- Vehicle Photo -->
                            <div class="col-12 col-md-6">
                                <label for="vehiclePhoto" class="form-label">Vehicle Photo</label>
                                <input type="file" id="vehiclePhoto" name="vehiclePhoto" class="form-control">
                            </div>
                            
                            <!-- License Plate Photo -->
                            <div class="col-12 col-md-6">
                                <label for="licensePlatePhoto" class="form-label">License Plate Photo</label>
                                <input type="file" id="licensePlatePhoto" name="licensePlatePhoto" class="form-control">
                            </div>
                        </div> <!-- End row -->
                    </div> <!-- End modal-body -->
                    
                    <!-- Modal Footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="bi bi-x-circle me-1"></i>Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-circle me-1"></i><%= isEdit ? "Update" : "Add" %>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Sidebar toggle if using a sidebar
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        if(menuToggle && sidebar) {
            menuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('show');
            });
        }
        
        // Initialize Bootstrap modal for Vehicle
        const vehicleModal = new bootstrap.Modal(document.getElementById('vehicleModal'));
        
        // "Add New Vehicle" button - open modal in 'add' mode
        document.getElementById('addVehicleBtn').addEventListener('click', function() {
            // Reset the form
            document.getElementById('vehicleForm').reset();
            
            // Set action to "add"
            document.querySelector('input[name="action"]').value = 'add';
            
            // Remove hidden fields if any (vehicleId, driverId in edit mode)
            const vehicleIdField = document.querySelector('input[name="vehicleId"]');
            const driverIdField = document.querySelector('input[name="driverId"]');
            if(vehicleIdField) vehicleIdField.remove();
            if(driverIdField && driverIdField.type === 'hidden') driverIdField.remove();
            
            // Update modal title
            document.getElementById('vehicleModalLabel').innerHTML =
                '<i class="fas fa-car-side me-2"></i>Add New Vehicle';
            
            // Show the modal
            vehicleModal.show();
        });
        
        // If we're editing, show the modal immediately on page load
        <% if(isEdit) { %>
            document.addEventListener('DOMContentLoaded', function() {
                vehicleModal.show();
            });
        <% } %>
        
        // Search functionality: filter by Model (cell 3), License Plate (cell 4), or Color (cell 7)
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const filter = this.value.toLowerCase();
            const rows = document.querySelectorAll('#vehicleTable tbody tr');
            
            rows.forEach(row => {
                const modelText = row.cells[3].innerText.toLowerCase();
                const licenseText = row.cells[4].innerText.toLowerCase();
                const colorText = row.cells[6].innerText.toLowerCase();
                
                if(modelText.indexOf(filter) > -1 || licenseText.indexOf(filter) > -1 || colorText.indexOf(filter) > -1) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
