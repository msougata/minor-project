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
                        <img src="https://i.ibb.co/NmMYT1c/iic1.jpg" class="d-block w-100" alt="First slide image"
                            data-bs-toggle="modal" data-bs-target="#imageModal" onclick="showModal(this.src)">

                    </div>
                    <div class="carousel-item">
                        <img src="https://i.ibb.co/T2D8DPk/iic2.jpg" class="d-block w-100" alt="Second slide image"
                            data-bs-toggle="modal" data-bs-target="#imageModal" onclick="showModal(this.src)">

                    </div>
                    <div class="carousel-item active">
                        <img src="https://i.ibb.co/wwsmhTQ/iic.jpg" class="d-block w-100" alt="Third slide image"
                            data-bs-toggle="modal" data-bs-target="#imageModal" onclick="showModal(this.src)">
                        <div class="container">
                            <div class="carousel-caption text-end">
                                <p><a href="https://www.instagram.com/anakhronos_tmsl"><a
                                            href="https://www.instagram.com/iictmsl" class="fa fa-instagram"></a></p>
                                <p><a href="https://www.facebook.com/Anakhronos"><a
                                            href="https://www.facebook.com/Instituition's Innovation Council TMSL"
                                            class="fa fa-facebook"></a></p>
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
                        <img src="https://i.ibb.co/DbxY98B/envisage1.webp" class="rounded-circle" alt="Column 1 image"
                            data-bs-toggle="modal" data-bs-target="#imageModal" onclick="showModal(this.src)">
                        <h2 class="fw-normal">ENVISAGE</h2>
                        <p>The Annual Cultural Fest of IIC,TMSL's e-cell.</p>
                    </div>
                    <div class="col-lg-4">
                        <img src="https://i.ibb.co/ZNzQdGJ/iichult.jpg" class="rounded-circle" alt="Column 2 image"
                            data-bs-toggle="modal" data-bs-target="#imageModal" onclick="showModal(this.src)">
                        <h2 class="fw-normal">HULT PRIZE</h2>
                        <p>The celebration of young problem solvers and innovators at an international platform brought
                            to you by Techno Main Salt Lake in association with Hult Prize</p>
                    </div>
                    <div class="col-lg-4">
                        <img src="https://i.ibb.co/nCxJVpP/bootcamp.jpg" class="rounded-circle" alt="Column 3 image"
                            data-bs-toggle="modal" data-bs-target="#imageModal" onclick="showModal(this.src)">
                        <h2 class="fw-normal">BOOTCAMP</h2>
                        <p>Discover a space where ideas evolve into movements.</p>
                    </div>
                </div>
                <hr class="featurette-divider">
                <div class="row featurette">
                    <div class="col-md-7">
                        <br><br>
                        <h2 class="featurette-heading fw-normal lh-1">Details about our club. <span>It’ll blow your
                                mind.</span></h2><br>
                        <p class="lead">Instituition's Innovation Council(IIC) at institute is a unique model based on
                            Hub-Soke and coherence approach to align with the innovation an entrepreneurship promotion
                            and support programs are being organized by various departments.</p>
                    </div>
                    <div class="col-md-5">
                        <img src="https://i.ibb.co/wwsmhTQ/iic.jpg" class="img-fluid mx-auto" alt="Featurette 1 image"
                            data-bs-toggle="modal" data-bs-target="#imageModal" onclick="showModal(this.src)">
                    </div>
                </div>
                <hr class="featurette-divider">
                <div class="row featurette">
                    <div class="col-md-7 order-md-2">
                        <br><br>
                        <h2 class="featurette-heading fw-normal lh-1">Envisage <span>(Cultural Fest)</span></h2><br>
                        <p class="lead">Welcome to ENVISAGE , where you can experience the thrill from a wide array of
                            highly engaging events that you have ever encountered. Designed to bring students with
                            varied interests to showcase their talents and have a great time, IIC TMSL promises ENVISAGE
                            to be a memorable experience for one and all!</p>
                    </div>
                    <div class="col-md-5 order-md-1">
                        <img src="https://i.ibb.co/N6X69W3/envisage.jpg" class="img-fluid mx-auto"
                            alt="Featurette 2 image" data-bs-toggle="modal" data-bs-target="#imageModal"
                            onclick="showModal(this.src)">
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