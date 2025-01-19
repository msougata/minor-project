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

@WebServlet("/DeleteThreadServlet")
public class DeleteThreadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        HttpSession session = request.getSession(false);
        Boolean loggedIn = (Boolean) (session != null ? session.getAttribute("loggedIn") : false);

        if (loggedIn == null || !loggedIn) {
            // Redirect to login if not logged in
            response.sendRedirect("login.jsp");
            return;
        }

        int threadId = Integer.parseInt(request.getParameter("threadId"));
        String dbURL = "jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false";
        String dbUser = "root";
        String dbPassword = "1234";

        try (Connection conn = DriverManager.getConnection(dbURL, dbUser, dbPassword)) {
            // SQL query to delete the thread
            String sql = "DELETE FROM threads WHERE id = ?";
            try (PreparedStatement pst = conn.prepareStatement(sql)) {
                pst.setInt(1, threadId);
                int rowsAffected = pst.executeUpdate();
                if (rowsAffected > 0) {
                    session.setAttribute("message", "Thread deleted successfully.");
                } else {
                    session.setAttribute("message", "Failed to delete the thread.");
                }
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("message", "An error occurred while deleting the thread.");
        }

        // Redirect back to home page
        response.sendRedirect("index.jsp");
    }
}
