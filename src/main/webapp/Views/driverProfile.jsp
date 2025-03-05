<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if(role == null || !role.equalsIgnoreCase("Driver")){
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
        return;
    }
    // Retrieve existing Driver and Vehicle records passed as attributes (if any); otherwise, create new objects.
    com.megacitycab.model.Driver driver = (com.megacitycab.model.Driver) request.getAttribute("driver");
    if(driver == null) {
        driver = new com.megacitycab.model.Driver();
    }
    com.megacitycab.model.Vehicle vehicle = (com.megacitycab.model.Vehicle) request.getAttribute("vehicle");
    if(vehicle == null) {
        vehicle = new com.megacitycab.model.Vehicle();
    }
    // Use defaults from session (from user table) for auto-fill if driver fields are empty.
    String autoFName = (String) session.getAttribute("f_name");
    String autoAddress = (String) session.getAttribute("Address");
    String autoContact = (String) session.getAttribute("Contact");
    String autoEmail = (String) session.getAttribute("email");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Complete Your Driver Profile</title>
</head>
<body>
    <h2>Complete Your Driver Profile</h2>
    <form action="<%= request.getContextPath() %>/driverProfileServlet" method="post" enctype="multipart/form-data">
        <h3>Driver Details</h3>
        <!-- Name -->
        <label for="fName">Name:</label>
        <input type="text" id="fName" name="fName" 
               value="<%= (driver.getFName() != null && !driver.getFName().trim().isEmpty()) ? driver.getFName() : (autoFName != null ? autoFName : "") %>" required>
        <br><br>
        
        <!-- Address -->
        <label for="address">Address:</label>
        <input type="text" id="address" name="address" 
               value="<%= (driver.getAddress() != null && !driver.getAddress().trim().isEmpty()) ? driver.getAddress() : (autoAddress != null ? autoAddress : "") %>">
        <br><br>
        
        <!-- Contact -->
        <label for="contact">Contact:</label>
        <input type="text" id="contact" name="contact" 
               value="<%= (driver.getContact() != null && !driver.getContact().trim().isEmpty()) ? driver.getContact() : (autoContact != null ? autoContact : "") %>">
        <br><br>
        
        <!-- Email -->
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" 
               value="<%= driver.getEmail() != null ? driver.getEmail() : (autoEmail != null ? autoEmail : "") %>">
        <br><br>
        
        <!-- License Number -->
        <label for="licenseNumber">License Number:</label>
        <input type="text" id="licenseNumber" name="licenseNumber" value="<%= driver.getLicenseNumber() == null ? "" : driver.getLicenseNumber() %>" required>
        <br><br>
        
        <!-- Driver Profile Picture -->
        <label for="driverProfilePicture">Profile Picture:</label>
        <input type="file" id="driverProfilePicture" name="driverProfilePicture">
        <br><br>
        
        <!-- Licence Photo -->
        <label for="licencePhoto">Licence Photo:</label>
        <input type="file" id="licencePhoto" name="licencePhoto">
        <br><br>
        
        <h3>Vehicle Details</h3>
        <!-- Model -->
        <label for="model">Model:</label>
        <input type="text" id="model" name="model" value="<%= vehicle.getModel() == null ? "" : vehicle.getModel() %>" required>
        <br><br>
        
        <!-- License Plate -->
        <label for="licensePlate">License Plate:</label>
        <input type="text" id="licensePlate" name="licensePlate" value="<%= vehicle.getLicensePlate() == null ? "" : vehicle.getLicensePlate() %>" required>
        <br><br>
        
        <!-- Type -->
        <label for="type">Type:</label>
        <input type="text" id="type" name="type" value="<%= vehicle.getType() == null ? "" : vehicle.getType() %>">
        <br><br>
        
        <!-- Color -->
        <label for="color">Color:</label>
        <input type="text" id="color" name="color" value="<%= vehicle.getColor() == null ? "" : vehicle.getColor() %>">
        <br><br>
        
        <!-- Vehicle Photo -->
        <label for="vehiclePhoto">Vehicle Photo:</label>
        <input type="file" id="vehiclePhoto" name="vehiclePhoto">
        <br><br>
        
        <!-- License Plate Photo -->
        <label for="licensePlatePhoto">License Plate Photo:</label>
        <input type="file" id="licensePlatePhoto" name="licensePlatePhoto">
        <br><br>
        
        <input type="submit" value="Save">
    </form>
</body>
</html>
