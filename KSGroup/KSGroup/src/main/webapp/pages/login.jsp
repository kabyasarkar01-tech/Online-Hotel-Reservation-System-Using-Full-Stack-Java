<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
if(session.getAttribute("customer_Id") != null){

    response.sendRedirect("../index.jsp");
    return;

}
%>

<!doctype html>
<html lang="en">
  <head>
    <title>KS Group - Login</title>
    <meta charset="utf-8">
    <meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

    <link href="https://fonts.googleapis.com/css?family=Playfair+Display:400,700,900|Rubik:300,400,700" rel="stylesheet">

    <link rel="stylesheet" href="../css/bootstrap.css">
    <link rel="stylesheet" href="../css/animate.css">
    <link rel="stylesheet" href="../css/owl.carousel.min.css">

    <link rel="stylesheet" href="../fonts/ionicons/css/ionicons.min.css">
    <link rel="stylesheet" href="../fonts/fontawesome/css/font-awesome.min.css">
    <link rel="stylesheet" href="../css/magnific-popup.css">
    <link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.8.0/css/bootstrap-datepicker.min.css">

    <!-- Theme Style -->
    <link rel="stylesheet" href="../css/style.css">
  </head>
  
  <style>

.ks-logo{
    font-family:'Playfair Display',serif;
    font-size:28px;
    font-weight:900;
    letter-spacing:2px;
    color:#000!important;
    text-transform:uppercase;
}

.ks-logo span{
    color:#c59d5f;
}

.contact-area{
    min-height:650px;
    display:flex;
    justify-content:center;
    align-items:flex-start;
    padding-top:70px;
}

.form-box{
    padding:15px;
}

.form-box h2{
    color:#fff;
    text-align:center;
    margin-bottom:35px;
    font-weight:700;
    text-shadow:2px 2px 8px rgba(0,0,0,.6);
}

.form-control{
    background:rgba(255,255,255,.15);
    border:1px solid rgba(255,255,255,.65);
    color:#fff;
    border-radius:30px;
    height:48px;
}

.form-control::placeholder{
    color:rgba(255,255,255,.85);
}

.form-control:focus{
    background:rgba(255,255,255,.25);
    border-color:#fff;
    color:#fff;
    box-shadow:none;
}

.form-control{
    font-size:16px;
}

.form-control::-webkit-input-placeholder{
    color:rgba(255,255,255,.85);
}

.form-control:-ms-input-placeholder{
    color:rgba(255,255,255,.85);
}

.form-control::placeholder{
    color:rgba(255,255,255,.85);
}

.btn-register{
    width:100%;
    height:50px;
    border:none;
    border-radius:30px;
    background:#c59d5f;
    color:#fff;
    font-weight:600;
    transition:.3s;
}

.btn-register:hover{
    background:#b08a4a;
    color:#fff;
}

.site-hero.overlay::before{
    background:rgba(0,0,0,.55);
}

.form-box p{
    color:rgba(255,255,255,.85);
}
</style>
  <body>
    
    <header role="banner">
     
      <nav class="navbar navbar-expand-md navbar-dark bg-light">
      	<div class="container">
        
        	<a class="navbar-brand ks-logo" href="index.jsp">
            	<span>KS</span> Group
                </a>
            <button class="navbar-toggler" type="button" data-toggle="collapse" data-target="#navbarsExample05">
            	<span class="navbar-toggler-icon"></span>
            </button>
            
            <div class="collapse navbar-collapse navbar-light" id="navbarsExample05">
            	<ul class="navbar-nav ml-auto">
                
                <li class="nav-item">
                	<a class="nav-link" href="../index.jsp">Home</a>
                </li>
                
                <li class="nav-item">
                	<a class="nav-link" href="rooms.jsp">Rooms</a>
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
                 
                <li class="nav-item">
                	<a class="nav-link active" href="login.jsp">Login</a>
                </li>
                
                <li class="nav-item">
                	<a class="nav-link" href="register.jsp">Register</a>
                </li>
              </ul>
            </div>
         </div>
      </nav>
    </header>
    <!-- END header -->

    <section class="site-hero site-hero-innerpage overlay"
data-stellar-background-ratio="0.5"
style="background-image:url(../images/big_image_1.jpg);">

<div class="container">

<div class="row contact-area">

<div class="col-lg-5">

<div class="form-box">

<h2>Welcome Back</h2>

<p class="text-center text-white mb-4">
Sign in to continue your stay.
</p>

<form action="loginProcess.jsp" method="post">

<div class="form-group">

<input
type="email"
class="form-control"
placeholder="Email Address"
name="email"
required>

</div>

<div class="form-group">

<input
type="password"
class="form-control"
placeholder="Password"
name="password"
required>

</div>

<button
type="submit"
class="btn-register">

Log In

</button>

</form>

</div>

</div>

</div>

</div>

</section>
    <!-- END section -->


   
   

    <section class="section-cover" data-stellar-background-ratio="0.5" style="background-image: url(../images/img_5.jpg);">
      <div class="container">
        <div class="row justify-content-center align-items-center intro">
          <div class="col-md-9 text-center element-animate">
            <h2>Relax and Enjoy your Holiday</h2>
            <p class="lead mb-5">Lorem ipsum dolor sit amet, consectetur adipisicing elit. Architecto quidem tempore expedita facere facilis, dolores!</p>
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
            <p class="lead"><a href="tel://">+ 1 332 3093 323</a></p>
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
            <p>Lorem ipsum dolor sit amet, consectetur adipisicing elit. Maxime, odio.</p>
            <form action="#" class="subscribe">
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
    <script src="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.8.0/js/bootstrap-datepicker.min.js"></script>

    <script>
      
      $('#arrival_date, #departure_date').datepicker({});

    </script>

    

    <script src="../js/main.js"></script>
  </body>
</html>