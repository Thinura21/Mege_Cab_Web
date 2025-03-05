package com.megacitycab.controller;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.ByteArrayOutputStream;
import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.util.List;
import com.megacitycab.dao.ManageVehicleDao;
import com.megacitycab.model.Vehicle;

@WebServlet("/manageVehicle")
@MultipartConfig(maxFileSize = 16177215) // approx 16MB
public class ManageVehicleServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private ManageVehicleDao manageVehicleDao;
    
    public void init() {
        manageVehicleDao = new ManageVehicleDao();
    }
    
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String action = request.getParameter("action");
        if(action == null) {
            action = "list";
        }
        switch(action) {
            case "add":
                request.setAttribute("vehicle", null);
                request.getRequestDispatcher("/Views/manageVehicle.jsp").forward(request, response);
                break;
            case "edit":
                showEditForm(request, response);
                break;
            case "delete":
                deleteVehicle(request, response);
                break;
            case "viewImage":
                viewImage(request, response);
                break;
            case "list":
            default:
                listVehicles(request, response);
                break;
        }
    }
    
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String action = request.getParameter("action");
        if(action == null) {
            action = "";
        }
        switch(action) {
            case "add":
                insertVehicle(request, response);
                break;
            case "edit":
                updateVehicle(request, response);
                break;
            default:
                doGet(request, response);
                break;
        }
    }
    
    private void listVehicles(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        List<Vehicle> vehicleList = manageVehicleDao.getAllVehicles();
        request.setAttribute("vehicleList", vehicleList);
        request.getRequestDispatcher("/Views/manageVehicle.jsp").forward(request, response);
    }
    
    private void showEditForm(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int vehicleId = Integer.parseInt(request.getParameter("id"));
        Vehicle vehicle = manageVehicleDao.getVehicleById(vehicleId);
        request.setAttribute("vehicle", vehicle);
        request.getRequestDispatcher("/Views/manageVehicle.jsp").forward(request, response);
    }
    
    private void insertVehicle(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        // For adding a vehicle, assume that driver_id is provided by the form.
        int driverId = Integer.parseInt(request.getParameter("driverId"));
        String model = request.getParameter("model");
        String licensePlate = request.getParameter("licensePlate");
        String type = request.getParameter("type");
        String color = request.getParameter("color");
        String status = request.getParameter("status");
        byte[] vehiclePhoto = getBytesFromPart(request.getPart("vehiclePhoto"));
        byte[] licensePlatePhoto = getBytesFromPart(request.getPart("licensePlatePhoto"));
        
        Vehicle vehicle = new Vehicle();
        vehicle.setDriverId(driverId);
        vehicle.setModel(model);
        vehicle.setLicensePlate(licensePlate);
        vehicle.setType(type);
        vehicle.setColor(color);
        vehicle.setStatus(status);
        vehicle.setVehiclePhoto(vehiclePhoto);
        vehicle.setLicensePlatePhoto(licensePlatePhoto);
        
        manageVehicleDao.addVehicle(vehicle);
        response.sendRedirect(request.getContextPath() + "/manageVehicle?action=list");
    }
    
    private void updateVehicle(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int vehicleId = Integer.parseInt(request.getParameter("vehicleId"));
        int driverId = Integer.parseInt(request.getParameter("driverId"));
        String model = request.getParameter("model");
        String licensePlate = request.getParameter("licensePlate");
        String type = request.getParameter("type");
        String color = request.getParameter("color");
        String status = request.getParameter("status");
        byte[] vehiclePhoto = getBytesFromPart(request.getPart("vehiclePhoto"));
        byte[] licensePlatePhoto = getBytesFromPart(request.getPart("licensePlatePhoto"));
        
        Vehicle vehicle = new Vehicle();
        vehicle.setVehicleId(vehicleId);
        vehicle.setDriverId(driverId);
        vehicle.setModel(model);
        vehicle.setLicensePlate(licensePlate);
        vehicle.setType(type);
        vehicle.setColor(color);
        vehicle.setStatus(status);
        if(vehiclePhoto != null) {
            vehicle.setVehiclePhoto(vehiclePhoto);
        }
        if(licensePlatePhoto != null) {
            vehicle.setLicensePlatePhoto(licensePlatePhoto);
        }
        
        manageVehicleDao.editVehicle(vehicle);
        response.sendRedirect(request.getContextPath() + "/manageVehicle?action=list");
    }
    
    private void deleteVehicle(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        int vehicleId = Integer.parseInt(request.getParameter("id"));
        manageVehicleDao.deleteVehicle(vehicleId);
        response.sendRedirect(request.getContextPath() + "/manageVehicle?action=list");
    }
    
    // Branch to stream vehicle photo as image
    private void viewImage(HttpServletRequest request, HttpServletResponse response)
         throws ServletException, IOException {
        String idParam = request.getParameter("id");
        if (idParam != null) {
            int vehicleId = Integer.parseInt(idParam);
            Vehicle vehicle = manageVehicleDao.getVehicleById(vehicleId);
            if (vehicle != null && vehicle.getVehiclePhoto() != null) {
                response.setContentType("image/jpeg"); // adjust if needed
                try (OutputStream out = response.getOutputStream()) {
                    out.write(vehicle.getVehiclePhoto());
                }
                return;
            }
        }
        response.sendError(HttpServletResponse.SC_NOT_FOUND);
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
