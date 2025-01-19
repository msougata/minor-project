<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Club Details</title>
    <link rel="stylesheet" href="addSubscription.css">
</head>
<body>

    <div class="container">
        <h1>Add Club Subscription Details</h1>
        <form action="AddClubDetailsServlet" method="post">
            <label for="clubName">Club Name:</label>
            <input type="text" id="clubName" name="clubName" required>

            <label for="description">Description:</label>
            <textarea id="description" name="description" required></textarea>

            <label for="startDate">Start Date:</label>
            <input type="date" id="startDate" name="startDate" required>

            <label for="endDate">End Date:</label>
            <input type="date" id="endDate" name="endDate" required>

            <label for="amount">Amount:</label>
            <input type="number" id="amount" name="amount" required>

            <label for="logoUrl">Club Logo URL:</label>
            <input type="text" id="logoUrl" name="logoUrl" required>

            <button type="submit">Submit</button>
        </form>
    </div>
</body>
</html>
