<!-- verifyOTP.jsp -->
<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
    <meta charset="UTF-8">
    <title>Verify OTP</title>
</head>
<body>
    <div class="container">
        <h1>Verify OTP</h1>
        <form action="VerifyOTPServlet" method="post">
            <div class="form-group">
                <label for="otp">Enter OTP</label>
                <input type="text" id="otp" name="otp" required="true">
            </div>
            <div class="form-group">
                <button type="submit">Verify OTP</button>
            </div>
        </form>
    </div>
</body>
</html>