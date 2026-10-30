<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
	response.sendRedirect("adminLogin.jsp");
	return;
}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Hotels - KS Group</title>

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
	max-width:1000px;
	margin:50px auto;
	background:white;
	padding:30px;
	border-radius:12px;
	box-shadow:0 8px 20px rgba(0,0,0,0.12);
}

h2{
	text-align:center;
	color:#444;
	margin-bottom:30px;
}

table{
	width:100%;
	border-collapse:collapse;
}

th{
	background:#c59d5f;
	color:white;
	padding:15px;
	text-align:center;
}

td{
	padding:12px;
	text-align:center;
	border-bottom:1px solid #ddd;
}

tr:nth-child(even){
	background:#f9f9f9;
}

tr:hover{
	background:#f1f1f1;
}

.back-btn{
	display:block;
	width:180px;
	margin:40px auto 0;
	padding:14px;
	text-align:center;
	background:#c59d5f;
	color:white;
	text-decoration:none;
	font-weight:bold;
	border-radius:8px;
	transition:0.3s;
}

.back-btn:hover{
	background:#b08a4a;
}

.delete-btn{

    background:#dc3545;
    color:white;
    border:none;
    padding:10px 16px;
    border-radius:6px;
    cursor:pointer;
    font-weight:bold;

}

.delete-btn:hover{

    background:#c82333;

}

.modal{
    display:none;
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

.modal-buttons{
    margin-top:20px;
    display:flex;
    gap:15px;
}

.modal-buttons button{
    flex:1;
}

.modal-content h3{
    color:#444;
    margin-bottom:20px;
}

.modal-content p{
    color:#555;
    font-size:16px;
    margin-bottom:25px;
}

.yes-btn{
    background:#28a745;
    color:white;
    border:none;
    border-radius:8px;
    padding:12px;
    font-size:16px;
    font-weight:bold;
    cursor:pointer;
}

.yes-btn:hover{
    background:#218838;
}

.no-btn{
    background:#dc3545;
    color:white;
    border:none;
    border-radius:8px;
    padding:12px;
    font-size:16px;
    font-weight:bold;
    cursor:pointer;
}

.no-btn:hover{
    background:#c82333;
}

</style>

<script>

var selectedHotelId="";

function openDeleteModal(hotelId){

    selectedHotelId=hotelId;

    document.getElementById("deleteModal").style.display="block";

}

function closeDeleteModal(){

    document.getElementById("deleteModal").style.display="none";

}

function submitDelete(){

    window.location="deleteHotelFromView.jsp?hotelId="+selectedHotelId;

}
</script>
</head>

<body>

<div class="header">
	<span>KS</span> Group Admin Panel
</div>

<div class="container">

<table>

<tr>
    <th>Hotel ID</th>
    <th>Hotel Name</th>
    <th>City</th>
    <th>Photo</th>
    <th></th>
</tr>

<%

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

	Class.forName("oracle.jdbc.driver.OracleDriver");

	con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","username","password");

	ps=con.prepareStatement("select * from HOTELS order by HOTEL_ID");

	rs=ps.executeQuery();

	while(rs.next()){
%>

<tr>

	<td><%=rs.getString("HOTEL_ID")%></td>

	<td><%=rs.getString("HOTEL_NAME")%></td>

	<td><%=rs.getString("CITY")%></td>
	
	<td>

<%
String photo=rs.getString("PHOTO");

if(photo!=null && !photo.equals("")){
%>

<img
src="<%=request.getContextPath()%>/images/<%=photo%>"
width="120"
height="80"
style="border-radius:8px;object-fit:cover;">

<%
}else{
%>

No Photo

<%
}
%>

</td>

<td>

<button
class="delete-btn" onclick="openDeleteModal('<%=rs.getString("HOTEL_ID")%>')">

Delete

</button>

</td>

</tr>

<%
	}

}catch(Exception e){

%>

<tr>
    <td colspan="5">
        Error loading hotel data.
    </td>
</tr>

<%
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
</table>

<a href="home.jsp" class="back-btn">Back</a>

</div>

<div id="deleteModal" class="modal">

    <div class="modal-content">

        <h3>Delete Hotel</h3>

        <p>

            Are you sure you want to delete this hotel?

        </p>

        <div class="modal-buttons">

            <button class="yes-btn"
                    onclick="submitDelete()">

                Yes

            </button>

            <button class="no-btn"
                    onclick="closeDeleteModal()">

                No

            </button>

        </div>

    </div>

</div>

</body>
</html>