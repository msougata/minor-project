<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ page import="java.sql.*, java.util.*, jakarta.servlet.http.*" %>
<!DOCTYPE html>
<html lang="en">
<head>
    <meta charset="UTF-8">
    <meta name="viewport" content="width=device-width, initial-scale=1.0">
    <title>ClubHub</title>

    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.0.0-beta3/css/all.min.css">
    <link rel="stylesheet" href="home.css">
    <style>
        /* Add custom styles for thread alignment */
        .container {
            display: flex;
            flex-direction: column;
            gap: 20px;
            padding: 20px;
        }

        .thread {
            display: inline-block;
            max-width: 90%;
            background-color: rgba(193, 246, 237, 0.8);
            backdrop-filter: blur(5px);
            border-radius: 8px;
            box-shadow: 0 2px 5px rgba(0, 0, 0, 0.1);
            padding: 20px;
            word-wrap: break-word;
            overflow-wrap: break-word;
            box-sizing: border-box;
        }

        /* Align the user's thread to the right */
        .user-thread {
            align-self: flex-end;
            background-color: rgba(193, 246, 237, 0.8);
        }

        /* Align others' threads to the left */
        .other-thread {
            align-self: flex-start;
            background-color: rgba(233, 233, 233, 0.8);
        }

        .thread-photo {
            height: 30vh;
        }

        .delete-btn {
            border: 1px solid white;
            background: none;
            border: none;
            font-size: 1em;
            color: #ff6f61;
            cursor: pointer;
            padding: 0;
            margin-left: 10px;
        }

        .delete-btn:hover {
            color: #ff2a1a;
        }

 .re-thread-badge {
    color: #4CAF50;
    font-weight: bold;
    font-size: 0.9em;
    background-color: #f1f1f1;
    padding: 3px 8px;
    border-radius: 10px;
    position: absolute; /* Absolute positioning to prevent overlap */
    top: 10px; /* Position it from the top of the thread container */
    right: 10px; /* Position it from the right edge */
    z-index: 10; /* Ensure it's above other elements */
}

        @media (max-width: 768px){
            .container{
                margin-top:30vh;
            }
        }
    </style>
    <script>
    function openReThreadModal(threadId, title, content) {
        const reThreadModal = document.getElementById("reThreadModal");
        reThreadModal.style.display = "flex";

        // Set hidden input field for the original thread ID
        document.getElementById("originalThreadId").value = threadId;

        // Set the logged-in user's username (Re-threading as)
        const loggedInUsername = "<%= session.getAttribute("username") %>";  // Dynamically insert the username from session
        document.getElementById("reThreadUsername").value = loggedInUsername;

        // Decode the content to handle newlines properly
        const decodedContent = decodeURIComponent(content.replace(/\+/g, ' '));
        const decodedTitle = decodeURIComponent(title.replace(/\+/g, ' '));

        // Set the original title and content in the read-only fields
        document.getElementById("originalTitle").value = decodedTitle;
        document.getElementById("originalContent").value = decodedContent;

        // Focus on the new content input area for the user to add their response
        document.getElementById("reThreadContent").focus();
    }




        function openReportModal(threadId) {
            const reportModal = document.getElementById("reportThreadModal");
            reportModal.style.display = "flex";
            document.getElementById("reportThreadId").value = threadId;
        }

        function closeModal() {
            document.getElementById("postThreadModal").style.display = "none";
            document.getElementById("reportThreadModal").style.display = "none";
            document.getElementById("reThreadModal").style.display = "none";
            
            
        }
        function openModal() {
            const loggedIn = <%= (session.getAttribute("loggedIn") != null && (Boolean) session.getAttribute("loggedIn")) %>;
            if (loggedIn) {
                document.getElementById("postThreadModal").style.display = "flex";
            } else {
                alert("You need to log in to post a thread.");
                window.location.href = "login.jsp";
            }
        }

        function likePost(threadId) {
            fetch('PostLikeServlet?threadId=' + threadId)
                .then(response => response.json())
                .then(data => {
                    if (data.success) {
                        document.getElementById('likes-' + threadId).innerText = data.likes;
                    } else {
                        alert(data.message);
                    }
                })
                .catch(error => {
                    console.error('Error:', error);
                    alert('There was an error processing your request.');
                });
        }
    </script>
</head>
<body>
    <div class="navbar">
        <img src="https://i.ibb.co/ky7rGFZ/LOGO.png" class="nav-logo">
        <ul class="nav-links">
            <li><a href="index.jsp">Home</a></li>
            <li><a href="profile.jsp">Profile</a></li>
            <li><a href="subscription.jsp">Subscriptions</a></li>
            <li><a href="contact.jsp">Contact us</a></li>
            <% 
                Boolean loggedIn = (Boolean) session.getAttribute("loggedIn"); 
                if (loggedIn != null && loggedIn) { 
            %>
                <li><a href="logout.jsp">Logout</a></li>
            <% 
                } else { 
            %>
                <li><a href="login.jsp">Log in</a></li>
                <li><a href="signup.jsp">Sign up</a></li>
            <% 
                } 
            %>
        </ul>
    </div>
    <div class="sidebar">
        <ul class="side-links">
            <li><a href="clubsmain.jsp"><i class="fas fa-fire"></i> <p>Our Clubs</p></a></li>
            <li><a href="event.jsp"><i class="fas fa-calendar-alt"></i><p>Events</p></a></li>
        </ul>
    </div>
    <div class="container">
        <h1 style="color:#C1F6ED;">Threads</h1>
        <br>
<% 
    String loggedInUsername = (String) session.getAttribute("username");
    String dbURL = "jdbc:mysql://localhost:3306/chattingwebsite?useSSL=false";
    String dbUser = "root";
    String dbPassword = "1234";
    Connection conn = null;
    PreparedStatement stmt = null;
    ResultSet rs = null;

    try {
        conn = DriverManager.getConnection(dbURL, dbUser, dbPassword);
        String sql = "SELECT t.*, u.profile_pic, t2.username AS original_username, t2.id AS original_thread_id, t2.image_url AS original_image_url " +
                     "FROM threads t " +
                     "JOIN users u ON t.username = u.uname " +
                     "LEFT JOIN threads t2 ON t.original_thread_id = t2.id ORDER BY t.timestamp DESC";
        stmt = conn.prepareStatement(sql);
        rs = stmt.executeQuery();

        while (rs.next()) {
            int threadId = rs.getInt("id");
            String username = rs.getString("username");
            String originalUsername = rs.getString("original_username"); // Original thread username
            String department = rs.getString("department");
            String year = rs.getString("year");
            String title = rs.getString("title");
            String info = rs.getString("info");
            String re_info = rs.getString("re_info");
            Timestamp timestamp = rs.getTimestamp("timestamp");
            int likes = rs.getInt("likes");
            int comments = rs.getInt("comments");
            String profilePic = rs.getString("profile_pic"); 
            String threadPhoto = rs.getString("image_url");
            Integer originalThreadId = rs.getInt("original_thread_id"); // Check if it's a re-thread
            String originalThreadPhoto = rs.getString("original_image_url"); // Original thread photo URL
            String threadClass = username.equals(loggedInUsername) ? "user-thread" : "other-thread"; 
            String reInfo = rs.getString("re_info"); // Fetch the re_info column
    %>

    <div class="thread <%= threadClass %>">
        <div class="profile-pic">
            <img src="<%= profilePic != null ? "Assets/profile_pic/" + profilePic : "Assets/profile_pic/default-profile.jpg" %>" alt="Profile Picture">
        </div>
        <div class="thread-content">
            <div class="thread-header">
                <!-- Display the new username if it's a re-thread -->
                <span class="username">
                    <% if (originalThreadId != 0) { %>
                        Re-threaded by: <%= username %> (Replying to <%= originalUsername %>)
                    <% } else { %>
                        <%= username %>
                    <% } %>
                </span>
                <span class="department"> <%= department %></span>
                <span class="year"> <%= year %></span>
                <span class="timestamp"> <%= timestamp %></span>
                <!-- Report Button -->
                <button class="action-btn" onclick="openReportModal(<%= threadId %>)">🚩 Report</button>

                <!-- Add Delete button -->
                <% if (loggedInUsername != null && loggedInUsername.equals(username)) { %>
                <form action="DeleteThreadServlet" method="post" style="display:inline;">
                    <input type="hidden" name="threadId" value="<%= threadId %>">
                    <button type="submit" class="action-btn" onclick="return confirm('Are you sure you want to delete this thread?')">❌</button>
                </form>
                <% } %>
            </div>
            <p class="thread-title"> <%= title %> </p>

            <!-- Display the original thread photo if it's a re-thread -->
            <% if (originalThreadId != 0 && originalThreadPhoto != null) { %>
                <img src="<%= originalThreadPhoto %>" alt="Original Thread Photo" class="thread-photo">
            <% } else if (threadPhoto != null) { %>
                <img src="<%= threadPhoto %>" alt="Thread Photo" class="thread-photo">
            <% } %>
            
            <p class="thread-info" style="font-size:1em;"> <%= info.replaceAll("\n", "<br>") %> </p><br><br>

            <% if (re_info != null && !re_info.trim().isEmpty()) { %>
                 <p class="thread-info" style="font-size:1em;"> <%= re_info.replaceAll("\n", "<br>") %> </p><br><br>
            <% } %>

            <div class="thread-actions">
                <!-- Add Re-thread Button -->
                <%@ page import="java.net.URLEncoder" %>
                
                <button class="action-btn" onclick="openReThreadModal(
    <%= threadId %>, 
    '<%= URLEncoder.encode(title, "UTF-8") %>', 
    '<%= URLEncoder.encode(info, "UTF-8") %>'
)">🔄 Re-thread</button>


                <button class="action-btn" onclick="likePost(<%= threadId %>)">
                  ❤️ <span id="likes-<%= threadId %>"><%= likes %></span>
                </button>
            </div>
            <% if (originalThreadId != 0) { %>
                <span class="re-thread-badge">Re-thread</span>
            <% } %>
        </div>
    </div>

<% 
        }
    } catch (Exception e) {
        e.printStackTrace();
    } finally {
        try {
            if (rs != null) rs.close();
            if (stmt != null) stmt.close();
            if (conn != null) conn.close();
        } catch (SQLException e) {
            e.printStackTrace();
        }
    }
%>

        
    </div>
    
<!-- Re-thread Modal -->
<div id="reThreadModal" class="modal" style="display: none;">
    <div class="modal-content">
        <span class="close" onclick="closeModal()">&times;</span>
        <h2>Re-thread</h2>
        <form action="ReThreadServlet" method="post">
            <input type="hidden" name="originalThreadId" id="originalThreadId">
            
            <!-- Display the Username (Re-threading User) -->
            <label for="username">Re-threading as:</label>
            <input type="text" name="username" id="reThreadUsername" readonly>
            
            <!-- Display Original Thread Title (read-only) -->
            <label for="originalTitle">Original Thread Title:</label>
            <input type="text" id="originalTitle" readonly>
            
            <!-- Display Original Thread Content (read-only) -->
            <label for="originalContent">Original Thread Content:</label>
            <textarea id="originalContent" readonly rows="5"></textarea>
            
            <!-- User's New Re-Thread Content -->
            <label for="reThreadContent">Your Re-thread Content:</label>
            <textarea name="content" id="reThreadContent" placeholder="Enter your re-thread content" rows="5" required></textarea>
            
            <button type="submit">Post Re-thread</button>
        </form>
    </div>
</div>


    
    <!-- Report Thread Modal -->
    <div id="reportThreadModal" class="modal">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Report Thread</h2>
            <form action="ReportThreadServlet" method="post">
                <input type="hidden" name="threadId" id="reportThreadId">
                <textarea name="reason" placeholder="Why are you reporting this thread?" rows="5" required></textarea>
                <button type="submit">Submit Report</button>
            </form>
        </div>
    </div>

    <!-- Floating Post Thread Button -->
    <button class="post-thread-button" onclick="openModal()">+</button>

    <!-- Modal for Posting Threads -->
    <div id="postThreadModal" class="modal" style="display: none;">
        <div class="modal-content">
            <span class="close" onclick="closeModal()">&times;</span>
            <h2>Post a New Thread</h2>
            <form action="PostThreadServlet" method="post" enctype="multipart/form-data">
                <input type="text" name="title" placeholder="Thread Title" required>
                <textarea name="content" placeholder="Thread Content" rows="5" required></textarea>
                <input type="file" name="image" accept="image/*">
                <button type="submit">Post Thread</button>
            </form>
        </div>
    </div>
</body>
</html>
