package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;

import com.megacitycab.dao.ManageDriverDao;
import com.megacitycab.dao.UserDao;
import com.megacitycab.model.Driver;
import com.megacitycab.model.Vehicle;
import com.megacitycab.model.Users;

@WebServlet("/manageDriver")
@MultipartConfig(maxFileSize = 16177215) // Allows file uploads up to ~16MB
public class ManageDriverServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ManageDriverDao manageDriverDao;
    private UserDao userDao;
    
    @Override
    public void init() {
        manageDriverDao = new ManageDriverDao();
        userDao = new UserDao();
    }
    
    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        // Session check: Only allow if role is Staff or Admin.
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }
        String role = (String) session.getAttribute("role");
        if (!role.equalsIgnoreCase("Staff") && !role.equalsIgnoreCase("Admin")) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "list";
        }
        
        switch (action) {
            case "add":
                // Show form to add a new driver
                request.setAttribute("driver", null);
                request.setAttribute("vehicle", null);
                request.getRequestDispatcher("/Views/manageDriver.jsp").forward(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteDriver(request, response);
                break;
            case "viewImage":
                viewImage(request, response);
                break;
            case "list":
            default:
                listDrivers(request, response);
                break;
        }
    }
    
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        // Session check: Only allow if role is Staff or Admin.
        HttpSession session = request.getSession(false);
        if (session == null || session.getAttribute("role") == null) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }
        String role = (String) session.getAttribute("role");
        if (!role.equalsIgnoreCase("Staff") && !role.equalsIgnoreCase("Admin")) {
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }
        
        String action = request.getParameter("action");
        if (action == null) {
            action = "";
        }
        switch (action) {
            case "add":
                insertDriver(request, response);
                break;
            case "edit":
                updateDriver(request, response);
                break;
            default:
                doGet(request, response);
                break;
        }
    }
    
    // 1) List all drivers
    private void listDrivers(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        request.setAttribute("driverList", manageDriverDao.getAllDrivers());
        request.getRequestDispatcher("/Views/manageDriver.jsp").forward(request, response);
    }
    
    // 2) Show edit form for a specific driver
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("id"));
        Driver driver = manageDriverDao.getDriverById(driverId);
        request.setAttribute("driver", driver);
        
        // Retrieve vehicle by driverId
        Vehicle vehicle = manageDriverDao.getVehicleByDriverId(driverId);
        request.setAttribute("vehicle", vehicle);
        
        // Retrieve the linked user record to show userName/password
        try {
            Users user = userDao.getUserById(driver.getUserId());
            if (user != null) {
                request.setAttribute("userName", user.getUser_name());
                request.setAttribute("password", user.getPassword());
            }
        } catch (ClassNotFoundException e) {
            e.printStackTrace();
        }
        
        request.getRequestDispatcher("/Views/manageDriver.jsp").forward(request, response);
    }
    
    // 3) Insert a new driver + user + vehicle
    private void insertDriver(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        // --- Create a new user record for the driver ---
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        String fName = request.getParameter("fName");
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");
        
        // Create a new user with role "Driver"
        Users newUser = new Users();
        newUser.setF_name(fName);
        newUser.setAddress(address);
        newUser.setContact(contact);
        newUser.setUser_name(userName);
        newUser.setPassword(password);
        newUser.setRole("Driver");
        
        int newUserId = 0;
        try {
            newUserId = userDao.insertUser(newUser); // Insert user row
        } catch (ClassNotFoundException ex) {
            ex.printStackTrace();
        }
        
        // --- Create driver record ---
        String email = request.getParameter("email");
        String licenseNumber = request.getParameter("licenseNumber");
        
        // Read driver status & verified from form
        String status = request.getParameter("status"); // e.g. "Pending", "Active", "Inactive"
        if (status == null || status.isEmpty()) {
            status = "Pending";
        }
        boolean verified = "true".equals(request.getParameter("verified")); // from checkbox
        
        // Profile pictures
        Part driverPicPart = request.getPart("driverProfilePicture");
        byte[] driverProfilePicture = getBytesFromPart(driverPicPart);
        Part licencePhotoPart = request.getPart("licencePhoto");
        byte[] licencePhoto = getBytesFromPart(licencePhotoPart);
        
        Driver driver = new Driver();
        driver.setUserId(newUserId);
        driver.setFName(fName);
        driver.setAddress(address);
        driver.setContact(contact);
        driver.setEmail(email);
        driver.setLicenseNumber(licenseNumber);
        driver.setProfilePicture(driverProfilePicture);
        driver.setLicencePhoto(licencePhoto);
        driver.setStatus(status);
        driver.setVerified(verified);
        
        // --- Retrieve vehicle details ---
        String model = request.getParameter("model");
        String licensePlate = request.getParameter("licensePlate");
        String vehicleType = request.getParameter("vehicleType");
        String color = request.getParameter("color");
        
        Part vehiclePhotoPart = request.getPart("vehiclePhoto");
        byte[] vehiclePhoto = getBytesFromPart(vehiclePhotoPart);
        Part licensePlatePhotoPart = request.getPart("licensePlatePhoto");
        byte[] licensePlatePhoto = getBytesFromPart(licensePlatePhotoPart);
        
        Vehicle vehicle = new Vehicle();
        vehicle.setModel(model);
        vehicle.setLicensePlate(licensePlate);
        vehicle.setType(vehicleType);
        vehicle.setColor(color);
        vehicle.setVehiclePhoto(vehiclePhoto);
        vehicle.setLicensePlatePhoto(licensePlatePhoto);
        vehicle.setStatus("Pending");
        
        // Insert driver and associated vehicle
        manageDriverDao.addDriver(driver, vehicle);
        
        response.sendRedirect(request.getContextPath() + "/manageDriver?action=list");
    }
    
    // 4) Update existing driver + vehicle + user
    private void updateDriver(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("driverId"));
        int userId = Integer.parseInt(request.getParameter("userId"));
        
        String fName = request.getParameter("fName");
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");
        String licenseNumber = request.getParameter("licenseNumber");
        
        // Read driver status & verified from form
        String status = request.getParameter("status");
        boolean verified = "true".equals(request.getParameter("verified")); 
        
        // Profile pictures
        Part driverPicPart = request.getPart("driverProfilePicture");
        byte[] driverProfilePicture = getBytesFromPart(driverPicPart);
        Part licencePhotoPart = request.getPart("licencePhoto");
        byte[] licencePhoto = getBytesFromPart(licencePhotoPart);
        
        // Build the Driver object
        Driver driver = new Driver();
        driver.setDriverId(driverId);
        driver.setUserId(userId);
        driver.setFName(fName);
        driver.setAddress(address);
        driver.setContact(contact);
        driver.setEmail(email);
        driver.setLicenseNumber(licenseNumber);
        if (driverProfilePicture != null) driver.setProfilePicture(driverProfilePicture);
        if (licencePhoto != null) driver.setLicencePhoto(licencePhoto);
        driver.setStatus(status);
        driver.setVerified(verified);
        
        // Retrieve vehicle details
        String model = request.getParameter("model");
        String licensePlate = request.getParameter("licensePlate");
        String vehicleType = request.getParameter("vehicleType");
        String color = request.getParameter("color");
        
        Part vehiclePhotoPart = request.getPart("vehiclePhoto");
        byte[] vehiclePhoto = getBytesFromPart(vehiclePhotoPart);
        Part licensePlatePhotoPart = request.getPart("licensePlatePhoto");
        byte[] licensePlatePhoto = getBytesFromPart(licensePlatePhotoPart);
        
        Vehicle vehicle = new Vehicle();
        vehicle.setModel(model);
        vehicle.setLicensePlate(licensePlate);
        vehicle.setType(vehicleType);
        vehicle.setColor(color);
        if (vehiclePhoto != null) vehicle.setVehiclePhoto(vehiclePhoto);
        if (licensePlatePhoto != null) vehicle.setLicensePlatePhoto(licensePlatePhoto);
        
        // Check if a vehicle already exists for this driver
        Vehicle existingVehicle = manageDriverDao.getVehicleByDriverId(driverId);
        if (existingVehicle != null) {
            vehicle.setVehicleId(existingVehicle.getVehicleId());
            vehicle.setDriverId(driverId);
        }
        
        manageDriverDao.updateDriver(driver, vehicle);        
        String userName = request.getParameter("userName");
        String password = request.getParameter("password");
        manageDriverDao.updateUser(userName, password, userId);
        
        response.sendRedirect(request.getContextPath() + "/manageDriver?action=list");
    }
    
    // 5) Delete driver & associated vehicle
    private void deleteDriver(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int driverId = Integer.parseInt(request.getParameter("id"));
        int rowsAffected = manageDriverDao.deleteDriverAndVehicle(driverId);
        System.out.println("DEBUG: Deleted rows: " + rowsAffected);
        response.sendRedirect(request.getContextPath() + "/manageDriver?action=list");
    }
    
    private void viewImage(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int driverId = Integer.parseInt(idParam);
            Driver driver = manageDriverDao.getDriverById(driverId);
            if (driver != null && driver.getProfilePicture() != null) {
                response.setContentType("image/jpeg");
                try (OutputStream out = response.getOutputStream()) {
                    out.write(driver.getProfilePicture());
                }
                return;
            }
        }
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
    }
    
    // Utility to convert uploaded file Part to byte[]
    private byte[] getBytesFromPart(Part part) throws IOException {
        if (part != null && part.getSize() > 0) {
            try (InputStream is = part.getInputStream();
                 ByteArrayOutputStream buffer = new ByteArrayOutputStream()) {
                int nRead;
                byte[] data = new byte[1024];
                while ((nRead = is.read(data, 0, data.length)) != -1) {
                    buffer.write(data, 0, nRead);
                }
                return buffer.toByteArray();
            }
        }
        return null;
    }
}
