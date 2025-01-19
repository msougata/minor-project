package com.company.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/PostLikeServlet")
public class PostLikeServlet extends HttpServlet {
    private static final String DB_URL = "jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false";
    private static final String DB_USER = "root";
    private static final String DB_PASSWORD = "1234";

    @Override
    protected void doGet(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        response.setContentType("application/json");
        PrintWriter out = response.getWriter();

        // Check if the user is logged in
        HttpSession session = request.getSession(false); // Get session if it exists
        if (session == null || session.getAttribute("username") == null) {
            // User is not logged in
            out.write("{\"success\": false, \"message\": \"You must be logged in to like this post.\"}");
            return;
        }

        String username = (String) session.getAttribute("username");
        int threadId = Integer.parseInt(request.getParameter("threadId"));

        Connection conn = null;
        PreparedStatement stmt = null;
        ResultSet rs = null;

        try {
            conn = DriverManager.getConnection(DB_URL, DB_USER, DB_PASSWORD);

            // Check if the user has already liked this post
            String checkLikeSQL = "SELECT COUNT(*) FROM likes WHERE username = ? AND thread_id = ?";
            stmt = conn.prepareStatement(checkLikeSQL);
            stmt.setString(1, username);  // Use username instead of user_id
            stmt.setInt(2, threadId);
            rs = stmt.executeQuery();
            rs.next();

            if (rs.getInt(1) > 0) {
                out.write("{\"success\": false, \"message\": \"You have already liked this post.\"}");
                return;
            }

            // Update the like count for the thread
            String updateLikesSQL = "UPDATE threads SET likes = likes + 1 WHERE id = ?";
            stmt = conn.prepareStatement(updateLikesSQL);
            stmt.setInt(1, threadId);
            int rowsUpdated = stmt.executeUpdate();

            if (rowsUpdated > 0) {
                // Insert into the likes table to track the user's like
                String insertLikeSQL = "INSERT INTO likes (username, thread_id) VALUES (?, ?)";
                stmt = conn.prepareStatement(insertLikeSQL);
                stmt.setString(1, username);  // Use username
                stmt.setInt(2, threadId);
                stmt.executeUpdate();

                // Fetch the updated like count
                String fetchLikesSQL = "SELECT likes FROM threads WHERE id = ?";
                stmt = conn.prepareStatement(fetchLikesSQL);
                stmt.setInt(1, threadId);
                rs = stmt.executeQuery();

                if (rs.next()) {
                    int likes = rs.getInt("likes");
                    out.write("{\"success\": true, \"likes\": " + likes + "}");
                }
            } else {
                out.write("{\"success\": false, \"message\": \"Failed to update likes.\"}");
            }
        } catch (Exception e) {
            // Enhanced error logging
            e.printStackTrace();
            out.write("{\"success\": false, \"message\": \"An error occurred while liking the post. " +
                    "Error: " + e.getMessage() + "\"}");
        } finally {
            try {
                if (stmt != null) stmt.close();
                if (conn != null) conn.close();
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }
}
