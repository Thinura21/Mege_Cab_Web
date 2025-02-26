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
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String roleParam = request.getParameter("role"); // e.g. "Customer", "Driver", "Admin", "Staff"
        
        Connection con = null;
        PreparedStatement ps = null;
        ResultSet rs = null;
        
        try {
            con = DBConnection.getConnection();
            
            // Suppose your Users table has columns: Email, Password, Role, Name, Contact, Address
            String sql = "SELECT * FROM Users WHERE Email = ? AND Password = ? AND Role = ?";
            ps = con.prepareStatement(sql);
            ps.setString(1, email);
            ps.setString(2, password);
            ps.setString(3, roleParam);
            rs = ps.executeQuery();
            
            if (rs.next()) {
                // Successful login
                HttpSession session = request.getSession();
                
                String dbRole = rs.getString("Role");
                String dbName = rs.getString("Name"); // or adapt to your column name

                // Store in session
                session.setAttribute("userEmail", email);
                session.setAttribute("role", dbRole);
                session.setAttribute("userName", dbName);

                // Redirect to home page
                response.sendRedirect(request.getContextPath() + "/Views/index.jsp");
            } else {
                // Login failed
                response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=Invalid%20credentials");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp?error=An%20error%20occurred");
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
