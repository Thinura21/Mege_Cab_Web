<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Customer Form</title>
</head>
<body>
    <h2>Customer Form</h2>
    <form action="<%= request.getContextPath() %>/manageCustomer" method="post" enctype="multipart/form-data">
        <% 
            com.megacitycab.model.Customer customer = (com.megacitycab.model.Customer) request.getAttribute("customer");
            boolean isEdit = false;
            if(customer != null && customer.getCustomerId() != 0) {
                isEdit = true;
            }
        %>
        <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>" />
        <% if(isEdit){ %>
            <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>" />
        <% } %>
        
        <!-- For simplicity, assume userId is provided manually (or can be auto-filled from session in a real app) -->
        <label for="userId">User ID:</label>
        <input type="text" id="userId" name="userId" value="<%= isEdit ? customer.getUserId() : "" %>" required />
        <br/><br/>
        
        <label for="name">Name:</label>
        <input type="text" id="name" name="name" value="<%= isEdit ? customer.getName() : "" %>" required />
        <br/><br/>
        
        <label for="address">Address:</label>
        <input type="text" id="address" name="address" value="<%= isEdit ? customer.getAddress() : "" %>" />
        <br/><br/>
        
        <label for="nic">NIC:</label>
        <input type="text" id="nic" name="nic" value="<%= isEdit ? customer.getNic() : "" %>" required />
        <br/><br/>
        
        <label for="contact">Contact:</label>
        <input type="text" id="contact" name="contact" value="<%= isEdit ? customer.getContact() : "" %>" />
        <br/><br/>
        
        <label for="email">Email:</label>
        <input type="email" id="email" name="email" value="<%= isEdit ? customer.getEmail() : "" %>" />
        <br/><br/>
        
        <!-- Optionally add a profile picture field -->
        <label for="profilePicture">Profile Picture:</label>
        <input type="file" id="profilePicture" name="profilePicture" />
        <br/><br/>
        
        <input type="submit" value="<%= isEdit ? "Update" : "Add" %>" />
    </form>
    <br/>
    <a href="<%= request.getContextPath() %>/manageCustomer?action=list">Back to List</a>
</body>
</html>
