<%
    String status = (String) request.getAttribute("status");
    if ("success".equals(status)) {
%>
    <p>Event added successfully!</p>
<%
    } else if ("failed".equals(status)) {
%>
    <p>Failed to add event. Please try again.</p>
<%
    }
%>



<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>Add Event</title>
    <link rel="stylesheet" href="adminAddeventt.css">
</head>
<body>
    <header>
        <h1>Add Event</h1>
    </header>
    <main>
       <%
    String role = (String) session.getAttribute("role");
    if ("admin".equals(role)) {
       %>
    <form action="EventServlet" method="POST" class="add-event-form" enctype="multipart/form-data">
    <label for="title">Event Title:</label>
    <input type="text" id="title" name="title" required>

    <label for="description">Description:</label>
    <textarea id="description" name="description" rows="5" required></textarea>

    <label for="eventDate">Event Date:</label>
    <input type="date" id="eventDate" name="eventDate" required>

    <label for="image">Upload Image:</label>
    <input type="file" id="image" name="image" accept="image/*">

    <button type="submit">Add Event</button>
</form>
    
<%
    } else {
%>
    <p>You do not have permission to add events.</p>
<%
    }
%>

    </main>
</body>
</html>
