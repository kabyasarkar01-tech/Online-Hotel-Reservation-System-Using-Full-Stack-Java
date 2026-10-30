<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
response.sendRedirect("adminLogin.jsp");
return;
}

String oldUsername=request.getParameter("oldUsername");
String newUsername=request.getParameter("newUsername");

String newPassword=request.getParameter("newPassword");
String confirmPassword=request.getParameter("confirmPassword");

String msg="";
String btnClass="error-btn";
String redirectPage="changePassword.jsp";

if(!newPassword.equals(confirmPassword)){

msg="Confirm Password Correctly";

}else{

Connection con=null;
PreparedStatement ps=null;

try{

	Class.forName("oracle.jdbc.driver.OracleDriver");

	con=DriverManager.getConnection(
	"jdbc:oracle:thin:@localhost:1521:xe",
	"username",
	"password"
	);

	ps=con.prepareStatement(
	"update KSGROUP_ADMIN set USERNAME=?, PASSWORD=? where USERNAME=?"
	);

	ps.setString(1,newUsername);
	ps.setString(2,newPassword);
	ps.setString(3,oldUsername);

	int x=ps.executeUpdate();

	if(x>0){

		msg="Credentials Changed Successfully";
		btnClass="success-btn";
		redirectPage="home.jsp";

	}else{

		msg="Old Username Incorrect";

	}

}catch(Exception e){

	msg="Error While Updating Credentials";

}

}
%>

<!DOCTYPE html>

<html>
<head>
<meta charset="UTF-8">
<title>Credential Status</title>

<style>

body{
	margin:0;
	padding:0;
	font-family:Arial,sans-serif;
	background:#f5f5f5;
}

.modal{
	display:block;
	position:fixed;
	left:0;
	top:0;
	width:100%;
	height:100%;
	background:rgba(0,0,0,0.5);
}

.modal-content{
	background:white;
	width:350px;
	margin:200px auto;
	padding:30px;
	border-radius:10px;
	text-align:center;
	box-shadow:0 8px 20px rgba(0,0,0,0.2);
}

.modal-content h3{
	color:#444;
	margin-bottom:20px;
}

.modal-content p{
	font-size:16px;
	color:#555;
	margin-bottom:25px;
}

.ok-btn{
	color:white;
	border:none;
	border-radius:8px;
	padding:12px;
	width:100%;
	font-size:16px;
	font-weight:bold;
	cursor:pointer;
}

.success-btn{
	background:#28a745;
}

.success-btn:hover{
	background:#218838;
}

.error-btn{
	background:#dc3545;
}

.error-btn:hover{
	background:#c82333;
}

</style>

<script>

function goBack(){

	window.location="<%=redirectPage%>";

}

</script>

</head>

<body>

<div class="modal">

```
<div class="modal-content">

	<h3>Credential Status</h3>

	<p><%=msg%></p>

	<button class="ok-btn <%=btnClass%>" onclick="goBack()">

		OK

	</button>

</div>

</div>

</body>
</html>