package com.datapackage.controler;

import com.datapackage.dao.CustomerDao;
import com.datapackage.model.Customer;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manageCustomers")
public class CustomerManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDao customerDao;

    @Override
    public void init() {
        customerDao = new CustomerDao();
    }

    // doGet: Retrieve all customers (or search by query parameter "q") and forward to JSP
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String query = request.getParameter("q");
            List<Customer> customerList;
            if(query != null && !query.trim().isEmpty()){
                customerList = customerDao.searchCustomers(query.trim());
            } else {
                customerList = customerDao.getAllCustomers();
            }
            request.setAttribute("customerList", customerList);
            RequestDispatcher rd = request.getRequestDispatcher("/Views/customerManagement.jsp");
            rd.forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    // doPost: Handle add, update, and delete actions for customers
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if(action == null) {
            action = "";
        }
        try {
            switch(action) {
                case "add":
                    String email = request.getParameter("email");
                    String password = request.getParameter("password");
                    String name = request.getParameter("name");
                    String address = request.getParameter("address");
                    String nic = request.getParameter("nic");
                    String contact = request.getParameter("contact");

                    Customer newCustomer = new Customer();
                    newCustomer.setEmail(email);
                    newCustomer.setPassword(password);
                    newCustomer.setName(name);
                    newCustomer.setAddress(address);
                    newCustomer.setNic(nic);
                    newCustomer.setContact(contact);

                    customerDao.registerCustomer(newCustomer);
                    break;
                case "update":
                    int updateUserId = Integer.parseInt(request.getParameter("userId"));
                    String updateName = request.getParameter("name");
                    String updateAddress = request.getParameter("address");
                    String updateNic = request.getParameter("nic");
                    String updateContact = request.getParameter("contact");
                    customerDao.updateCustomer(updateUserId, updateName, updateAddress, updateNic, updateContact);
                    break;
                case "delete":
                    int deleteUserId = Integer.parseInt(request.getParameter("userId"));
                    customerDao.deleteCustomer(deleteUserId);
                    break;
                default:
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/manageCustomers");
    }
}
