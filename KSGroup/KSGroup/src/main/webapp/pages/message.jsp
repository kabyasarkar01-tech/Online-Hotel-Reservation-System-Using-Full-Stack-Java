<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

String msg=request.getParameter("msg");
String nextPage=request.getParameter("nextPage");
String button=request.getParameter("button");

if(msg==null)
	msg="Operation Completed.";

if(nextPage==null)
	nextPage="../index.jsp";

if(button==null)
	button="Back";
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>KS Group</title>

<link rel="stylesheet" href="../css/bootstrap.css">

<link href="https://fonts.googleapis.com/css?family=Playfair+Display:400,700,900|Rubik:300,400,700" rel="stylesheet">

<style>

body{

	margin:0;
	padding:0;
	height:100vh;

	display:flex;
	justify-content:center;
	align-items:center;

	background:url("../images/big_image_1.jpg");

	background-size:cover;
	background-position:center;

	font-family:'Rubik',sans-serif;

}

.overlay{

	position:fixed;

	top:0;
	left:0;

	width:100%;
	height:100%;

	background:rgba(0,0,0,.55);

}

.box{

	position:relative;
	
	width:90%;

	max-width:500px;

	background:white;

	border-radius:12px;

	padding:40px;

	text-align:center;

	box-shadow:0 10px 30px rgba(0,0,0,.3);

	z-index:100;

}

h2{

	font-family:'Playfair Display',serif;

	color:#c59d5f;

	margin-bottom:25px;

}

p{

	font-size:18px;

	color:#444;

	margin-bottom:35px;

}

.btn-custom{

    display:inline-block;

    background:#c59d5f;

    color:#fff;

    padding:12px 40px;

    border-radius:30px;

    text-decoration:none;

    font-size:16px;

    font-weight:bold;

    transition:.3s;

}

.btn-custom:hover{

	background:#b08a4a;

	color:white;

	text-decoration:none;

}

</style>

</head>

<body>

<div class="overlay"></div>

<div class="box">

<h2>KS Group</h2>

<p>

<%=msg%>

</p>

<a
href="<%=nextPage%>"
class="btn-custom">

<%=button%>

</a>

</div>

</body>

</html>