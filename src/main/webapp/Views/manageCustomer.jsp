<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // SESSION CHECK: Only Staff
    if (session == null || session.getAttribute("role") == null 
        || !"Staff".equals(session.getAttribute("role"))) {
        response.sendRedirect("login.jsp");
        return;
    }
    
    // Determine if we're in edit mode – if a "customer" attribute exists.
    com.megacitycab.model.Customer customer = 
        (com.megacitycab.model.Customer) request.getAttribute("customer");
    boolean isEdit = (customer != null);
    
    // Retrieve username/password from request attributes (set in the servlet)
    String userNameVal = (isEdit && request.getAttribute("userName") != null)
                           ? (String) request.getAttribute("userName")
                           : "";
    String passwordVal = (isEdit && request.getAttribute("password") != null)
                           ? (String) request.getAttribute("password")
                           : "";
    
    // Retrieve any error message passed from the servlet
    String errorMessage = (String) request.getAttribute("errorMessage");
    
    // Retrieve the customer list for the table
    java.util.List<com.megacitycab.model.Customer> list = 
        (java.util.List<com.megacitycab.model.Customer>) request.getAttribute("customerList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer Management - MegaCityCab</title>
    
    <!-- Include Bootstrap and other CDN-based CSS/JS -->
    <%@ include file="/Assets/CDN_Links.jsp" %>
    
    <!-- Link to merged dashboard styles -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/dashboard_styles.css">
</head>
<body>
    <!-- Mobile Menu Toggle -->
    <button class="menu-toggle d-md-none" id="menuToggle">
        <i class="bi bi-list fs-4"></i>
    </button>
    
    <div class="container-fluid">
        <div class="row">
            <!-- Include the sidebar -->
            <%@ include file="sidebar.jsp" %>
            
            <!-- Main Content -->
            <div class="col main-content">
                <!-- Page Header -->
                <div class="page-header d-flex justify-content-between align-items-center">
                    <h2><i class="bi bi-people me-2"></i>Customer Management</h2>
                    <button class="btn btn-warning" id="addCustomerBtn">
                        <i class="bi bi-person-plus me-2"></i>Add New Customer
                    </button>
                </div>
                
                <!-- Display Error Message if any -->
                <% if (errorMessage != null) { %>
                <div class="alert alert-danger" role="alert">
                    <%= errorMessage %>
                </div>
                <% } %>
                
                <hr>
                <div class = "mb-3"></div>
                
                
                <!-- Customer List Section -->
                <div class="mb-4 p-3 bg-white rounded shadow-sm">
                    <div class="d-flex align-items-center justify-content-between mb-3">
                        <h5 class="mb-0">Customer List</h5>
                        <form class="d-flex" id="filterForm">
                            <input class="form-control" 
                                   type="text" 
                                   id="searchInput" 
                                   placeholder="Search by Name, NIC, or Address">
                        </form>
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover align-middle" id="customerTable">
                            <thead class="table-light">
                                <tr>
                                    <th>ID</th>
                                    <th>Personal Details</th>
                                    <th>NIC</th>
                                    <th>Contact</th>
                                    <th>Email</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if(list != null && !list.isEmpty()){
                                        for(com.megacitycab.model.Customer c : list){
                                %>
                                <tr>
                                    <td><%= c.getCustomerId() %></td>
                                    <td>
                                        <div class="d-flex align-items-center">
                                            <!-- Photo -->
                                            <div>
                                                <% if(c.getProfilePicture() != null) { %>
                                                    <img src="<%= request.getContextPath() %>/manageCustomer?action=viewImage&id=<%= c.getCustomerId() %>"
                                                         alt="Profile Picture" class="profile-img" />
                                                <% } else { %>
                                                    <div class="no-image"><i class="bi bi-person"></i></div>
                                                <% } %>
                                            </div>
                                            <!-- Name & Address -->
                                            <div class="ms-3">
                                                <div class="fw-bold"><%= c.getName() %></div>
                                                <small class="text-muted">
                                                    <%= (c.getAddress() != null && !c.getAddress().trim().isEmpty()) 
                                                        ? c.getAddress() : "-" %>
                                                </small>
                                            </div>
                                        </div>
                                    </td>
                                    <td><%= c.getNic() %></td>
                                    <td><%= (c.getContact() != null && !c.getContact().trim().isEmpty()) 
                                              ? c.getContact() : "-" %></td>
                                    <td><%= (c.getEmail() != null && !c.getEmail().trim().isEmpty()) 
                                              ? c.getEmail() : "-" %></td>
                                    <td>
                                        <!-- Edit Button -->
                                        <a href="<%= request.getContextPath() %>/manageCustomer?action=edit&id=<%= c.getCustomerId() %>"
                                           class="btn btn-sm btn-primary action-btn">
                                            <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <!-- Delete Button -->
                                        <a href="<%= request.getContextPath() %>/manageCustomer?action=delete&id=<%= c.getCustomerId() %>"
                                           onclick="return confirm('Are you sure you want to delete this customer?');"
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
                                    <td colspan="6" class="text-center">
                                        No customers found. Click "Add New Customer" to create one.
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
    
    <!-- Bootstrap Modal for Add/Edit Customer -->
    <div class="modal fade" id="customerModal" tabindex="-1" aria-labelledby="customerModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                <!-- Modal Header -->
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="customerModalLabel">
                        <i class="bi bi-person-plus me-2"></i><%= isEdit ? "Edit Customer" : "Add New Customer" %>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal" 
                            aria-label="Close"></button>
                </div>
                
                <!-- Modal Body (Form) with Input Groups -->
                <form id="customerForm" action="<%= request.getContextPath() %>/manageCustomer" 
                      method="post" enctype="multipart/form-data">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>" />
                        <% if(isEdit){ %>
                            <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>" />
                            <input type="hidden" name="userId" value="<%= customer.getUserId() %>" />
                        <% } %>
                        
                        <div class="row g-3">
                            <!-- Username -->
                            <div class="col-12 col-md-6 mb-3">
                                <label for="userName" class="form-label">Username</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person"></i></span>
                                    <input type="text" id="userName" name="userName" class="form-control"
                                           required placeholder="Username" value="<%= userNameVal %>">
                                </div>
                            </div>
                            
                            <!-- Password -->
                            <div class="col-12 col-md-6 mb-3">
                                <label for="password" class="form-label">Password</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                    <input type="password" id="password" name="password" class="form-control"
                                           required placeholder="Password" value="<%= passwordVal %>">
                                </div>
                            </div>
                            
                            <!-- Full Name -->
                            <div class="col-12 col-md-6 mb-3">
                                <label for="name" class="form-label">Full Name</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                                    <input type="text" id="name" name="name" class="form-control"
                                           required placeholder="Full Name" value="<%= isEdit ? customer.getName() : "" %>">
                                </div>
                            </div>
                            
                            <!-- NIC -->
                            <div class="col-12 col-md-6 mb-3">
                                <label for="nic" class="form-label">National ID (NIC)</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-credit-card-2-front"></i></span>
                                    <input type="text" id="nic" name="nic" class="form-control"
                                           required placeholder="NIC" value="<%= isEdit ? customer.getNic() : "" %>">
                                </div>
                            </div>
                            
                            <!-- Residential Address -->
                            <div class="col-12 col-md-6 mb-3">
                                <label for="address" class="form-label">Residential Address</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                                    <input type="text" id="address" name="address" class="form-control"
                                           placeholder="Address" value="<%= isEdit ? customer.getAddress() : "" %>">
                                </div>
                            </div>
                            
                            <!-- Contact Number -->
                            <div class="col-12 col-md-6 mb-3">
                                <label for="contact" class="form-label">Contact Number</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                    <input type="tel" class="form-control" id="contact" name="contact"
                                           required placeholder="Contact Number" value="<%= isEdit ? customer.getContact() : "" %>">
                                </div>
                            </div>
                            
                            <!-- Email Address -->
                            <div class="col-12 col-md-6 mb-3">
                                <label for="email" class="form-label">Email Address</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-envelope"></i></span>
                                    <input type="email" id="email" name="email" class="form-control"
                                           placeholder="Email Address" value="<%= isEdit ? customer.getEmail() : "" %>">
                                </div>
                            </div>
                            
                            <!-- Profile Picture -->
                            <div class="col-12 col-md-6 mb-3">
                                <label for="profilePicture" class="form-label">Profile Picture</label>
                                <div class="input-group">
                                    <span class="input-group-text"><i class="bi bi-image"></i></span>
                                    <input type="file" id="profilePicture" name="profilePicture" class="form-control">
                                </div>
                                <% if(isEdit && customer.getProfilePicture() != null) { %>
                                    <div class="mt-2">
                                        <small class="text-muted">
                                            Current profile picture exists. Upload a new one to replace it.
                                        </small>
                                    </div>
                                <% } %>
                            </div>
                        </div> <!-- End .row -->
                    </div> <!-- End .modal-body -->
                    
                    <!-- Modal Footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="bi bi-x-circle me-2"></i>Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-circle me-2"></i><%= isEdit ? "Update Customer" : "Add Customer" %>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    
    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Mobile sidebar toggle
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        
        menuToggle.addEventListener('click', function() {
            sidebar.classList.toggle('show');
        });
        
        document.querySelectorAll('.sidebar .nav-link').forEach(link => {
            link.addEventListener('click', function() {
                if (window.innerWidth < 768) {
                    sidebar.classList.remove('show');
                }
            });
        });
        
        const customerModal = new bootstrap.Modal(document.getElementById('customerModal'));
        
        document.getElementById('addCustomerBtn').addEventListener('click', function() {
            document.getElementById('customerForm').reset();
            document.querySelector('input[name="action"]').value = 'add';
            const custIdField = document.querySelector('input[name="customerId"]');
            const userIdField = document.querySelector('input[name="userId"]');
            if (custIdField) custIdField.remove();
            if (userIdField) userIdField.remove();
            document.getElementById('customerModalLabel').innerHTML =
                '<i class="bi bi-person-plus me-2"></i>Add New Customer';
            customerModal.show();
        });
        
        <% if(isEdit) { %>
            document.addEventListener('DOMContentLoaded', function() {
                customerModal.show();
            });
        <% } %>
        
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const filter = this.value.toLowerCase();
            const rows = document.querySelectorAll("#customerTable tbody tr");
            rows.forEach(row => {
                const detailsText = row.cells[1].textContent.toLowerCase();
                const nicText = row.cells[2].textContent.toLowerCase();
                if (detailsText.indexOf(filter) > -1 || nicText.indexOf(filter) > -1) {
                    row.style.display = "";
                } else {
                    row.style.display = "none";
                }
            });
        });
    </script>
</body>
</html>
