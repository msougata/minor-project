package com.company.servlet;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;
import java.sql.SQLException;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

@WebServlet("/ReThreadServlet")
public class ReThreadServlet extends HttpServlet {

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        // Get session info (username)
        HttpSession session = request.getSession();
        String username = (String) session.getAttribute("username");
        String department = (String) session.getAttribute("dept");
        String year = (String) session.getAttribute("year");

        if (username == null || username.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_UNAUTHORIZED);
            response.getWriter().write("{\"message\": \"You must be logged in to re-thread.\"}");
            return;
        }

        // Get re-thread data
        String originalThreadId = request.getParameter("originalThreadId");
        String content = request.getParameter("content");

        // Validate content (title is not editable, it will be fetched from the original thread)
        if (content == null || content.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\": \"Re-thread content is required.\"}");
            return;
        }

        // Validate originalThreadId (it must be a valid number)
        if (originalThreadId == null || originalThreadId.trim().isEmpty()) {
            response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
            response.getWriter().write("{\"message\": \"Original thread ID is required.\"}");
            return;
        }

        // Database credentials and connection
        String dbURL = "jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false";
        String dbUser = "root";
        String dbPassword = "1234";
        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);

            // Recursive query to find the original thread
            String getOriginalThreadQuery = 
                "WITH RECURSIVE original_thread AS ( " +
                "    SELECT id, title, info, image_url, original_thread_id " +
                "    FROM threads " +
                "    WHERE id = ? " +
                "    UNION ALL " +
                "    SELECT t.id, t.title, t.info, t.image_url, t.original_thread_id " +
                "    FROM threads t " +
                "    INNER JOIN original_thread o ON t.id = o.original_thread_id " +
                ") " +
                "SELECT title, info, image_url FROM original_thread WHERE original_thread_id IS NULL";

            stmt = conn.prepareStatement(getOriginalThreadQuery);
            stmt.setString(1, originalThreadId);
            rs = stmt.executeQuery();

            if (rs.next()) {
                String originalTitle = rs.getString("title");
                String originalContent = rs.getString("info");
                String originalImageUrl = rs.getString("image_url"); // Fetch the original image URL

                // SQL query for inserting the re-thread
                String sql = "INSERT INTO threads (username, department, year, title, info, timestamp, likes, comments, original_thread_id, re_info, image_url) VALUES (?,?,?,?,?,NOW(),0,0,?,?,?)";
                stmt = conn.prepareStatement(sql);
                stmt.setString(1, username);
                stmt.setString(2, department);
                stmt.setString(3, year);
                stmt.setString(4, originalTitle);  // Use the original title
                stmt.setString(5, originalContent);        // Use the original content
                stmt.setString(6, originalThreadId);
                stmt.setString(7, content);        // Store the new content in the `re_info` column
                stmt.setString(8, originalImageUrl); // Store the original image URL

                int rowsAffected = stmt.executeUpdate();

                if (rowsAffected > 0) {
                    session.setAttribute("successMessage", "Re-thread posted successfully.");
                    response.sendRedirect("index.jsp");  // Redirect back to the home page
                } else {
                    response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
                    response.getWriter().write("{\"message\": \"An error occurred while re-threading.\"}");
                }
            } else {
                response.setStatus(HttpServletResponse.SC_BAD_REQUEST);
                response.getWriter().write("{\"message\": \"Original thread not found.\"}");
            }
        } catch (SQLException e) {
            // Log more details about the exception
            e.printStackTrace();
            response.setStatus(HttpServletResponse.SC_INTERNAL_SERVER_ERROR);
            response.getWriter().write("{\"message\": \"Database error: " + e.getMessage() + "\"}");
        }

        
        finally {
            try {
                if (rs != null) rs.close();
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (SQLException e) {
                e.printStackTrace();
            }
        }
    }
}
