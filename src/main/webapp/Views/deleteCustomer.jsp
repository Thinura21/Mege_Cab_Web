<%
    int id = Integer.parseInt(request.getParameter("id"));
%>
<!DOCTYPE html>
<html>
<head>
    <title>Delete Customer</title>
</head>
<body>
    <form action="<%= request.getContextPath() %>/customerServlet" method="post">
        <input type="hidden" name="action" value="delete">
        <input type="hidden" name="id" value="<%= id %>">
        <p>Are you sure you want to delete this customer?</p>
        <button type="submit">Yes, Delete</button>
    </form>
</body>
</html>
