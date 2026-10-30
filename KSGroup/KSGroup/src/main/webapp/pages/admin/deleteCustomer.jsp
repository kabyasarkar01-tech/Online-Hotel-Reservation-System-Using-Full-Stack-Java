<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
	response.sendRedirect("adminLogin.jsp");
	return;
}

String customer_Id=request.getParameter("customer_Id");

String msg="";
String redirectPage="customers.jsp";
String buttonColor="#28a745";
String hoverColor="#218838";

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

	String photo="";

	ps=con.prepareStatement(
	"select PHOTO from CUSTOMERS where CUSTOMER_ID=?"
	);

	ps.setString(1,customer_Id);

	rs=ps.executeQuery();

	if(rs.next()){

		photo=rs.getString("PHOTO");

	}

	rs.close();
	ps.close();

	if(photo!=null && !photo.equals("")){

		ServletContext context=pageContext.getServletContext();

		String filePath=context.getRealPath("/images");

		File f=new File(filePath,photo);

		if(f.exists()){

			f.delete();

		}

	}

	ps=con.prepareStatement(
	"delete from CUSTOMERS where CUSTOMER_ID=?"
	);

	ps.setString(1,customer_Id);

	int x=ps.executeUpdate();

	if(x>0){

		msg="Customer Deleted Successfully";

	}else{

		msg="Customer Could Not Be Deleted";

		buttonColor="#dc3545";
		hoverColor="#c82333";

	}

}catch(Exception e){

	e.printStackTrace();

	msg="Customer Could Not Be Deleted";

	buttonColor="#dc3545";
	hoverColor="#c82333";

}finally{

	try{
		if(rs!=null)
			rs.close();
	}catch(Exception e){}

	try{
		if(ps!=null)
			ps.close();
	}catch(Exception e){}

	try{
		if(con!=null)
			con.close();
	}catch(Exception e){}

}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete Customer Status</title>

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
	width:400px;
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
	display:block;
	width:100%;
	background:<%=buttonColor%>;
	color:white;
	border:none;
	border-radius:8px;
	padding:12px;
	font-size:16px;
	font-weight:bold;
	cursor:pointer;
	box-sizing:border-box;
}

.ok-btn:hover{
	background:<%=hoverColor%>;
}

</style>

<script>

function goToPage(){

	window.location="<%=redirectPage%>";

}

</script>

</head>

<body>

<div class="modal">

	<div class="modal-content">

		<h3>Delete Customer Status</h3>

		<p><%=msg%></p>

		<button
		class="ok-btn"
		onclick="goToPage()">

			OK

		</button>

	</div>

</div>

</body>
</html>