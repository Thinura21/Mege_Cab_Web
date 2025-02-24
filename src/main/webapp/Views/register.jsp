<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Register - Mega City Cab</title>
    
    <%@ include file="../Assests/CDN_Links.jsp" %>
    
    <%@ include file="../../Assests/styles.jsp" %>
    
    
    <link rel="stylesheet" href="css/style.css">
</head>
<body>
	<%@ include file="Navigation/hedding.jsp" %>
    <div class="register-container">
        <div class="register-card">
            <div class="register-header">
                <a href="index.jsp" class="text-dark text-decoration-none">
                    <i class="fa-solid fa-taxi"></i>
                    <h3 class="mb-0">Mega City Cab</h3>
                </a>
            </div>
            <div class="card-body p-4">
                <h4 class="text-center mb-4">Create New Account</h4>
                
                <!-- Registration Type Tabs -->
                <ul class="nav nav-tabs nav-fill mb-4" role="tablist">
                    <li class="nav-item">
                        <a class="nav-link active" data-bs-toggle="tab" href="#customer-form">Customer Registration</a>
                    </li>
                    <li class="nav-item">
                        <a class="nav-link" data-bs-toggle="tab" href="#driver-form">Driver Registration</a>
                    </li>
                </ul>

              <!-- Tab Content -->
				<div class="tab-content">
				    <!-- Customer Registration Form -->
				    <div id="customer-form" class="tab-pane fade show active">
				        <form action="<%= request.getContextPath() %>/registerCustomer" method="POST">
				            <input type="hidden" name="role" value="Customer">
				            <div class="mb-3">
				                <label class="form-label">Full Name</label>
				                <input type="text" class="form-control" name="name" required>
				            </div>
				            <div class="mb-3">
				                <label class="form-label">Email</label>
				                <input type="email" class="form-control" name="email" required>
				            </div>
				            <div class="mb-3">
				                <label class="form-label">Password</label>
				                <input type="password" class="form-control" name="password" required>
				            </div>
				            <div class="mb-3">
				                <label class="form-label">NIC Number</label>
				                <input type="text" class="form-control" name="nic" required>
				            </div>
				            <div class="mb-3">
				                <label class="form-label">Contact Number</label>
				                <input type="tel" class="form-control" name="contact" required>
				            </div>
				            <div class="mb-3">
				                <label class="form-label">Address</label>
				                <textarea class="form-control" name="address" rows="2" required></textarea>
				            </div>
				            <div class="mb-3 form-check">
				                <input type="checkbox" class="form-check-input" id="customerTerms" required>
				                <label class="form-check-label" for="customerTerms">
				                    I agree to the Terms and Conditions
				                </label>
				            </div>
				            <button type="submit" class="btn btn-warning w-100">Register as Customer</button>
				        </form>
				    </div>
				
				    <!-- Driver Registration Form -->
				    <div id="driver-form" class="tab-pane fade">
				        <form action="<%= request.getContextPath() %>/registerDriver" method="POST">
				            <input type="hidden" name="role" value="Driver">
				            <div class="mb-3">
				                <label class="form-label">Full Name</label>
				                <input type="text" class="form-control" name="name" required>
				            </div>
				            <div class="mb-3">
				                <label class="form-label">Email</label>
				                <input type="email" class="form-control" name="email" required>
				            </div>
				            <div class="mb-3">
				                <label class="form-label">Password</label>
				                <input type="password" class="form-control" name="password" required>
				            </div>
				            <div class="mb-3">
				                <label class="form-label">NIC Number</label>
				                <input type="text" class="form-control" name="nic" required>
				            </div>
				            <div class="mb-3">
				                <label class="form-label">Contact Number</label>
				                <input type="tel" class="form-control" name="contact" required>
				            </div>
				            <div class="mb-3">
				                <label class="form-label">Address</label>
				                <textarea class="form-control" name="address" rows="2" required></textarea>
				            </div>
				            <div class="mb-3 form-check">
				                <input type="checkbox" class="form-check-input" id="driverTerms" required>
				                <label class="form-check-label" for="driverTerms">
				                    I agree to the Terms and Conditions
				                </label>
				            </div>
				            <button type="submit" class="btn btn-warning w-100">Register as Driver</button>
				        </form>
				    </div>
				</div>
              
                <div class="text-center mt-3">
                    <p class="mb-0">Already have an account? <a href="login.jsp" class="text-warning">Login</a></p>
                </div>
            </div>
        </div>
    </div>
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
