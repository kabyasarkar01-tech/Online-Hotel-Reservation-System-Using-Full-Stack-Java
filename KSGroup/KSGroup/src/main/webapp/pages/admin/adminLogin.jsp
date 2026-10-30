<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Admin Login - KS Group</title>

<style>

body{
	margin:0;
	padding:0;
	font-family: Arial, sans-serif;
	background:#f5f5f5;
	height:100vh;
	display:flex;
	justify-content:center;
	align-items:center;
}

.login-container{
	width:380px;
	background:white;
	padding:40px;
	border-radius:12px;
	box-shadow:0 10px 25px rgba(0,0,0,0.15);
}

.logo{
	text-align:center;
	font-size:32px;
	font-weight:bold;
	margin-bottom:10px;
	color:#000;
	letter-spacing:2px;
}

.logo span{
	color:#c59d5f;
}

.heading{
	text-align:center;
	margin-bottom:30px;
	color:#444;
	font-size:22px;
	font-weight:bold;
}

.form-group{
	margin-bottom:20px;
}

label{
	display:block;
	margin-bottom:8px;
	font-weight:600;
	color:#444;
}

input{
	width:100%;
	padding:12px;
	border:1px solid #ccc;
	border-radius:6px;
	font-size:15px;
	box-sizing:border-box;
}

input:focus{
	outline:none;
	border-color:#c59d5f;
	box-shadow:0 0 5px rgba(197,157,95,0.5);
}

.login-btn{
	width:100%;
	padding:12px;
	background:#c59d5f;
	border:none;
	color:white;
	font-size:16px;
	font-weight:bold;
	border-radius:6px;
	cursor:pointer;
	transition:0.3s;
}

.login-btn:hover{
	background:#b08a4a;
}

</style>

</head>
<body>

<div class="login-container">

	<div class="logo">
		<span>KS</span> Group
	</div>

	<div class="heading">
		Admin Login
	</div>

	<form action="loginProcess.jsp" method="post">

		<div class="form-group">
			<label>Admin Username</label>
			<input type="text" name="username" required>
		</div>

		<div class="form-group">
			<label>Admin Password</label>
			<input type="password" name="password" required>
		</div>

		<button type="submit" class="login-btn">
			Login
		</button>

	</form>

</div>

</body>
</html>