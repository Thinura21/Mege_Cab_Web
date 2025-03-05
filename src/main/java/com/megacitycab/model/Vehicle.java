package com.megacitycab.model;

public class Vehicle {
    private int vehicleId;
    private byte[] vehiclePhoto;
    private String model;
    private String licensePlate;
    private byte[] licensePlatePhoto;
    private String type;
    private String color;
    private String status;
    private int driverId;

    public int getVehicleId() { return vehicleId; }
    public void setVehicleId(int vehicleId) { this.vehicleId = vehicleId; }

    public byte[] getVehiclePhoto() { return vehiclePhoto; }
    public void setVehiclePhoto(byte[] vehiclePhoto) { this.vehiclePhoto = vehiclePhoto; }

    public String getModel() { return model; }
    public void setModel(String model) { this.model = model; }

    public String getLicensePlate() { return licensePlate; }
    public void setLicensePlate(String licensePlate) { this.licensePlate = licensePlate; }

    public byte[] getLicensePlatePhoto() { return licensePlatePhoto; }
    public void setLicensePlatePhoto(byte[] licensePlatePhoto) { this.licensePlatePhoto = licensePlatePhoto; }

    public String getType() { return type; }
    public void setType(String type) { this.type = type; }

    public String getColor() { return color; }
    public void setColor(String color) { this.color = color; }

    public String getStatus() { return status; }
    public void setStatus(String status) { this.status = status; }

    public int getDriverId() { return driverId; }
    public void setDriverId(int driverId) { this.driverId = driverId; }
}
