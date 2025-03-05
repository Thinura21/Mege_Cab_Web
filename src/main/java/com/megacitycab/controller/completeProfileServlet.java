package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;

import com.megacitycab.dao.CustomerDao;
import com.megacitycab.model.Customer;

@WebServlet("/completeProfileServlet")
@MultipartConfig(maxFileSize = 16177215) // approx 16MB
public class completeProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDao customerDao;
    
    public void init() {
        customerDao = new CustomerDao();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("userId") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }

        int userId = (Integer) session.getAttribute("userId");

        // Retrieve form parameters
        String name = request.getParameter("name");
        String address = request.getParameter("address");
        String nic = request.getParameter("nic");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");

        // Debug: Log received form data
        System.out.println("DEBUG: Received form data - name: " + name + ", address: " + address 
            + ", NIC: " + nic + ", contact: " + contact + ", email: " + email);

        // Process profile picture upload
        Part filePart = request.getPart("profilePicture");
        byte[] profilePictureBytes = null;
        if (filePart != null && filePart.getSize() > 0) {
            try (InputStream is = filePart.getInputStream();
                 ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {
                int nRead;
                byte[] data = new byte[1024];
                while ((nRead = is.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, nRead);
                }
                profilePictureBytes = buffer.toByteArray();
            }
        }

        // Try to fetch an existing Customer record for this user
        Customer existingCustomer = customerDao.getCustomerByUserId(userId);
        int result = 0;
        
        if (existingCustomer == null) {
            // No record exists: Insert a new Customer record.
            Customer newCustomer = new Customer();
            newCustomer.setUserId(userId);
            newCustomer.setName(name);
            newCustomer.setAddress(address);
            newCustomer.setNic(nic);
            newCustomer.setContact(contact);
            newCustomer.setEmail(email);
            newCustomer.setProfilePicture(profilePictureBytes);
            
            result = customerDao.insertCustomer(newCustomer);
            System.out.println("DEBUG: Insert result: " + result);
        } else {
            // Update existing Customer record.
            existingCustomer.setName(name);
            existingCustomer.setAddress(address);
            existingCustomer.setNic(nic);
            existingCustomer.setContact(contact);
            existingCustomer.setEmail(email);
            existingCustomer.setProfilePicture(profilePictureBytes);
            
            result = customerDao.updateCustomer(existingCustomer);
            System.out.println("DEBUG: Update result: " + result);
        }
        
        if (result > 0) {
            System.out.println("DEBUG: Customer record inserted/updated successfully.");
        } else {
            System.out.println("DEBUG: Failed to insert/update customer record.");
        }
        
        response.sendRedirect(request.getContextPath() + "/Views/home.jsp");
    }
}
