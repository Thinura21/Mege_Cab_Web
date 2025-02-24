package com.datapackage.controler;

import com.datapackage.dao.DriverDao;
import com.datapackage.model.Driver;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;

@WebServlet("/registerDriver")
public class RegisterDriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DriverDao driverDao;

    public void init() {
        driverDao = new DriverDao();
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

        // Create Driver object (using email as unique key)
        Driver driver = new Driver();
        driver.setEmail(email);
        driver.setPassword(password);
        driver.setName(name);
        driver.setNic(nic);
        driver.setContact(contact);
        driver.setAddress(address);

        String message;
        try {
            int result = driverDao.registerDriver(driver);
            if (result > 0) {
                message = "Driver registered successfully!";
            } else {
                message = "Failed to register driver!";
            }
        } catch (ClassNotFoundException | SQLException e) {
            e.printStackTrace();
            message = "An error occurred while registering driver.";
        }

        request.setAttribute("message", message);
        RequestDispatcher rd = request.getRequestDispatcher("/Views/login.jsp");
        rd.forward(request, response);
    }
}
