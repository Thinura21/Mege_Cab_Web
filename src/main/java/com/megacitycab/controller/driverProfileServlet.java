package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.io.ByteArrayOutputStream;

import com.megacitycab.dao.DriverDao;
import com.megacitycab.dao.VehicleDao;
import com.megacitycab.model.Driver;
import com.megacitycab.model.Vehicle;

@WebServlet("/driverProfileServlet")
@MultipartConfig(maxFileSize = 16177215)
public class driverProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private DriverDao driverDao;
    private VehicleDao vehicleDao;
    
    public void init() {
        driverDao = new DriverDao();
        vehicleDao = new VehicleDao();
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        
        HttpSession session = request.getSession(false);
        if(session == null || session.getAttribute("userId") == null){
            response.sendRedirect(request.getContextPath() + "/Views/login.jsp");
            return;
        }
        
        int userId = (Integer) session.getAttribute("userId");
        
        // Retrieve Driver fields from form
        String fName = request.getParameter("fName");
        String address = request.getParameter("address");
        String contact = request.getParameter("contact");
        String email = request.getParameter("email");
        String licenseNumber = request.getParameter("licenseNumber");
        
        // Process driver's profile picture
        Part driverPicPart = request.getPart("driverProfilePicture");
        byte[] driverProfilePicture = getBytesFromPart(driverPicPart);
        
        // Process driver's licence photo
        Part licencePhotoPart = request.getPart("licencePhoto");
        byte[] licencePhoto = getBytesFromPart(licencePhotoPart);
        
        // Retrieve Vehicle fields from form
        String model = request.getParameter("model");
        String licensePlate = request.getParameter("licensePlate");
        String type = request.getParameter("type");
        String color = request.getParameter("color");
        
        // Process vehicle photo
        Part vehiclePhotoPart = request.getPart("vehiclePhoto");
        byte[] vehiclePhoto = getBytesFromPart(vehiclePhotoPart);
        
        // Process license plate photo
        Part licensePlatePhotoPart = request.getPart("licensePlatePhoto");
        byte[] licensePlatePhoto = getBytesFromPart(licensePlatePhotoPart);
        
        // Debug logs
        System.out.println("DEBUG: Driver Data - fName: " + fName + ", address: " + address + ", contact: " + contact +
                           ", email: " + email + ", licenseNumber: " + licenseNumber);
        System.out.println("DEBUG: Vehicle Data - model: " + model + ", licensePlate: " + licensePlate + ", type: " + type + ", color: " + color);
        
        // Process Driver record
        Driver existingDriver = driverDao.getDriverByUserId(userId);
        int driverResult = 0;
        if(existingDriver == null){
            // Insert new driver record (verified is set to false by default)
            Driver newDriver = new Driver();
            newDriver.setUserId(userId);
            newDriver.setFName(fName);
            newDriver.setAddress(address);
            newDriver.setContact(contact);
            newDriver.setEmail(email);
            newDriver.setLicenseNumber(licenseNumber);
            newDriver.setProfilePicture(driverProfilePicture);
            newDriver.setLicencePhoto(licencePhoto);
            newDriver.setStatus("Pending"); // default status; driver cannot verify themselves
            driverResult = driverDao.insertDriver(newDriver);
            System.out.println("DEBUG: Insert driver result: " + driverResult);
            // Retrieve the inserted driver record for vehicle processing
            existingDriver = driverDao.getDriverByUserId(userId);
        } else {
            // Update driver record (do not update verified field)
            existingDriver.setFName(fName);
            existingDriver.setAddress(address);
            existingDriver.setContact(contact);
            existingDriver.setEmail(email);
            existingDriver.setLicenseNumber(licenseNumber);
            if(driverProfilePicture != null) existingDriver.setProfilePicture(driverProfilePicture);
            if(licencePhoto != null) existingDriver.setLicencePhoto(licencePhoto);
            driverResult = driverDao.updateDriver(existingDriver);
            System.out.println("DEBUG: Update driver result: " + driverResult);
        }
        
        // Process Vehicle record
        int vehicleResult = 0;
        Vehicle existingVehicle = vehicleDao.getVehicleByDriverId(existingDriver.getDriverId());
        if(existingVehicle == null){
            // Insert new vehicle record
            Vehicle newVehicle = new Vehicle();
            newVehicle.setDriverId(existingDriver.getDriverId());
            newVehicle.setModel(model);
            newVehicle.setLicensePlate(licensePlate);
            newVehicle.setType(type);
            newVehicle.setColor(color);
            newVehicle.setVehiclePhoto(vehiclePhoto);
            newVehicle.setLicensePlatePhoto(licensePlatePhoto);
            newVehicle.setStatus("Pending"); // default status
            vehicleResult = vehicleDao.insertVehicle(newVehicle);
            System.out.println("DEBUG: Insert vehicle result: " + vehicleResult);
        } else {
            // Update vehicle record
            existingVehicle.setModel(model);
            existingVehicle.setLicensePlate(licensePlate);
            existingVehicle.setType(type);
            existingVehicle.setColor(color);
            if(vehiclePhoto != null) existingVehicle.setVehiclePhoto(vehiclePhoto);
            if(licensePlatePhoto != null) existingVehicle.setLicensePlatePhoto(licensePlatePhoto);
            vehicleResult = vehicleDao.updateVehicle(existingVehicle);
            System.out.println("DEBUG: Update vehicle result: " + vehicleResult);
        }
        
        if(driverResult > 0 && vehicleResult > 0){
            System.out.println("DEBUG: Driver and Vehicle records processed successfully.");
        } else {
            System.out.println("DEBUG: Failed to process driver or vehicle records.");
        }
        
        response.sendRedirect(request.getContextPath() + "/Views/home.jsp");
    }
    
    private byte[] getBytesFromPart(Part part) throws IOException {
        if(part != null && part.getSize() > 0){
            try(InputStream is = part.getInputStream();
                ByteArrayOutputStream buffer = new ByteArrayOutputStream()){
                int nRead;
                byte[] data = new byte[1024];
                while((nRead = is.read(data, 0, data.length)) != -1){
                    buffer.write(data, 0, nRead);
                }
                return buffer.toByteArray();
            }
        }
        return null;
    }
}
	