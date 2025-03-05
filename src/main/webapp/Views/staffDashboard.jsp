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
<html>
<head>
    <meta charset="UTF-8">
    <title>Staff Dashboard</title>
    <!-- Link to your main theme stylesheet -->
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/Theme/styles.css">
    <style>
        /* Minimal inline styling to create a sidebar layout */
        .sidebar {
            background-color: var(--secondary);
            min-height: 100vh; /* Full viewport height */
        }
        .sidebar h4 {
            color: var(--white);
        }
        .sidebar ul {
            list-style: none;
            padding: 0;
            margin: 0;
        }
        .sidebar li {
            margin-bottom: var(--spacing-sm);
        }
        .sidebar a {
            display: block;
            color: var(--white);
            text-decoration: none;
            padding: var(--spacing-sm) var(--spacing-md);
            border-radius: var(--border-radius-sm);
            transition: background-color 0.2s;
        }
        .sidebar a:hover {
            background-color: var(--secondary-light);
        }
        .main-content {
            padding: var(--spacing-md);
        }
    </style>
</head>
<body>
    <div class="container-fluid">
        <div class="row">
            <!-- Sidebar -->
            <div class="col-md-2 sidebar p-4">
                <h4>Staff Panel</h4>
                <ul>
                    <li>
                        <a href="<%= request.getContextPath() %>/manageCustomer?action=list">Customer</a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/manageDriver">Drivers</a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/manageVehicle">Vehicles</a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/manageBooking">Bookings</a>
                    </li>
                    <li>
                        <a href="<%= request.getContextPath() %>/Views/reports.jsp">Reports</a>
                    </li>
                </ul>
            </div>
            
            <!-- Main Content Area -->
            <div class="col-md-10 main-content">
                <div class="card p-4">
                    <h2>Welcome, <%= username %> (Staff)</h2>
                    <p>This is the Staff Dashboard page.</p>
                    
                    <!-- Additional dashboard info or cards could go here -->
                    
                    <form action="<%= request.getContextPath() %>/logoutServlet" method="post" class="mt-3">
                        <input type="submit" value="Logout" class="btn btn-danger">
                    </form>
                </div>
            </div>
        </div>
    </div>
</body>
</html>
