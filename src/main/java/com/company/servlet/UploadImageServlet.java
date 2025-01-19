package com.company.servlet;

import java.io.*;
import java.net.HttpURLConnection;
import java.net.URL;
import java.util.Scanner;
import jakarta.servlet.ServletException;
import jakarta.servlet.annotation.MultipartConfig;
import jakarta.servlet.http.HttpServlet;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import jakarta.servlet.http.Part;
import javax.imageio.ImageIO;
import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.ByteArrayOutputStream;
import jakarta.servlet.annotation.WebServlet;

@MultipartConfig(
    fileSizeThreshold = 1024 * 1024 * 2, // 2MB
    maxFileSize = 1024 * 1024 * 10,     // 10MB
    maxRequestSize = 1024 * 1024 * 50  // 50MB
)
@WebServlet("/UploadImageServlet")

public class UploadImageServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;
    private static final String IMGBB_API_KEY = "8c33be69df83357c3867f21959421ada"; // Replace with your actual ImgBB API key

    @Override
    protected void doPost(HttpServletRequest request, HttpServletResponse response)
            throws ServletException, IOException {
        try {
            // Retrieve the uploaded file
            Part filePart = request.getPart("image");
            if (filePart == null || filePart.getSize() == 0) {
                response.getWriter().write("<p style='color:red;'>No file uploaded. Please try again.</p>");
                return;
            }

            // Read the image from the uploaded file
            InputStream fileContent = filePart.getInputStream();
            BufferedImage originalImage = ImageIO.read(fileContent);

            // Compress the image (resize and reduce quality)
            BufferedImage compressedImage = compressImage(originalImage);

            // Convert the compressed image to byte array
            byte[] compressedImageBytes = imageToByteArray(compressedImage, "jpg");

            // Prepare the ImgBB API URL
            String apiUrl = "https://api.imgbb.com/1/upload?key=" + IMGBB_API_KEY;

            // Open a connection to the ImgBB API
            URL url = new URL(apiUrl);
            HttpURLConnection connection = (HttpURLConnection) url.openConnection();
            connection.setRequestMethod("POST");
            connection.setDoOutput(true);
            connection.setRequestProperty("Content-Type", "multipart/form-data");

            // Prepare form data
            String boundary = "----WebKitFormBoundary" + System.currentTimeMillis();
            connection.setRequestProperty("Content-Type", "multipart/form-data; boundary=" + boundary);

            // Start writing the data to the connection
            try (DataOutputStream out = new DataOutputStream(connection.getOutputStream())) {
                // Write the boundary
                out.writeBytes("--" + boundary + "\r\n");

                // Write the file field
                out.writeBytes("Content-Disposition: form-data; name=\"image\"; filename=\"" + filePart.getSubmittedFileName() + "\"\r\n");
                out.writeBytes("Content-Type: image/jpeg\r\n");
                out.writeBytes("\r\n");

                // Write the compressed image content
                out.write(compressedImageBytes);

                // End the form data
                out.writeBytes("\r\n");
                out.writeBytes("--" + boundary + "--\r\n");

                out.flush();
            }

            // Get the response from ImgBB
            int responseCode = connection.getResponseCode();
            if (responseCode == HttpURLConnection.HTTP_OK) {
                InputStream responseStream = connection.getInputStream();
                String jsonResponse = new Scanner(responseStream, "UTF-8").useDelimiter("\\A").next();

                // Parse the JSON response to get the image URL
                org.json.JSONObject jsonObject = new org.json.JSONObject(jsonResponse);
                if (jsonObject.getBoolean("success")) {
                    String imageUrl = jsonObject.getJSONObject("data").getString("url");

                    // Redirect to the new page with the image URL as a query parameter
                    response.sendRedirect("displayImage.jsp?imageUrl=" + imageUrl);
                } else {
                    String errorMessage = jsonObject.getJSONObject("error").getString("message");
                    response.getWriter().write("<p style='color:red;'>Failed to upload image: " + errorMessage + "</p>");
                }
            } else {
                response.getWriter().write("<p style='color:red;'>HTTP error occurred: " + responseCode + "</p>");
            }

        } catch (Exception e) {
            e.printStackTrace();
            response.getWriter().write("<p style='color:red;'>An error occurred: " + e.getMessage() + "</p>");
        }
    }

    // Method to compress image (resize and reduce quality)
    private BufferedImage compressImage(BufferedImage originalImage) throws IOException {
        int width = originalImage.getWidth();
        int height = originalImage.getHeight();

        // Define the compression dimensions (you can adjust these values)
        int targetWidth = width / 4; // Resize to half the original width
        int targetHeight = height / 4; // Resize to half the original height

        // Create a new compressed image with reduced dimensions
        Image scaledImage = originalImage.getScaledInstance(targetWidth, targetHeight, Image.SCALE_SMOOTH);
        BufferedImage compressedImage = new BufferedImage(targetWidth, targetHeight, BufferedImage.TYPE_INT_RGB);
        Graphics2D g = compressedImage.createGraphics();
        g.drawImage(scaledImage, 0, 0, null);
        g.dispose();

        return compressedImage;
    }

    // Method to convert BufferedImage to byte array
    private byte[] imageToByteArray(BufferedImage image, String format) throws IOException {
        ByteArrayOutputStream baos = new ByteArrayOutputStream();
        ImageIO.write(image, format, baos);
        baos.flush();
        return baos.toByteArray();
    }
}
