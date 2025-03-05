package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;

@WebServlet("/logoutServlet")
public class logoutServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
    		
    		String contextPath = request.getContextPath();
        
        HttpSession session = request.getSession(false); // get existing session
        if (session != null) {
            session.invalidate();
        }
        response.sendRedirect(contextPath + "/Views/login.jsp");
    }
}
