<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Login</title>
    <!-- Link to your main theme stylesheet -->
    <link rel="stylesheet" type="text/css" href="<%= request.getContextPath() %>/Theme/styles.css">
    <style>
        /* Login page specific styles */
        body {
            background-color: var(--body-bg);
        }
        .login-container {
            max-width: 400px;
            margin: 100px auto;
            background-color: var(--white);
            padding: var(--spacing-lg);
            box-shadow: var(--box-shadow);
            border-radius: var(--border-radius);
        }
        .login-header {
            text-align: center;
            margin-bottom: var(--spacing-lg);
        }
        .login-form label {
            font-weight: 500;
        }
        .login-form input[type="text"],
        .login-form input[type="password"] {
            width: 100%;
            padding: var(--spacing-sm) var(--spacing-md);
            border: 1px solid var(--gray-light);
            border-radius: var(--border-radius);
            margin-bottom: var(--spacing-md);
        }
        .login-form input[type="submit"] {
            width: 100%;
            padding: var(--spacing-sm);
            border: none;
            border-radius: var(--border-radius);
            background-color: var(--primary);
            color: var(--white);
            font-weight: bold;
            cursor: pointer;
        }
        .login-form input[type="submit"]:hover {
            background-color: var(--primary-dark);
        }
        .login-footer {
            text-align: center;
            margin-top: var(--spacing-md);
        }
    </style>
</head>
<body>
    <div class="login-container">
        <div class="login-header">
            <h2>Login</h2>
        </div>
        <form class="login-form" action="<%= request.getContextPath() %>/loginServlet" method="post">
            <div class="form-group">
                <label for="uname">Username:</label>
                <input type="text" id="uname" name="uname" required>
            </div>
            <div class="form-group">
                <label for="password">Password:</label>
                <input type="password" id="password" name="password" required>
            </div>
            <input type="submit" value="Login">
        </form>
        <div class="login-footer">
            <p>Don't have an account? 
                <a href="<%= request.getContextPath() %>/Views/register.jsp">Register here</a>.
            </p>
        </div>
    </div>
</body>
</html>
