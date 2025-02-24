<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
  <head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login - Mega City Cab</title>
    
    <%@ include file="../Assests/CDN_Links.jsp" %>
    <%@ include file="../../Assests/styles.jsp" %>
  </head>
  <body>
    <%@ include file="Navigation/hedding.jsp" %>
    
    <div class="login-container">
      <div class="login-card">
        <div class="login-header">
          <a href="index.jsp" class="text-dark text-decoration-none">
            <i class="fa-solid fa-taxi"></i>
            <h3 class="mb-0">Mega City Cab</h3>
          </a>
        </div>
        <div class="card-body p-4">
          <h4 class="text-center mb-4">Login to Your Account</h4>
          <form action="<%= request.getContextPath() %>/login" method="POST">
            <div class="mb-3">
              <label class="form-label">Email</label>
              <input type="email" class="form-control" name="email" required>
            </div>
            <div class="mb-3">
              <label class="form-label">Password</label>
              <input type="password" class="form-control" name="password" required>
            </div>
            <div class="mb-3 form-check">
              <input type="checkbox" class="form-check-input" id="remember">
              <label class="form-check-label" for="remember">Remember me</label>
            </div>
            <div class="mb-3">
              <select class="form-select" name="role" required>
                <option value="">Select Role</option>
                <option value="Customer">Customer</option>
                <option value="Driver">Driver</option>
              </select>
            </div>
            <button type="submit" class="btn btn-warning w-100 mb-3">Login</button>
            <div class="text-center">
              <a href="#" class="text-muted text-decoration-none">Forgot Password?</a>
              <p class="mt-3 mb-0">Don't have an account? <a href="register.jsp" class="text-warning">Register</a></p>
            </div>
          </form>
        </div>
      </div>
    </div>
    
    <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
  </body>
</html>
