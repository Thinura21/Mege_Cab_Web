package com.megacitycab.model;

public class VehicleType {
    private int id;
    private String vehicleName;
    private double costPerKm;

    public VehicleType() {
    }

    public VehicleType(int id, String vehicleName, double costPerKm) {
        this.id = id;
        this.vehicleName = vehicleName;
        this.costPerKm = costPerKm;
    }

    public int getId() {
        return id;
    }
    public void setId(int id) {
        this.id = id;
    }

    public String getVehicleName() {
        return vehicleName;
    }
    public void setVehicleName(String vehicleName) {
        this.vehicleName = vehicleName;
    }

    public double getCostPerKm() {
        return costPerKm;
    }
    public void setCostPerKm(double costPerKm) {
        this.costPerKm = costPerKm;
    }
}
