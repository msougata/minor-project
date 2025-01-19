<%@ page import="java.sql.*, java.util.*" %>
<%
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    String eventId = request.getParameter("id");
    Map<String, String> eventDetails = new HashMap<>();

    if (eventId != null) {
        try {
            con = DriverManager.getConnection("jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false", "root", "1234");

            String query = "SELECT * FROM events WHERE id = ?";
            pst = con.prepareStatement(query);
            pst.setInt(1, Integer.parseInt(eventId));
            rs = pst.executeQuery();

            if (rs.next()) {
                eventDetails.put("title", rs.getString("title"));
                eventDetails.put("description", rs.getString("description"));
                eventDetails.put("eventDate", rs.getString("event_date"));
                eventDetails.put("imageUrl", rs.getString("image_url"));
            } else {
                request.setAttribute("error", "Event not found.");
            }
        } catch (Exception e) {
            e.printStackTrace();
        } finally {
            if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (pst != null) try { pst.close(); } catch (SQLException e) { e.printStackTrace(); }
            if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
        }
    } else {
        request.setAttribute("error", "No event selected.");
    }
%>

<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Event Details</title>
    <link rel="stylesheet" href="eventDetails.css">
</head>
<body>
    <div class="event-details">
        <% if (eventDetails.isEmpty()) { %>
            <p><%= request.getAttribute("error") %></p>
        <% } else { %>
            <img src="<%= eventDetails.get("imageUrl") %>" alt="Event Image">
            <h1><%= eventDetails.get("title") %></h1>
            <p>Date: <%= eventDetails.get("eventDate") %></p>
            <p><%= eventDetails.get("description") %></p>
        <% } %>
    </div>
</body>
</html>
