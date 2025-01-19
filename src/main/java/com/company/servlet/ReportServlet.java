package com.company.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.SQLException;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ReportThreadServlet")
public class ReportServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Set content type for plain text response
        response.setContentType("application/json");

        // Get the session to fetch the username
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");

        // Debugging: Print session info to check if username exists
        System.out.println("Session username: " + username);

        // Check if the user is logged in (username should not be null)
        if (username == null || username.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"message\": \"You must be logged in to report a thread.\"}");
            return;
        }

        // Retrieve the 'threadId' and 'reason' parameters from the request
        String threadIdParam = request.getParameter("threadId");
        String reason = request.getParameter("reason");

        // Debugging: Print request parameters
        System.out.println("threadId: " + threadIdParam);
        System.out.println("reason: " + reason);

        // Validate if 'threadId' is present
        if (threadIdParam == null || threadIdParam.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\": \"Thread ID is missing or invalid.\"}");
            return;
        }

        // Validate if 'reason' is provided
        if (reason == null || reason.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\": \"Reason for reporting is missing.\"}");
            return;
        }

        // Convert 'threadId' from String to integer
        int threadId;
        try {
            threadId = Integer.parseInt(threadIdParam.trim());
        } catch (NumberFormatException e) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\": \"Invalid thread ID format.\"}");
            return;
        }

        // Database connection details
        String dbURL = "jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false";
        String dbUser = "root";
        String dbPassword = "1234";

        // Insert report into the database
        Connection conn = null;
        PreparedStatement stmt = null;
        try {
            // Establishing the connection to the database
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
            String sql = "INSERT INTO reports (thread_id, reported_by, reason, timestamp) VALUES (?, ?, ?, NOW())";
            stmt = conn.prepareStatement(sql);
            stmt.setInt(1, threadId);
            stmt.setString(2, username);
            stmt.setString(3, reason.trim());

            // Debugging: Print query execution details
            System.out.println("Executing SQL: " + sql);

            int rowsAffected = stmt.executeUpdate();

            if (rowsAffected > 0) {
            	 response.setContentType("text/html");
            	 response.getWriter().write("<script>alert('Thread reported successfully!'); window.location.href='index.jsp';</script>");

            } else {
                response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                response.getWriter().write("{\"message\": \"No rows affected, something went wrong.\"}");
            }

        } catch (SQLException e) {
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"message\": \"An error occurred while reporting the thread.\"}");
            e.printStackTrace();  // This will log the stack trace to the server console, which is helpful for debugging
        } finally {
            // Close resources in finally block
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();  // Log any exceptions that occur while closing resources
            }
        }
    }
}
