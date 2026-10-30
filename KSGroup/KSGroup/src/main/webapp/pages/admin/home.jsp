<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
	response.sendRedirect("adminLogin.jsp");
	return;
}
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Home - KS Group</title>

<style>

body{
	margin:0;
	padding:0;
	font-family:Arial, sans-serif;
	background:#f5f5f5;
}

.header{
	background:#c59d5f;
	color:white;
	padding:20px;
	text-align:center;
	font-size:30px;
	font-weight:bold;
	letter-spacing:2px;
}

.header span{
	color:black;
}

.container{
	width:90%;
	max-width:1000px;
	margin:50px auto;
}

.navbar{
	background:white;
	padding:18px 25px;
	border-radius:12px;
	box-shadow:0 8px 20px rgba(0,0,0,0.12);
	display:flex;
	flex-wrap:wrap;
	align-items:center;
	justify-content:center;
	gap:20px;
}

.navbar a,
.dropbtn{
	text-decoration:none;
	color:#444;
	font-size:18px;
	font-weight:bold;
	padding:12px 20px;
	border-radius:8px;
	transition:0.3s;
	background:none;
	border:none;
	cursor:pointer;
}

.navbar a:hover,
.dropbtn:hover{
	background:#c59d5f;
	color:white;
}

.dropdown{
	position:relative;
}

.dropdown-content{
	display:none;
	position:absolute;
	background:white;
	min-width:200px;
	box-shadow:0 8px 20px rgba(0,0,0,0.15);
	border-radius:10px;
	overflow:hidden;
	z-index:1;
}

.dropdown-content a{
	display:block;
	padding:14px 18px;
	color:#444;
	text-decoration:none;
	font-size:16px;
}

.dropdown-content a:hover{
	background:#c59d5f;
	color:white;
}

.dropdown:hover .dropdown-content{
	display:block;
}
.change-password{
	margin-top:50px;
	text-align:center;
}

.change-password button{
	padding:15px 40px;
	font-size:18px;
	font-weight:bold;
	border:none;
	border-radius:8px;
	background:#c59d5f;
	color:white;
	cursor:pointer;
	transition:0.3s;
}

.change-password button:hover{
	background:#b08a4a;
}

</style>

</head>
<body>

<div class="header">
	<span>KS</span> Group Admin Panel
</div>

<div class="container">

	<div class="navbar">

	<div class="dropdown">
		<button class="dropbtn">Hotels</button>

		<div class="dropdown-content">
			<a href="addHotel.jsp">Add Hotel</a>
			<a href="modifyHotel.jsp">Modify Hotel</a>
			<a href="viewHotel.jsp">View Hotel</a>
		</div>
	</div>

	<div class="dropdown">
		<button class="dropbtn">Rooms</button>

		<div class="dropdown-content">
			<a href="addRoom.jsp">Add Room</a>
			<a href="modifyRoom.jsp">Modify Room</a>
			<a href="viewRoom.jsp">View Rooms</a>
		</div>
	</div>

	<a href="customers.jsp">Customers</a>

	<a href="bookings.jsp">Bookings</a>

	<a href="payment.jsp">Payments</a>

	<a href="reports.jsp">Reports</a>

</div>
	<div class="change-password">

	<a href="changePassword.jsp">
	<button>Change Password</button>
	</a>

	<br><br>

	<a href="logout.jsp">
	<button>Log Out</button>
	</a>

</div>

</div>

</body>
</html>