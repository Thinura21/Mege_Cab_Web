<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    // Determine if we're in edit mode – if a "customer" attribute exists.
    com.megacitycab.model.Customer customer = (com.megacitycab.model.Customer) request.getAttribute("customer");
    boolean isEdit = (customer != null);
    // Retrieve customer's username and password from request attributes (set in the servlet)
    String userNameVal = isEdit && request.getAttribute("userName") != null 
                         ? (String) request.getAttribute("userName") 
                         : "";
    String passwordVal = isEdit && request.getAttribute("password") != null 
                         ? (String) request.getAttribute("password") 
                         : "";
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MegaCityCab - Customer Management</title>
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
            <h1>Customer Management</h1>
            <a href="<%= request.getContextPath() %>/manageCustomer?action=add" class="btn btn-success">
                <i class="fas fa-user-plus"></i> Add New Customer
            </a>
        </div>
        
        <!-- Customer List -->
        <table>
            <thead>
                <tr>
                    <th>ID</th>
                    <th>User ID</th>
                    <th>Photo</th>
                    <th>Name</th>
                    <th>Address</th>
                    <th>NIC</th>
                    <th>Contact</th>
                    <th>Email</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    java.util.List<com.megacitycab.model.Customer> list = 
                        (java.util.List<com.megacitycab.model.Customer>) request.getAttribute("customerList");
                    if(list != null && !list.isEmpty()){
                        for(com.megacitycab.model.Customer c : list){
                %>
                <tr>
                    <td><%= c.getCustomerId() %></td>
                    <td><%= c.getUserId() %></td>
                    <td>
                        <% if(c.getProfilePicture() != null) { %>
                            <img src="<%= request.getContextPath() %>/manageCustomer?action=viewImage&id=<%= c.getCustomerId() %>" alt="Profile Picture" class="profile-img" />
                        <% } else { %>
                            <div class="no-image"><i class="fas fa-user"></i></div>
                        <% } %>
                    </td>
                    <td><%= c.getName() %></td>
                    <td><%= c.getAddress() != null && !c.getAddress().trim().isEmpty() ? c.getAddress() : "-" %></td>
                    <td><%= c.getNic() %></td>
                    <td><%= c.getContact() != null && !c.getContact().trim().isEmpty() ? c.getContact() : "-" %></td>
                    <td><%= c.getEmail() != null && !c.getEmail().trim().isEmpty() ? c.getEmail() : "-" %></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/manageCustomer?action=edit&id=<%= c.getCustomerId() %>">Edit</a> | 
                        <a href="<%= request.getContextPath() %>/manageCustomer?action=delete&id=<%= c.getCustomerId() %>" onclick="return confirm('Are you sure you want to delete this customer?');">Delete</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="9" style="text-align: center;">No customers found. Use the "Add New Customer" button above.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        
        <hr/>
        
        <!-- Add/Edit Customer Form -->
        <h2><%= isEdit ? "Edit Customer" : "Add New Customer" %></h2>
        <form action="<%= request.getContextPath() %>/manageCustomer" method="post" enctype="multipart/form-data">
            <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>" />
            <% if(isEdit){ %>
                <input type="hidden" name="customerId" value="<%= customer.getCustomerId() %>" />
                <input type="hidden" name="userId" value="<%= customer.getUserId() %>" />
            <% } %>
            
            <!-- Linked User Record Fields -->
            <div class="form-group">
                <label for="userName">User Name:</label>
                <input type="text" id="userName" name="userName" class="form-control" value="<%= userNameVal %>" required />
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" class="form-control" value="<%= passwordVal %>" required />
            </div>
            
            <!-- Customer Details -->
            <div class="form-group">
                <label for="name">Full Name:</label>
                <input type="text" id="name" name="name" class="form-control" value="<%= isEdit ? customer.getName() : "" %>" required />
            </div>
            <div class="form-group">
                <label for="address">Residential Address:</label>
                <input type="text" id="address" name="address" class="form-control" value="<%= isEdit ? customer.getAddress() : "" %>" />
            </div>
            <div class="form-group">
                <label for="nic">National ID (NIC):</label>
                <input type="text" id="nic" name="nic" class="form-control" value="<%= isEdit ? customer.getNic() : "" %>" required />
            </div>
            <div class="form-group">
                <label for="contact">Phone Number:</label>
                <input type="text" id="contact" name="contact" class="form-control" value="<%= isEdit ? customer.getContact() : "" %>" />
            </div>
            <div class="form-group">
                <label for="email">Email Address:</label>
                <input type="email" id="email" name="email" class="form-control" value="<%= isEdit ? customer.getEmail() : "" %>" />
            </div>
            <div class="form-group">
                <label for="profilePicture">Profile Picture:</label>
                <input type="file" id="profilePicture" name="profilePicture" class="form-control" />
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
