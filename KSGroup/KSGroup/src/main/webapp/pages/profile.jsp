<%@ page import="java.sql.*" %>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);


String customer_Id=(String)session.getAttribute("customer_Id");
String customerName=(String)session.getAttribute("customerName");

if(customer_Id==null || customer_Id.equals("")){

    response.sendRedirect("login.jsp");

    return;

}

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

String firstName="";
String middleName="";
String lastName="";
String gender="";
String email="";
String password="";
String dob="";
String phone="";
String photo="default-user.png";

try{

	Class.forName("oracle.jdbc.driver.OracleDriver");

	con=DriverManager.getConnection(
	"jdbc:oracle:thin:@localhost:1521:xe",
	"username",
	"password");

	ps=con.prepareStatement(
	"select * from customers where customer_Id=?");

	ps.setString(1,customer_Id);

	rs=ps.executeQuery();

	if(rs.next()){

		firstName=rs.getString("first_name");
		middleName=rs.getString("middle_name");
		lastName=rs.getString("last_name");
		gender=rs.getString("gender");
		email=rs.getString("email");
		password=rs.getString("password");
		dob=String.valueOf(rs.getDate("dob"));
		phone=rs.getString("phone");

		if(rs.getString("photo")!=null){

			photo=rs.getString("photo");

		}

	}

}
catch(Exception e){

	out.println(e);

}

%>

<!DOCTYPE html>

<html lang="en">

<head>

<title>KS Group - My Profile</title>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1">

<link href="https://fonts.googleapis.com/css?family=Playfair+Display:400,700,900|Rubik:300,400,700" rel="stylesheet">

<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/animate.css">
<link rel="stylesheet" href="../css/owl.carousel.min.css">
<link rel="stylesheet" href="../fonts/ionicons/css/ionicons.min.css">
<link rel="stylesheet" href="../fonts/fontawesome/css/font-awesome.min.css">
<link rel="stylesheet" href="../css/magnific-popup.css">
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

.profile-area{

	min-height:900px;

	display:flex;

	justify-content:center;

	align-items:flex-start;

	padding-top:50px;

}

.profile-box{

	padding:20px;

}

.profile-box h2{

	color:#fff;

	text-align:center;

	margin-bottom:30px;

	font-weight:700;

	text-shadow:2px 2px 8px rgba(0,0,0,.6);

}

.profile-photo{

	width:150px;

	height:150px;

	border-radius:50%;

	border:4px solid #c59d5f;

	object-fit:cover;

	display:block;

	margin:auto;

}

.photo-buttons{

	text-align:center;

	margin-top:15px;

	margin-bottom:25px;

}

.photo-buttons button{

	margin:5px;

}

.profile-box .form-control::placeholder{

	color:#fff;

}

.profile-box .form-control{

    background:rgba(255,255,255,.15);

    border:1px solid rgba(255,255,255,.7);

    color:#fff;

    border-radius:30px;

    height:48px;

}

.profile-box .form-control::placeholder{

    color:#fff;

}

.profile-box .form-control:focus{

    background:rgba(255,255,255,.25);

    color:#fff;

    border-color:#fff;

    box-shadow:none;

}

.site-hero.overlay:before{

	background:rgba(0,0,0,.55);

}

.profile-box input[type="date"]{

    color:#ffffff !important;

}

.profile-box input[type="date"]::-webkit-calendar-picker-indicator{

    filter:invert(1);

}

.site-hero{

    min-height:100vh;

    height:auto;

    padding-bottom:80px;

}

.btn-gold{

	width:100%;

	height:48px;

	border:none;

	border-radius:30px;

	background:#c59d5f;

	color:#fff;

	font-weight:bold;

	margin-top:15px;

}

.btn-gold:hover{

	background:#b08a4a;

	color:#fff;

}

.btn-danger-custom{

	width:100%;

	height:48px;

	border:none;

	border-radius:30px;

	background:#dc3545;

	color:#fff;

	font-weight:bold;

	margin-top:15px;

}

.btn-danger-custom:hover{

	background:#b52a37;

}

.btn-dark-custom{

	width:100%;

	height:48px;

	border:none;

	border-radius:30px;

	background:#343a40;

	color:#fff;

	font-weight:bold;

	margin-top:15px;

}

.btn-dark-custom:hover{

	background:#23272b;

}

.photo-buttons button{

    width:220px;

    height:45px;

    border-radius:30px;

    margin:5px;

}

</style>

</head>

<body>

<header role="banner">

<nav class="navbar navbar-expand-md navbar-dark bg-light">

<div class="container">

<a class="navbar-brand ks-logo" href="../index.jsp">

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
<a class="nav-link" href="rooms2.jsp">Rooms</a>
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

<li class="nav-item active">

<a class="nav-link" href="profile.jsp">

<%=firstName%>

</a>

</li>

</ul>

</div>

</div>

</nav>

</header>

<section class="site-hero overlay"
data-stellar-background-ratio="0.5"
style="background-image:url(../images/big_image_1.jpg);">

<div class="container">

<div class="row profile-area">

<div class="col-lg-8">

<div class="profile-box">

<h2>My Profile</h2>

<form
action="updateProfile.jsp"
method="post"
enctype="multipart/form-data">

<input
type="hidden"
name="removePhoto"
id="removePhoto"
value="no">

<img
src="../images/<%=photo%>"
id="preview"
class="profile-photo">

<div class="photo-buttons">

<input
type="file"
name="photo"
id="photo"
accept="image/*"
style="display:none;"
onchange="previewImage(this)">

<button
type="button"
class="btn-gold"
onclick="document.getElementById('photo').click();">

Choose Photo

</button>

<button
type="button"
class="btn-danger-custom"
onclick="myRemovePhoto();">

Remove Photo

</button>

</div>

<div class="form-row">

<div class="form-group col-md-4">

<input
type="text"
class="form-control"
name="firstName"
value="<%=firstName%>"
placeholder="First Name"
required>

</div>

<div class="form-group col-md-4">

<input
type="text"
class="form-control"
name="middleName"
value="<%=(middleName==null || middleName.trim().equalsIgnoreCase("null")) ? "" : middleName%>"
placeholder="Middle Name">

</div>

<div class="form-group col-md-4">

<input
type="text"
class="form-control"
name="lastName"
value="<%=lastName%>"
placeholder="Surname"
required>

</div>

</div>

<div class="form-group">

<label class="text-white mb-2">

Gender

</label>

<div class="gender-box text-white">

<label class="mr-3">

<input
type="radio"
name="gender"
value="Male"
<%=gender.equals("Male")?"checked":""%>>

Male

</label>

<label class="mr-3">

<input
type="radio"
name="gender"
value="Female"
<%=gender.equals("Female")?"checked":""%>>

Female

</label>

<label>

<input
type="radio"
name="gender"
value="Other"
<%=gender.equals("Other")?"checked":""%>>

Other

</label>

</div>

</div>

<div class="form-group">

<input
type="email"
class="form-control"
name="email"
value="<%=email%>"
placeholder="Email Address"
required>

</div>

<div class="form-group">

<input
type="password"
class="form-control"
name="password"
value="<%=password%>"
placeholder="Password"
required>

</div>

<div class="form-row">

<div class="form-group col-md-6">

<input
type="date"
class="form-control"
name="dob"
value="<%=dob%>"
required>

</div>

<div class="form-group col-md-6">

<input
type="tel"
class="form-control"
name="phone"
value="<%=phone%>"
placeholder="Phone Number"
maxlength="10"
pattern="[0-9]{10}"
required>

</div>

</div>

<button
type="submit"
class="btn-gold">

UPDATE

</button>

<a
href="deleteAccount.jsp"
class="btn btn-danger-custom">

Delete Account

</a>

<a
href="../index.jsp"
class="btn btn-gold">

Home

</a>

<a
href="logout.jsp"
class="btn btn-dark-custom">

Logout

</a>

</form>

</div>

</div>

</div>

</div>

</section>


<div id="loader" class="show fullscreen">

<svg
class="circular"
width="48px"
height="48px">

<circle
class="path-bg"
cx="24"
cy="24"
r="22"
fill="none"
stroke-width="4"
stroke="#eeeeee"/>

<circle
class="path"
cx="24"
cy="24"
r="22"
fill="none"
stroke-width="4"
stroke-miterlimit="10"
stroke="#f4b214"/>

</svg>

</div>

<script>

function previewImage(input){

	if(input.files && input.files[0]){

		var reader=new FileReader();

		reader.onload=function(e){

			document.getElementById("preview").src=e.target.result;

			document.getElementById("removePhoto").value="no";

		};

		reader.readAsDataURL(input.files[0]);

	}

}

function myRemovePhoto(){

    document.getElementById("preview").src="../images/default-user.png";

    document.getElementById("photo").value="";

    document.getElementById("removePhoto").value="yes";

}

</script>

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

<%

try{

	if(rs!=null)
		rs.close();

	if(ps!=null)
		ps.close();

	if(con!=null)
		con.close();

}
catch(Exception e){}

%>