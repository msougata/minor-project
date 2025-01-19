
<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Login Page</title>
    <link rel="stylesheet" href="loginn.css">
    <style type="text/css" id="operaUserStyle"></style>
</head>
<body>
    <div class="login-container">
        <form action="LoginServlet" method="POST">
            <h2>Login</h2>

            <div class="input-group">
                <label for="username-email">Username or Email</label>
                <input type="text" id="username-email" name="username-email" placeholder="Enter your username or email" required=""/>
            </div>

            <div class="input-group">
                <label for="password">Password</label>
                <input type="password" id="password" name="password" placeholder="Enter your password" required=""/>
            </div>

            <div class="input-group">
                <button type="submit" class="login-btn">Login</button>
            </div>

            <div class="extra-options">
                <p><a href="#">Forgot Password?</a></p>
                <p>Don't have an account? <a href="signup.jsp">Sign up</a></p>
            </div>
        </form>

        <%
            String status = (String) request.getAttribute("status");
            if (status != null) {
                String message = (String) request.getAttribute("message");
                if ("success".equals(status)) {
        %>
                    <div class="alert success">
                        <strong>Success!</strong> <%= message %>
                    </div>
                    <script type="text/javascript">
                        // Redirect to home page after 2 seconds
                        setTimeout(function() {
                            window.location.href = "index.jsp";
                        }, 1000);
                    </script>
        <%
                } else if ("failed".equals(status)) {
        %>
                    <div class="alert error">
                        <strong>Error!</strong> <%= message %>
                    </div>
        <%
                }
            }
        %>
    </div>
</body>
</html>
