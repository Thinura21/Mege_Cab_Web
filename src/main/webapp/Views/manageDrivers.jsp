<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.datapackage.model.Driver" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Driver Management - Mega City Cab</title>
    <%@ include file="../Assests/CDN_Links.jsp" %>
    <link rel="stylesheet" href="../Assests/d_styles.css">
</head>
<body>
    <%@ include file="Navigation/d_hedding.jsp" %>
    
    <div class="container-lg py-3">
        <h2 class="fw-bold">Driver Management</h2>
        
        <!-- Add Driver & Search Row -->
        <div class="d-flex justify-content-between align-items-center my-3">
            <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addDriverModal">
                <i class="fas fa-plus"></i> Add Driver
            </button>
            <form class="d-flex" style="max-width: 300px;">
                <input class="form-control me-2" type="search" placeholder="Search drivers..." aria-label="Search">
                <button class="btn btn-warning" type="submit"><i class="fas fa-search"></i></button>
            </form>
        </div>
        
        <!-- Driver Table -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>UserID</th>
                                <th>Email</th>
                                <th>Name</th>
                                <th>Address</th>
                                <th>NIC</th>
                                <th>Contact</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
<%
    // Retrieve the driver list from the request scope
    List<Driver> driverList = (List<Driver>) request.getAttribute("driverList");
    if (driverList != null && !driverList.isEmpty()) {
        for (Driver driver : driverList) {
%>
                            <tr>
                                <td><%= driver.getUserID() %></td>
                                <td><%= driver.getEmail() %></td>
                                <td><%= driver.getName() %></td>
                                <td><%= driver.getAddress() %></td>
                                <td><%= driver.getNic() %></td>
                                <td><%= driver.getContact() %></td>
                                <td>
                                    <!-- Option 1: Use a modal for editing -->
                                    <!-- Option 2: Provide direct link or separate action for editing -->

                                    <!-- Delete action -->
                                    <form action="<%= request.getContextPath() %>/manageDrivers" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userId" value="<%= driver.getUserID() %>">
                                        <button type="submit" class="btn btn-sm btn-dark" onclick="return confirm('Are you sure?')">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
<%
        }
    } else {
%>
                            <tr>
                                <td colspan="7" class="text-center">No drivers found.</td>
                            </tr>
<%
    }
%>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add Driver Modal -->
    <div class="modal fade" id="addDriverModal" tabindex="-1" aria-labelledby="addDriverModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title fw-bold" id="addDriverModalLabel">Add New Driver</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form action="<%= request.getContextPath() %>/manageDrivers" method="post">
              <input type="hidden" name="action" value="add">
              <div class="mb-3">
                <label class="form-label fw-semibold">Email</label>
                <input type="email" class="form-control" name="email" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Password</label>
                <input type="password" class="form-control" name="password" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Name</label>
                <input type="text" class="form-control" name="name" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Address</label>
                <input type="text" class="form-control" name="address" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">NIC</label>
                <input type="text" class="form-control" name="nic" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Contact</label>
                <input type="text" class="form-control" name="contact" required>
              </div>
              <button type="submit" class="btn btn-warning w-100">Add Driver</button>
            </form>
          </div>
        </div>
      </div>
    </div>

    <%@ include file="../Assests/scripts.jsp" %>
</body>
</html>
