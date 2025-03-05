<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    String role = (String) session.getAttribute("role");
    if (role == null || !role.equalsIgnoreCase("Customer")) {
        response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
        return;
    }
    // Try to retrieve an existing Customer record passed as an attribute; if not, create a new one.
    com.megacitycab.model.Customer customer = (com.megacitycab.model.Customer) request.getAttribute("customer");
    if (customer == null) {
        customer = new com.megacitycab.model.Customer();
    }
    // Use session defaults from the user table for auto-fill if Customer record is empty.
    String autoName = (String) session.getAttribute("f_name");
    String autoAddress = (String) session.getAttribute("Address");
    String autoContact = (String) session.getAttribute("Contact");
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Complete Your Profile</title>
</head>
<body>
    <h2>Complete Your Profile</h2>
    <form action="<%= request.getContextPath() %>/completeProfileServlet" method="post" enctype="multipart/form-data">
        <!-- Name (required) -->
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" 
            value="<%= (customer.getName() != null && !customer.getName().trim().isEmpty()) ? customer.getName() : (autoName != null ? autoName : "") %>" required>
        <br><br>

        <!-- Address -->
        <label for="address">Address:</label>
        <input type="text" id="address" name="address" 
            value="<%= (customer.getAddress() != null && !customer.getAddress().trim().isEmpty()) ? customer.getAddress() : (autoAddress != null ? autoAddress : "") %>">
        <br><br>

        <!-- NIC (required) -->
        <label for="nic">NIC:</label>
        <input type="text" id="nic" name="nic" value="<%= customer.getNic() == null ? "" : customer.getNic() %>" required>
        <br><br>

        <!-- Contact -->
        <label for="contact">Contact:</label>
        <input type="text" id="contact" name="contact" 
            value="<%= (customer.getContact() != null && !customer.getContact().trim().isEmpty()) ? customer.getContact() : (autoContact != null ? autoContact : "") %>">
        <br><br>

        <!-- Email -->
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<%= customer.getEmail() == null ? "" : customer.getEmail() %>">
        <br><br>

        <!-- Profile Picture -->
        <label for="profilePicture">Profile Picture:</label>
        <input type="file" id="profilePicture" name="profilePicture">
        <br><br>

        <input type="submit" value="Save">
    </form>
</body>
</html>
