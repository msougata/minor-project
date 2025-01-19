package com.company.servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.HttpSession;

import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;
import java.sql.ResultSet;

@WebServlet("/LoginServlet")
public class LoginServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public LoginServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String usernameOrEmail = request.getParameter("username-email").trim();
        String password = request.getParameter("password").trim();
        RequestDispatcher dispatcher = null;

        try {
            // Database connection setup
            Class.forName("com.mysql.cj.jdbc.Driver");
            Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false", "root", "1234");

            // Query to check if the credentials match
            String query = "SELECT * FROM users WHERE (uemail = ? OR uname = ?) AND upwd = ?";
            PreparedStatement pst = con.prepareStatement(query);
            pst.setString(1, usernameOrEmail);
            pst.setString(2, usernameOrEmail);
            pst.setString(3, password);

            ResultSet rs = pst.executeQuery();

            if (rs.next()) {
                // Successful login
                String username = rs.getString("uname");
                String email = rs.getString("uemail");
                String ph = rs.getString("uphone");
                String dept = rs.getString("udpt");
                String year = rs.getString("uyear");
                String clgid = rs.getString("uclgid");
                String profile_pic = rs.getString("profile_pic");
                String role = rs.getString("role");
                

                // Set session attributes
                HttpSession session = request.getSession();
                session.setAttribute("loggedIn", true);  // This line ensures the user is marked as logged in
                session.setAttribute("username", username);
                session.setAttribute("email", email);
                session.setAttribute("ph", ph);
                session.setAttribute("dept", dept);
                session.setAttribute("year", year);
                session.setAttribute("clgid", clgid);
                session.setAttribute("profile_pic", profile_pic);
                session.setAttribute("role", role); // Store role in session

                request.setAttribute("status", "success");
                request.setAttribute("message", "You are successfully logged in.");
                dispatcher = request.getRequestDispatcher("index.jsp");
            } else {
                // Failed login
                request.setAttribute("status", "failed");
                request.setAttribute("message", "Invalid credentials. Please try again.");
                dispatcher = request.getRequestDispatcher("login.jsp");
            }

            dispatcher.forward(request, response);
        } catch (Exception e) {
            e.printStackTrace();
            // Handle exceptions appropriately
            request.setAttribute("status", "failed");
            request.setAttribute("message", "An error occurred. Please try again later.");
            dispatcher = request.getRequestDispatcher("login.jsp");
            dispatcher.forward(request, response);
        }
    }
}
