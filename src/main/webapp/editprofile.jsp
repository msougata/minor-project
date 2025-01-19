<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Edit Profile</title>
    <link rel="stylesheet" href="editprofilee.css">
</head>
<body>
    <div class="edit-container">
        <h2>Edit Profile</h2>
        <form action="ProfileUpdateServlet" method="POST">
            <label for="username">Username:</label>
            <input type="text" id="username" name="username" value="<%= session.getAttribute("username") %>" required>

            <label for="email">Email:</label>
            <input type="email" id="email" name="email" value="<%= session.getAttribute("email") %>" required>

            <label for="phone">Phone No:</label>
            <input type="text" id="phone" name="phone" value="<%= session.getAttribute("ph") != null ? session.getAttribute("ph") : "" %>">

            <label for="department">Department:</label>
            <input type="text" id="department" name="department" value="<%= session.getAttribute("dept") != null ? session.getAttribute("dept") : "" %>">

            <label for="year">Year:</label>
            <input type="text" id="year" name="year" value="<%= session.getAttribute("year") != null ? session.getAttribute("year") : "" %>">

            <label for="collegeId">College ID:</label>
            <input type="text" id="collegeId" name="collegeId" value="<%= session.getAttribute("clgid") != null ? session.getAttribute("clgid") : "" %>">

            <div class="btn-container">
            <button type="submit" class="btn">Save Changes</button>
            <a href="index.jsp" class="btn">return to Home</a>
            </div>
            
        </form>
    </div>
</body>
</html>
