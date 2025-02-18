package com.datapackage.controller;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import com.datapackage.model.Customer;
import com.datapackage.dao.CustomerDao;

@WebServlet("/customerServlet")
public class CustomerServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private CustomerDao customerDao;

    public void init() {
        customerDao = new CustomerDao();
    }

    protected void doGet(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        request.setAttribute("customers", customerDao.getAllCustomers());
        RequestDispatcher rd = request.getRequestDispatcher("/Views/customers.jsp");
        rd.forward(request, response);
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String action = request.getParameter("action");

        if ("delete".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            customerDao.deleteCustomer(id);
            response.sendRedirect("customerServlet");
        } else if ("update".equals(action)) {
            int id = Integer.parseInt(request.getParameter("id"));
            String nic = request.getParameter("nic");
            String name = request.getParameter("name");
            String address = request.getParameter("address");
            String contact = request.getParameter("contact");
            String userType = request.getParameter("userType");

            Customer customer = new Customer();
            customer.setId(id);
            customer.setNic(nic);
            customer.setName(name);
            customer.setAddress(address);
            customer.setContact(contact);
            customer.setUserType(userType);

            customerDao.updateCustomer(customer);
            response.sendRedirect("customerServlet");
        }
    }
}
