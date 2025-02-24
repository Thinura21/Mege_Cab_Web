package com.datapackage.controler;

import com.datapackage.dao.DriverDao;
import com.datapackage.model.Driver;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manageDrivers")
public class DriverManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DriverDao driverDao;

    @Override
    public void init() {
        driverDao = new DriverDao();
    }

    // doGet: List all drivers and forward to driverManagement.jsp
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Fetch driver data
            List<Driver> driverList = driverDao.getAllDrivers();

            // Put the driver list in the request scope
            request.setAttribute("driverList", driverList);

            // Forward to /Views/driverManagement.jsp
            RequestDispatcher rd = request.getRequestDispatcher("Views/driverManagement.jsp");
            rd.forward(request, response);

        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            // If there's an error, you could forward or redirect to an error page
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    // doPost: Handle Add, Update, Delete actions
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {

        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }

        try {
            switch (action) {
                case "add":
                    // Gather fields from the add form
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    String name = request.getParameter("name");
                    String address = request.getParameter("address");
                    String nic = request.getParameter("nic");
                    String contact = request.getParameter("contact");

                    // Create a new Driver object
                    Driver newDriver = new Driver();
                    newDriver.setEmail(email);
                    newDriver.setPassword(password);
                    newDriver.setName(name);
                    newDriver.setAddress(address);
                    newDriver.setNic(nic);
                    newDriver.setContact(contact);

                    // Insert into DB
                    driverDao.registerDriver(newDriver);
                    break;

                case "update":
                    // Gather fields from the edit form
                    int updateUserId = Integer.parseInt(request.getParameter("userId"));
                    String updateName = request.getParameter("name");
                    String updateAddress = request.getParameter("address");
                    String updateNic = request.getParameter("nic");
                    String updateContact = request.getParameter("contact");

                    driverDao.updateDriver(updateUserId, updateName, updateAddress, updateNic, updateContact);
                    break;

                case "delete":
                    int deleteUserId = Integer.parseInt(request.getParameter("userId"));
                    driverDao.deleteDriver(deleteUserId);
                    break;

                default:
                    // No action specified
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Optionally handle or log the error
        }

        // After processing, redirect back to the management page (doGet)
        response.sendRedirect(request.getContextPath() + "/manageDrivers");
    }
}
