<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html lang="en">

    <head>
        <meta charset="UTF-8">
        <meta name="viewport" content="width=device-width, initial-scale=1.0">
        <title>College Clubs</title>
        <link rel="stylesheet" href="clubstyle.css"> <!-- Link to external CSS file -->
    </head>

    <body>
        <div class="container">
            <h2 class="header">College Clubs</h2>

            <!-- Static Clubs Section -->
            <div class="cards-container">
                <!-- Static Club 1 -->
                <div class="card">
                    <img src="https://i.ibb.co/0yTXfr6/png-20230704-210626-0000-2.png" alt="Club 1 Image"
                        class="card-image" />
                    <div class="card-content">
                        <h3 class="card-title">ANKURAN</h3>
                        <!-- Buttons Section -->
                        <div class="card-buttons">
                            <a href="clubankuran.jsp?clubId=1" class="btn card-button btn-info">View Details</a>
                        </div>
                    </div>
                </div>

                <!-- Static Club 2 -->
                <div class="card">
                    <img src="https://ibb.co/smt5YPj" alt="Club 2 Image" class="card-image" />
                    <div class="card-content">
                        <h3 class="card-title">GENESIS</h3>
                        <!-- Buttons Section -->
                        <div class="card-buttons">
                            <a href="clubgenesis.jsp?clubId=2" class="btn card-button btn-info">View Details</a>
                        </div>
                    </div>
                </div>

                <!-- Static Club 3 -->
                <div class="card">
                    <img src="https://i.ibb.co/rKhqNZQ/geekonix.png" alt="Club 3 Image" class="card-image" />
                    <div class="card-content">
                        <h3 class="card-title">GEEKONIX</h3>
                        <!-- Buttons Section -->
                        <div class="card-buttons">
                            <a href="clubgeekonix.jsp?clubId=3" class="btn card-button btn-info">View Details</a>
                        </div>
                    </div>
                </div>

                <div class="card">
                    <img src="club3.jpg" alt="Club 3 Image" class="card-image" />
                    <div class="card-content">
                        <h3 class="card-title">SAMARITANS</h3>
                        <!-- Buttons Section -->
                        <div class="card-buttons">
                            <a href="clubsamaritans.jsp?clubId=3" class="btn card-button btn-info">View Details</a>
                        </div>
                    </div>
                </div>


                <div class="card">
                    <img src="https://i.ibb.co/Ws082rj/iic.jpg" alt="Club 3 Image" class="card-image" />
                    <div class="card-content">
                        <h3 class="card-title">IIC</h3>
                        <!-- Buttons Section -->
                        <div class="card-buttons">
                            <a href="clubiic.jsp?clubId=3" class="btn card-button btn-info">View Details</a>
                        </div>
                    </div>
                </div>
            </div>
        </div>
        <a href="index.jsp" class="btn card-button btn-info return-home">return home</a>
        <br><br><br><br>
        

    </body>

    </html>