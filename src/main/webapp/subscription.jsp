<%@ page import="java.sql.*" %>
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Club Subscriptions</title>
    <link rel="stylesheet" href="subscriptioncss.css">
    <script src="https://checkout.razorpay.com/v1/checkout.js"></script> <!-- Razorpay script -->
    <script type="text/javascript">
        function checkAdminPermission(clubId) {
            var role = '<%= session.getAttribute("role") %>'; // Get the user's role from session
            
            if (role !== 'admin') {
                alert('You are not authorized to delete this subscription.');
                return false; // Prevent form submission
            }
            
            // If admin, allow the form submission
            return true;
        }
    </script>
</head>
<body>
    <div class="container">
        <header>
            <h1>College Club Subscription Page</h1>
            <p>Subscribe to your favorite college clubs and stay updated with their activities!</p>

            <!-- Conditionally display the "Add Subscription" button for admins -->
            <% 
                String userRole = (String) session.getAttribute("role");
                if (userRole != null && userRole.equals("admin")) {
            %>
                <a href="addSubscription.jsp" class="add-club-btn">Add Club Subscription</a>
            <% 
                }
            %>

            <a href="index.jsp" class="add-club-btn">Home</a> <!-- Button to go home -->
        </header>

        <!-- Subscription Table -->
        <div class="subscription-table">
            <table>
                <thead>
                    <tr>
                        <th>Club Logo</th>
                        <th>Club Name</th>
                        <th>Description</th>
                        <th>Start Date</th>
                        <th>End Date</th>
                        <th>Amount</th>
                        <th>Payment Option</th>
                        <th>Delete</th> <!-- Added a Delete column -->
                    </tr>
                </thead>
                <tbody>
                    <%
                        Connection connection = null;
                        Statement statement = null;
                        ResultSet resultSet = null;

                        try {
                            Class.forName("com.mysql.cj.jdbc.Driver");
                            String jdbcURL = "jdbc:mysql://localhost:3306/chattingwebsite";
                            String dbUser = "root";
                            String dbPassword = "1234";

                            connection = DriverManager.getConnection(jdbcURL, dbUser, dbPassword);
                            statement = connection.createStatement();
                            String sql = "SELECT * FROM club_details";
                            resultSet = statement.executeQuery(sql);

                            while (resultSet.next()) {
                                String clubId = resultSet.getString("id"); // Assuming the unique identifier is 'id'
                                String clubLogo = resultSet.getString("logo_url");
                                String clubName = resultSet.getString("club_name");
                                String description = resultSet.getString("description");
                                String startDate = resultSet.getString("start_date");
                                String endDate = resultSet.getString("end_date");
                                String amount = resultSet.getString("amount");
                    %>
                    <tr>
                        <td><img src="<%= clubLogo %>" alt="<%= clubName %> Logo" class="club-logo"></td>
                        <td><%= clubName %></td>
                        <td><%= description %></td>
                        <td><%= startDate %></td>
                        <td><%= endDate %></td>
                        <td>₹<%= amount %></td>
                        <td>
                            <button class="payment-btn" 
                                    onclick="initiatePayment('<%= clubName %>', <%= amount %>)">
                                Pay Now
                            </button>
                        </td>
                        <!-- Delete Button -->
                        <td>
                            <form action="DeletePaymentServlet" method="post" onsubmit="return checkAdminPermission('<%= clubId %>')">
                                <input type="hidden" name="clubId" value="<%= clubId %>">
                                <button type="submit" class="btn btn-delete">Delete</button>
                            </form>
                        </td>
                    </tr>
                    <%
                            }
                        } catch (Exception e) {
                            e.printStackTrace();
                    %>
                    <tr>
                        <td colspan="8">Error loading data: <%= e.getMessage() %></td>
                    </tr>
                    <%
                        } finally {
                            try {
                                if (resultSet != null) resultSet.close();
                                if (statement != null) statement.close();
                                if (connection != null) connection.close();
                            } catch (Exception e) {
                                e.printStackTrace();
                            }
                        }
                    %>
                </tbody>
            </table>
        </div>
    </div>

    <script>
        function initiatePayment(clubName, amount) {
            var options = {
                "key": "rzp_test_Big7cxagvzfBqR", // Razorpay API key
                "amount": amount * 100, // Amount in paise
                "currency": "INR",
                "name": clubName,
                "description": "Subscription Fee",
                "image": "example.com/logo.png", // Optional: Replace with your logo
                "handler": function (response) {
                    alert("Payment successful! Payment ID: " + response.razorpay_payment_id);
                    // Optionally, send the payment ID to the backend for verification
                },
                "prefill": {
                    "name": "", // Optionally prefill user's name
                    "email": "", // Optionally prefill user's email
                    "contact": "" // Optionally prefill user's contact
                },
                "theme": {
                    "color": "#F37254" // Customizable theme color
                }
            };

            var rzp1 = new Razorpay(options);
            rzp1.open();
        }
    </script>
</body>
</html>
