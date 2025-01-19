// SignupServlet.java
package com.company.servlet;

import jakarta.servlet.*;
import jakarta.servlet.annotation.WebServlet;
import jakarta.servlet.http.*;
import java.io.IOException;
import javax.mail.*;
import javax.mail.internet.*;
import java.util.Properties;

@WebServlet("/SignupServlet")
public class SignupServlet extends HttpServlet {
    private static final long serialVersionUID = 1L;

    public SignupServlet() {
        super();
    }

    protected void doPost(HttpServletRequest request, HttpServletResponse response) throws ServletException, IOException {
        String uname = request.getParameter("name");
        String uemail = request.getParameter("email");
        String uphone = request.getParameter("phone");
        String udpt = request.getParameter("department");
        String uyear = request.getParameter("year");
        String uclgid = request.getParameter("clgid");
        String upwd = request.getParameter("password");

        // Generate OTP
        String otp = generateOTP();
        
        // Assign a random profile picture
        String[] profilePictures = {
            "blue.png",
            "orange.png",
            "red.png",
            "yellow.png",
        };
        String profile_pic = profilePictures[(int)(Math.random() * profilePictures.length)];

        // Store user info temporarily in session
        HttpSession session = request.getSession();
        session.setAttribute("chattingwebsite", new String[]{uname, uemail, uphone, udpt, uyear, uclgid, upwd, profile_pic});
        session.setAttribute("otp", otp);

        // Send OTP to the user's email
        sendOTP(uemail, otp);

        // Forward to OTP verification page
        RequestDispatcher dispatcher = request.getRequestDispatcher("verifyOTP.jsp");
        dispatcher.forward(request, response);
    }


    private String generateOTP() {
        int otp = (int)(Math.random() * 900000) + 100000;
        return String.valueOf(otp);
    }

    private void sendOTP(String toEmail, String otp) {
        String fromEmail = "clubloginotp.gen@gmail.com"; // Your Mailjet sender email
        String host = "in-v3.mailjet.com";
        String username = "cdb148fd97da0497c517bb8a060f7b3d";
        String password = "5649dc049da230606c171627a72cc956";

        Properties properties = new Properties();
        properties.put("mail.smtp.host", host);
        properties.put("mail.smtp.port", "587");
        properties.put("mail.smtp.auth", "true");
        properties.put("mail.smtp.starttls.enable", "true");

        Session session = Session.getInstance(properties, new Authenticator() {
            protected PasswordAuthentication getPasswordAuthentication() {
                return new PasswordAuthentication(username, password);
            }
        });

        try {
            // Create email message
            MimeMessage message = new MimeMessage(session);
            message.setFrom(new InternetAddress(fromEmail));
            message.addRecipient(Message.RecipientType.TO, new InternetAddress(toEmail));
            message.setSubject("Your OTP Code");
            message.setText("Your OTP code is: " + otp);

            // Send email
            Transport.send(message);
        } catch (MessagingException e) {
            e.printStackTrace();
        }
    }
}
