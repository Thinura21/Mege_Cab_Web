package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import com.megacitycab.dao.UserDao;
import com.megacitycab.dao.CustomerDao;
import com.megacitycab.dao.DriverDao;
import com.megacitycab.model.Users;
import com.megacitycab.model.Customer;
import com.megacitycab.model.Driver;

@WebServlet("/loginServlet")
public class loginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private UserDao userDao;
    private CustomerDao customerDao;
    private DriverDao driverDao;
    
    public void init() {
        userDao = new UserDao();
        customerDao = new CustomerDao();
        driverDao = new DriverDao();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        
        String uname = request.getParameter("uname");
        String password = request.getParameter("password");
        
        try {
            Users user = userDao.validate(uname, password);
            if (user != null) {
                HttpSession session = request.getSession();
                session.setAttribute("username", user.getUser_name());
                session.setAttribute("role", user.getRole());
                session.setAttribute("userId", user.getUser_id());
                session.setAttribute("f_name", user.getF_name());
                session.setAttribute("Address", user.getAddress());
                session.setAttribute("Contact", user.getContact());
                
                String contextPath = request.getContextPath();
                
                if ("Customer".equalsIgnoreCase(user.getRole())) {
                    Customer customer = customerDao.getCustomerByUserId(user.getUser_id());
                    if (!isCustomerProfileComplete(customer)) {
                        response.sendRedirect(contextPath + "/Views/completeProfile.jsp");
                    } else {
                        session.setAttribute("customerId", customer.getCustomerId());
                        response.sendRedirect(contextPath + "/Views/index.jsp");
                    }
                } else if ("Driver".equalsIgnoreCase(user.getRole())) {
                    Driver driver = driverDao.getDriverByUserId(user.getUser_id());
                    if (driver == null || !isDriverProfileComplete(driver)) {
                        response.sendRedirect(contextPath + "/Views/driverProfile.jsp");
                    } else {
                        session.setAttribute("driverId", driver.getDriverId());
                        session.setAttribute("verified", driver.isVerified());
                        response.sendRedirect(contextPath + "/Views/index.jsp");
                    }
                } else if ("Admin".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect(contextPath + "/Views/adminDashboard.jsp");
                } else if ("Staff".equalsIgnoreCase(user.getRole())) {
                    response.sendRedirect(contextPath + "/Views/staffDashboard.jsp");
                } else {
                    response.sendRedirect(contextPath + "/Views/home.jsp");
                }
            } else {
                response.sendRedirect(request.getContextPath() + "/Views/loginunsuccessful.jsp");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/Views/loginunsuccessful.jsp");
        }
    }
    
    // Check that the customer's required fields (name and NIC) are filled.
    private boolean isCustomerProfileComplete(Customer customer) {
        if (customer == null) {
            return false;
        }
        if (customer.getName() == null || customer.getName().trim().isEmpty()) {
            return false;
        }
        if (customer.getNic() == null || customer.getNic().trim().isEmpty()) {
            return false;
        }
        return true;
    }
    
    // For drivers, we require that fName and licenseNumber are filled.
    private boolean isDriverProfileComplete(Driver driver) {
        if (driver == null) {
            return false;
        }
        if (driver.getFName() == null || driver.getFName().trim().isEmpty()) {
            return false;
        }
        if (driver.getLicenseNumber() == null || driver.getLicenseNumber().trim().isEmpty()) {
            return false;
        }
        return true;
    }
}
