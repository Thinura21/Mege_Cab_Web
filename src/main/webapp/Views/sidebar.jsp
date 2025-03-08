<div class="col-md-auto sidebar" id="sidebar">
    <div class="sidebar-header">
        <h4><i class="bi bi-shield-lock me-2"></i>Staff Panel</h4>
    </div>
    <nav class="nav flex-column">
        <a href="<%= request.getContextPath() %>/Views/staffDashboard.jsp" class="nav-link active">
            <i class="bi bi-grid-1x2"></i> Dashboard
        </a>
        <a href="<%= request.getContextPath() %>/manageCustomer?action=list" class="nav-link">
            <i class="bi bi-people"></i> Customers
        </a>
        <a href="<%= request.getContextPath() %>/manageDriver" class="nav-link">
            <i class="bi bi-truck"></i> Drivers
        </a>
        <a href="<%= request.getContextPath() %>/manageVehicle" class="nav-link">
            <i class="bi bi-car-front"></i> Vehicles
        </a>
        <a href="<%= request.getContextPath() %>/manageBooking" class="nav-link">
            <i class="bi bi-calendar-check"></i> Bookings
        </a>
        <a href="<%= request.getContextPath() %>/Views/reports.jsp" class="nav-link">
            <i class="bi bi-file-earmark-text"></i> Reports
        </a>
        <div class="mt-auto">
            <form action="<%= request.getContextPath() %>/logoutServlet" method="post">
                <button type="submit" class="btn btn-danger w-100">
                    <i class="bi bi-box-arrow-right me-2"></i> Logout
                </button>
            </form>
        </div>
    </nav>
</div>
