<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Simple session check
String role = (String) session.getAttribute("role");
String username = (String) session.getAttribute("username");
if (role == null || !role.equals("Staff")) {
// Not a staff, redirect to login or error
response.sendRedirect("login.jsp");
return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Staff Dashboard</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
    <style>
        body {
            background-color: #f4f6f9;
        }
        .sidebar {
            background-color: #4361ee;
            min-height: 100vh;
            position: fixed;
            top: 0;
            left: 0;
            z-index: 1000;
        }
        .sidebar a {
            color: white;
            transition: background-color 0.3s ease;
        }
        .sidebar a:hover {
            background-color: rgba(255,255,255,0.2);
        }
        .main-content {
            margin-left: 250px;
            padding: 20px;
        }
        @media (max-width: 768px) {
            .sidebar {
                width: 100%;
                height: auto;
                position: relative;
                min-height: auto;
            }
            .main-content {
                margin-left: 0;
            }
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar p-4">
                <h4 class="text-white mb-4">Staff Panel</h4>
                <div class="nav flex-column">
                    <a href="<%= request.getContextPath() %>/manageCustomer?action=list" class="nav-link py-2 px-3 mb-2 rounded">
                        <i class="bi bi-people me-2"></i>Customers
                    </a>
                    <a href="<%= request.getContextPath() %>/manageDriver" class="nav-link py-2 px-3 mb-2 rounded">
                        <i class="bi bi-truck me-2"></i>Drivers
                    </a>
                    <a href="<%= request.getContextPath() %>/manageVehicle" class="nav-link py-2 px-3 mb-2 rounded">
                        <i class="bi bi-car-front me-2"></i>Vehicles
                    </a>
                    <a href="<%= request.getContextPath() %>/manageBooking" class="nav-link py-2 px-3 mb-2 rounded">
                        <i class="bi bi-calendar-check me-2"></i>Bookings
                    </a>
                    <a href="<%= request.getContextPath() %>/Views/reports.jsp" class="nav-link py-2 px-3 mb-2 rounded">
                        <i class="bi bi-file-earmark-text me-2"></i>Reports
                    </a>
                </div>
            </div>

            <!-- Main Content Area -->
            <div class="main-content">
                <div class="card shadow-sm">
                    <div class="card-header bg-primary text-white">
                        <h2 class="mb-0">Welcome, <%= username %></h2>
                    </div>
                    <div class="card-body">
                        <p class="card-text">You are logged in as <span class="badge bg-info">Staff</span></p>
                        
                        <div class="row g-3 mt-3">
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title">Customers</h5>
                                        <p class="card-text">Manage customer information</p>
                                        <a href="<%= request.getContextPath() %>/manageCustomer?action=list" class="btn btn-primary">
                                            <i class="bi bi-people me-2"></i>View Customers
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title">Bookings</h5>
                                        <p class="card-text">View and manage bookings</p>
                                        <a href="<%= request.getContextPath() %>/manageBooking" class="btn btn-primary">
                                            <i class="bi bi-calendar-check me-2"></i>Manage Bookings
                                        </a>
                                    </div>
                                </div>
                            </div>
                            <div class="col-md-4">
                                <div class="card">
                                    <div class="card-body">
                                        <h5 class="card-title">Reports</h5>
                                        <p class="card-text">Generate and view reports</p>
                                        <a href="<%= request.getContextPath() %>/Views/reports.jsp" class="btn btn-primary">
                                            <i class="bi bi-file-earmark-text me-2"></i>View Reports
                                        </a>
                                    </div>
                                </div>
                            </div>
                        </div>

                        <div class="mt-4">
                            <form action="<%= request.getContextPath() %>/logoutServlet" method="post">
                                <button type="submit" class="btn btn-danger">
                                    <i class="bi bi-box-arrow-right me-2"></i>Logout
                                </button>
                            </form>
                        </div>
                    </div>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>