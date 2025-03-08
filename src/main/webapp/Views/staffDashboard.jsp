<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Simple session check
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    if (role == null || !role.equals("Staff")) {
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard</title>
    <!-- Include CDN-based CSS and fonts -->
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
            <!-- Include the sidebar -->
            <%@ include file="sidebar.jsp" %>
            
            <!-- Main Content Area -->
            <div class="col main-content">
                <!-- Welcome Header -->
                <div class="welcome-header">
                    <h2><i class="bi bi-emoji-smile me-2"></i>Welcome, <%= username %>!</h2>
                    <p>You are logged in as <span class="badge badge-staff">Staff</span></p>
                </div>
                <!-- Quick Access Cards -->
                <div class="row g-4">
                    <div class="col-md-4 mb-4">
                        <div class="dashboard-card">
                            <div class="card-body text-center">
                                <div class="card-icon">
                                    <i class="bi bi-people"></i>
                                </div>
                                <h5 class="card-title">Customers</h5>
                                <p class="card-text">Manage customer information, profiles and preferences</p>
                                <a href="<%= request.getContextPath() %>/manageCustomer?action=list" class="btn btn-primary w-100">
                                    <i class="bi bi-people me-2"></i> View Customers
                                </a>
                            </div>
                        </div>
                    </div>
                    <!-- Other cards: Bookings, Reports, Drivers, Vehicles -->
                    <div class="col-md-4 mb-4">
                        <div class="dashboard-card">
                            <div class="card-body text-center">
                                <div class="card-icon">
                                    <i class="bi bi-calendar-check"></i>
                                </div>
                                <h5 class="card-title">Bookings</h5>
                                <p class="card-text">View and manage all bookings, schedules and assignments</p>
                                <a href="<%= request.getContextPath() %>/manageBooking" class="btn btn-primary w-100">
                                    <i class="bi bi-calendar-check me-2"></i> Manage Bookings
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="dashboard-card">
                            <div class="card-body text-center">
                                <div class="card-icon">
                                    <i class="bi bi-file-earmark-text"></i>
                                </div>
                                <h5 class="card-title">Reports</h5>
                                <p class="card-text">Generate and view comprehensive business reports</p>
                                <a href="<%= request.getContextPath() %>/Views/reports.jsp" class="btn btn-primary w-100">
                                    <i class="bi bi-file-earmark-text me-2"></i> View Reports
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="dashboard-card">
                            <div class="card-body text-center">
                                <div class="card-icon">
                                    <i class="bi bi-truck"></i>
                                </div>
                                <h5 class="card-title">Drivers</h5>
                                <p class="card-text">Manage driver profiles, schedules and assignments</p>
                                <a href="<%= request.getContextPath() %>/manageDriver" class="btn btn-primary w-100">
                                    <i class="bi bi-truck me-2"></i> Manage Drivers
                                </a>
                            </div>
                        </div>
                    </div>
                    <div class="col-md-4 mb-4">
                        <div class="dashboard-card">
                            <div class="card-body text-center">
                                <div class="card-icon">
                                    <i class="bi bi-car-front"></i>
                                </div>
                                <h5 class="card-title">Vehicles</h5>
                                <p class="card-text">Track and manage vehicle fleet, maintenance and status</p>
                                <a href="<%= request.getContextPath() %>/manageVehicle" class="btn btn-primary w-100">
                                    <i class="bi bi-car-front me-2"></i> Manage Vehicles
                                </a>
                            </div>
                        </div>
                    </div>
                </div>
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
        
        // Auto-hide sidebar when clicking on a link (mobile)
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
