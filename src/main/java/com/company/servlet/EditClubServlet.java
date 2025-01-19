package com.company.servlet;

import java.io.*;
import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.sql.*;

@WebServlet("/EditClubServlet")

public class EditClubServlet extends HttpServlet {
	

    
	private static final long serialVersionUID = 1L;

	protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get the club ID and other details to be updated from the form
        String clubId = request.getParameter("clubId");
        String clubName = request.getParameter("clubName");
        String description = request.getParameter("description");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String amount = request.getParameter("amount");
        String logoUrl = request.getParameter("logoUrl");

        // Database connection variables
        Connection connection = null;
        PreparedStatement ps = null;

        try {
            // Load JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Database credentials
            String jdbcURL = "jdbc:mysql://localhost:3306/chattingwebsite";
            String dbUser = "root";
            String dbPassword = "1234";

            // Establish the connection
            connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);

            // SQL query to update the club details by its ID
            String sql = "UPDATE club_details SET club_name = ?, description = ?, start_date = ?, end_date = ?, amount = ?, logo_url = ? WHERE id = ?";
            ps = connection.prepareStatement(sql);

            // Set the values in the prepared statement
            ps.setString(1, clubName);
            ps.setString(2, description);
            ps.setString(3, startDate);
            ps.setString(4, endDate);
            ps.setString(5, amount);
            ps.setString(6, logoUrl);
            ps.setString(7, clubId); // Set the club ID

            // Execute the update query
            int result = ps.executeUpdate();

            if (result > 0) {
                // If the update is successful, redirect to the subscription page with a success message
                response.sendRedirect("subscriptionPage.jsp?message=Club+Updated+Successfully");
            } else {
                // If the update fails, redirect back to the subscription page with an error message
                response.sendRedirect("subscriptionPage.jsp?error=Failed+to+Update+Club");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("subscriptionPage.jsp?error=Error+Occurred+While+Updating+Club");
        } finally {
            try {
                if (ps != null) ps.close();
                if (connection != null) connection.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
