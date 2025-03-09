<!-- Navbar -->
<nav class="navbar navbar-expand-lg navbar-light bg-white shadow-sm sticky-top">
  <div class="container">
    <a class="navbar-brand fw-bold fs-3 text-warning" href="index.jsp"><i class="fa-solid fa-taxi me-2"></i> Mega City Cab</a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav mx-auto">
        <li class="nav-item"><a class="nav-link active" href="index.jsp"><i class="fas fa-home me-1"></i> Home</a></li>
        <li class="nav-item"><a class="nav-link" href="#about"><i class="fas fa-info-circle me-1"></i> About Us</a></li>
        <li class="nav-item"><a class="nav-link" href="#services"><i class="fas fa-taxi me-1"></i> Services</a></li>
        <% if (role != null) {
          if(role.equalsIgnoreCase("Customer")) { %>
            <a class="nav-link" href="<%= request.getContextPath() %>/BookingServlet">
              <i class="fas fa-calendar-check me-1"></i> Booking
            </a>
          <% } else if(role.equalsIgnoreCase("Driver")) { %>
            <a class="nav-link" href="<%= request.getContextPath() %>/manageDriverBooking">
              <i class="fas fa-calendar-check me-1"></i> Booking
            </a>
          <% } else { %>
            <a class="nav-link" href="bookingForm.jsp">
              <i class="fas fa-calendar-check me-1"></i> Booking
            </a>
          <% }
        } else { %>
          <a class="nav-link" href="bookingForm.jsp">
            <i class="fas fa-calendar-check me-1"></i> Booking
          </a>
        <% } %>
        <li class="nav-item"><a class="nav-link" href="#contact"><i class="fas fa-envelope me-1"></i> Contact</a></li>
      </ul>
      <div class="d-flex">
        <% if (username != null && !username.isEmpty()) { %>
          <!-- Profile button added for logged-in users -->
          <a href="profile.jsp" class="btn btn-outline-warning text-dark me-2">
            <i class="fas fa-user me-1"></i> Profile
          </a>
          <form action="<%= request.getContextPath() %>/logoutServlet" method="post" class="d-inline">
            <button type="submit" class="btn btn-danger">
              <i class="bi bi-box-arrow-right me-2"></i>Logout
            </button>
          </form>
        <% } else { %>
          <a href="login.jsp" class="btn btn-warning text-dark">
            <i class="fas fa-sign-in-alt me-1"></i> Login
          </a>
        <% } %>
      </div>
    </div>
  </div>
</nav>