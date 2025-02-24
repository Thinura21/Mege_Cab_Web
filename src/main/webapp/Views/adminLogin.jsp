<%@ page contentType="text/html;charset=UTF-8" language="java" %>
<!DOCTYPE html>
<html lang="en">
<head>
  <meta charset="UTF-8">
  <meta name="viewport" content="width=device-width, initial-scale=1.0">
  <title>Admin &amp; Staff Login - Mega City Cab</title>
  
  <!-- Bootstrap CSS -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap/5.3.2/css/bootstrap.min.css" rel="stylesheet">
  <!-- Font Awesome -->
  <link href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.4.0/css/all.min.css" rel="stylesheet">
  <%@ include file="../../Assests/styles.jsp" %>
  
  <style>
    html, body {
      margin: 0;
      padding: 0;
      height: 100%;
      font-family: 'Poppins', sans-serif;
    }
    .bg-yellow {
      background-color: #FFC107; 
    }
    .left-panel {
      display: flex;
      flex-direction: column;
      justify-content: center;
      align-items: center;
    }
    .left-panel .fa-taxi {
      font-size: 4rem;
    }
    .left-panel h1 {
      margin-top: 1rem;
      font-weight: 700;
    }
    .login-form-container {
      max-width: 400px;
      width: 100%;
      margin: 0 auto;
    }
  </style>
</head>
<body>
  <div class="container-fluid h-100">
    <div class="row h-100">
      <!-- Left Side: White background with icon and text -->
      <div class="col-12 col-lg-6 left-panel bg-white">
        <i class="fa-solid fa-taxi"></i>
        <h1 class="text-warning mt-3">Mega City Cab</h1>
        <h4 class="text-dark">Admin &amp; Staff Login</h4>
      </div>
      <!-- Right Side: Yellow background with login form -->
      <div class="col-12 col-lg-6 d-flex flex-column justify-content-center bg-yellow">
        <div class="login-form-container">
          <h3 class="mb-4 fw-bold text-dark text-center">Log In</h3>
          <form action="<%= request.getContextPath() %>/login" method="POST">
            <div class="form-floating mb-3">
              <input type="text" class="form-control" name="email" placeholder="Email" required>
              <label for="email"><i class="fa-solid fa-user"></i> Email</label>
            </div>
            <div class="form-floating mb-3">
              <input type="password" class="form-control" name="password" placeholder="Password" required>
              <label for="password"><i class="fa-solid fa-lock"></i> Password</label>
            </div>
            <div class="form-floating mb-3">
              <select class="form-select" name="role" required>
                <option value="">Select Role</option>
                <option value="Admin">Admin</option>
                <option value="Staff">Staff</option>
              </select>
              <label for="role"><i class="fa-solid fa-user-shield"></i> Role</label>
            </div>
            <button type="submit" class="btn btn-dark w-100 btn-lg">Log In</button>
          </form>
        </div>
      </div>
    </div>
  </div>
  
  <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.0/dist/js/bootstrap.bundle.min.js"></script>
</body>
</html>
