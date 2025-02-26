package com.datapackage.controler;

import com.datapackage.dao.VehicleDao;
import com.datapackage.model.Vehicle;
import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.io.InputStream;
import java.sql.SQLException;
import java.util.List;

@WebServlet("/manageVehicles")
@MultipartConfig  // allows file uploads
public class VehicleManagementServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private VehicleDao vehicleDao;

    @Override
    public void init() {
        vehicleDao = new VehicleDao();
    }

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            String query = request.getParameter("q");
            List<Vehicle> vehicleList;
            if(query != null && !query.trim().isEmpty()) {
                vehicleList = vehicleDao.searchVehicles(query.trim());
            } else {
                vehicleList = vehicleDao.getAllVehicles();
            }
            request.setAttribute("vehicleList", vehicleList);
            RequestDispatcher rd = request.getRequestDispatcher("/Views/vehicleManagement.jsp");
            rd.forward(request, response);
        } catch (SQLException | ClassNotFoundException e) {
            e.printStackTrace();
            response.sendRedirect(request.getContextPath() + "/error.jsp");
        }
    }

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        String action = request.getParameter("action");
        if(action == null) action = "";

        try {
            switch(action) {
                case "add":
                    Vehicle newV = extractVehicleFromRequest(request);
                    vehicleDao.registerVehicle(newV);
                    break;

                case "update":
                    Vehicle updV = extractVehicleFromRequest(request);
                    vehicleDao.updateVehicle(updV);
                    break;

                case "delete":
                    int delId = Integer.parseInt(request.getParameter("id"));
                    vehicleDao.deleteVehicle(delId);
                    break;
                default:
                    // no action
                    break;
            }
        } catch (Exception e) {
            e.printStackTrace();
        }
        response.sendRedirect(request.getContextPath() + "/manageVehicles");
    }

    private Vehicle extractVehicleFromRequest(HttpServletRequest request) throws IOException, ServletException {
        Vehicle vehicle = new Vehicle();

        // If "id" is present, parse it; otherwise it's a new record
        String idStr = request.getParameter("id");
        if(idStr != null && !idStr.isEmpty()) {
            vehicle.setId(Integer.parseInt(idStr));
        }

        vehicle.setModel(request.getParameter("model"));
        vehicle.setBrand(request.getParameter("brand"));
        vehicle.setType(request.getParameter("type"));
        vehicle.setStatus(request.getParameter("status"));

        String driverIdStr = request.getParameter("driverID");
        if(driverIdStr != null && !driverIdStr.isEmpty()) {
            vehicle.setDriverID(Integer.parseInt(driverIdStr));
        }

        // Handle image part
        Part imagePart = request.getPart("image");
        if(imagePart != null && imagePart.getSize() > 0) {
            InputStream is = imagePart.getInputStream();
            byte[] imageBytes = is.readAllBytes();
            vehicle.setImage(imageBytes);
        } else {
            // If no new image is uploaded on update, you might want to keep the old image from DB
            // For simplicity, we’ll set it to null. Then your update method might overwrite with null.
            // Alternatively, you'd fetch the old image first or have a hidden field to preserve it.
            vehicle.setImage(null);
        }
        return vehicle;
    }
}
