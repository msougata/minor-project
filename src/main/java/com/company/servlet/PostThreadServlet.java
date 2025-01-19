package com.company.servlet;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;

@WebServlet("/PostThreadServlet")
@MultipartConfig
public class PostThreadServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        System.out.println("PostThreadServlet invoked."); // Debugging log
        
        HttpSession session = request.getSession(false); // Get existing session, do not create a new one
        Boolean loggedIn = (Boolean) (session != null ? session.getAttribute("loggedIn") : false);

        if (loggedIn == null || !loggedIn) {
            System.out.println("User not logged in."); // Debugging log
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve session attributes
        String username = (String) session.getAttribute("username");
        String department = (String) session.getAttribute("dept");
        String year = (String) session.getAttribute("year");

        if (username == null || department == null || year == null) {
            System.out.println("Session attributes missing."); // Debugging log
            session.setAttribute("error", "Session expired. Please log in again.");
            response.sendRedirect("login.jsp");
            return;
        }

        // Retrieve form parameters
        String title = request.getParameter("title") != null ? request.getParameter("title").trim() : "";
        String info = request.getParameter("content") != null ? request.getParameter("content").trim() : "";

        if (title.isEmpty() || info.isEmpty()) {
            System.out.println("Title or content is empty."); // Debugging log
            session.setAttribute("error", "Title and content cannot be empty.");
            response.sendRedirect("index.jsp");
            return;
        }

        // Handle image upload
        Part imagePart = request.getPart("image");
        String imageUrl = null;

        if (imagePart != null && imagePart.getSize() > 0) {
            try {
                imageUrl = uploadImageToImgBB(imagePart);
                System.out.println("Image uploaded successfully: " + imageUrl); // Debugging log
            } catch (IOException e) {
                e.printStackTrace();
                session.setAttribute("error", "Image upload failed: " + e.getMessage());
            }
        } else {
            System.out.println("No image provided."); // Debugging log
        }

        // Insert new thread into the database
        try (Connection con = DriverManager.getConnection("jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false", "root", "1234");
             PreparedStatement pst = con.prepareStatement(
                     "INSERT INTO threads (username, department, year, title, info, likes, comments, image_url, re_info) VALUES (?, ?, ?, ?, ?, 0, 0, ?, ?)")) {

            pst.setString(1, username);
            pst.setString(2, department);
            pst.setString(3, year);
            pst.setString(4, title);
            pst.setString(5, info);
            pst.setString(6, imageUrl); // Store the image URL
            pst.setString(7, null); // Placeholder for re_info column

            int rowsAffected = pst.executeUpdate();
            if (rowsAffected > 0) {
                System.out.println("Thread posted successfully."); // Debugging log
                session.setAttribute("threadPosted", "success");
            } else {
                System.out.println("Failed to post the thread."); // Debugging log
                session.setAttribute("error", "Failed to post the thread. Please try again.");
            }
        } catch (SQLException e) {
            e.printStackTrace();
            session.setAttribute("error", "Database error: " + e.getMessage());
        }

        // Fetch threads from the database
        List<Thread> threads = fetchThreads();

        // Set the threads as a request attribute
        request.setAttribute("threads", threads);

        // Forward to index.jsp to display the threads
        request.getRequestDispatcher("index.jsp").forward(request, response);
    }

    private String uploadImageToImgBB(Part imagePart) throws IOException {
        String apiKey = "8c33be69df83357c3867f21959421ada"; // Replace with your ImgBB API key
        String uploadUrl = "https://api.imgbb.com/1/upload?key=" + apiKey;

        String boundary = "----WebKitFormBoundary" + System.currentTimeMillis();
        HttpURLConnection connection = (HttpURLConnection) new URL(uploadUrl).openConnection();
        connection.setDoOutput(true);
        connection.setRequestMethod("POST");
        connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);

        try (DataOutputStream out = new DataOutputStream(connection.getOutputStream())) {
            out.writeBytes("--" + boundary + "\r\n");
            out.writeBytes("Content-Disposition: form-data; name=\"image\"; filename=\"" + imagePart.getSubmittedFileName() + "\"\r\n");
            out.writeBytes("Content-Type: " + imagePart.getContentType() + "\r\n\r\n");

            try (InputStream inputStream = imagePart.getInputStream()) {
                byte[] buffer = new byte[4096];
                int bytesRead;
                while ((bytesRead = inputStream.read(buffer)) != -1) {
                    out.write(buffer, 0, bytesRead);
                }
            }
            out.writeBytes("\r\n--" + boundary + "--\r\n");
            out.flush();

            try (BufferedReader in = new BufferedReader(new InputStreamReader(connection.getInputStream()))) {
                StringBuilder responseString = new StringBuilder();
                String inputLine;
                while ((inputLine = in.readLine()) != null) {
                    responseString.append(inputLine);
                }

                String responseJson = responseString.toString();
                String imageUrl = responseJson.split("\"url\":\"")[1].split("\"")[0];
                return imageUrl;
            }
        }
    }

    private List<Thread> fetchThreads() {
        List<Thread> threads = new ArrayList<>();
        String dbURL = "jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false";
        String dbUser = "root";
        String dbPassword = "1234";

        try (Connection con = DriverManager.getConnection(dbURL, dbUser, dbPassword);
             PreparedStatement pst = con.prepareStatement("SELECT * FROM threads ORDER BY timestamp DESC");
             ResultSet rs = pst.executeQuery()) {

            while (rs.next()) {
                String username = rs.getString("username");
                String department = rs.getString("department");
                String year = rs.getString("year");
                String title = rs.getString("title");
                String info = rs.getString("info");
                int likes = rs.getInt("likes");
                int comments = rs.getInt("comments");
                Timestamp timestamp = rs.getTimestamp("timestamp");
                String imageUrl = rs.getString("image_url");
                String reInfo = rs.getString("re_info");

                threads.add(new Thread(username, department, year, title, info, likes, comments, timestamp, imageUrl, reInfo));
            }
        } catch (SQLException e) {
            e.printStackTrace();
        }

        return threads;
    }

    private static class Thread {
        private String username;
        private String department;
        private String year;
        private String title;
        private String info;
        private int likes;
        private int comments;
        private Timestamp timestamp;
        private String imageUrl;
        private String reInfo;

        public Thread(String username, String department, String year, String title, String info, int likes, int comments, Timestamp timestamp, String imageUrl, String reInfo) {
            this.username = username;
            this.department = department;
            this.year = year;
            this.title = title;
            this.info = info;
            this.likes = likes;
            this.comments = comments;
            this.timestamp = timestamp;
            this.imageUrl = imageUrl;
            this.reInfo = reInfo;
        }

        public String getUsername() { return username; }
        public String getDepartment() { return department; }
        public String getYear() { return year; }
        public String getTitle() { return title; }
        public String getInfo() { return info; }
        public int getLikes() { return likes; }
        public int getComments() { return comments; }
        public Timestamp getTimestamp() { return timestamp; }
        public String getImageUrl() { return imageUrl; }
        public String getReInfo() { return reInfo; }
    }
}
