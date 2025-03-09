package com.megacitycab.dao;

import java.sql.*;
import com.megacitycab.model.Payment;
import com.megacitycab.util.DBConnection;

public class PaymentDao {
    public int insertPayment(Payment payment) {
        int generatedId = 0;
        String sql = "INSERT INTO Payments (booking_id, customer_id, amount, payment_method, status) VALUES (?, ?, ?, ?, ?)";
        try (Connection conn = DBConnection.getConnection();
             PreparedStatement ps = conn.prepareStatement(sql, Statement.RETURN_GENERATED_KEYS)) {
            ps.setInt(1, payment.getBookingId());
            ps.setInt(2, payment.getCustomerId());
            ps.setDouble(3, payment.getAmount());
            ps.setString(4, payment.getPaymentMethod());
            ps.setString(5, payment.getStatus());
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
