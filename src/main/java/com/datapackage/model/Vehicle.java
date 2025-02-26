package com.datapackage.model;

public class Vehicle {
    private int id;             
    private String model;
    private String brand;
    private String type;
    private byte[] image;       
    private String status;
    private int driverID; 

    public Vehicle() {}

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getModel() {
        return model;
    }
    public void setModel(String model) {
        this.model = model;
    }

    public String getBrand() {
        return brand;
    }
    public void setBrand(String brand) {
        this.brand = brand;
    }

    public String getType() {
        return type;
    }
    public void setType(String type) {
        this.type = type;
    }

    public byte[] getImage() {
        return image;
    }
    public void setImage(byte[] image) {
        this.image = image;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public int getDriverID() {
        return driverID;
    }
    public void setDriverID(int driverID) {
        this.driverID = driverID;
    }
}
