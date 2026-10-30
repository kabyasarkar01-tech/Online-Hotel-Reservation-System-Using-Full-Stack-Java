<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
	response.sendRedirect("adminLogin.jsp");
	return;
}

String id=request.getParameter("id");

if(id==null || id.trim().equals("")){
	response.sendRedirect("reports.jsp");
	return;
}

id=id.trim();

String update=request.getParameter("update");

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

	Class.forName("oracle.jdbc.driver.OracleDriver");

	con=DriverManager.getConnection(
		"jdbc:oracle:thin:@localhost:1521:xe",
		"username",
		"password"
	);

	if("yes".equals(update)){

		String message=request.getParameter("message");

		if(message==null || message.trim().equals("")){
			response.sendRedirect("reports.jsp");
			return;
		}

		ps=con.prepareStatement(
			"update CONTACT_MESSAGES "+
			"set MESSAGE_TEXT=?, UPDATED_AT=SYSDATE "+
			"where MESSAGE_ID=? and IS_ADMIN='Y'"
		);

		ps.setString(1,message.trim());
		ps.setString(2,id);

		ps.executeUpdate();

		ps.close();

		response.sendRedirect("reports.jsp");
		return;
	}


	ps=con.prepareStatement(
		"select MESSAGE_TEXT "+
		"from CONTACT_MESSAGES "+
		"where MESSAGE_ID=? and IS_ADMIN='Y'"
	);

	ps.setString(1,id);

	rs=ps.executeQuery();

	if(!rs.next()){

		rs.close();
		ps.close();
		con.close();

		out.println("<script>");
		out.println("alert('Admin message not found.');");
		out.println("window.location='reports.jsp';");
		out.println("</script>");

		return;
	}

	String messageText=rs.getString("MESSAGE_TEXT");

	rs.close();
	ps.close();

%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Edit Message - KS Group</title>

<style>

body{
	margin:0;
	padding:0;
	font-family:Arial,sans-serif;
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
	max-width:800px;
	margin:50px auto;
}

.edit-box{
	background:white;
	padding:30px;
	border-radius:12px;
	box-shadow:0 8px 20px rgba(0,0,0,0.12);
}

.edit-box h2{
	text-align:center;
	color:#444;
	margin-top:0;
}

.edit-box textarea{
	width:100%;
	height:180px;
	padding:15px;
	box-sizing:border-box;
	border:1px solid #ccc;
	border-radius:8px;
	font-family:Arial,sans-serif;
	font-size:16px;
	resize:vertical;
	outline:none;
}

.edit-box textarea:focus{
	border-color:#c59d5f;
}

.buttons{
	text-align:center;
	margin-top:20px;
}

.buttons button{
	padding:12px 30px;
	font-size:16px;
	font-weight:bold;
	border:none;
	border-radius:8px;
	cursor:pointer;
	margin:5px;
}

.update-btn{
	background:#007bff;
	color:white;
}

.update-btn:hover{
	background:#0069d9;
}

.cancel-btn{
	background:#c59d5f;
	color:white;
}

.cancel-btn:hover{
	background:#b08a4a;
}

</style>

</head>

<body>

<div class="header">
	<span>KS</span> Group Admin Panel
</div>

<div class="container">

	<div class="edit-box">

		<h2>Edit Message</h2>

		<form action="editAdminMessage.jsp" method="post">

			<input
				type="hidden"
				name="id"
				value="<%=id%>">

			<textarea
				name="message"
				required><%=messageText%></textarea>

			<div class="buttons">

				<button
					type="submit"
					name="update"
					value="yes"
					class="update-btn">
					Update Message
				</button>

				<button
					type="button"
					class="cancel-btn"
					onclick="location.href='reports.jsp'">
					Cancel
				</button>

			</div>

		</form>

	</div>

</div>

</body>

</html>

<%

}
catch(Exception e){

	out.println("<h3>Error: "+e.getMessage()+"</h3>");

}
finally{

	try{
		if(rs!=null) rs.close();
	}catch(Exception e){}

	try{
		if(ps!=null) ps.close();
	}catch(Exception e){}

	try{
		if(con!=null) con.close();
	}catch(Exception e){}

}
%>