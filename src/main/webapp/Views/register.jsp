<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Register</title>
</head>
<body>
    <h2>Register</h2>
    
    <form action="<%= request.getContextPath() %>/registerServlet" method="post">
        <label for="f_name">Full Name:</label>
        <input type="text" id="f_name" name="f_name" required>
        <br><br>

        <label for="Address">Address:</label>
        <input type="text" id="Address" name="Address" required>
        <br><br>

        <label for="Contact">Contact:</label>
        <input type="text" id="Contact" name="Contact" required>
        <br><br>

        <label for="user_name">Username:</label>
        <input type="text" id="user_name" name="user_name" required>
        <br><br>

        <label for="password">Password:</label>
        <input type="password" id="password" name="password" required>
        <br><br>

        <label for="role">Role:</label>
        <select id="role" name="role" required>
            <option value="">-- Select Role --</option>
            <option value="Admin">Admin</option>
            <option value="Staff">Staff</option>
            <option value="Driver">Driver</option>
            <option value="Customer">Customer</option>
        </select>
        <br><br>

        <input type="submit" value="Register">
    </form>
    
    <p>
        <% 
            String message = (String) request.getAttribute("message");
            if (message != null) {
        %>
            <strong><%= message %></strong>
        <% } %>
    </p>
    
    <p>Already have an account?
        <a href="<%= request.getContextPath() %>/Views/login.jsp">Login here</a>.
    </p>
</body>
</html>
