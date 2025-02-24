package com.datapackage.controler;

import com.datapackage.dao.CustomerDao;
import com.datapackage.model.Customer;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/registerCustomer")
public class RegisterCustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDao customerDao;

    public void init() {
        customerDao = new CustomerDao();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        // Retrieve form data
        String name = request.getParameter("name");
        String email = request.getParameter("email");
        String password = request.getParameter("password");
        String nic = request.getParameter("nic");
        String contact = request.getParameter("contact");
        String address = request.getParameter("address");

        // Create Customer object (email will be used as unique key)
        com.datapackage.model.Customer customer = new com.datapackage.model.Customer();
        customer.setEmail(email);
        customer.setPassword(password);
        customer.setName(name);
        customer.setNic(nic);
        customer.setContact(contact);
        customer.setAddress(address);

        String message;
        try {
            int result = customerDao.registerCustomer(customer);
            if (result > 0) {
                message = "Customer registered successfully!";
            } else {
                message = "Failed to register customer!";
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            message = "An error occurred while registering customer.";
        }

        request.setAttribute("message", message);
        RequestDispatcher rd = request.getRequestDispatcher("/Views/login.jsp");
        rd.forward(request, response);
    }
}
