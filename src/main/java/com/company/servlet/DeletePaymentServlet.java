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
import jakarta.servlet.http.HttpSession;

@WebServlet("/DeletePaymentServlet")
public class DeletePaymentServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession();
        String userRole = (String) session.getAttribute("role"); // Get user role from session

        // Check if the user is an admin
        if (userRole == null || !userRole.equals("admin")) {
            response.setStatus(HttpServletResponse.SC_FORBIDDEN);  // 403 Forbidden status code
            response.getWriter().println("Access denied. Only admins can delete subscriptions.");
            return;
        }

        String clubId = request.getParameter("clubId"); // Get the club ID from the form
        if (clubId == null || clubId.isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);  // 400 Bad Request
            response.getWriter().println("Invalid club ID.");
            return;
        }

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

            // Assuming the unique identifier column in club_details table is 'id'
            String sql = "DELETE FROM club_details WHERE id = ?";
            statement = connection.prepareStatement(sql);
            statement.setString(1, clubId);

            int rowsDeleted = statement.executeUpdate();
            if (rowsDeleted > 0) {
                // Redirect back to subscription page if deletion is successful
                response.sendRedirect("subscription.jsp");
            } else {
                // Handle case where club ID is not found
                response.setStatus(HttpServletResponse.SC_NOT_FOUND);  // 404 Not Found
                response.getWriter().println("Error: Club not found or already deleted.");
            }
        } catch (Exception e) {
            e.printStackTrace();
            // Internal server error status code
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);  // 500 Internal Server Error
            response.getWriter().println("Error deleting club subscription: " + e.getMessage());
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
