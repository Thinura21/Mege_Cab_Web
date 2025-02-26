package com.datapackage.model;

import java.sql.Timestamp;

public class Booking {
    private String id;     
    private String name;
    private String address;
    private String nic;
    private String contact;
    private Timestamp dateTime;
    private String pickup;
    private String destination; 
    private String status;    
    private int customerID;    
    private String driverID;
    private String vehicleID;

    public Booking() {}

    // Getters and Setters

    public String getId() {
        return id;
    }
    public void setId(String id) {
        this.id = id;
    }

    public String getName() {
        return name;
    }
    public void setName(String name) {
        this.name = name;
    }

    public String getAddress() {
        return address;
    }
    public void setAddress(String address) {
        this.address = address;
    }

    public String getNic() {
        return nic;
    }
    public void setNic(String nic) {
        this.nic = nic;
    }

    public String getContact() {
        return contact;
    }
    public void setContact(String contact) {
        this.contact = contact;
    }

    public Timestamp getDateTime() {
        return dateTime;
    }
    public void setDateTime(Timestamp dateTime) {
        this.dateTime = dateTime;
    }

    public String getPickup() {
        return pickup;
    }
    public void setPickup(String pickup) {
        this.pickup = pickup;
    }

    public String getDestination() {
        return destination;
    }
    public void setDestination(String destination) {
        this.destination = destination;
    }

    public String getStatus() {
        return status;
    }
    public void setStatus(String status) {
        this.status = status;
    }

    public int getCustomerID() {
        return customerID;
    }
    public void setCustomerID(int customerID) {
        this.customerID = customerID;
    }

    public String getDriverID() {
        return driverID;
    }
    public void setDriverID(String driverID) {
        this.driverID = driverID;
    }

    public String getVehicleID() {
        return vehicleID;
    }
    public void setVehicleID(String vehicleID) {
        this.vehicleID = vehicleID;
    }
}
