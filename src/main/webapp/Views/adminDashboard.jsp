<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Simple session check
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    if (role == null || !role.equals("Admin")) {
        // Not an admin, redirect to login
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
    <!-- Include CDN-based CSS/JS and fonts -->
    <%@ include file="/Assets/CDN_Links.jsp" %>
    <!-- Link to your custom CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/dashboard_styles.css">
</head>
<body>
    <!-- Mobile Menu Toggle -->
    <button class="menu-toggle d-md-none" id="menuToggle">
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
            
            <!-- Main Content Area -->
            <div class="col main-content">
                <!-- Welcome Header -->
                <div class="welcome-header">
                    <h2>
                        <i class="bi bi-emoji-smile me-2"></i>Welcome, <%= username %>!
                    </h2>
                    <p>You are logged in as <span class="badge badge-admin">Admin</span></p>
                </div>                
                <!-- Quick Access Cards or main admin features -->
                <div class="row g-4">
                    <!-- Example card for Manage Users -->
                    <div class="col-md-4 mb-4">
                        <div class="dashboard-card">
                            <div class="card-body text-center">
                                <div class="card-icon">
                                    <i class="bi bi-people"></i>
                                </div>
                                <h5 class="card-title">Manage Users</h5>
                                <p class="card-text">Add, edit or remove users and their roles.</p>
                                <a href="<%= request.getContextPath() %>/manageUser" class="btn btn-primary w-100">
                                    <i class="bi bi-people me-2"></i> Go to Manage Users
                                </a>
                            </div>
                        </div>
                    </div>
                </div> <!-- End row g-4 -->
            </div> <!-- End main-content -->
        </div> <!-- End row -->
    </div> <!-- End container-fluid -->

    <!-- Bootstrap JS Bundle -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    
    <script>
        // Mobile menu toggle
        document.getElementById('menuToggle').addEventListener('click', function() {
            document.getElementById('sidebar').classList.toggle('show');
        });
        
        // Auto-hide sidebar when clicking a link (in mobile view)
        document.querySelectorAll('.sidebar .nav-link').forEach(link => {
            link.addEventListener('click', function() {
                if (window.innerWidth < 768) {
                    document.getElementById('sidebar').classList.remove('show');
                }
            });
        });
    </script>
</body>
</html>
