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

    // doGet: List all drivers (or search if "q" is provided) and forward to JSP
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String query = request.getParameter("q");
            List<Driver> driverList;
            if(query != null && !query.trim().isEmpty()){
                driverList = driverDao.searchDrivers(query.trim());
            } else {
                driverList = driverDao.getAllDrivers();
            }
            request.setAttribute("driverList", driverList);
            RequestDispatcher rd = request.getRequestDispatcher("/Views/driverManagement.jsp");
            rd.forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    // doPost: Handle add, update, delete actions
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
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    String name = request.getParameter("name");
                    String address = request.getParameter("address");
                    String nic = request.getParameter("nic");
                    String contact = request.getParameter("contact");

                    Driver newDriver = new Driver();
                    newDriver.setEmail(email);
                    newDriver.setPassword(password);
                    newDriver.setName(name);
                    newDriver.setAddress(address);
                    newDriver.setNic(nic);
                    newDriver.setContact(contact);

                    driverDao.registerDriver(newDriver);
                    break;
                case "update":
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
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/manageDrivers");
    }
}
