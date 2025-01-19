package com.company.servlet;

import jakarta.servlet.RequestDispatcher;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;

import java.io.IOException;
import java.io.InputStream;
import java.io.OutputStream;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;

import java.sql.Connection;
import java.sql.DriverManager;
import java.sql.PreparedStatement;

@WebServlet("/EventServlet")
@MultipartConfig // Enables file upload handling
public class EventServlet extends HttpServlet {
    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String role = (String) request.getSession().getAttribute("role");

        if (role == null || !role.equals("admin")) {
            response.sendRedirect("unauthorized.jsp"); // Redirect to an unauthorized page
            return;
        }

        String title = request.getParameter("title");
        String description = request.getParameter("description");
        String eventDate = request.getParameter("eventDate");
        String imageUrl = null;

        Part filePart = request.getPart("image"); // Retrieve the uploaded file part
        if (filePart != null && filePart.getSize() > 0) {
            imageUrl = uploadToImgBB(filePart);
        }

        RequestDispatcher dispatcher = null;
        Connection con = null;

        try {
            // Load MySQL JDBC driver
            Class.forName("com.mysql.cj.jdbc.Driver");
            // Connect to the database
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false", "root", "1234");

            // SQL query to insert event details into the database
            String query = "INSERT INTO events (title, description, event_date, image_url) VALUES (?, ?, ?, ?)";
            PreparedStatement pst = con.prepareStatement(query);

            // Set parameters for the prepared statement
            pst.setString(1, title);
            pst.setString(2, description);
            pst.setString(3, eventDate); // Ensure the date format is correct (YYYY-MM-DD)
            pst.setString(4, imageUrl);

            // Execute the query and check the result
            int rowCount = pst.executeUpdate();
            dispatcher = request.getRequestDispatcher("event.jsp");

            if (rowCount > 0) {
                request.setAttribute("status", "success");
            } else {
                request.setAttribute("status", "failed");
            }

            // Forward the request to the events.jsp page
            dispatcher.forward(request, response);

        } catch (Exception e) {
            e.printStackTrace();
            request.setAttribute("status", "failed");
            dispatcher = request.getRequestDispatcher("event.jsp");
            dispatcher.forward(request, response);

        } finally {
            // Close the database connection
            try {
                if (con != null) {
                    con.close();
                }
            } catch (Exception e) {
                e.printStackTrace();
            }
        }
    }

    private String uploadToImgBB(Part filePart) {
        String apiKey = "8c33be69df83357c3867f21959421ada"; // Replace with your ImgBB API key
        String uploadUrl = "https://api.imgbb.com/1/upload?key=" + apiKey;

        try {
            InputStream fileContent = filePart.getInputStream();
            byte[] fileBytes = fileContent.readAllBytes();

            // Create the connection
            HttpURLConnection connection = (HttpURLConnection) new URL(uploadUrl).openConnection();
            connection.setDoOutput(true);
            connection.setRequestMethod("POST");
            connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=----WebKitFormBoundary");

            // Build the multipart form data
            OutputStream outputStream = connection.getOutputStream();
            outputStream.write(("------WebKitFormBoundary\r\n" +
                    "Content-Disposition: form-data; name=\"image\"; filename=\"" + filePart.getSubmittedFileName() + "\"\r\n" +
                    "Content-Type: " + filePart.getContentType() + "\r\n\r\n").getBytes());
            outputStream.write(fileBytes);
            outputStream.write("\r\n------WebKitFormBoundary--\r\n".getBytes());
            outputStream.flush();
            outputStream.close();

            // Read the response
            Scanner scanner = new Scanner(connection.getInputStream());
            StringBuilder response = new StringBuilder();
            while (scanner.hasNextLine()) {
                response.append(scanner.nextLine());
            }
            scanner.close();

            // Extract the URL from the JSON response
            String responseBody = response.toString();
            String imageUrl = extractImageUrl(responseBody);
            return imageUrl;

        } catch (Exception e) {
            e.printStackTrace();
            return null; // Return null if upload fails
        }
    }

    private String extractImageUrl(String responseBody) {
        // Extract the "url" field from the JSON response
        int urlIndex = responseBody.indexOf("\"url\":\"") + 7;
        int endIndex = responseBody.indexOf("\"", urlIndex);
        if (urlIndex > 6 && endIndex > urlIndex) {
            return responseBody.substring(urlIndex, endIndex).replace("\\/", "/");
        }
        return null;
    }
}
