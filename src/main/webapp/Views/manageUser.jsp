<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%
    com.megacitycab.model.Users user = (com.megacitycab.model.Users) request.getAttribute("user");
    boolean isEdit = (user != null);
%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>MegaCityCab - User Management</title>
    <!-- External stylesheets (Font Awesome, Google Fonts) -->
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css">
    <link rel="stylesheet" href="https://fonts.googleapis.com/css2?family=Poppins:wght@300;400;500;600;700&display=swap">
    <style>
        body { font-family: 'Poppins', sans-serif; background-color: #f0f2f5; margin: 0; padding: 20px; }
        .header { background: linear-gradient(135deg, #4361ee, #3f37c9); color: white; padding: 20px; margin-bottom: 30px; }
        .header .logo { font-size: 24px; font-weight: 700; }
        .back-btn { color: white; text-decoration: none; font-weight: 500; }
        .container { max-width: 1200px; margin: 0 auto; }
        h1, h2 { color: #212529; }
        table { width: 100%; border-collapse: collapse; margin-bottom: 30px; }
        th, td { padding: 10px; border: 1px solid #dee2e6; text-align: left; }
        th { background-color: #f8f9fa; }
        .btn { display: inline-block; padding: 10px 15px; border: none; border-radius: 4px; text-decoration: none; color: white; cursor: pointer; }
        .btn-primary { background-color: #4361ee; }
        .btn-success { background-color: #4cc9f0; }
        .btn-danger { background-color: #f72585; }
        .page-title { display: flex; justify-content: space-between; align-items: center; margin-bottom: 20px; }
        .form-group { margin-bottom: 15px; }
        .form-group label { display: block; margin-bottom: 5px; font-weight: 500; }
        .form-group input, .form-group select { width: 100%; padding: 8px; border: 1px solid #ced4da; border-radius: 4px; }
    </style>
</head>
<body>
    <header class="header">
        <div class="container">
            <div class="header-content">
                <div class="logo"><i class="fas fa-user"></i> MegaCityCab - User Management</div>
                <a href="<%= request.getContextPath() %>/Views/adminDashboard.jsp" class="back-btn">
                    <i class="fas fa-arrow-left"></i> Back to Admin Dashboard
                </a>
            </div>
        </div>
    </header>
    
    <div class="container">
        <h1>User Management</h1>
        <a href="<%= request.getContextPath() %>/manageUser?action=add" class="btn btn-success">
            <i class="fas fa-user-plus"></i> Add New User
        </a>
        <br/><br/>
        <table>
            <thead>
                <tr>
                    <th>User ID</th>
                    <th>Full Name</th>
                    <th>Address</th>
                    <th>Contact</th>
                    <th>Username</th>
                    <th>Role</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    java.util.List<com.megacitycab.model.Users> list = (java.util.List<com.megacitycab.model.Users>) request.getAttribute("userList");
                    if(list != null && !list.isEmpty()){
                        for(com.megacitycab.model.Users u : list){
                %>
                <tr>
                    <td><%= u.getUser_id() %></td>
                    <td><%= u.getF_name() %></td>
                    <td><%= u.getAddress() %></td>
                    <td><%= u.getContact() %></td>
                    <td><%= u.getUser_name() %></td>
                    <td><%= u.getRole() %></td>
                    <td>
                        <a href="<%= request.getContextPath() %>/manageUser?action=edit&id=<%= u.getUser_id() %>">Edit</a> | 
                        <a href="<%= request.getContextPath() %>/manageUser?action=delete&id=<%= u.getUser_id() %>" onclick="return confirm('Are you sure you want to delete this user?');">Delete</a>
                    </td>
                </tr>
                <%
                        }
                    } else {
                %>
                <tr>
                    <td colspan="7" style="text-align: center;">No users found. Use the "Add New User" button above.</td>
                </tr>
                <%
                    }
                %>
            </tbody>
        </table>
        
        <hr/>
        
        <h2><%= isEdit ? "Edit User" : "Add New User" %></h2>
        <form action="<%= request.getContextPath() %>/manageUser" method="post">
            <input type="hidden" name="action" value="<%= isEdit ? "edit" : "add" %>" />
            <% if(isEdit){ %>
                <input type="hidden" name="userId" value="<%= user.getUser_id() %>" />
            <% } %>
            <div class="form-group">
                <label for="fName">Full Name:</label>
                <input type="text" id="fName" name="fName" value="<%= isEdit ? user.getF_name() : "" %>" required />
            </div>
            <div class="form-group">
                <label for="address">Address:</label>
                <input type="text" id="address" name="address" value="<%= isEdit ? user.getAddress() : "" %>" />
            </div>
            <div class="form-group">
                <label for="contact">Contact:</label>
                <input type="text" id="contact" name="contact" value="<%= isEdit ? user.getContact() : "" %>" />
            </div>
            <div class="form-group">
                <label for="userName">Username:</label>
                <input type="text" id="userName" name="userName" value="<%= isEdit ? user.getUser_name() : "" %>" required />
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" value="<%= isEdit ? user.getPassword() : "" %>" required />
            </div>
            <div class="form-group">
                <label for="role">Role:</label>
                <select id="role" name="role" required>
                    <option value="">-- Select Role --</option>
                    <option value="Admin" <%= isEdit && "Admin".equals(user.getRole()) ? "selected" : "" %>>Admin</option>
                    <option value="Staff" <%= isEdit && "Staff".equals(user.getRole()) ? "selected" : "" %>>Staff</option>
                    <option value="Driver" <%= isEdit && "Driver".equals(user.getRole()) ? "selected" : "" %>>Driver</option>
                    <option value="Customer" <%= isEdit && "Customer".equals(user.getRole()) ? "selected" : "" %>>Customer</option>
                </select>
            </div>
            
            <input type="submit" value="<%= isEdit ? "Update" : "Add" %>" class="btn btn-primary" />
        </form>
        
        <br/>
        <a href="<%= request.getContextPath() %>/Views/adminDashboard.jsp" class="back-btn">
            <i class="fas fa-arrow-left"></i> Back to Admin Dashboard
        </a>
    </div>
</body>
</html>
