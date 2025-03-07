<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
// Get the current session or create a new one if it doesn't exist.
HttpSession httpsession = request.getSession();

// Retrieve user role and username from the session.
String role = (String) httpsession.getAttribute("role");
String username = (String) httpsession.getAttribute("username");

if (role == null || (!role.equalsIgnoreCase("Customer") && !role.equalsIgnoreCase("Driver"))) {
response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
return;
}
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Welcome Page</title>
    <!-- Bootstrap CSS -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css" rel="stylesheet">
    <!-- Custom CSS -->
    <style>
		body {
		    background-color: #f4f6f9;
		}
		
		.card {
		    border-radius: 10px;
		    max-width: 600px;
		    margin: 0 auto;
		}
		
		.card-header {
		    display: flex;
		    align-items: center;
		    justify-content: space-between;
		}
		
		.btn i {
		    margin-right: 5px;
		} 
    </style>
    
</head>
<body>
    <div class="container mt-5">
        <div class="card shadow-sm">
            <div class="card-header bg-primary text-white">
                <h2 class="mb-0">Welcome, <%= username %>!</h2>
            </div>
            <div class="card-body">
                <p class="card-text">Your role: <span class="badge bg-info"><%= role %></span></p>
                <p>This is the Home page for <%= role %>s.</p>

                <div class="mt-4">
                    <% if(role.equalsIgnoreCase("Customer")) { %>
                        <a href="<%= request.getContextPath() %>/BookingServlet" class="btn btn-primary me-2">
                            <i class="bi bi-calendar-check me-2"></i>Bookings
                        </a>
                    <% } else if(role.equalsIgnoreCase("Driver")) { %>
                        <a href="<%= request.getContextPath() %>/manageDriverBooking" class="btn btn-primary me-2">
                            <i class="bi bi-truck me-2"></i>Hires
                        </a>
                    <% } %>

                    <form action="<%= request.getContextPath() %>/logoutServlet" method="post" class="d-inline">
                        <button type="submit" class="btn btn-danger">
                            <i class="bi bi-box-arrow-right me-2"></i>Logout
                        </button>
                    </form>
                </div>
            </div>
        </div>
    </div>

    <!-- Bootstrap JS and Popper.js -->
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
    <!-- Bootstrap Icons -->
    <link href="https://cdn.jsdelivr.net/npm/bootstrap-icons@1.10.0/font/bootstrap-icons.css" rel="stylesheet">
</body>
</html>