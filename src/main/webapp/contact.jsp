<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Contact Us</title>
    <link rel="stylesheet" href="contactUs.css">
</head>
<body>
    <header>
        <h1>Contact Us</h1>
    </header>
    <div class="container">
        <h2>We'd love to hear from you!</h2>
        <!-- Contact form -->
        <form action="ContactServlet" method="post">
            <label for="name">Your Name:</label>
            <input type="text" id="name" name="name" placeholder="Enter your name" required>

            <label for="email">Your Email:</label>
            <input type="email" id="email" name="email" placeholder="Enter your email" required>

            <label for="message">Message:</label>
            <textarea id="message" name="message" rows="5" placeholder="Type your message here..." required></textarea>

            <div class="btn">
                <button type="submit" class="btn-container">Send</button>
                <a  href="index.jsp" class="btn-container" ">return to Home</a>
            </div>

            
        </form>
    </div>
    <footer>
        &copy; 2024 Contact Page. All rights reserved.
    </footer>

    <!-- JavaScript for showing success message -->
    
    <script>
        <% 
            String successMessage = (String) request.getAttribute("successMessage");
            if (successMessage != null) { 
        %>
            alert("<%= successMessage %>");
        <% 
            } 
        %>
    </script>
</body>
</html>
