<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8"/>
    <meta name="viewport" content="width=device-width, initial-scale=1.0"/>
    <title>Mega City Cab - Colombo's Best Cab Service</title>

    <!-- Include all CSS/Font links -->
    <%@ include file="../../Assests/CDN_Links.jsp" %>
    
    <%@ include file="../../Assests/styles.jsp" %>
    
</head>
<body>
    <nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm">
        <div class="container">
            <a class="navbar-brand fw-bold fs-3 text-warning" href="index.jsp">
                <i class="fa-solid fa-taxi"></i> Mega City Cab
            </a>
            <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
                <span class="navbar-toggler-icon"></span>
            </button>
            <div class="collapse navbar-collapse" id="navbarNav">
                <ul class="navbar-nav mx-auto">
                    <li class="nav-item"><a class="nav-link" href="index.jsp">Home</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">About Us</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Services</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Booking</a></li>
                    <li class="nav-item"><a class="nav-link" href="#">Contact</a></li>
                </ul>
                <button class="btn btn-outline-dark me-2">Book Now</button>
                <a href="login.jsp" class="btn btn-warning text-dark">Login</a>
            </div>
        </div>
    </nav>

