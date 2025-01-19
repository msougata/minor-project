package com.company.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/VerifyOTPServlet")
public class VerifyOTPServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public VerifyOTPServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String enteredOTP = request.getParameter("otp");

        HttpSession session = request.getSession();
        String generatedOTP = (String) session.getAttribute("otp");
        String[] chattingwebsite = (String[]) session.getAttribute("chattingwebsite");

        if (enteredOTP.equals(generatedOTP)) {
            // Store user data in database
            saveUserToDatabase(chattingwebsite);

            // Forward to success page
            response.sendRedirect("login.jsp");
        } else {
            // OTP did not match
            response.sendRedirect("signup_failed.jsp");
        }
    }

    private void saveUserToDatabase(String[] chattingwebsite) {
        String uname = chattingwebsite[0];
        String uemail = chattingwebsite[1];
        String uphone = chattingwebsite[2];
        String udpt = chattingwebsite[3];
        String uyear = chattingwebsite[4];
        String uclgid = chattingwebsite[5];
        String upwd = chattingwebsite[6];
        String profile_pic = chattingwebsite[7];

        try {
            // Explicitly load the MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");

            // Database connection details
            String jdbcUrl = "jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false&allowPublicKeyRetrieval=true";
            String jdbcUsername = "root";
            String jdbcPassword = "1234";

            try (Connection con = DriverManager.getConnection(jdbcUrl, jdbcUsername, jdbcPassword);
                 PreparedStatement pst = con.prepareStatement("INSERT INTO users(uname, uemail, uphone, udpt, uyear, uclgid, upwd, profile_pic) VALUES(?, ?, ?, ?, ?, ?, ?, ?)")) {

                // Set parameters in the prepared statement
                pst.setString(1, uname);
                pst.setString(2, uemail);
                pst.setString(3, uphone);
                pst.setString(4, udpt);
                pst.setString(5, uyear);
                pst.setString(6, uclgid);
                pst.setString(7, upwd);
                pst.setString(8, profile_pic);

                // Execute the update
                int rowCount = pst.executeUpdate();
                if (rowCount > 0) {
                    System.out.println("User successfully registered");
                }
            }

        } catch (ClassNotFoundException e) {
            // Handle error if the driver is not found
            e.printStackTrace();
        } catch (Exception e) {
            // Handle SQL errors
            e.printStackTrace();
        }
    }
}
