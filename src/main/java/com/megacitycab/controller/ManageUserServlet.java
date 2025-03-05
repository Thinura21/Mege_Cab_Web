package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.util.List;
import com.megacitycab.dao.ManageUserDao;
import com.megacitycab.model.Users;

@WebServlet("/manageUser")
public class ManageUserServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ManageUserDao manageUserDao;
    
    public void init() {
        manageUserDao = new ManageUserDao();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String action = request.getParameter("action");
        if(action == null) {
            action = "list";
        }
        switch(action) {
            case "add":
                request.setAttribute("user", null);
                request.getRequestDispatcher("/Views/manageUser.jsp").forward(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteUser(request, response);
                break;
            case "list":
            default:
                listUsers(request, response);
                break;
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String action = request.getParameter("action");
        if(action == null) {
            action = "";
        }
        switch(action) {
            case "add":
                insertUser(request, response);
                break;
            case "edit":
                updateUser(request, response);
                break;
            default:
                doGet(request, response);
                break;
        }
    }
    
    private void listUsers(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        List<Users> userList = manageUserDao.getAllUsers();
        request.setAttribute("userList", userList);
        request.getRequestDispatcher("/Views/manageUser.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        Users user = manageUserDao.getUserById(userId);
        request.setAttribute("user", user);
        request.getRequestDispatcher("/Views/manageUser.jsp").forward(request, response);
    }
    
    private void insertUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String fName = request.getParameter("fName");
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        Users user = new Users();
        user.setF_name(fName);
        user.setAddress(address);
        user.setContact(contact);
        user.setUser_name(userName);
        user.setPassword(password);
        user.setRole(role);
        
        try {
            manageUserDao.insertUser(user);  
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/manageUser?action=list");
    }

    private void updateUser(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("userId"));
        String fName = request.getParameter("fName");
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String role = request.getParameter("role");
        
        Users user = new Users();
        user.setUser_id(userId);
        user.setF_name(fName);
        user.setAddress(address);
        user.setContact(contact);
        user.setUser_name(userName);
        user.setPassword(password);
        user.setRole(role);
        
        manageUserDao.updateUserAndRelated(user);
        response.sendRedirect(request.getContextPath() + "/manageUser?action=list");
    }

    
    private void deleteUser(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int userId = Integer.parseInt(request.getParameter("id"));
        manageUserDao.deleteUser(userId);
        response.sendRedirect(request.getContextPath() + "/manageUser?action=list");
    }
}
