<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Simple session check
    String role = (String) session.getAttribute("role");
    String username = (String) session.getAttribute("username");
    if (role == null || !role.equals("Admin")) {
        // Not an admin, redirect to login or error
        response.sendRedirect("login.jsp");
        return;
    }
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Admin Dashboard</title>
</head>
<body>
    <h2>Welcome, <%= username %> (Admin)</h2>
    <p>This is the Admin Dashboard page.</p>

    <ol>
    		<li><a href="<%= request.getContextPath() %>/manageUser"> Manage Users</a></li>
    </ol>
    
    <form action="<%= request.getContextPath() %>/logoutServlet" method="post">
        <input type="submit" value="Logout">
    </form>
</body>
</html>
