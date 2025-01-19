package com.company.servlet;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

import java.io.IOException;
import java.io.PrintWriter;
import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/AddClubDetailsServlet")
public class AddClubDetailsServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {

        // Get the role from the session
        String role = (String) request.getSession().getAttribute("role");

        response.setContentType("text/html");
        PrintWriter out = response.getWriter();

        // If the role is not "admin", send an alert response
        if (role == null || !role.equals("admin")) {
            out.println("<script type=\"text/javascript\">");
            out.println("alert('You are not authorized to perform this action.');");
            out.println("window.history.back();"); // Redirect back to the previous page
            out.println("</script>");
            return;
        }

        // Get club details from the form
        String clubName = request.getParameter("clubName");
        String description = request.getParameter("description");
        String startDate = request.getParameter("startDate");
        String endDate = request.getParameter("endDate");
        String amount = request.getParameter("amount");
        String logoUrl = request.getParameter("logoUrl");

        try (Connection con = DriverManager.getConnection(
                "jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false", "root", "1234")) {
            
            Class.forName("com.mysql.cj.jdbc.Driver");

            // SQL query to insert club details into the database
            String query = "INSERT INTO club_details (club_name, description, start_date, end_date, amount, logo_url) VALUES (?, ?, ?, ?, ?, ?)";
            try (PreparedStatement pst = con.prepareStatement(query)) {
                pst.setString(1, clubName);
                pst.setString(2, description);
                pst.setString(3, startDate); // Ensure the date format is correct (YYYY-MM-DD)
                pst.setString(4, endDate);   // Ensure the date format is correct (YYYY-MM-DD)
                pst.setString(5, amount);
                pst.setString(6, logoUrl);

                // Execute the query and redirect based on the result
                int rowCount = pst.executeUpdate();
                if (rowCount > 0) {
                    response.sendRedirect("subscription.jsp?status=success");
                } else {
                    response.sendRedirect("addSubscription.jsp?status=failed");
                }
            }
        } catch (Exception e) {
            e.printStackTrace();
            response.sendRedirect("addSubscription.jsp?status=error");
        }
    }
}
