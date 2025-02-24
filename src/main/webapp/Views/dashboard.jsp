<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Mega City Cab - Dashboard</title>
    
    <!-- Include CDN links (Bootstrap, FontAwesome, etc.) -->
    <%@ include file="../Assests/CDN_Links.jsp" %>
    <!-- Include Dashboard Styles -->
    <%@ include file="../Assests/d_styles.jsp" %>
  </head>
  <body>
    <!-- Include Navigation Bar -->
    <%@ include file="Navigation/d_hedding.jsp" %>

    <!-- Main Dashboard Content -->
    <div class="container-fluid py-4">
      <div class="row g-4">
        <!-- Stats Cards -->
        <div class="col-md-3">
          <div class="card stats-card bg-warning text-dark h-100">
            <div class="card-body position-relative">
              <h5 class="card-title fw-bold">Total Bookings</h5>
              <h2 class="card-text">156</h2>
              <i class="fas fa-book fa-3x position-absolute end-0 bottom-0 mb-3 me-3 opacity-25"></i>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stats-card bg-warning text-dark h-100">
            <div class="card-body position-relative">
              <h5 class="card-title fw-bold">Active Customers</h5>
              <h2 class="card-text">89</h2>
              <i class="fas fa-users fa-3x position-absolute end-0 bottom-0 mb-3 me-3 opacity-25"></i>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stats-card bg-warning text-dark h-100">
            <div class="card-body position-relative">
              <h5 class="card-title fw-bold">Available Cars</h5>
              <h2 class="card-text">24</h2>
              <i class="fas fa-car fa-3x position-absolute end-0 bottom-0 mb-3 me-3 opacity-25"></i>
            </div>
          </div>
        </div>
        <div class="col-md-3">
          <div class="card stats-card bg-warning text-dark h-100">
            <div class="card-body position-relative">
              <h5 class="card-title fw-bold">Active Drivers</h5>
              <h2 class="card-text">32</h2>
              <i class="fas fa-id-card fa-3x position-absolute end-0 bottom-0 mb-3 me-3 opacity-25"></i>
            </div>
          </div>
        </div>
      </div>

      <!-- Recent Bookings & Quick Actions -->
      <div class="row mt-4">
        <div class="col-md-8 mb-4">
          <div class="card">
            <div class="card-header bg-white py-3">
              <h5 class="card-title mb-0 fw-bold">Recent Bookings</h5>
            </div>
            <div class="card-body">
              <div class="table-responsive">
                <table class="table">
                  <thead>
                    <tr>
                      <th>Booking ID</th>
                      <th>Customer</th>
                      <th>Destination</th>
                      <th>Status</th>
                      <th>Actions</th>
                    </tr>
                  </thead>
                  <tbody>
                    <tr>
                      <td>#12345</td>
                      <td>John Doe</td>
                      <td>Airport</td>
                      <td>
                        <span class="badge bg-success">Completed</span>
                      </td>
                      <td>
                        <button class="btn btn-sm btn-warning">
                          <i class="fas fa-eye"></i>
                        </button>
                        <button class="btn btn-sm btn-dark">
                          <i class="fas fa-edit"></i>
                        </button>
                      </td>
                    </tr>
                    <tr>
                      <td>#12346</td>
                      <td>Jane Smith</td>
                      <td>Hotel Hilton</td>
                      <td>
                        <span class="badge bg-warning text-dark">In Progress</span>
                      </td>
                      <td>
                        <button class="btn btn-sm btn-warning">
                          <i class="fas fa-eye"></i>
                        </button>
                        <button class="btn btn-sm btn-dark">
                          <i class="fas fa-edit"></i>
                        </button>
                      </td>
                    </tr>
                    <!-- More rows as needed -->
                  </tbody>
                </table>
              </div>
            </div>
          </div>
        </div>
        <div class="col-md-4 mb-4">
          <div class="card">
            <div class="card-header bg-white py-3">
              <h5 class="card-title mb-0 fw-bold">Quick Actions</h5>
            </div>
            <div class="card-body">
              <div class="d-grid gap-3">
                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addBookingModal">
                  <i class="fas fa-plus"></i> New Booking
                </button>
                <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                  <i class="fas fa-user-plus"></i> Add Customer
                </button>
                <a href="generate-bill.jsp" class="btn btn-warning">
                  <i class="fas fa-file-invoice-dollar"></i> Generate Bill
                </a>
                <a href="view-reports.jsp" class="btn btn-warning">
                  <i class="fas fa-chart-bar"></i> View Reports
                </a>
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>

    <!-- Add Booking Modal -->
    <div class="modal fade" id="addBookingModal" tabindex="-1" aria-labelledby="addBookingModalLabel" aria-hidden="true">
      <div class="modal-dialog modal-lg">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title fw-bold" id="addBookingModalLabel">Add New Booking</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form>
              <!-- Booking details form -->
              <div class="row">
                <div class="col-md-4 mb-3">
                  <label class="form-label fw-semibold">Booking ID</label>
                  <input type="text" class="form-control" required>
                </div>
                <div class="col-md-4 mb-3">
                  <label class="form-label fw-semibold">Name</label>
                  <input type="text" class="form-control" required>
                </div>
                <div class="col-md-4 mb-3">
                  <label class="form-label fw-semibold">NIC</label>
                  <input type="text" class="form-control" required>
                </div>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Address</label>
                <input type="text" class="form-control" required>
              </div>
              <div class="row">
                <div class="col-md-3 mb-3">
                  <label class="form-label fw-semibold">Contact</label>
                  <input type="text" class="form-control" required>
                </div>
                <div class="col-md-3 mb-3">
                  <label class="form-label fw-semibold">DateTime</label>
                  <input type="datetime-local" class="form-control" required>
                </div>
                <div class="col-md-3 mb-3">
                  <label class="form-label fw-semibold">Pickup</label>
                  <input type="text" class="form-control" required>
                </div>
                <div class="col-md-3 mb-3">
                  <label class="form-label fw-semibold">Drop</label>
                  <input type="text" class="form-control" required>
                </div>
              </div>
              <div class="row">
                <div class="col-md-3 mb-3">
                  <label class="form-label fw-semibold">Status</label>
                  <select class="form-select" required>
                    <option value="Pending">Pending</option>
                    <option value="Confirmed">Confirmed</option>
                    <option value="In Progress">In Progress</option>
                    <option value="Completed">Completed</option>
                    <option value="Cancelled">Cancelled</option>
                  </select>
                </div>
                <div class="col-md-3 mb-3">
                  <label class="form-label fw-semibold">CustomerID</label>
                  <input type="text" class="form-control" required>
                </div>
                <div class="col-md-3 mb-3">
                  <label class="form-label fw-semibold">DriverID</label>
                  <input type="text" class="form-control">
                </div>
                <div class="col-md-3 mb-3">
                  <label class="form-label fw-semibold">VehicleID</label>
                  <input type="text" class="form-control">
                </div>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-warning">Add Booking</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Add Customer Modal -->
    <div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title fw-bold" id="addCustomerModalLabel">Add New Customer</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form>
              <!-- Customer details form -->
              <div class="mb-3">
                <label class="form-label fw-semibold">UserID</label>
                <input type="text" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Name</label>
                <input type="text" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Address</label>
                <input type="text" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">NIC</label>
                <input type="text" class="form-control" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Contact</label>
                <input type="text" class="form-control" required>
              </div>
            </form>
          </div>
          <div class="modal-footer">
            <button type="button" class="btn btn-light" data-bs-dismiss="modal">Cancel</button>
            <button type="button" class="btn btn-warning">Add Customer</button>
          </div>
        </div>
      </div>
    </div>

    <!-- Include Scripts -->
    <%@ include file="../Assests/scripts.jsp" %>
  </body>
</html>
