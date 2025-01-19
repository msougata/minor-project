<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>User Profile</title>
    <link rel="stylesheet" href="profilee.css">

    <script>
        window.onload = function() {
            <% 
                String status = (String) request.getAttribute("status");
                if (status != null) {
                    String message = (String) request.getAttribute("message");
            %>
                alert("<%= message %>");
            <% 
                }
            %>
        };
    </script>
</head>
<body>
    <div class="profile-container">
        <div class="profile-header">
            <h1>User Profile</h1>
        </div>
<div class="profile-picture">
    <img src="<%= session.getAttribute("profile_pic") != null ? "Assets/profile_pic/" + session.getAttribute("profile_pic") : "Assets/profile_pic/default-profile.jpg" %>" 
         alt="Profile Picture">
</div>


        <div class="profile-details">
            <h2>Profile Information</h2>
            <p class="detail-item"><span>Username:</span> <%= session.getAttribute("username") != null ? session.getAttribute("username") : "Not Available" %></p>
            <p class="detail-item"><span>Email:</span> <%= session.getAttribute("email") != null ? session.getAttribute("email") : "Not Available" %></p>
            <p class="detail-item"><span>Phone No:</span> <%= session.getAttribute("ph") != null ? session.getAttribute("ph") : "Not Available" %></p>
            <p class="detail-item"><span>Department:</span> <%= session.getAttribute("dept") != null ? session.getAttribute("dept") : "Not Available" %></p>
            <p class="detail-item"><span>Year:</span> <%= session.getAttribute("year") != null ? session.getAttribute("year") : "Not Available" %></p>
            <p class="detail-item"><span>College ID:</span> <%= session.getAttribute("clgid") != null ? session.getAttribute("clgid") : "Not Available" %></p>
        </div>
        
        <div class="btn-container">
            <a href="editprofile.jsp" class="btn-edit">Edit Profile</a>
            <a href="index.jsp" class="btn-edit">Return to Home</a>
        </div>
    </div>
</body>
</html>
