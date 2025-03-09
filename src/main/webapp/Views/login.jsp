<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    
    <!-- Include CDN-based CSS and fonts -->
    <%@ include file="/Assets/CDN_Links.jsp" %>
    <!-- Link to your custom CSS -->
    <link rel="stylesheet" href="<%= request.getContextPath() %>/Assets/styles.css">
</head>
<body>

 <%@ include file="Navigation/navbar_noSessions.jsp" %>
 
    <div class="container mt-5">
        <div class="row login-container">
            <div class="col-md-6 d-none d-md-block">
                <div class="login-image"
                     style="background-image: url('<%= request.getContextPath() %>/Assets/Images/cab.png');">
                </div>
            </div>

            <div class="col-md-6 p-5">
                <h2 class="text-center mb-4">Login to Your Account</h2>

                <%
                    String errorMessage = (String) request.getAttribute("errorMessage");
                    if (errorMessage != null) {
                %>
                    <div class="alert alert-danger alert-dismissible fade show" role="alert">
                        <i class="bi bi-exclamation-triangle-fill me-2"></i>
                        <%= errorMessage %>
                        <button type="button" class="btn-close" data-bs-dismiss="alert" aria-label="Close"></button>
                    </div>
                <% } %>

                <form action="<%= request.getContextPath() %>/loginServlet" method="post">
                    <div class="mb-3">
                        <label for="uname" class="form-label">Username</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-person-badge"></i></span>
                            <input type="text" class="form-control" id="uname" name="uname"
                                   required placeholder="Enter your username">
                        </div>
                    </div>

                    <div class="mb-3">
                        <label for="password" class="form-label">Password</label>
                        <div class="input-group">
                            <span class="input-group-text"><i class="bi bi-lock"></i></span>
                            <input type="password" class="form-control" id="password" name="password"
                                   required placeholder="Enter your password">
                        </div>
                    </div>

                    <div class="mb-3">
                        <button type="submit" class="btn btn-primary w-100">
                            <i class="bi bi-box-arrow-in-right me-2"></i>Login
                        </button>
                    </div>

                    <p class="text-center mt-3">
                        Don't have an account? 
                        <a href="<%= request.getContextPath() %>/Views/register.jsp" class="text-primary">Register here</a>
                    </p>
                </form>
            </div>
        </div>
    </div>

    <%@ include file="/Assets/scripts.jsp" %>
</body>
</html>
