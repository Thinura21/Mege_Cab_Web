<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Add Customer</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4">Add Customer</h2>
        <form action="<%= request.getContextPath() %>/customerServlet" method="post">
            <div class="mb-3">
                <label for="nic" class="form-label">NIC</label>
                <input type="text" class="form-control" name="nic" required>
            </div>
            <div class="mb-3">
                <label for="name" class="form-label">Name</label>
                <input type="text" class="form-control" name="name" required>
            </div>
            <div class="mb-3">
                <label for="address" class="form-label">Address</label>
                <input type="text" class="form-control" name="address" required>
            </div>
            <div class="mb-3">
                <label for="contact" class="form-label">Contact</label>
                <input type="text" class="form-control" name="contact" required>
            </div>
            <div class="mb-3">
                <label for="password" class="form-label">Password</label>
                <input type="password" class="form-control" name="password" required>
            </div>
            <div class="mb-3">
                <label for="userType" class="form-label">User Type</label>
                <select class="form-select" name="userType" required>
                    <option value="Admin">Admin</option>
                    <option value="Customer">Customer</option>
                    <option value="Driver">Driver</option>
                </select>
            </div>
            <button type="submit" class="btn btn-success">Add Customer</button>
            <a href="customers.jsp" class="btn btn-secondary">Back</a>
        </form>
    </div>
</body>
</html>
