<!-- Navigation Bar for Dashboard -->
<nav class="navbar navbar-expand-lg navbar-light shadow-sm">
  <div class="container-fluid">
    <a class="navbar-brand fw-bold fs-3 text-warning" href="<%= request.getContextPath() %>/Views/dashboard.jsp">
      <i class="fas fa-taxi"></i> Mega City Cab
    </a>
    <button class="navbar-toggler" type="button" data-bs-toggle="collapse" data-bs-target="#navbarNav">
      <span class="navbar-toggler-icon"></span>
    </button>
    <div class="collapse navbar-collapse" id="navbarNav">
      <ul class="navbar-nav me-auto">
        <li class="nav-item">
          <a class="nav-link active" href="<%= request.getContextPath() %>/Views/dashboard.jsp">
            <i class="fas fa-tachometer-alt"></i> Dashboard
          </a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="<%= request.getContextPath() %>/Views/bookings.jsp">
            <i class="fas fa-book"></i> Bookings
          </a>
        </li>
        <li class="nav-item">
			<a class="nav-link" href="<%= request.getContextPath() %>/manageCustomers">
			  <i class="fas fa-users"></i> Customers
			</a>
        </li>
        <li class="nav-item">
			 <a class="nav-link" href="<%= request.getContextPath() %>/manageVehicles">
			 	<i class="fas fa-truck"></i> Vehicles
			</a>
        </li>
        <li class="nav-item">
          <a class="nav-link" href="<%= request.getContextPath() %>/manageDrivers">
            <i class="fas fa-id-card"></i> Drivers
          </a>
        </li>
      </ul>
      <ul class="navbar-nav">
        <li class="nav-item">
          <a class="nav-link" href="<%= request.getContextPath() %>/Views/help.jsp">
            <i class="fas fa-question-circle"></i> Help
          </a>
        </li>
        <li class="nav-item">
          <a class="btn btn-warning ms-2" href="<%= request.getContextPath() %>/Views/index.jsp">
            <i class="fas fa-sign-out-alt"></i> Logout
          </a>
        </li>
      </ul>
    </div>
  </div>
</nav>
