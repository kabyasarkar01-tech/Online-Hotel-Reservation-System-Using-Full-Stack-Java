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
<title>Change Password</title>

<style>

body{
	margin:0;
	padding:0;
	font-family:Arial;
	background:#f5f5f5;
	display:flex;
	justify-content:center;
	align-items:center;
	height:100vh;
}

.box{
	width:400px;
	background:white;
	padding:40px;
	border-radius:12px;
	box-shadow:0 10px 25px rgba(0,0,0,0.15);
}

h2{
	text-align:center;
	color:#c59d5f;
	margin-bottom:30px;
}

input{
	width:100%;
	padding:12px;
	margin-bottom:20px;
	border:1px solid #ccc;
	border-radius:6px;
	box-sizing:border-box;
}

button{
	width:100%;
	padding:12px;
	background:#c59d5f;
	color:white;
	border:none;
	border-radius:6px;
	font-size:16px;
	font-weight:bold;
	cursor:pointer;
}

button:hover{
	background:#b08a4a;
}

.home-btn{
	display:block;
	width:100%;
	padding:12px;
	background:#28a745;
	color:white;
	text-align:center;
	text-decoration:none;
	border-radius:6px;
	font-size:16px;
	font-weight:bold;
	box-sizing:border-box;
	margin-top:12px;
}

.home-btn:hover{
	background:#218838;
}
</style>

</head>
<body>

<div class="box">

<h2>Change Credentials</h2>

<form action="updateCredentials.jsp" method="post">

	<input type="text" name="oldUsername" placeholder="Old Username" required>

	<input type="text" name="newUsername" placeholder="New Username" required>

	<input type="password" name="newPassword" placeholder="New Password" required>
	
	<input type="password" name="confirmPassword" placeholder="Confirm New Password" required>

	<button type="submit">Confirm</button>
	
	<a href="home.jsp" class="home-btn">Back</a>

</form>

</div>

</body>
</html>