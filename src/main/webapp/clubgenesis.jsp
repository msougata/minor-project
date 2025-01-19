<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8" %>
    <!DOCTYPE html>
    <html>

    <head>
        <meta charset="UTF-8">
        <title>Improved Page</title>
        <link href="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/css/bootstrap.min.css" rel="stylesheet"
            integrity="sha384-QWTKZyjpPEjISv5WaRU9OFeRpok6YctnYmDr5pNlyT2bRjXh0JMhjY6hW+ALEwIH" crossorigin="anonymous">
        <script src="https://cdn.jsdelivr.net/npm/bootstrap@5.3.3/dist/js/bootstrap.bundle.min.js"
            integrity="sha384-YvpcrYf0tY3lHB60NNkmXc5s9fDVZLESaAA55NDzOxhy9GkcIdslK1eN7N6jIeHz"
            crossorigin="anonymous"></script>
        <link rel="stylesheet"
            href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
        <style>
            .rounded-circle {
                width: 140px;
                height: 140px;
                object-fit: cover;
            }

            .carousel-item img {
                height: 400px;
                /* Adjust this value for desired height */
                object-fit: cover;
                /* Ensures proper scaling without distortion */
            }

            .fa {
                padding: 10px;
                font-size: 30px;
                width: 50px;
                text-align: center;
                text-decoration: none;
                margin: 5px 2px;
            }

            .fa:hover {
                opacity: 0.7;
            }

            .fa-facebook {
                background: #3B5998;
                color: white;
            }

            .fa-instagram {
                background: radial-gradient(circle at 30% 110%,
                        #ffdb8b 0%,
                        #ee653d 25%,
                        #d42e81 50%,
                        #a237b6 75%,
                        #3e57bc 100%);
                box-shadow: 0px 15px 40px 1px rgba(0, 0, 0, 0.5);

            }

            body {
                background-color: #02353C;
                font-family: 'Times New Roman', Times, serif;
            }

            b {
                font-weight: bold;
            }

            h1 {
                color: #C1F6ED;
            }

            h2 {
                color: #3FD0C9;
            }

            * {
                color: #fcfcf7;
            }

            span {
                color: #ff4848;
            }
        </style>
    </head>

    <body>
        <main>
            <div id="myCarousel" class="carousel slide mb-6" data-bs-ride="carousel">
                <div class="carousel-indicators">
                    <button type="button" data-bs-target="#myCarousel" data-bs-slide-to="0"
                        aria-label="Slide 1"></button>
                    <button type="button" data-bs-target="#myCarousel" data-bs-slide-to="1"
                        aria-label="Slide 2"></button>
                    <button type="button" data-bs-target="#myCarousel" data-bs-slide-to="2" class="active"
                        aria-current="true" aria-label="Slide 3"></button>
                </div>
                <div class="carousel-inner">
                    <div class="carousel-item">
                        <img src="https://scontent.fccu27-2.fna.fbcdn.net/v/t39.30808-6/340082597_916926159517109_5504479735959472026_n.jpg?_nc_cat=110&ccb=1-7&_nc_sid=cc71e4&_nc_ohc=QrPPaE4JLhIQ7kNvgF_Aok3&_nc_zt=23&_nc_ht=scontent.fccu27-2.fna&_nc_gid=A8G6rI5J3qIarKSNT3NrboY&oh=00_AYBynRdqIXNjYuIYLZUhVT7N8_KjzxNJ2zTfbu3f0RJdBQ&oe=678EA59A"
                            class="d-block w-100" alt="First slide image" data-bs-toggle="modal"
                            data-bs-target="#imageModal" onclick="showModal(this.src)">

                    </div>
                    <div class="carousel-item">
                        <img src="https://scontent.fccu27-2.fna.fbcdn.net/v/t1.6435-9/56451917_1198966213614220_2834820252359983104_n.jpg?_nc_cat=107&ccb=1-7&_nc_sid=cc71e4&_nc_ohc=4A80TGJXs3wQ7kNvgEu1azc&_nc_zt=23&_nc_ht=scontent.fccu27-2.fna&_nc_gid=ARQD4-XPwqdYKVmOKOhusjf&oh=00_AYDRZfg5wQlTRT0Y_t_PbTJdotOHNSEWb63b4Jddtxg-1w&oe=67B07091"
                            class="d-block w-100" alt="Second slide image" data-bs-toggle="modal"
                            data-bs-target="#imageModal" onclick="showModal(this.src)">

                    </div>
                    <div class="carousel-item active">
                        <img src="https://i.ibb.co/ZNDntNg/Whats-App-Image-2025-01-16-at-7-22-27-PM.jpg"
                            class="d-block w-100" alt="Third slide image" data-bs-toggle="modal"
                            data-bs-target="#imageModal" onclick="showModal(this.src)">
                        <div class="container">
                            <div class="carousel-caption text-end">
                                <p><a href="https://www.instagram.com/technogenesisofficial"><a
                                            href="https://www.instagram.com/technogenesisofficial"
                                            class="fa fa-instagram"></a></a></p>
                                <p><a href="https://www.facebook.com/technogenesisofficial"><a
                                            href="https://www.instagram.com/genesisofficial"
                                            class="fa fa-facebook"></a></a></p>
                            </div>
                        </div>
                    </div>
                </div>
                <button class="carousel-control-prev" type="button" data-bs-target="#myCarousel" data-bs-slide="prev">
                    <span class="carousel-control-prev-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Previous</span>
                </button>
                <button class="carousel-control-next" type="button" data-bs-target="#myCarousel" data-bs-slide="next">
                    <span class="carousel-control-next-icon" aria-hidden="true"></span>
                    <span class="visually-hidden">Next</span>
                </button>
            </div>
            <br><br>
            <div class="container text-center">
                <b>
                    <h1 class="mb-4">Our Main Events</h1>
                </b>
            </div>
            <div class="container main-event text-center">
                <div class="row">
                    <div class="col-lg-4">
                        <img src="https://scontent.fccu27-1.fna.fbcdn.net/v/t39.30808-6/344247128_1367625657141233_3523253596638901177_n.jpg?_nc_cat=105&ccb=1-7&_nc_sid=127cfc&_nc_ohc=SUdvbJoNKh0Q7kNvgGx4bMT&_nc_zt=23&_nc_ht=scontent.fccu27-1.fna&_nc_gid=Abm-jFxYbLHYAKU45IfmjOy&oh=00_AYBExYPZ5X7GV_32bnipQmVqDQlBUEVV9pnRX9jT1gnoOA&oe=678EB69E"
                            class="rounded-circle" alt="Column 1 image" data-bs-toggle="modal"
                            data-bs-target="#imageModal" onclick="showModal(this.src)">
                        <h2 class="fw-normal">GENESIS</h2>
                        <p>Annual Cultural & Technical meet of BCA department, Techno Main Saltlake....</p>
                    </div>
                    <div class="col-lg-4">
                        <img src="https://i.ibb.co/BGVKKK6/Screenshot-206.png" class="rounded-circle"
                            alt="Column 2 image" data-bs-toggle="modal" data-bs-target="#imageModal"
                            onclick="showModal(this.src)">
                        <h2 class="fw-normal">Influx</h2>
                        <p>Fresher's Welcome</p>
                    </div>
                    <div class="col-lg-4">
                        <img src="https://i.ibb.co/CnGLB3z/Whats-App-Image-2025-01-16-at-7-13-03-PM-1.jpg"
                            class="rounded-circle" alt="Column 3 image" data-bs-toggle="modal"
                            data-bs-target="#imageModal" onclick="showModal(this.src)">
                        <h2 class="fw-normal">Blood & Food Donation</h2>
                        <p>Donation Drive</p>
                    </div>
                </div>
                <hr class="featurette-divider">
                <div class="row featurette">
                    <div class="col-md-7">
                        <br><br>
                        <h2 class="featurette-heading fw-normal lh-1">Details about our club. <span>It’ll blow your
                                mind.</span></h2><br>
                        <p class="lead">The annual cultural and alumni meet of BCA
                            Department, Techno main Salt lake & Techno
                            main Kolkata. The stepping stones of Genesis
                            were planted in 2018 and here we are taking
                            forward the legacy of Genesis towards it's 7th
                            year completion.
                            Dedicated to this celebration of creativity,
                            Genesis promises to be an unforgettable
                            extravaganza all together where the students
                            dream big makes bigger</p>
                    </div>
                    <div class="col-md-5">
                        <img src="https://scontent.fccu11-1.fna.fbcdn.net/v/t39.30808-6/344331871_1233859667235112_598762086279853648_n.jpg?_nc_cat=103&ccb=1-7&_nc_sid=127cfc&_nc_ohc=xuPFW135CvIQ7kNvgGQM7p5&_nc_zt=23&_nc_ht=scontent.fccu11-1.fna&_nc_gid=A2wcwWFoyEn59C14w7F211Z&oh=00_AYBsdPdkVIPh0S4JFsDYYhF-gPTTdRPSy09re6te2TVzZA&oe=678EC406"
                            class="img-fluid mx-auto" alt="Featurette 1 image" data-bs-toggle="modal"
                            data-bs-target="#imageModal" onclick="showModal(this.src)">
                    </div>
                </div>
                <hr class="featurette-divider">
                <div class="row featurette">
                    <div class="col-md-7 order-md-2">
                        <br><br>
                        <h2 class="featurette-heading fw-normal lh-1">Genesis <span>(Departmental Fest)</span></h2><br>
                        <p class="lead">45% Increase in footfall between every
                            consecutive year.
                            Introducing 2 best star performers of different
                            genres to keep up the authenticity.
                            Changing Genesis merchandise design every year
                            to bring in new effect and enthusiasm.
                            Keep academic growth as a key focus along with
                            other cultural events.
                            Increase target budget every year</p>
                    </div>
                    <div class="col-md-5 order-md-1">
                        <img src="https://i.ibb.co/ZNDntNg/Whats-App-Image-2025-01-16-at-7-22-27-PM.jpg"
                            class="img-fluid mx-auto" alt="Featurette 2 image" data-bs-toggle="modal"
                            data-bs-target="#imageModal" onclick="showModal(this.src)">
                    </div>
                </div>
                <br><br>
                <footer class="container">
                    <p class="float-end"><a href="#">Back to top</a></p>
                </footer>
        </main>

        <!-- Modal for displaying image -->
        <div class="modal fade" id="imageModal" tabindex="-1" aria-labelledby="imageModalLabel" aria-hidden="true">
            <div class="modal-dialog modal-dialog-centered">
                <div class="modal-content">
                    <div class="modal-header">
                        <h5 class="modal-title" id="imageModalLabel">Full Image View</h5>
                        <button type="button" class="btn-close" data-bs-dismiss="modal" aria-label="Close"></button>
                    </div>
                    <div class="modal-body">
                        <img id="modalImage" src="" class="img-fluid" alt="Full Image">
                    </div>
                </div>
            </div>
        </div>

        <script>
            document.getElementById('currentYear').textContent = new Date().getFullYear();

            function showModal(imageSrc) {
                document.getElementById("modalImage").src = imageSrc;
            }
        </script>
    </body>

    </html>