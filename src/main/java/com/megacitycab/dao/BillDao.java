package com.megacitycab.dao;

import java.sql.*;
import com.megacitycab.model.Bill;
import com.megacitycab.util.DBConnection;

public class BillDao {
    public Bill getBillByBookingId(int bookingId) {
        Bill bill = null;
        String sql = "SELECT * FROM Bills WHERE booking_id = ?";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql)) {
            ps.setInt(1, bookingId);
            ResultSet rs = ps.executeQuery();
            if(rs.next()){
                bill = new Bill();
                bill.setBillId(rs.getInt("bill_id"));
                bill.setBookingId(rs.getInt("booking_id"));
                bill.setBaseAmount(rs.getDouble("base_amount"));
                bill.setDiscount(rs.getDouble("discount"));
                bill.setTotalAmount(rs.getDouble("total_amount"));
            }
        } catch(SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return bill;
    }
    
    public int insertBill(Bill bill) {
        int generatedId = 0;
        String sql = "INSERT INTO Bills (booking_id, base_amount, discount, total_amount) VALUES (?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, bill.getBookingId());
            ps.setDouble(2, bill.getBaseAmount());
            ps.setDouble(3, bill.getDiscount());
            ps.setDouble(4, bill.getTotalAmount());
            int rows = ps.executeUpdate();
            if(rows > 0) {
                ResultSet rs = ps.getGeneratedKeys();
                if(rs.next()){
                    generatedId = rs.getInt(1);
                }
            }
        } catch(SQLException | ClassNotFoundException e){
            e.printStackTrace();
        }
        return generatedId;
    }
}
