<%@ page import="com.datapackage.dao.CustomerDao, com.datapackage.model.Customer, java.util.List" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <title>Customer List</title>
    <link rel="stylesheet" href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/css/bootstrap.min.css">
</head>
<body>
    <div class="container mt-5">
        <h2 class="mb-4">Customer List</h2>
        <a href="addCustomer.jsp" class="btn btn-primary mb-3">Add Customer</a>
        <table class="table table-bordered">
            <thead class="table-dark">
                <tr>
                    <th>ID</th>
                    <th>NIC</th>
                    <th>Name</th>
                    <th>Address</th>
                    <th>Contact</th>
                    <th>User Type</th>
                    <th>Actions</th>
                </tr>
            </thead>
            <tbody>
                <%
                    CustomerDao dao = new CustomerDao();
                    List<Customer> customers = dao.getAllCustomers();
                    for (Customer c : customers) {
                %>
                <tr>
                    <td><%= c.getId() %></td>
                    <td><%= c.getNic() %></td>
                    <td><%= c.getName() %></td>
                    <td><%= c.getAddress() %></td>
                    <td><%= c.getContact() %></td>
                    <td><%= c.getUserType() %></td>
                    <td>
					    <a href="editCustomer.jsp?id=<%= c.getId() %>" class="btn btn-warning btn-sm">Edit</a>
					    <a href="deleteCustomer.jsp?id=<%= c.getId() %>" class="btn btn-danger btn-sm">Delete</a>
					</td>
                </tr>
                <% } %>
            </tbody>
        </table>
    </div>
</body>
</html>
