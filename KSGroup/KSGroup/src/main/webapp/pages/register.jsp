<%
if(session.getAttribute("customer_Id")!=null){

	response.sendRedirect("../index.jsp");
	return;

}
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!doctype html>
<html lang="en">
<head>

<title>KS Group - Register</title>

<meta charset="utf-8">
<meta name="viewport" content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link href="https://fonts.googleapis.com/css?family=Playfair+Display:400,700,900|Rubik:300,400,700" rel="stylesheet">

<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/animate.css">
<link rel="stylesheet" href="../css/owl.carousel.min.css">

<link rel="stylesheet" href="../fonts/ionicons/css/ionicons.min.css">
<link rel="stylesheet" href="../fonts/fontawesome/css/font-awesome.min.css">
<link rel="stylesheet" href="../css/magnific-popup.css">

<link rel="stylesheet"
href="https://cdnjs.cloudflare.com/ajax/libs/bootstrap-datepicker/1.8.0/css/bootstrap-datepicker.min.css">

<link rel="stylesheet" href="../css/style.css">

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
    min-height:700px;
    display:flex;
    justify-content:center;
    align-items:flex-start;
    padding-top:45px;
}

.form-box{
    padding:15px;
}

.form-box h2{
    color:#fff;
    text-align:center;
    font-weight:700;
    margin-bottom:8px;
    text-shadow:2px 2px 8px rgba(0,0,0,.6);
}

.form-box p{
    color:rgba(255,255,255,.88);
    text-align:center;
    margin-bottom:30px;
}

.form-group{
    margin-bottom:18px;
}

.form-control{
    background:rgba(255,255,255,.15);
    border:1px solid rgba(255,255,255,.65);
    color:#fff;
    border-radius:30px;
    height:48px;
    box-shadow:none;
}

.form-control::placeholder{
    color:rgba(255,255,255,.85);
}

.form-control:focus{
    background:rgba(255,255,255,.25);
    color:#fff;
    border-color:#fff;
    box-shadow:none;
}

input[type="date"]{
    color:rgba(255,255,255,.85);
}

.gender-box{
    color:#fff;
    margin-top:5px;
}

.gender-box label{
    margin-right:25px;
    cursor:pointer;
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

</style>

</head>

<body>

<header role="banner">

<nav class="navbar navbar-expand-md navbar-dark bg-light">

<div class="container">

<a class="navbar-brand ks-logo" href="index.jsp">
<span>KS</span> Group
</a>

<button class="navbar-toggler"
type="button"
data-toggle="collapse"
data-target="#navbarsExample05">

<span class="navbar-toggler-icon"></span>

</button>

<div class="collapse navbar-collapse navbar-light"
id="navbarsExample05">

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
<a class="nav-link" href="login.jsp">Login</a>
</li>

<li class="nav-item">
<a class="nav-link active" href="register.jsp">Register</a>
</li>

</ul>

</div>

</div>

</nav>

</header>

<section class="site-hero site-hero-innerpage overlay"
data-stellar-background-ratio="0.5"
style="background-image:url(../images/big_image_1.jpg);">

<div class="container">

<div class="row contact-area justify-content-center">

<div class="col-lg-8">

<div class="form-box">

<h2>Create Account</h2>

<p>Join the KS Group family.</p>

<form action="registerProcess.jsp" method="post">

<div class="form-row">

<div class="form-group col-md-4">
<input
type="text"
class="form-control"
placeholder="First Name"
name="firstName"
pattern="[A-Za-z]+"
title="Name can contain letters only."
oninput="this.value=this.value.replace(/[^A-Za-z]/g,'')"
required>
</div>

<div class="form-group col-md-4">
<input
type="text"
class="form-control"
placeholder="Middle Name"
name="middleName"
pattern="[A-Za-z]+"
title="Name can contain letters only."
oninput="this.value=this.value.replace(/[^A-Za-z]/g,'')">
</div>

<div class="form-group col-md-4">
<input
type="text"
class="form-control"
placeholder="Surname"
name="lastName"
pattern="[A-Za-z]+"
title="Name can contain letters only."
oninput="this.value=this.value.replace(/[^A-Za-z]/g,'')"
required>
</div>

</div>

<div class="form-group">

<label class="text-white mb-2">
Gender
</label>

<div class="gender-box">

<label>

<input
type="radio"
name="gender"
value="Male"
required>

Male

</label>

<label>

<input
type="radio"
name="gender"
value="Female">

Female

</label>

<label>

<input
type="radio"
name="gender"
value="Other">

Other

</label>

</div>

</div>

<div class="form-group">
<input
type="email"
class="form-control"
placeholder="Email Address"
name="email"
pattern="[A-Za-z0-9_.@]+"
title="Email can contain letters, numbers, underscore (_), @ and dot (.) only."
oninput="this.value=this.value.replace(/[^A-Za-z0-9_.@]/g,'')"
required>
</div>

<div class="form-group">

<input
type="password"
class="form-control"
placeholder="Password"
name="password"
minlength="8"
required>

</div>

<div class="form-row">

<div class="form-group col-md-6">
<input
type="date"
class="form-control"
name="dob"
id="dob"
required>
</div>

<div class="form-group col-md-6">

<input
type="tel"
class="form-control"
placeholder="Phone Number"
name="phone"
maxlength="10"
pattern="[0-9]{10}"
required>

</div>

</div>

<button
type="submit"
class="btn-register">

Create Account

</button>

</form>

</div>

</div>

</div>

</div>

</section>

<!-- END section -->

<section class="section-cover"
data-stellar-background-ratio="0.5"
style="background-image:url(../images/img_5.jpg);">

<div class="container">

<div class="row justify-content-center align-items-center intro">

<div class="col-md-9 text-center element-animate">

<h2>Relax and Enjoy your Holiday</h2>

<p class="lead mb-5">
Lorem ipsum dolor sit amet, consectetur adipisicing elit.
Architecto quidem tempore expedita facere facilis, dolores!
</p>

<div class="btn-play-wrap">

<a href="https://vimeo.com/channels/staffpicks/93951774"
class="btn-play popup-vimeo">

<span class="ion-ios-play"></span>

</a>

</div>

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

<p class="lead">

<a href="tel://">
+1 332 3093 323
</a>

</p>

</div>

<div class="col-md-4">

<h3>Connect With Us</h3>

<p>We are socialized. Follow us</p>

<p>

<a href="#" class="pl-0 p-3">
<span class="fa fa-facebook"></span>
</a>

<a href="#" class="p-3">
<span class="fa fa-twitter"></span>
</a>

<a href="#" class="p-3">
<span class="fa fa-instagram"></span>
</a>

<a href="#" class="p-3">
<span class="fa fa-vimeo"></span>
</a>

<a href="#" class="p-3">
<span class="fa fa-youtube-play"></span>
</a>

</p>

</div>

<div class="col-md-4">

<h3>Connect With Us</h3>

<p>
Lorem ipsum dolor sit amet, consectetur adipisicing elit.
Maxime, odio.
</p>

<form action="#" class="subscribe">

<div class="form-group">

<button type="submit">

<span class="ion-ios-arrow-thin-right"></span>

</button>

<input
type="email"
class="form-control"
placeholder="Enter email">

</div>

</form>

</div>

</div>

<div class="row justify-content-center">

    <div class="col-md-7 text-center">

        &copy;
        <script>
            document.write(new Date().getFullYear());
        </script>
        KS Group. All Rights Reserved.

    </div>

</div>

</div>

</footer>

<!-- END footer -->

<!-- Loader -->

<div id="loader" class="show fullscreen">

    <svg class="circular"
         width="48px"
         height="48px">

        <circle class="path-bg"
                cx="24"
                cy="24"
                r="22"
                fill="none"
                stroke-width="4"
                stroke="#eeeeee"/>

        <circle class="path"
                cx="24"
                cy="24"
                r="22"
                fill="none"
                stroke-width="4"
                stroke-miterlimit="10"
                stroke="#f4b214"/>

    </svg>

</div>

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

<script src="../js/main.js">

document.getElementById("dob").max =
    new Date().toISOString().split("T")[0];

</script>

</body>
</html>