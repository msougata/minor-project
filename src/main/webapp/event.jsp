<%@ page import="java.sql.*, java.util.*" %>
<%
    Connection con = null;
    PreparedStatement pst = null;
    ResultSet rs = null;

    List<Map<String, String>> upcomingEvents = new ArrayList<>();
    List<Map<String, String>> pastEvents = new ArrayList<>();

    try {
        con = DriverManager.getConnection("jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false", "root", "1234");

        // Query for upcoming events
        String queryUpcoming = "SELECT * FROM events WHERE event_date >= CURDATE() ORDER BY event_date ASC";
        pst = con.prepareStatement(queryUpcoming);
        rs = pst.executeQuery();
        while (rs.next()) {
            Map<String, String> event = new HashMap<>();
            event.put("title", rs.getString("title"));
            event.put("description", rs.getString("description"));
            event.put("eventDate", rs.getString("event_date"));
            event.put("imageUrl", rs.getString("image_url"));
            event.put("eventId", rs.getString("id")); // Assuming 'id' is the primary key
            upcomingEvents.add(event);
        }

        // Query for past events
        String queryPast = "SELECT * FROM events WHERE event_date < CURDATE() ORDER BY event_date DESC";
        pst = con.prepareStatement(queryPast);
        rs = pst.executeQuery();
        while (rs.next()) {
            Map<String, String> event = new HashMap<>();
            event.put("title", rs.getString("title"));
            event.put("description", rs.getString("description"));
            event.put("eventDate", rs.getString("event_date"));
            event.put("imageUrl", rs.getString("image_url"));
            event.put("eventId", rs.getString("id")); // Assuming 'id' is the primary key
            pastEvents.add(event);
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        if (rs != null) try { rs.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (pst != null) try { pst.close(); } catch (SQLException e) { e.printStackTrace(); }
        if (con != null) try { con.close(); } catch (SQLException e) { e.printStackTrace(); }
    }

    String role = (String) session.getAttribute("role"); // Retrieve role from the session
    boolean isLoggedIn = (role != null);
%>


<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>College Club Events</title>
    <link rel="stylesheet" href="event.css">
    <style>
        .event-date {
            font-style: italic;
            font-size: 0.9em;
            color: #555;
        }
        .event-description {
            max-height: 4.5em; /* Limit to 3 lines */
            overflow: hidden;
            text-overflow: ellipsis;
            white-space: nowrap;
        }

        .event-description.expanded {
            max-height: none; /* Remove the height limit */
            white-space: normal; /* Allow multiline text */
        }

        .toggle-button {
            border-radius: 4px;
            padding: 10px;
            background-color: #02353C;
            height: 5vh;
            color: white;
            cursor: pointer;
            text-decoration: none;
            display: inline-block;
            margin-top: 5px;
        }
    </style>
    <script>
        function toggleDescription(button, eventId) {
            const descriptionElement = document.getElementById('description-' + eventId);
            if (descriptionElement.classList.contains('expanded')) {
                descriptionElement.classList.remove('expanded');
                button.textContent = 'Read More';
            } else {
                descriptionElement.classList.add('expanded');
                button.textContent = 'Show Less';
            }
        }
    </script>
</head>
<body>
    <header>
        <div class="header-content">
            <h1>Events</h1>
            <nav>
                <ul class="nav-links">
                    <li><a href="index.jsp">Home</a></li>
                    <% if (isLoggedIn && "admin".equals(role)) { %>
                        <a href="adminAddEvent.jsp" class="add-event-button">Add Event</a>
                    <% } %>
                </ul>
            </nav>
        </div>
    </header>
    <main>
        <!-- Upcoming Events Section -->
        <section class="events-section">
            <h2>Upcoming Events</h2>
            <div class="events-grid">
                <% for (Map<String, String> event : upcomingEvents) { %>
                    <div class="event-card">
                        <img src="<%= event.get("imageUrl") %>" alt="<%= event.get("title") != null ? event.get("title") + " image" : "Untitled Event image" %>">
                        <h3><%= event.get("title") %></h3>
                        <p class="event-date"><%= event.get("eventDate") %></p>
                        <p id="description-<%= event.get("eventId") %>" class="event-description">
                            <%= event.get("description") %>
                        </p>
                        <div class="toggle-button" onclick="toggleDescription(this, '<%= event.get("eventId") %>')">Read More</div>
                    </div>
                <% } %>
            </div>
        </section>
        
        <!-- Past Events Section -->
        <section class="events-section">
            <h2>Past Events</h2>
            <div class="events-grid">
                <% for (Map<String, String> event : pastEvents) { %>
                    <div class="event-card past">
                        <img src="<%= event.get("imageUrl") %>" alt="<%= event.get("title") != null ? event.get("title") + " image" : "Untitled Event image" %>">
                        <h3><%= event.get("title") %></h3>
                        <p class="event-date"><%= event.get("eventDate") %></p>
                        <p id="description-<%= event.get("eventId") %>" class="event-description">
                            <%= event.get("description") %>
                        </p>
                        <span class="toggle-button" onclick="toggleDescription(this, '<%= event.get("eventId") %>')">Read More</span>
                    </div>
                <% } %>
            </div>
        </section>
    </main>
</body>
</html>
