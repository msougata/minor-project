<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="jakarta.servlet.http.HttpSession"%>
<%
    // Invalidate the session
    HttpSession sessionObj = request.getSession(false);
    if (sessionObj != null) {
        sessionObj.invalidate();  // Invalidate the session
    }
%>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Logout</title>
    <style>
        /* Styles for the logout message */
        #logout-message {
            position: fixed;
            top: 20%;
            left: 50%;
            transform: translateX(-50%);
            background-color: #4CAF50;
            color: white;
            padding: 20px;
            border-radius: 5px;
            font-size: 18px;
            box-shadow: 0 4px 8px rgba(0, 0, 0, 0.2);
            display: none;
            z-index: 1000;
        }
    </style>
</head>
<body>

    <!-- Logout message -->
    <div id="logout-message">
        You have successfully logged out!
    </div>

    <script type="text/javascript">
        // Show the logout message
        document.getElementById("logout-message").style.display = "block";

        // Redirect to the home page after 3 seconds
        setTimeout(function() {
            window.location.href = "index.jsp";
        }, 2000); // Delay redirect by 3 seconds to show the message
    </script>

</body>
</html>
