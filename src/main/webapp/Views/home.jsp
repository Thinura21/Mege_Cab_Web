<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    if (role == null || (!role.equalsIgnoreCase("Customer") && !role.equalsIgnoreCase("Driver"))) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Home Page</title>
    <style>
        .btn {
            display: inline-block;
            padding: 10px 20px;
            background-color: #4361ee;
            color: white;
            text-decoration: none;
            border-radius: 5px;
            margin: 5px 0;
        }
        .btn:hover {
            background-color: #3a56d4;
        }
    </style>
</head>
<body>
    <h2>Welcome, <%= username %>!</h2>
    <p>Your role: <%= role %></p>
    
    <p>This is the Home page for <%= role %>s.</p>
    <ul>
        <% if(role.equalsIgnoreCase("Customer")) { %>
            <li><a class="btn" href="<%= request.getContextPath() %>/BookingServlet">Bookings</a></li>
        <% } else if(role.equalsIgnoreCase("Driver")) { %>
            <li><a class="btn" href="<%= request.getContextPath() %>/manageDriverBooking">Hires</a></li>
        <% } %>
    </ul>
    
    <form action="<%= request.getContextPath() %>/logoutServlet" method="post">
        <input type="submit" value="Logout" class="btn">
    </form>
</body>
</html>
