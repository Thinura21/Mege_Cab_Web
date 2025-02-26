<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<%@ page import="java.util.List" %>
<%@ page import="com.datapackage.model.Vehicle" %>
<%@ page import="java.util.Base64" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1">
    <title>Vehicle Management - Mega City Cab</title>
    
    <!-- Include your CSS/JS references -->
    <%@ include file="../Assests/CDN_Links.jsp" %>
    <link rel="stylesheet" href="../Assets/d_styles.css">
</head>
<body>
    <!-- Include your navbar or heading -->
    <%@ include file="Navigation/d_hedding.jsp" %>

    <div class="container-lg py-3">
        <h2 class="fw-bold">Vehicle Management</h2>
        
        <!-- Search & Add Row -->
        <div class="d-flex justify-content-between align-items-center my-3">
            <!-- Search form (GET) -->
            <form class="d-flex" action="<%= request.getContextPath() %>/manageVehicles" method="get" style="max-width: 300px;">
                <input 
                  class="form-control me-2" 
                  type="search" 
                  name="q" 
                  placeholder="Search vehicles..." 
                  aria-label="Search"
                >
                <button class="btn btn-warning" type="submit">
                  <i class="fas fa-search"></i>
                </button>
            </form>

            <!-- Button to open Add Vehicle Modal -->
            <button 
              class="btn btn-warning" 
              data-bs-toggle="modal" 
              data-bs-target="#addVehicleModal"
            >
                <i class="fas fa-plus"></i> Add Vehicle
            </button>
        </div>
        
        <!-- Vehicle Table -->
        <div class="card">
            <div class="card-body">
                <div class="table-responsive">
                    <table class="table table-hover">
                        <thead>
                            <tr>
                                <th>ID</th>
                                <th>Model</th>
                                <th>Brand</th>
                                <th>Type</th>
                                <th>Status</th>
                                <th>DriverID</th>
                                <th>Image</th>
                                <th>Actions</th>
                            </tr>
                        </thead>
                        <tbody>
<%
    // The servlet sets "vehicleList" in request scope
    List<Vehicle> vehicleList = (List<Vehicle>) request.getAttribute("vehicleList");
    if(vehicleList != null && !vehicleList.isEmpty()) {
        for(Vehicle v : vehicleList) {
            // Convert BLOB to base64
            byte[] imgData = v.getImage();
            String base64Image = "";
            if (imgData != null && imgData.length > 0) {
                base64Image = Base64.getEncoder().encodeToString(imgData);
            }
%>
                            <tr>
                                <td><%= v.getId() %></td>
                                <td><%= v.getModel() %></td>
                                <td><%= v.getBrand() %></td>
                                <td><%= v.getType() %></td>
                                <td><%= v.getStatus() %></td>
                                <td><%= v.getDriverID() %></td>
                                <td>
<%
    if(!base64Image.isEmpty()) {
%>
                                    <img 
                                      src="data:image/*;base64,<%= base64Image %>" 
                                      alt="Vehicle Image" 
                                      style="max-width: 100px; max-height: 100px;"
                                    >
<%
    } else {
%>
                                    <span class="text-muted">No image</span>
<%
    }
%>
                                </td>
                                <td>
                                    <!-- Edit Button: Opens the Edit modal -->
                                    <button 
                                      class="btn btn-sm btn-warning"
                                      data-bs-toggle="modal"
                                      data-bs-target="#editVehicleModal"
                                      data-id="<%= v.getId() %>"
                                      data-model="<%= v.getModel() %>"
                                      data-brand="<%= v.getBrand() %>"
                                      data-type="<%= v.getType() %>"
                                      data-status="<%= v.getStatus() %>"
                                      data-driverid="<%= v.getDriverID() %>"
                                    >
                                        <i class="fas fa-edit"></i>
                                    </button>
                                    
                                    <!-- Delete Form -->
                                    <form 
                                      action="<%= request.getContextPath() %>/manageVehicles" 
                                      method="post" 
                                      style="display:inline;"
                                    >
                                        <input type="hidden" name="action" value="delete">
                                        <input type="hidden" name="id" value="<%= v.getId() %>">
                                        <button 
                                          type="submit" 
                                          class="btn btn-sm btn-dark" 
                                          onclick="return confirm('Are you sure you want to delete this vehicle?');"
                                        >
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
                                <td colspan="8" class="text-center">No vehicles found.</td>
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

    <!-- Add Vehicle Modal -->
    <div 
      class="modal fade" 
      id="addVehicleModal" 
      tabindex="-1" 
      aria-labelledby="addVehicleModalLabel" 
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title fw-bold" id="addVehicleModalLabel">Add New Vehicle</h5>
            <button 
              type="button" 
              class="btn-close" 
              data-bs-dismiss="modal" 
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <!-- Important: multipart/form-data for file upload -->
            <form 
              action="<%= request.getContextPath() %>/manageVehicles" 
              method="post" 
              enctype="multipart/form-data"
            >
              <input type="hidden" name="action" value="add">

              <!-- ID is auto-increment, so no ID field here -->
              <div class="mb-3">
                <label class="form-label fw-semibold">Model</label>
                <input 
                  type="text" 
                  class="form-control" 
                  name="model" 
                  required
                >
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Brand</label>
                <input 
                  type="text" 
                  class="form-control" 
                  name="brand" 
                  required
                >
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Type</label>
                <input 
                  type="text" 
                  class="form-control" 
                  name="type" 
                  required
                >
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Status</label>
                <select 
                  class="form-select" 
                  name="status" 
                  required
                >
                  <option value="Available">Available</option>
                  <option value="In Use">In Use</option>
                  <option value="Maintenance">Maintenance</option>
                </select>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">DriverID</label>
                <input 
                  type="number" 
                  class="form-control" 
                  name="driverID"
                >
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Image</label>
                <input 
                  type="file" 
                  class="form-control" 
                  name="image"
                >
              </div>
              <button 
                type="submit" 
                class="btn btn-warning w-100"
              >
                Add Vehicle
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>

    <!-- Edit Vehicle Modal -->
    <div 
      class="modal fade" 
      id="editVehicleModal" 
      tabindex="-1" 
      aria-labelledby="editVehicleModalLabel" 
      aria-hidden="true"
    >
      <div class="modal-dialog">
        <div class="modal-content">
          <div class="modal-header">
            <h5 class="modal-title fw-bold" id="editVehicleModalLabel">Edit Vehicle</h5>
            <button 
              type="button" 
              class="btn-close" 
              data-bs-dismiss="modal" 
              aria-label="Close"
            ></button>
          </div>
          <div class="modal-body">
            <!-- multipart/form-data for file re-upload -->
            <form 
              action="<%= request.getContextPath() %>/manageVehicles" 
              method="post" 
              enctype="multipart/form-data"
            >
              <input type="hidden" name="action" value="update">
              
              <!-- We'll store the ID in a hidden field -->
              <input 
                type="hidden" 
                id="editId" 
                name="id"
              >

              <div class="mb-3">
                <label class="form-label fw-semibold">Model</label>
                <input 
                  type="text" 
                  class="form-control" 
                  name="model" 
                  id="editModel" 
                  required
                >
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Brand</label>
                <input 
                  type="text" 
                  class="form-control" 
                  name="brand" 
                  id="editBrand" 
                  required
                >
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Type</label>
                <input 
                  type="text" 
                  class="form-control" 
                  name="type" 
                  id="editType" 
                  required
                >
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Status</label>
                <select 
                  class="form-select" 
                  name="status" 
                  id="editStatus" 
                  required
                >
                  <option value="Available">Available</option>
                  <option value="In Use">In Use</option>
                  <option value="Maintenance">Maintenance</option>
                </select>
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">DriverID</label>
                <input 
                  type="number" 
                  class="form-control" 
                  name="driverID" 
                  id="editDriverID"
                >
              </div>
              <div class="mb-3">
                <label class="form-label fw-semibold">Image (Upload to Replace)</label>
                <input 
                  type="file" 
                  class="form-control" 
                  name="image"
                >
              </div>
              <button 
                type="submit" 
                class="btn btn-warning w-100"
              >
                Save Changes
              </button>
            </form>
          </div>
        </div>
      </div>
    </div>

    <%@ include file="../Assests/scripts.jsp" %>
    <script>
      // JavaScript to populate Edit Modal fields
      var editModal = document.getElementById('editVehicleModal');
      editModal.addEventListener('show.bs.modal', function (event) {
          var button = event.relatedTarget;
          var id = button.getAttribute('data-id');
          var model = button.getAttribute('data-model');
          var brand = button.getAttribute('data-brand');
          var type = button.getAttribute('data-type');
          var status = button.getAttribute('data-status');
          var driverID = button.getAttribute('data-driverid');

          document.getElementById('editId').value = id;
          document.getElementById('editModel').value = model;
          document.getElementById('editBrand').value = brand;
          document.getElementById('editType').value = type;
          document.getElementById('editStatus').value = status;
          document.getElementById('editDriverID').value = driverID;
      });
    </script>
</body>
</html>
