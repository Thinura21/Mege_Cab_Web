package com.megacitycab.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;

import com.megacitycab.dao.UserDao;
import com.megacitycab.model.Users;

@WebServlet("/registerServlet")
public class registerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDao userDao;

    public void init() {
        userDao = new UserDao();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        RequestDispatcher rd = request.getRequestDispatcher("/Views/register.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String first_name = request.getParameter("f_name");
        String address = request.getParameter("Address");
        String contact = request.getParameter("Contact");
        String u_name = request.getParameter("user_name");
        String pass = request.getParameter("password");
        String role = request.getParameter("role"); // get role

        Users users = new Users();
        users.setF_name(first_name);
        users.setAddress(address);
        users.setContact(contact);
        users.setUser_name(u_name);
        users.setPassword(pass);
        users.setRole(role);

        String message = "Something went wrong. Please try again.";

        try {
            int result = userDao.register_Users(users);
            if (result > 0) {
                message = "User registered successfully!";
            } else {
                message = "Failed to register user.";
            }
        } catch (Exception e) {
            e.printStackTrace();
            message = "An error occurred during registration.";
        }

        request.setAttribute("message", message);
        RequestDispatcher rd = request.getRequestDispatcher("/Views/login.jsp");
        rd.forward(request, response);
    }
}
