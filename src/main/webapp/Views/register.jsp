<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Register</title>
    
    <!-- Include CDN-based CSS and fonts -->
    <%@ include file="/Assets/CDN_Links.jsp" %>
    
    <!-- Link to your shared styles -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/styles.css">
</head>
<body>
	
	<%@ include file="Navigation/navbar_noSessions.jsp" %>

    <div class="container mt-5">
        <div class="row register-container">
            <div class="col-md-6 d-none d-md-block">
                <div class="register-image"
                     style="background-image: url('<%= request.getContextPath() %>/Assets/Images/cab.png');">
                </div>
            </div>

            <div class="col-md-6 p-4">
                <h2 class="text-center mb-4">Create an Account</h2>

                <form action="<%= request.getContextPath() %>/registerServlet" method="post">
                    <div class="row">
                        <div class="col-12 col-md-6 mb-3">
                            <label for="f_name" class="form-label">Full Name</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person"></i></span>
                                <input type="text" class="form-control" id="f_name" name="f_name"
                                       required placeholder="Full Name">
                            </div>
                        </div>

                        <div class="col-12 col-md-6 mb-3">
                            <label for="Contact" class="form-label">Contact Number</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-telephone"></i></span>
                                <input type="tel" class="form-control" id="Contact" name="Contact"
                                       required placeholder="Contact">
                            </div>
                        </div>

                        <div class="col-12 mb-3">
                            <label for="Address" class="form-label">Address</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-geo-alt"></i></span>
                                <input type="text" class="form-control" id="Address" name="Address"
                                       required placeholder="Enter your address">
                            </div>
                        </div>

                        <div class="col-12 col-md-6 mb-3">
                            <label for="user_name" class="form-label">Username</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                                <input type="text" class="form-control" id="user_name" name="user_name"
                                       required placeholder="Username">
                            </div>
                        </div>

                        <div class="col-12 col-md-6 mb-3">
                            <label for="password" class="form-label">Password</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-lock"></i></span>
                                <input type="password" class="form-control" id="password" name="password"
                                       required placeholder="Password">
                            </div>
                        </div>

                        <div class="col-12 mb-3">
                            <label for="role" class="form-label">Role</label>
                            <div class="input-group">
                                <span class="input-group-text"><i class="bi bi-person-lines-fill"></i></span>
                                <select class="form-select" id="role" name="role" required>
                                    <option value="">-- Select Role --</option>
                                    <option value="Driver">Driver</option>
                                    <option value="Customer">Customer</option>
                                </select>
                            </div>
                        </div>

                        <div class="col-12">
                            <button type="submit" class="btn btn-primary w-100">
                                <i class="bi bi-person-add me-2"></i>Register
                            </button>
                        </div>
                    </div>
                </form>

                <%
                    String message = (String) request.getAttribute("message");
                    if (message != null) {
                %>
                    <div class="alert alert-info text-center mt-3" role="alert">
                        <%= message %>
                    </div>
                <% } %>

                <p class="text-center mt-3 mb-0">
                    Already have an account?
                    <a href="<%= request.getContextPath() %>/Views/login.jsp" class="text-primary">Login here</a>
                </p>
            </div>
        </div>
    </div>

    <!-- Include Bootstrap JS and Popper -->
    <%@ include file="/Assets/scripts.jsp" %>
</body>
</html>
