<%@ page import="com.datapackage.dao.CustomerDao, com.datapackage.model.Customer" %>
<%
    int id = Integer.parseInt(request.getParameter("id"));
    CustomerDao dao = new CustomerDao();
    Customer customer = dao.getCustomerById(id);
%>
<!DOCTYPE html>
<html>
<head>
    <title>Edit Customer</title>
</head>
<body>
    <form action="<%= request.getContextPath() %>/customerServlet" method="post">
        <input type="hidden" name="action" value="update">
        <input type="hidden" name="id" value="<%= customer.getId() %>">
        <input type="text" name="nic" value="<%= customer.getNic() %>">
        <input type="text" name="name" value="<%= customer.getName() %>">
        <input type="text" name="address" value="<%= customer.getAddress() %>">
        <input type="text" name="contact" value="<%= customer.getContact() %>">
        <button type="submit">Update</button>
    </form>
</body>
</html>
