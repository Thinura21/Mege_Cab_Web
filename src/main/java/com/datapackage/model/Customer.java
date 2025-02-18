package com.datapackage.model;

public class Customer {

    private int id;
    private String nic;
    private String name;
    private String address;
    private String contact;
    private String password;
    private String userType;

    // Getters and Setters
    public int getId() { 
    	return id; 
    	}
    
    public void setId(int id) { 
    	this.id = id; 
    	}

    public String getNic() { 
    	return nic; 
    	}
    
    public void setNic(String nic) { 
    	this.nic = nic; 
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

    public String getContact() { 
    	return contact;
    	}
    
    public void setContact(String contact) { 
    	this.contact = contact;
    	}

    public String getPassword() { 
    	return password;
    	}
    
    public void setPassword(String password) { 
    	this.password = password;
    	}

    public String getUserType() { 
    	return userType;
    	}
    
    public void setUserType(String userType) { 
    	this.userType = userType;
    	}
}
