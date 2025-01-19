package com.company.servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/ProfileUpdateServlet")
public class editProfileServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String username = request.getParameter("username");
        String email = request.getParameter("email");
        String phone = request.getParameter("phone");
        String department = request.getParameter("department");
        String year = request.getParameter("year");
        String collegeId = request.getParameter("collegeId");

        // Use collegeId from session (assuming it's stored in session)
        String sessionCollegeId = (String) request.getSession().getAttribute("clgid");  // Assuming collegeId is stored in session
        
        if (sessionCollegeId == null) {
            System.out.println("College ID is null. Session might have expired.");
            request.setAttribute("status", "failed");
            request.setAttribute("message", "Session expired. Please log in again.");
            RequestDispatcher dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
            return;
        }

        System.out.println("College ID from session: " + sessionCollegeId);

        try {
            // Database connection setup
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false", "root", "1234");

            // Print SQL query and parameters for debugging
            String query = "UPDATE users SET uname = ?, uemail = ?, uphone = ?, udpt = ?, uyear = ? WHERE uclgid = ?";
            System.out.println("SQL Query: " + query);
            System.out.println("Parameters - uname: " + username + ", uemail: " + email + ", uphone: " + phone + ", udpt: " + department + ", uyear: " + year + ", uclgid: " + collegeId);

            // Query to update the user's profile information
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, username);
            pst.setString(2, email);
            pst.setString(3, phone);
            pst.setString(4, department);
            pst.setString(5, year);
            pst.setString(6, sessionCollegeId);  // Use sessionCollegeId to identify the user

            int result = pst.executeUpdate();

            // If update is successful, update session attributes
            if (result > 0) {
                request.setAttribute("status", "success");
                request.setAttribute("message", "Profile updated successfully.");

                // Update session attributes with new values
                request.getSession().setAttribute("username", username);
                request.getSession().setAttribute("email", email);
                request.getSession().setAttribute("ph", phone);
                request.getSession().setAttribute("dept", department);
                request.getSession().setAttribute("year", year);
                request.getSession().setAttribute("clgid", collegeId);  // Optional if you want to update the collegeId too

            } else {
                request.setAttribute("status", "failed");
                request.setAttribute("message", "Profile update failed. Please try again.");
            }

        } catch (Exception e) {
            e.printStackTrace();  // Print the exception stack trace for debugging
            request.setAttribute("status", "failed");
            request.setAttribute("message", "An error occurred: " + e.getMessage());
        }

        // Forward the request with the message to the profile page
        RequestDispatcher dispatcher = request.getRequestDispatcher("profile.jsp");
        dispatcher.forward(request, response);
    }
}
