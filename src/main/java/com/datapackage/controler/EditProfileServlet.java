package com.datapackage.controler;

import com.datapackage.dao.DBConnection;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.*;

@WebServlet("/editProfile")
public class EditProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession();
        String userEmail = (String) session.getAttribute("userEmail");
        if(userEmail == null) {
            // Not logged in
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }

        String name = request.getParameter("name");
        String contact = request.getParameter("contact");
        String address = request.getParameter("address");
        
        try (Connection con = DBConnection.getConnection()) {
            String sql = "UPDATE Users SET Name=?, Contact=?, Address=? WHERE Email=?";
            try(PreparedStatement ps = con.prepareStatement(sql)) {
                ps.setString(1, name);
                ps.setString(2, contact);
                ps.setString(3, address);
                ps.setString(4, userEmail);
                ps.executeUpdate();
            }
        } catch(Exception e) {
            e.printStackTrace();
        }
        
        // Update session attribute "userName" if you want the home page to greet them by name
        session.setAttribute("userName", name);
        
        response.sendRedirect(request.getContextPath() + "/Views/index.jsp");
    }
}
