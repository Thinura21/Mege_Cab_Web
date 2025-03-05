<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Session check: Only allow Staff or Admin
    String role = (String) session.getAttribute("role");
    if (role == null || (!role.equalsIgnoreCase("Staff") && !role.equalsIgnoreCase("Admin"))) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
        return;
    }
    
    // Determine if we are editing – if a "driver" attribute exists.
    com.megacitycab.model.Driver driver = (com.megacitycab.model.Driver) request.getAttribute("driver");
    boolean isEdit = (driver != null);
    
    // Retrieve vehicle details if available
    com.megacitycab.model.Vehicle vehicle = (com.megacitycab.model.Vehicle) request.getAttribute("vehicle");
    if(vehicle == null) {
        vehicle = new com.megacitycab.model.Vehicle();
    }
    
    // Retrieve driver's linked username and password from request attributes
    String userNameVal = isEdit && request.getAttribute("userName") != null ? (String) request.getAttribute("userName") : "";
    String passwordVal = isEdit && request.getAttribute("password") != null ? (String) request.getAttribute("password") : "";
    
    // Retrieve the list of drivers from the servlet
    java.util.List<com.megacitycab.model.Driver> driverList = 
        (java.util.List<com.megacitycab.model.Driver>) request.getAttribute("driverList");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Manage Drivers (Staff)</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/tailwindcss@2.2.19/dist/tailwind.min.css">
</head>
<body class="bg-gray-100">
    <div class="max-w-4xl mx-auto py-8">
        <h2 class="text-2xl font-bold mb-4">Driver List</h2>
        <a href="<%= request.getContextPath() %>/manageDriver?action=list" class="text-blue-500 underline">Refresh List</a>
        <br/><br/>
        <table class="min-w-full bg-white border border-gray-300">
            <thead class="bg-gray-200">
                <tr>
                    <th class="px-4 py-2">ID</th>
                    <th class="px-4 py-2">User ID</th>
                    <th class="px-4 py-2">Profile Picture</th>
                    <th class="px-4 py-2">Name</th>
                    <th class="px-4 py-2">Address</th>
                    <th class="px-4 py-2">Contact</th>
                    <th class="px-4 py-2">Email</th>
                    <th class="px-4 py-2">License Number</th>
                    <th class="px-4 py-2">Status</th>
                    <th class="px-4 py-2">Verified</th>
                    <th class="px-4 py-2">Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    if(driverList != null && !driverList.isEmpty()){
                        for(com.megacitycab.model.Driver d : driverList){
                %>
                <tr class="border-b border-gray-300">
                    <td class="px-4 py-2"><%= d.getDriverId() %></td>
                    <td class="px-4 py-2"><%= d.getUserId() %></td>
                    <td class="px-4 py-2">
                        <% if(d.getProfilePicture() != null) { %>
                            <img src="<%= request.getContextPath() %>/manageDriver?action=viewImage&id=<%= d.getDriverId() %>" alt="Profile Picture" width="60" height="60" />
                        <% } else { %>
                            No Image
                        <% } %>
                    </td>
                    <td class="px-4 py-2"><%= d.getFName() %></td>
                    <td class="px-4 py-2"><%= d.getAddress() %></td>
                    <td class="px-4 py-2"><%= d.getContact() %></td>
                    <td class="px-4 py-2"><%= d.getEmail() %></td>
                    <td class="px-4 py-2"><%= d.getLicenseNumber() %></td>
                    <td class="px-4 py-2"><%= d.getStatus() %></td>
                    <td class="px-4 py-2">
                        <% if(d.isVerified()) { %>
                            Yes
                        <% } else { %>
                            No
                        <% } %>
                    </td>
                    <td class="px-4 py-2">
                        <a href="<%= request.getContextPath() %>/manageDriver?action=edit&id=<%= d.getDriverId() %>" class="bg-blue-500 text-white px-3 py-1 rounded">Edit</a>
                        |
                        <a href="<%= request.getContextPath() %>/manageDriver?action=delete&id=<%= d.getDriverId() %>" 
                           onclick="return confirm('Are you sure you want to delete this driver?');" 
                           class="bg-red-500 text-white px-3 py-1 rounded">Delete</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="11" class="text-center">No drivers found.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        
        <hr class="my-8">
        
        <!-- Add/Edit Driver Form -->
        <h2 class="text-2xl font-bold mb-4"><%= isEdit ? "Edit Driver" : "Add New Driver" %></h2>
        <form action="<%= request.getContextPath() %>/manageDriver" method="post" enctype="multipart/form-data" class="bg-white p-4 border rounded">
            <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>" />
            <% if(isEdit){ %>
                <input type="hidden" name="driverId" value="<%= driver.getDriverId() %>" />
                <input type="hidden" name="userId" value="<%= driver.getUserId() %>" />
            <% } %>
            
            <!-- Fields for updating the linked user record -->
            <label for="userName">User Name:</label>
            <input type="text" id="userName" name="userName" value="<%= userNameVal %>" required /><br/><br/>
            <label for="password">Password:</label>
            <input type="password" id="password" name="password" value="<%= passwordVal %>" required /><br/><br/>
            
            <!-- Driver fields -->
            <label for="fName">Name:</label>
            <input type="text" id="fName" name="fName" value="<%= isEdit ? driver.getFName() : "" %>" required /><br/><br/>
            <label for="address">Address:</label>
            <input type="text" id="address" name="address" value="<%= isEdit ? driver.getAddress() : "" %>" /><br/><br/>
            <label for="contact">Contact:</label>
            <input type="text" id="contact" name="contact" value="<%= isEdit ? driver.getContact() : "" %>" /><br/><br/>
            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= isEdit ? driver.getEmail() : "" %>" /><br/><br/>
            <label for="licenseNumber">License Number:</label>
            <input type="text" id="licenseNumber" name="licenseNumber" value="<%= isEdit ? driver.getLicenseNumber() : "" %>" required /><br/><br/>
            
            <!-- Driver status selection -->
            <label for="status">Driver Status:</label>
            <select id="status" name="status">
                <option value="Pending" <%= isEdit && "Pending".equalsIgnoreCase(driver.getStatus()) ? "selected" : "" %>>Pending</option>
                <option value="Active" <%= isEdit && "Active".equalsIgnoreCase(driver.getStatus()) ? "selected" : "" %>>Active</option>
                <option value="Inactive" <%= isEdit && "Inactive".equalsIgnoreCase(driver.getStatus()) ? "selected" : "" %>>Inactive</option>
            </select>
            <br/><br/>
            
            <!-- Verified checkbox -->
            <label for="verified">Verified:</label>
            <input type="checkbox" id="verified" name="verified" value="true" <%= isEdit && driver.isVerified() ? "checked" : "" %> />
            <span>(Check if driver is verified)</span>
            <br/><br/>
            
            <label for="driverProfilePicture">Profile Picture:</label>
            <input type="file" id="driverProfilePicture" name="driverProfilePicture" /><br/><br/>
            <label for="licencePhoto">Licence Photo:</label>
            <input type="file" id="licencePhoto" name="licencePhoto" /><br/><br/>
            
            <!-- Vehicle Details -->
            <h3 class="text-xl font-semibold mb-2">Vehicle Details</h3>
            <label for="model">Model:</label>
            <input type="text" id="model" name="model" value="<%= isEdit ? vehicle.getModel() : "" %>" /><br/><br/>
            <label for="licensePlate">License Plate:</label>
            <input type="text" id="licensePlate" name="licensePlate" value="<%= isEdit ? vehicle.getLicensePlate() : "" %>" /><br/><br/>
            
            <!-- Vehicle type selection box using text values -->
            <label for="vehicleType">Vehicle Type:</label>
            <select id="vehicleType" name="vehicleType" required>
                <option value="Mini Car (2)" <%= isEdit && "Mini Car (2)".equals(vehicle.getType()) ? "selected" : "" %>>Mini Car (2)</option>
                <option value="Normal Car (3)" <%= isEdit && "Normal Car (3)".equals(vehicle.getType()) ? "selected" : "" %>>Normal Car (3)</option>
                <option value="SUV (3)" <%= isEdit && "SUV (3)".equals(vehicle.getType()) ? "selected" : "" %>>SUV (3)</option>
                <option value="Large Car (4)" <%= isEdit && "Large Car (4)".equals(vehicle.getType()) ? "selected" : "" %>>Large Car (4)</option>
                <option value="Minivan (6)" <%= isEdit && "Minivan (6)".equals(vehicle.getType()) ? "selected" : "" %>>Minivan (6)</option>
                <option value="Large Van (10)" <%= isEdit && "Large Van (10)".equals(vehicle.getType()) ? "selected" : "" %>>Large Van (10)</option>
                <option value="Minibus (15)" <%= isEdit && "Minibus (15)".equals(vehicle.getType()) ? "selected" : "" %>>Minibus (15)</option>
            </select>
            <br/><br/>
            
            <label for="color">Color:</label>
            <input type="text" id="color" name="color" value="<%= isEdit ? vehicle.getColor() : "" %>" /><br/><br/>
            
            <label for="vehiclePhoto">Vehicle Photo:</label>
            <input type="file" id="vehiclePhoto" name="vehiclePhoto" /><br/><br/>
            <label for="licensePlatePhoto">License Plate Photo:</label>
            <input type="file" id="licensePlatePhoto" name="licensePlatePhoto" /><br/><br/>
            
            <button type="submit" class="bg-green-500 text-white px-4 py-2 rounded">
                <%= isEdit ? "Update Driver" : "Add Driver" %>
            </button>
        </form>
        
        <br/>
        <a href="<%= request.getContextPath() %>/Views/staffDashboard.jsp" class="bg-blue-500 text-white px-4 py-2 rounded">Back to Staff Dashboard</a>
    </div>
</body>
</html>
