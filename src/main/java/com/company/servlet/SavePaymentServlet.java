package com.company.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@WebServlet("/SavePaymentServlet")
public class SavePaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String paymentId = request.getParameter("paymentId");
        String clubName = request.getParameter("clubName");
        String amount = request.getParameter("amount");

        Connection connection = null;
        PreparedStatement statement = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Database connection details
            String jdbcURL = "jdbc:mysql://localhost:3306/chattingwebsite";
            String dbUser = "root";
            String dbPassword = "1234";

            connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            String sql = "INSERT INTO payments (payment_id, club_name, amount) VALUES (?, ?, ?)";
            statement = connection.prepareStatement(sql);
            statement.setString(1, paymentId);
            statement.setString(2, clubName);
            statement.setString(3, amount);

            int rowsInserted = statement.executeUpdate();
            if (rowsInserted > 0) {
                response.getWriter().println("Payment details saved successfully.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().println("Error saving payment details: " + e.getMessage());
        } finally {
            try {
                if (statement != null) statement.close();
                if (connection != null) connection.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
