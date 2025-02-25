<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.datapackage.model.Customer" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Customer Management - Mega City Cab</title>
    <%@ include file="../Assests/CDN_Links.jsp" %>
    <link rel="stylesheet" href="../Assests/d_styles.css">
</head>
<body>
    <%@ include file="Navigation/d_hedding.jsp" %>
    
    <div class="container-lg py-3">
        <h2 class="fw-bold">Customer Management</h2>
        
        <!-- Search & Add Row -->
        <div class="d-flex justify-content-between align-items-center my-3">
            <!-- Search Form (GET) -->
            <form class="d-flex" action="<%= request.getContextPath() %>/manageCustomers" method="get" style="max-width: 300px;">
                <input class="form-control me-2" type="search" name="q" placeholder="Search customers..." aria-label="Search">
                <button class="btn btn-warning" type="submit"><i class="fas fa-search"></i></button>
            </form>
            <button class="btn btn-warning" data-bs-toggle="modal" data-bs-target="#addCustomerModal">
                <i class="fas fa-plus"></i> Add Customer
            </button>
        </div>
        
        <!-- Customer Table -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>UserID</th>
                                <th>Email</th>
                                <th>Name</th>
                                <th>Address</th>
                                <th>NIC</th>
                                <th>Contact</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
<%
    List<Customer> customerList = (List<Customer>) request.getAttribute("customerList");
    if(customerList != null && !customerList.isEmpty()){
        for(Customer customer : customerList) {
%>
                            <tr>
                                <td><%= customer.getUserID() %></td>
                                <td><%= customer.getEmail() %></td>
                                <td><%= customer.getName() %></td>
                                <td><%= customer.getAddress() %></td>
                                <td><%= customer.getNic() %></td>
                                <td><%= customer.getContact() %></td>
                                <td>
                                    <!-- Edit Button: Open modal to edit customer -->
                                    <button class="btn btn-sm btn-warning" data-bs-toggle="modal" data-bs-target="#editCustomerModal"
                                        data-userid="<%= customer.getUserID() %>" data-email="<%= customer.getEmail() %>" 
                                        data-name="<%= customer.getName() %>" data-address="<%= customer.getAddress() %>" 
                                        data-nic="<%= customer.getNic() %>" data-contact="<%= customer.getContact() %>">
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    <!-- Delete Button -->
                                    <form action="<%= request.getContextPath() %>/manageCustomers" method="post" style="display:inline;">
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="userId" value="<%= customer.getUserID() %>">
                                        <button type="submit" class="btn btn-sm btn-dark" onclick="return confirm('Are you sure?');">
                                            <i class="fas fa-trash"></i>
                                        </button>
                                    </form>
                                </td>
                            </tr>
<%
        }
    } else {
%>
                            <tr>
                                <td colspan="7" class="text-center">No customers found.</td>
                            </tr>
<%
    }
%>
                        </tbody>
                    </table>
                </div>
            </div>
        </div>
    </div>
    
    <!-- Add Customer Modal -->
    <div class="modal fade" id="addCustomerModal" tabindex="-1" aria-labelledby="addCustomerModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title fw-bold" id="addCustomerModalLabel">Add New Customer</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form action="<%= request.getContextPath() %>/manageCustomers" method="post">
              <input type="hidden" name="action" value="add">
              <div class="mb-3">
                <label class="form-label fw-semibold">Email</label>
                <input type="email" class="form-control" name="email" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Password</label>
                <input type="password" class="form-control" name="password" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Name</label>
                <input type="text" class="form-control" name="name" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Address</label>
                <input type="text" class="form-control" name="address" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">NIC</label>
                <input type="text" class="form-control" name="nic" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Contact</label>
                <input type="text" class="form-control" name="contact" required>
              </div>
              <button type="submit" class="btn btn-warning w-100">Add Customer</button>
            </form>
          </div>
        </div>
      </div>
    </div>
    
    <!-- Edit Customer Modal -->
    <div class="modal fade" id="editCustomerModal" tabindex="-1" aria-labelledby="editCustomerModalLabel" aria-hidden="true">
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title fw-bold" id="editCustomerModalLabel">Edit Customer</h5>
            <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
          </div>
          <div class="modal-body">
            <form action="<%= request.getContextPath() %>/manageCustomers" method="post">
              <input type="hidden" name="action" value="update">
              <input type="hidden" name="userId" id="editUserId">
              <div class="mb-3">
                <label class="form-label fw-semibold">Name</label>
                <input type="text" class="form-control" name="name" id="editName" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Address</label>
                <input type="text" class="form-control" name="address" id="editAddress" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">NIC</label>
                <input type="text" class="form-control" name="nic" id="editNic" required>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Contact</label>
                <input type="text" class="form-control" name="contact" id="editContact" required>
              </div>
              <button type="submit" class="btn btn-warning w-100">Save Changes</button>
            </form>
          </div>
        </div>
      </div>
    </div>
    
    <%@ include file="../Assests/scripts.jsp" %>
    <script>
      // JavaScript to populate the edit modal using data attributes
      var editModal = document.getElementById('editCustomerModal');
      editModal.addEventListener('show.bs.modal', function (event) {
          var button = event.relatedTarget;
          var userId = button.getAttribute('data-userid');
          var name = button.getAttribute('data-name');
          var address = button.getAttribute('data-address');
          var nic = button.getAttribute('data-nic');
          var contact = button.getAttribute('data-contact');
          
          document.getElementById('editUserId').value = userId;
          document.getElementById('editName').value = name;
          document.getElementById('editAddress').value = address;
          document.getElementById('editNic').value = nic;
          document.getElementById('editContact').value = contact;
      });
    </script>
</body>
</html>
