package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.OutputStream;
import java.util.List;
import com.megacitycab.dao.ManageCustomerDao;
import com.megacitycab.dao.UserDao;
import com.megacitycab.model.Customer;
import com.megacitycab.model.Users;

@WebServlet("/manageCustomer")
@MultipartConfig(maxFileSize = 16177215)
public class ManageCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ManageCustomerDao manageCustomerDao;
    private UserDao userDao;
    
    public void init() {
        manageCustomerDao = new ManageCustomerDao();
        userDao = new UserDao();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String action = request.getParameter("action");
        if(action == null) {
            action = "list";
        }
        switch(action) {
            case "add":
                request.setAttribute("customer", null);
                request.getRequestDispatcher("/Views/manageCustomer.jsp").forward(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteCustomer(request, response);
                break;
            case "viewImage":
                viewImage(request, response);
                break;
            case "list":
            default:
                listCustomers(request, response);
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
                insertCustomer(request, response);
                break;
            case "edit":
                updateCustomer(request, response);
                break;
            default:
                doGet(request, response);
                break;
        }
    }
    
    private void listCustomers(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        List<Customer> customerList = manageCustomerDao.getAllCustomers();
        request.setAttribute("customerList", customerList);
        request.getRequestDispatcher("/Views/manageCustomer.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("id"));
        Customer customer = manageCustomerDao.getCustomerById(customerId);
        request.setAttribute("customer", customer);
        try {
            Users user = userDao.getUserById(customer.getUserId());
            request.setAttribute("userName", user != null ? user.getUser_name() : "");
            request.setAttribute("password", user != null ? user.getPassword() : "");
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        request.getRequestDispatcher("/Views/manageCustomer.jsp").forward(request, response);
    }
    
    private void insertCustomer(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String nic = request.getParameter("nic");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");
        byte[] profilePicture = null;
        
        // Retrieve profile picture part if provided
        Part filePart = request.getPart("profilePicture");
        if (filePart != null && filePart.getSize() > 0) {
            profilePicture = new byte[(int) filePart.getSize()];
            filePart.getInputStream().read(profilePicture);
        }
        
        // Create new user record for the customer:
        Users newUser = new Users();
        newUser.setF_name(name);
        newUser.setAddress(address);
        newUser.setContact(contact);
        newUser.setUser_name(userName);
        newUser.setPassword(password);
        newUser.setRole("Customer");
        
        int newUserId = 0;
        try {
            newUserId = userDao.insertUser(newUser);
        } catch (Exception e) {
            if (e instanceof java.sql.SQLIntegrityConstraintViolationException) {
                request.setAttribute("errorMessage", "User already exists. Please choose a different username.");
                request.getRequestDispatcher("/Views/manageCustomer.jsp").forward(request, response);
                return;
            } else {
                e.printStackTrace();
                request.setAttribute("errorMessage", "An unexpected error occurred while creating the user.");
                request.getRequestDispatcher("/Views/manageCustomer.jsp").forward(request, response);
                return;
            }
        }
        
        Customer customer = new Customer();
        customer.setUserId(newUserId);
        customer.setName(name);
        customer.setAddress(address);
        customer.setNic(nic);
        customer.setContact(contact);
        customer.setEmail(email);
        customer.setProfilePicture(profilePicture);
        
        try {
            manageCustomerDao.addCustomer(customer);
        } catch (Exception e) {
            if (e instanceof java.sql.SQLIntegrityConstraintViolationException) {
                request.setAttribute("errorMessage", "Error adding customer: " + e.getMessage());
                request.getRequestDispatcher("/Views/manageCustomer.jsp").forward(request, response);
                return;
            } else {
                e.printStackTrace();
                request.setAttribute("errorMessage", "An unexpected error occurred while adding the customer.");
                request.getRequestDispatcher("/Views/manageCustomer.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/manageCustomer?action=list");
    }
    
    private void updateCustomer(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("customerId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String nic = request.getParameter("nic");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        byte[] profilePicture = null;
        
        // Retrieve new image if provided
        Part filePart = request.getPart("profilePicture");
        if (filePart != null && filePart.getSize() > 0) {
            profilePicture = new byte[(int) filePart.getSize()];
            filePart.getInputStream().read(profilePicture);
        }
        
        Customer customer = new Customer();
        customer.setCustomerId(customerId);
        customer.setUserId(userId);
        customer.setName(name);
        customer.setAddress(address);
        customer.setNic(nic);
        customer.setContact(contact);
        customer.setEmail(email);
        if (profilePicture != null) {
            customer.setProfilePicture(profilePicture);
        }
        
        try {
            manageCustomerDao.editCustomer(customer);
            userDao.updateUser(userName, password, userId);
        } catch (Exception e) {
            if (e instanceof java.sql.SQLIntegrityConstraintViolationException) {
                request.setAttribute("errorMessage", "Error updating customer: " + e.getMessage());
                request.getRequestDispatcher("/Views/manageCustomer.jsp").forward(request, response);
                return;
            } else {
                e.printStackTrace();
                request.setAttribute("errorMessage", "An unexpected error occurred while updating the customer.");
                request.getRequestDispatcher("/Views/manageCustomer.jsp").forward(request, response);
                return;
            }
        }
        response.sendRedirect(request.getContextPath() + "/manageCustomer?action=list");
    }
    
    private void deleteCustomer(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int customerId = Integer.parseInt(request.getParameter("id"));
        manageCustomerDao.deleteCustomer(customerId);
        response.sendRedirect(request.getContextPath() + "/manageCustomer?action=list");
    }
    
    private void viewImage(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int customerId = Integer.parseInt(idParam);
            Customer customer = manageCustomerDao.getCustomerById(customerId);
            if (customer != null && customer.getProfilePicture() != null) {
                response.setContentType("image/jpeg");
                try (OutputStream out = response.getOutputStream()) {
                    out.write(customer.getProfilePicture());
                }
                return;
            }
        }
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
}
