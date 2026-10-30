<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
String customerName=(String)session.getAttribute("customerName");
%>

<!doctype html>
<html lang="en">
  <head>
    <title>KS Group - Rooms</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400,700,900|Rubik:300,400,700" rel="stylesheet">

    <link rel="stylesheet" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/animate.css">
    <link rel="stylesheet" href="../css/owl.carousel.min.css">

    <link rel="stylesheet" href="../fonts/ionicons/css/ionicons.min.css">
    <link rel="stylesheet" href="../fonts/fontawesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="../css/magnific-popup.css">

    <!-- Theme Style -->
    <link rel="stylesheet" href="../css/style.css">
    
    <style>
		.ks-logo {
		  font-family: 'Playfair Display', serif;
		  font-size: 28px;
		  font-weight: 900;
		  letter-spacing: 2px;
		  color: #000 !important;
		  text-transform: uppercase;
		}
		
		.ks-logo span {
		  color: #c59d5f;
		}
    </style>
  </head>
  <body>
    
    <header role="banner">
         <nav class="navbar navbar-expand-md navbar-dark bg-light">
      <div class="container">
    
        <!-- LOGO -->
        <a class="navbar-brand ks-logo" href="index.html">
          <span>KS</span> Group
        </a>
    
        <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample05">
          <span class="navbar-toggler-icon"></span>
        </button>
    
        <div class="collapse navbar-collapse navbar-light" id="navbarsExample05">
          <ul class="navbar-nav ml-auto pl-lg-5 pl-0">
    
            <li class="nav-item">
              <a class="nav-link" href="../index.jsp">Home</a>
            </li>
    
            <!-- ROOMS (NO DROPDOWN) -->
            <li class="nav-item">
              <a class="nav-link active" href="rooms.jsp">Rooms</a>
            </li>
    
            <li class="nav-item">
              <a class="nav-link" href="blog.jsp">Blog</a>
            </li>
    
            <li class="nav-item">
              <a class="nav-link" href="about.jsp">About</a>
            </li>
    
            <li class="nav-item">
              <a class="nav-link" href="contact.jsp">Contact</a>
            </li>
    
            <!-- LOGIN & REGISTER -->
            <%

if(customerName==null){

%>

<li class="nav-item">
    <a class="nav-link" href="login.jsp">
        Login
    </a>
</li>

<li class="nav-item">
    <a class="nav-link" href="register.jsp">
        Register
    </a>
</li>

<%

}
else{

%>

<li class="nav-item dropdown">

<a
class="nav-link dropdown-toggle"
href="#"
id="customerMenu"
data-toggle="dropdown">

<%=customerName%>

</a>

<div class="dropdown-menu dropdown-menu-right">

<a
class="dropdown-item"
href="profile.jsp">

My Profile

</a>

<div class="dropdown-divider"></div>

<a
class="dropdown-item"
href="logout.jsp">

Logout

</a>

</div>

</li>

<%

}

%>
    
          </ul>
        </div>
      </div>
    </nav>
          
    </header>
    <!-- END header -->



    <section class="site-hero site-hero-innerpage overlay" data-stellar-background-ratio="0.5" style="background-image: url(../images/big_image_1.jpg);">
      <div class="container">
        <div class="row align-items-center site-hero-inner justify-content-center">
          <div class="col-md-12 text-center">

            <div class="mb-5 element-animate">
              <h1>Our Rooms</h1>
              <p>Discover our world's #1 Luxury Room For VIP.</p>
            </div>

          </div>
        </div>
      </div>
    </section>
    <!-- END section -->


    <section class="site-section">
      <div class="container">
        <div class="row">
          <div class="col-md-4 mb-4">
            <div class="media d-block room mb-0">
              <figure>
                <img src="../images/img_2.jpg" alt="Generic placeholder image" class="img-fluid">
                <div class="overlap-text">
                  <span>
                    Featured Room 
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                  </span>
                </div>
              </figure>
              <div class="media-body">
                <h3 class="mt-0"><a href="#">Presidential Room</a></h3>
                <ul class="room-specs">
                  <li><span class="ion-ios-people-outline"></span> 2 Guests</li>
                  <li><span class="ion-ios-crop"></span> 22 ft <sup>2</sup></li>
                </ul>
                <p>Nulla vel metus scelerisque ante sollicitudin. Fusce condimentum nunc ac nisi vulputate fringilla. </p>
                <p><a href="rooms2.jsp" class="btn btn-primary btn-sm">Book Now</a></p>
              </div>
            </div>
          </div>
          <div class="col-md-4 mb-4">
            <div class="media d-block room mb-0">
              <figure>
                <img src="../images/img_3.jpg" alt="Generic placeholder image" class="img-fluid">
                <div class="overlap-text">
                  <span>
                    Featured Room 
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                  </span>
                </div>
              </figure>
              <div class="media-body">
                <h3 class="mt-0"><a href="#">Presidential Room</a></h3>
                <ul class="room-specs">
                  <li><span class="ion-ios-people-outline"></span> 2 Guests</li>
                  <li><span class="ion-ios-crop"></span> 22 ft <sup>2</sup></li>
                </ul>
                <p>Nulla vel metus scelerisque ante sollicitudin. Fusce condimentum nunc ac nisi vulputate fringilla. </p>
                <p><a href="rooms2.jsp" class="btn btn-primary btn-sm">Book Now</a></p>
              </div>
            </div>
          </div>
          <div class="col-md-4 mb-4">
            <div class="media d-block room mb-0">
              <figure>
                <img src="../images/img_1.jpg" alt="Generic placeholder image" class="img-fluid">
                <div class="overlap-text">
                  <span>
                    Featured Room 
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                  </span>
                </div>
              </figure>
              <div class="media-body">
                <h3 class="mt-0"><a href="#">Presidential Room</a></h3>
                <ul class="room-specs">
                  <li><span class="ion-ios-people-outline"></span> 2 Guests</li>
                  <li><span class="ion-ios-crop"></span> 22 ft <sup>2</sup></li>
                </ul>
                <p>Nulla vel metus scelerisque ante sollicitudin. Fusce condimentum nunc ac nisi vulputate fringilla. </p>
                <p><a href="rooms2.jsp" class="btn btn-primary btn-sm">Book Now</a></p>
              </div>
            </div>
          </div>


          <div class="col-md-4 mb-4">
            <div class="media d-block room mb-0">
              <figure>
                <img src="../images/img_2.jpg" alt="Generic placeholder image" class="img-fluid">
                <div class="overlap-text">
                  <span>
                    Featured Room 
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                  </span>
                </div>
              </figure>
              <div class="media-body">
                <h3 class="mt-0"><a href="#">Presidential Room</a></h3>
                <ul class="room-specs">
                  <li><span class="ion-ios-people-outline"></span> 2 Guests</li>
                  <li><span class="ion-ios-crop"></span> 22 ft <sup>2</sup></li>
                </ul>
                <p>Nulla vel metus scelerisque ante sollicitudin. Fusce condimentum nunc ac nisi vulputate fringilla. </p>
                <p><a href="rooms2.jsp" class="btn btn-primary btn-sm">Book Now</a></p>
              </div>
            </div>
          </div>
          <div class="col-md-4 mb-4">
            <div class="media d-block room mb-0">
              <figure>
                <img src="../images/img_3.jpg" alt="Generic placeholder image" class="img-fluid">
                <div class="overlap-text">
                  <span>
                    Featured Room 
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                  </span>
                </div>
              </figure>
              <div class="media-body">
                <h3 class="mt-0"><a href="#">Presidential Room</a></h3>
                <ul class="room-specs">
                  <li><span class="ion-ios-people-outline"></span> 2 Guests</li>
                  <li><span class="ion-ios-crop"></span> 22 ft <sup>2</sup></li>
                </ul>
                <p>Nulla vel metus scelerisque ante sollicitudin. Fusce condimentum nunc ac nisi vulputate fringilla. </p>
                <p><a href="rooms2.jsp" class="btn btn-primary btn-sm">Book Now</a></p>
              </div>
            </div>
          </div>
          <div class="col-md-4 mb-4">
            <div class="media d-block room mb-0">
              <figure>
                <img src="../images/img_1.jpg" alt="Generic placeholder image" class="img-fluid">
                <div class="overlap-text">
                  <span>
                    Featured Room 
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                  </span>
                </div>
              </figure>
              <div class="media-body">
                <h3 class="mt-0"><a href="#">Presidential Room</a></h3>
                <ul class="room-specs">
                  <li><span class="ion-ios-people-outline"></span> 2 Guests</li>
                  <li><span class="ion-ios-crop"></span> 22 ft <sup>2</sup></li>
                </ul>
                <p>Nulla vel metus scelerisque ante sollicitudin. Fusce condimentum nunc ac nisi vulputate fringilla. </p>
                <p><a href="rooms2.jsp" class="btn btn-primary btn-sm">Book Now</a></p>
              </div>
            </div>
          </div>


          <div class="col-md-4 mb-4">
            <div class="media d-block room mb-0">
              <figure>
                <img src="../images/img_2.jpg" alt="Generic placeholder image" class="img-fluid">
                <div class="overlap-text">
                  <span>
                    Featured Room 
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                  </span>
                </div>
              </figure>
              <div class="media-body">
                <h3 class="mt-0"><a href="#">Presidential Room</a></h3>
                <ul class="room-specs">
                  <li><span class="ion-ios-people-outline"></span> 2 Guests</li>
                  <li><span class="ion-ios-crop"></span> 22 ft <sup>2</sup></li>
                </ul>
                <p>Nulla vel metus scelerisque ante sollicitudin. Fusce condimentum nunc ac nisi vulputate fringilla. </p>
                <p><a href="rooms2.jsp" class="btn btn-primary btn-sm">Book Now</a></p>
              </div>
            </div>
          </div>
          <div class="col-md-4 mb-4">
            <div class="media d-block room mb-0">
              <figure>
                <img src="../images/img_3.jpg" alt="Generic placeholder image" class="img-fluid">
                <div class="overlap-text">
                  <span>
                    Featured Room 
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                  </span>
                </div>
              </figure>
              <div class="media-body">
                <h3 class="mt-0"><a href="#">Presidential Room</a></h3>
                <ul class="room-specs">
                  <li><span class="ion-ios-people-outline"></span> 2 Guests</li>
                  <li><span class="ion-ios-crop"></span> 22 ft <sup>2</sup></li>
                </ul>
                <p>Nulla vel metus scelerisque ante sollicitudin. Fusce condimentum nunc ac nisi vulputate fringilla. </p>
                <p><a href="rooms2.jsp" class="btn btn-primary btn-sm">Book Now</a></p>
              </div>
            </div>
          </div>
          <div class="col-md-4 mb-4">
            <div class="media d-block room mb-0">
              <figure>
                <img src="../images/img_1.jpg" alt="Generic placeholder image" class="img-fluid">
                <div class="overlap-text">
                  <span>
                    Featured Room 
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                    <span class="ion-ios-star"></span>
                  </span>
                </div>
              </figure>
              <div class="media-body">
                <h3 class="mt-0"><a href="#">Presidential Room</a></h3>
                <ul class="room-specs">
                  <li><span class="ion-ios-people-outline"></span> 2 Guests</li>
                  <li><span class="ion-ios-crop"></span> 22 ft <sup>2</sup></li>
                </ul>
                <p>Nulla vel metus scelerisque ante sollicitudin. Fusce condimentum nunc ac nisi vulputate fringilla. </p>
                <p><a href="rooms2.jsp" class="btn btn-primary btn-sm">Book Now</a></p>
              </div>
            </div>
          </div>
        </div>
      </div>
    </section>

   
   

    <section class="section-cover" data-stellar-background-ratio="0.5" style="background-image: url(../images/img_5.jpg);">
      <div class="container">
        <div class="row justify-content-center align-items-center intro">
          <div class="col-md-9 text-center element-animate">
            <h2>Relax and Enjoy your Holiday</h2>
            <p class="lead mb-5">Experience the perfect blend of comfort, elegance, and personalized service at KS Group. Our thoughtfully designed rooms, modern amenities, and warm hospitality ensure that every moment of your stay feels relaxing and memorable. Whether you’re here for business or leisure, we provide a peaceful retreat where you can unwind, recharge, and truly enjoy your time.</p>
            <div class="btn-play-wrap"><a href="https://vimeo.com/channels/staffpicks/93951774" class="btn-play popup-vimeo "><span class="ion-ios-play"></span></a></div>
          </div>
        </div>
      </div>
    </section>
    <!-- END section -->
   
    <footer class="site-footer">
      <div class="container">
        <div class="row mb-5">
          <div class="col-md-4">
            <h3>Phone Support</h3>
            <p>24/7 Call us now.</p>
            <p class="lead"><a href="tel://">+91 8649865030</a></p>
            <p class="lead"><a href="tel://">+91 9733376561</a></p>
          </div>
          <div class="col-md-4">
            <h3>Connect With Us</h3>
            <p>We are socialized. Follow us</p>
            <p>
              <a href="#" class="pl-0 p-3"><span class="fa fa-facebook"></span></a>
              <a href="#" class="p-3"><span class="fa fa-twitter"></span></a>
              <a href="#" class="p-3"><span class="fa fa-instagram"></span></a>
              <a href="#" class="p-3"><span class="fa fa-vimeo"></span></a>
              <a href="#" class="p-3"><span class="fa fa-youtube-play"></span></a>
            </p>
          </div>
          <div class="col-md-4">
            <h3>Connect With Us</h3>
            <p>Stay connected with KS Group and be a part of our journey. Follow us on our social platforms to get the latest updates, exclusive offers, and a glimpse into our luxury experiences. We’d love to hear from you and keep you inspired for your next stay.</p>
            <form action="contact.jsp" class="subscribe">
              <div class="form-group">
                <button type="submit"><span class="ion-ios-arrow-thin-right"></span></button>
                <input type="email" class="form-control" placeholder="Enter email">
              </div>
              
            </form>
          </div>
        </div>
        <div class="row justify-content-center">
          <div class="col-md-7 text-center">
            &copy; <!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
Copyright &copy;<script>document.write(new Date().getFullYear());</script> All rights reserved | This template is made with <i class="fa fa-heart-o" aria-hidden="true"></i> by <a href="https://colorlib.com" target="_blank">Colorlib</a>
<!-- Link back to Colorlib can't be removed. Template is licensed under CC BY 3.0. -->
          </div>
        </div>
      </div>
    </footer>
    <!-- END footer -->
    
    <!-- loader -->
    <div id="loader" class="show fullscreen"><svg class="circular" width="48px" height="48px"><circle class="path-bg" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke="#eeeeee"/><circle class="path" cx="24" cy="24" r="22" fill="none" stroke-width="4" stroke-miterlimit="10" stroke="#f4b214"/></svg></div>

    <script src="../js/jquery-3.2.1.min.js"></script>
    <script src="../js/jquery-migrate-3.0.0.js"></script>
    <script src="../js/popper.min.js"></script>
    <script src="../js/bootstrap.min.js"></script>
    <script src="../js/owl.carousel.min.js"></script>
    <script src="../js/jquery.waypoints.min.js"></script>
    <script src="../js/jquery.stellar.min.js"></script>

    <script src="../js/jquery.magnific-popup.min.js"></script>
    <script src="../js/magnific-popup-options.js"></script>

    <script src="../js/main.js"></script>
  </body>
</html>