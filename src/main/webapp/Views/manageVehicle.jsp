<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Determine if we're editing – if a "vehicle" attribute exists.
    com.megacitycab.model.Vehicle vehicle = (com.megacitycab.model.Vehicle) request.getAttribute("vehicle");
    boolean isEdit = (vehicle != null);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MegaCityCab - Vehicle Management</title>
    <!-- Optional external stylesheets -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f0f2f5; margin: 0; padding: 20px; }
        .header { background: linear-gradient(135deg, #4361ee 0%, #3f37c9 100%); color: white; padding: 20px; margin-bottom: 30px; }
        .header .logo { font-size: 24px; font-weight: 700; }
        .back-btn { color: white; text-decoration: none; font-weight: 500; }
        .container { max-width: 1200px; margin: 0 auto; }
        h1, h2 { color: #212529; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        th, td { padding: 10px; border: 1px solid #dee2e6; text-align: left; }
        th { background-color: #f8f9fa; }
        .profile-img { width: 60px; height: 60px; border-radius: 50%; object-fit: cover; }
        .no-image { width: 60px; height: 60px; border-radius: 50%; background-color: #e9ecef; display: flex; align-items: center; justify-content: center; color: #adb5bd; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 500; }
        .form-group input { width: 100%; padding: 8px; border: 1px solid #ced4da; border-radius: 4px; }
        .btn { display: inline-block; padding: 10px 15px; border: none; border-radius: 4px; text-decoration: none; color: white; cursor: pointer; }
        .btn-primary { background-color: #4361ee; }
        .btn-success { background-color: #4cc9f0; }
        .btn-danger { background-color: #f72585; }
        .page-title { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
    </style>
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo"><i class="fas fa-taxi"></i> MegaCityCab</div>
                <a href="<%= request.getContextPath() %>/Views/staffDashboard.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Staff Dashboard
                </a>
            </div>
        </div>
    </header>
    
    <div class="container">
        <div class="page-title">
            <h1>Vehicle Management</h1>
            <a href="<%= request.getContextPath() %>/manageVehicle?action=add" class="btn btn-success">
                <i class="fas fa-car-side"></i> Add New Vehicle
            </a>
        </div>
        
        <!-- Vehicle List -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>Driver ID</th>
                    <th>Photo</th>
                    <th>Model</th>
                    <th>License Plate</th>
                    <th>Type</th>
                    <th>Color</th>
                    <th>Status</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    java.util.List<com.megacitycab.model.Vehicle> list = 
                        (java.util.List<com.megacitycab.model.Vehicle>) request.getAttribute("vehicleList");
                    if(list != null && !list.isEmpty()){
                        for(com.megacitycab.model.Vehicle v : list){
                %>
                <tr>
                    <td><%= v.getVehicleId() %></td>
                    <td><%= v.getDriverId() %></td>
                    <td>
                        <% if(v.getVehiclePhoto() != null) { %>
                            <img src="<%= request.getContextPath() %>/manageVehicle?action=viewImage&id=<%= v.getVehicleId() %>" alt="Vehicle Photo" class="profile-img" />
                        <% } else { %>
                            <div class="no-image"><i class="fas fa-car"></i></div>
                        <% } %>
                    </td>
                    <td><%= v.getModel() %></td>
                    <td><%= v.getLicensePlate() %></td>
                    <td><%= v.getType() != null ? v.getType() : "-" %></td>
                    <td><%= v.getColor() != null ? v.getColor() : "-" %></td>
                    <td><%= v.getStatus() %></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/manageVehicle?action=edit&id=<%= v.getVehicleId() %>">Edit</a> | 
                        <a href="<%= request.getContextPath() %>/manageVehicle?action=delete&id=<%= v.getVehicleId() %>" onclick="return confirm('Are you sure you want to delete this vehicle?');">Delete</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="9" style="text-align: center;">No vehicles found. Use the "Add New Vehicle" button above.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        
        <hr/>
        
        <!-- Add/Edit Vehicle Form -->
        <h2><%= isEdit ? "Edit Vehicle" : "Add New Vehicle" %></h2>
        <form action="<%= request.getContextPath() %>/manageVehicle" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>" />
            <% if(isEdit){ %>
                <input type="hidden" name="vehicleId" value="<%= vehicle.getVehicleId() %>" />
                <input type="hidden" name="driverId" value="<%= vehicle.getDriverId() %>" />
            <% } else { %>
                <!-- For add mode, driverId is expected to be provided by the staff -->
                <div class="form-group">
                    <label for="driverId">Driver ID:</label>
                    <input type="number" id="driverId" name="driverId" class="form-control" required />
                </div>
            <% } %>
            
            <div class="form-group">
                <label for="model">Model:</label>
                <input type="text" id="model" name="model" class="form-control" value="<%= isEdit ? vehicle.getModel() : "" %>" required />
            </div>
            <div class="form-group">
                <label for="licensePlate">License Plate:</label>
                <input type="text" id="licensePlate" name="licensePlate" class="form-control" value="<%= isEdit ? vehicle.getLicensePlate() : "" %>" required />
            </div>
            <div class="form-group">
                <label for="type">Type:</label>
                <input type="text" id="type" name="type" class="form-control" value="<%= isEdit ? vehicle.getType() : "" %>" />
            </div>
            <div class="form-group">
                <label for="color">Color:</label>
                <input type="text" id="color" name="color" class="form-control" value="<%= isEdit ? vehicle.getColor() : "" %>" />
            </div>
            <div class="form-group">
                <label for="status">Status:</label>
                <input type="text" id="status" name="status" class="form-control" value="<%= isEdit ? vehicle.getStatus() : "Active" %>" />
            </div>
            <div class="form-group">
                <label for="vehiclePhoto">Vehicle Photo:</label>
                <input type="file" id="vehiclePhoto" name="vehiclePhoto" class="form-control" />
            </div>
            <div class="form-group">
                <label for="licensePlatePhoto">License Plate Photo:</label>
                <input type="file" id="licensePlatePhoto" name="licensePlatePhoto" class="form-control" />
            </div>
            
            <input type="submit" value="<%= isEdit ? "Update" : "Add" %>" class="btn btn-primary" />
        </form>
        
        <br/>
        <a href="<%= request.getContextPath() %>/Views/staffDashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Staff Dashboard
        </a>
    </div>
</body>
</html>
