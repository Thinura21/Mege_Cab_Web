<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session check: Only allow Admin
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    if (role == null || !role.equalsIgnoreCase("Admin")) {
        // Not an admin, redirect to login or error
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
        return;
    }
    
    // Check if we're editing an existing user
    com.megacitycab.model.Users user = (com.megacitycab.model.Users) request.getAttribute("user");
    boolean isEdit = (user != null);

    // Retrieve the list of users from the servlet
    java.util.List<com.megacitycab.model.Users> userList =
        (java.util.List<com.megacitycab.model.Users>) request.getAttribute("userList");
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>MegaCityCab - User Management</title>
    
    <!-- Include Bootstrap and other CDN-based CSS/JS -->
    <%@ include file="/Assets/CDN_Links.jsp" %>
    
    <!-- Optional custom CSS (similar to your dashboard_styles) -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/dashboard_styles.css">
</head>
<body>
    <!-- Mobile Menu Toggle (if using a sidebar) -->
    <button class="btn btn-light d-md-none" id="menuToggle">
        <i class="bi bi-list fs-4"></i>
    </button>
    
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-auto sidebar" id="sidebar">
                <div class="sidebar-header">
                    <h4><i class="bi bi-shield-lock me-2"></i>Admin Panel</h4>
                </div>
                <nav class="nav flex-column">
                    <!-- Active link to Admin Dashboard -->
                    <a href="<%= request.getContextPath() %>/Views/adminDashboard.jsp" class="nav-link active">
                        <i class="bi bi-grid-1x2"></i> Dashboard
                    </a>
                    <!-- Example: Manage Users link -->
                    <a href="<%= request.getContextPath() %>/manageUser" class="nav-link">
                        <i class="bi bi-people"></i> Manage Users
                    </a>
                    <!-- Add any other admin-specific links here -->
                    
                    <div class="mt-auto">
                        <form action="<%= request.getContextPath() %>/logoutServlet" method="post">
                            <button type="submit" class="btn btn-danger w-100">
                                <i class="bi bi-box-arrow-right me-2"></i> Logout
                            </button>
                        </form>
                    </div>
                </nav>
            </div>
            
            <!-- Main Content -->
            <div class="col main-content">
                
                <!-- Page Header -->
                <div class="d-flex justify-content-between align-items-center mt-4 mb-3">
                    <h2 class="mb-0">
                        <i class="bi bi-person-badge me-2"></i>User Management
                    </h2>
                    <button class="btn btn-warning text-white" id="addUserBtn">
                        <i class="bi bi-person-plus me-1"></i>Add New User
                    </button>
                </div>
                
                <hr>
                
                <!-- User List Table -->
                <div class="mb-4 p-3 bg-white rounded shadow-sm">
                    <div class="d-flex justify-content-between align-items-center mb-3">
                        <h5 class="mb-0">User List</h5>
                        <input type="text" id="searchInput" class="form-control w-auto" placeholder="Search by Name, Role, or Username">
                    </div>
                    
                    <div class="table-responsive">
                        <table class="table table-hover align-middle" id="userTable">
                            <thead class="table-light">
                                <tr>
                                    <th>User ID</th>
                                    <th>Full Name</th>
                                    <th>Address</th>
                                    <th>Contact</th>
                                    <th>Username</th>
                                    <th>Role</th>
                                    <th>Actions</th>
                                </tr>
                            </thead>
                            <tbody>
                                <%
                                    if(userList != null && !userList.isEmpty()) {
                                        for(com.megacitycab.model.Users u : userList) {
                                %>
                                <tr>
                                    <td><%= u.getUser_id() %></td>
                                    <td><%= (u.getF_name() != null) ? u.getF_name() : "-" %></td>
                                    <td><%= (u.getAddress() != null) ? u.getAddress() : "-" %></td>
                                    <td><%= (u.getContact() != null) ? u.getContact() : "-" %></td>
                                    <td><%= (u.getUser_name() != null) ? u.getUser_name() : "-" %></td>
                                    <td><%= (u.getRole() != null) ? u.getRole() : "-" %></td>
                                    <td>
                                        <a href="<%= request.getContextPath() %>/manageUser?action=edit&id=<%= u.getUser_id() %>"
                                           class="btn btn-sm btn-primary">
                                           <i class="bi bi-pencil-square"></i>
                                        </a>
                                        <a href="<%= request.getContextPath() %>/manageUser?action=delete&id=<%= u.getUser_id() %>"
                                           onclick="return confirm('Are you sure you want to delete this user?');"
                                           class="btn btn-sm btn-danger">
                                           <i class="bi bi-trash"></i>
                                        </a>
                                    </td>
                                </tr>
                                <%
                                        }
                                    } else {
                                %>
                                <tr>
                                    <td colspan="7" class="text-center">
                                        No users found. Click "Add New User" to create one.
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
    
    <!-- Modal for Add/Edit User -->
    <div class="modal fade" id="userModal" tabindex="-1" aria-labelledby="userModalLabel" aria-hidden="true">
        <div class="modal-dialog modal-lg">
            <div class="modal-content">
                
                <!-- Modal Header -->
                <div class="modal-header bg-primary text-white">
                    <h5 class="modal-title" id="userModalLabel">
                        <i class="bi bi-person-plus me-2"></i><%= isEdit ? "Edit User" : "Add New User" %>
                    </h5>
                    <button type="button" class="btn-close btn-close-white" data-bs-dismiss="modal"
                            aria-label="Close"></button>
                </div>
                
                <!-- Modal Body (Form) -->
                <form id="userForm" action="<%= request.getContextPath() %>/manageUser" method="post">
                    <div class="modal-body">
                        <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>">
                        <% if(isEdit){ %>
                            <input type="hidden" name="userId" value="<%= user.getUser_id() %>">
                        <% } %>
                        
                        <div class="row g-3">
                            <!-- Full Name -->
                            <div class="col-12 col-md-6">
                                <label for="fName" class="form-label">Full Name</label>
                                <input type="text" id="fName" name="fName" class="form-control" required
                                       value="<%= isEdit ? user.getF_name() : "" %>">
                            </div>
                            
                            <!-- Address -->
                            <div class="col-12 col-md-6">
                                <label for="address" class="form-label">Address</label>
                                <input type="text" id="address" name="address" class="form-control"
                                       value="<%= isEdit ? user.getAddress() : "" %>">
                            </div>
                            
                            <!-- Contact -->
                            <div class="col-12 col-md-6">
                                <label for="contact" class="form-label">Contact</label>
                                <input type="text" id="contact" name="contact" class="form-control"
                                       value="<%= isEdit ? user.getContact() : "" %>">
                            </div>
                            
                            <!-- Username -->
                            <div class="col-12 col-md-6">
                                <label for="userName" class="form-label">Username</label>
                                <input type="text" id="userName" name="userName" class="form-control" required
                                       value="<%= isEdit ? user.getUser_name() : "" %>">
                            </div>
                            
                            <!-- Password -->
                            <div class="col-12 col-md-6">
                                <label for="password" class="form-label">Password</label>
                                <input type="password" id="password" name="password" class="form-control" required
                                       value="<%= isEdit ? user.getPassword() : "" %>">
                            </div>
                            
                            <!-- Role -->
                            <div class="col-12 col-md-6">
                                <label for="role" class="form-label">Role</label>
                                <select id="role" name="role" class="form-select" required>
                                    <option value="">-- Select Role --</option>
                                    <option value="Admin" <%= isEdit && "Admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                                    <option value="Staff" <%= isEdit && "Staff".equals(user.getRole()) ? "selected" : "" %>>Staff</option>
                                    <option value="Driver" <%= isEdit && "Driver".equals(user.getRole()) ? "selected" : "" %>>Driver</option>
                                    <option value="Customer" <%= isEdit && "Customer".equals(user.getRole()) ? "selected" : "" %>>Customer</option>
                                </select>
                            </div>
                        </div> <!-- End .row -->
                    </div> <!-- End .modal-body -->
                    
                    <!-- Modal Footer -->
                    <div class="modal-footer">
                        <button type="button" class="btn btn-secondary" data-bs-dismiss="modal">
                            <i class="bi bi-x-circle me-2"></i>Cancel
                        </button>
                        <button type="submit" class="btn btn-primary">
                            <i class="bi bi-check-circle me-2"></i><%= isEdit ? "Update" : "Add" %>
                        </button>
                    </div>
                </form>
            </div>
        </div>
    </div>
    <!-- End .modal -->
    
    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // If using a sidebar
        const menuToggle = document.getElementById('menuToggle');
        const sidebar = document.getElementById('sidebar');
        if(menuToggle && sidebar) {
            menuToggle.addEventListener('click', function() {
                sidebar.classList.toggle('show');
            });
        }
        
        // Initialize the modal
        const userModal = new bootstrap.Modal(document.getElementById('userModal'));
        
        // "Add New User" button - open modal in 'add' mode
        const addUserBtn = document.getElementById('addUserBtn');
        addUserBtn.addEventListener('click', function() {
            // Reset the form
            document.getElementById('userForm').reset();
            
            // Make sure we set action to "add"
            document.querySelector('input[name="action"]').value = 'add';
            
            // Remove hidden userId if any
            const userIdField = document.querySelector('input[name="userId"]');
            if (userIdField) userIdField.remove();
            
            // Update modal title
            document.getElementById('userModalLabel').innerHTML =
                '<i class="bi bi-person-plus me-2"></i>Add New User';
            
            // Show the modal
            userModal.show();
        });
        
        // If we're editing, show the modal on page load
        <% if(isEdit) { %>
            document.addEventListener('DOMContentLoaded', function() {
                userModal.show();
            });
        <% } %>
        
        // Simple search filter for user table
        document.getElementById('searchInput').addEventListener('keyup', function() {
            const filter = this.value.toLowerCase();
            const rows = document.querySelectorAll('#userTable tbody tr');
            rows.forEach(row => {
                // We can filter by Full Name (cell index 1), Role (index 5), or Username (index 4)
                const fullNameText = row.cells[1].innerText.toLowerCase();
                const roleText = row.cells[5].innerText.toLowerCase();
                const usernameText = row.cells[4].innerText.toLowerCase();
                
                if (fullNameText.indexOf(filter) > -1 ||
                    roleText.indexOf(filter) > -1 ||
                    usernameText.indexOf(filter) > -1) {
                    row.style.display = '';
                } else {
                    row.style.display = 'none';
                }
            });
        });
    </script>
</body>
</html>
