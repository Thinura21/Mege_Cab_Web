package com.datapackage.controler;

import com.datapackage.dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/login")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        // Retrieve form parameters
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleParam = request.getParameter("role");
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            String sql = "SELECT * FROM Users WHERE Email = ? AND Password = ? AND Role = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, roleParam);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // Successful login: set session attribute.
                HttpSession session = request.getSession();
                session.setAttribute("userEmail", email);
                
                // Retrieve the role from the DB.
                String role = rs.getString("Role");
                
                // Redirect based on role using a switch-case.
                switch (role) {
                    case "Customer":
                        response.sendRedirect(request.getContextPath() + "/customerDashboard.jsp");
                        break;
                    case "Driver":
                        response.sendRedirect(request.getContextPath() + "/driverDashboard.jsp");
                        break;
                    case "Admin":
                        response.sendRedirect(request.getContextPath() + "/adminDashboard.jsp");
                        break;
                    case "Staff":
                        response.sendRedirect(request.getContextPath() + "/staffDashboard.jsp");
                        break;
                    default:
                        response.sendRedirect(request.getContextPath() + "/login.jsp?error=Unknown%20role");
                        break;
                }
            } else {
                // Login failed: redirect back with error message.
                response.sendRedirect(request.getContextPath() + "/login.jsp?error=Invalid%20credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/login.jsp?error=An%20error%20occurred");
        } finally {
            try {
                if (rs != null) rs.close();
                if (ps != null) ps.close();
                if (con != null) con.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
