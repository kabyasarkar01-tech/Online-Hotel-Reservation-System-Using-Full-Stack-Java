<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
	response.sendRedirect("adminLogin.jsp");
	return;
}

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

	Class.forName("oracle.jdbc.driver.OracleDriver");

	con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","username","password");

	ps=con.prepareStatement("select HOTEL_ID,HOTEL_NAME,PHOTO	from HOTELS order by HOTEL_ID");

	rs=ps.executeQuery();

}catch(Exception e){

	out.println(e);

}
%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Room - KS Group</title>

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
}

.header span{
	color:black;
}

.container{
	width:450px;
	margin:50px auto;
	background:white;
	padding:40px;
	border-radius:12px;
	box-shadow:0 8px 20px rgba(0,0,0,0.15);
}

h2{
	text-align:center;
	color:#444;
	margin-bottom:30px;
}

.form-group{
	margin-bottom:20px;
}

label{
	display:block;
	margin-bottom:8px;
	font-weight:bold;
	color:#444;
}

input[type=text],
input[type=number],
select{
    width:100%;
    padding:12px;
    border:1px solid #ccc;
    border-radius:6px;
    font-size:15px;
    box-sizing:border-box;
}

input:focus,
select:focus{
	outline:none;
	border-color:#c59d5f;
}

.button-group{
	display:flex;
	gap:15px;
}

button{
	flex:1;
	padding:14px;
	background:#c59d5f;
	color:white;
	border:none;
	border-radius:8px;
	font-size:16px;
	font-weight:bold;
	cursor:pointer;
}

button:hover{
	background:#b08a4a;
}

.add-btn{
    background:#28a745;
}

.add-btn:hover{
    background:#218838;
}

</style>

<script>

function showHotelPhoto(){

    var ddl=document.getElementsByName("hotel_id")[0];

    var img=document.getElementById("hotelPreview");

    var photo=ddl.options[ddl.selectedIndex].getAttribute("data-photo");

    if(photo!=null && photo!=""){

        img.src="<%=request.getContextPath()%>/images/"+photo;

        img.style.display="block";

    }
    else{

        img.style.display="none";

        img.src="";

    }

}

function showRoomPhoto(){

    var file=document.getElementById("photo").files[0];

    if(file){

        document.getElementById("roomPreview").src=
        URL.createObjectURL(file);

        document.getElementById("roomPreview").style.display="block";

        document.getElementById("removeBtn").style.display="inline-block";

        document.getElementById("chooseBtn").style.display="none";

    }

}

function chooseRoomPhoto(){

    document.getElementById("photo").click();

}

function removeRoomPhoto(){

    document.getElementById("photo").value="";

    document.getElementById("roomPreview").style.display="none";

    document.getElementById("roomPreview").src="";

    document.getElementById("removeBtn").style.display="none";

    document.getElementById("chooseBtn").style.display="inline-block";

}

function clearRoomPhoto(){

    removeRoomPhoto();

}

</script>

</head>

<body>

<div class="header">
	<span>KS</span> Group Admin Panel
</div>

<div class="container">

	<h2>Add Room</h2>

	<form action="addRoomDB.jsp" method="post" enctype="multipart/form-data">

		<div class="form-group">

			<label>Hotel ID</label>

			<select name="hotel_id" required onchange="showHotelPhoto()">

				<option value="" selected hidden>
					--Select Hotel--
				</option>

				<%
				while(rs.next()){
				%>

				<option value="<%=rs.getString("HOTEL_ID")%>"
				data-photo="<%=rs.getString("PHOTO")==null?"":rs.getString("PHOTO")%>">

					<%=rs.getString("HOTEL_ID")%>
					-
					<%=rs.getString("HOTEL_NAME")%>

				</option>

				<%
				}
				%>

			</select>

</div>

<div class="form-group">

<label>Hotel Preview</label>

<img
id="hotelPreview"
src=""
style="display:none;
width:100%;
height:220px;
object-fit:cover;
border-radius:8px;
border:1px solid #ccc;">

</div>

<div class="form-group">

<label>Room ID</label>

<input type="text" name="room_id" required>

</div>

		<div class="form-group">

			<label>Category</label>

			<input type="text" name="category" required>

		</div>

		<div class="form-group">

		<label>Price</label>
		
		<input type="number" name="price" min="0" required>
		
		</div>
		
		<div class="form-group">

    <label>Capacity</label>

    <select name="capacity" required>

        <option value="" selected hidden>
        </option>

        <option value="1">1 Person</option>

        <option value="2">2 People</option>

        <option value="3">3 People</option>

        <option value="4">4 People</option>

    </select>

</div>

<div class="form-group">

<label>Room Photo</label>

<input type="file" name="photo" id="photo" accept="image/*" style="display:none;" onchange="showRoomPhoto()" required>

<br><br>

<img
id="roomPreview"
style="display:none;
width:100%;
height:220px;
object-fit:cover;
border-radius:8px;
border:1px solid #ccc;">

<br><br>

<button
type="button"
id="removeBtn"
style="display:none;background:#dc3545;"
onclick="removeRoomPhoto()">

Remove

</button>

<button type="button" style="background:#6c757d;" onclick="clearRoomPhoto()">

Clear

</button>

<input type="hidden" name="removePhoto" id="removePhoto" value="no">

<button type="button" id="chooseBtn" class="add-btn" onclick="chooseRoomPhoto()">

    Choose File

</button>

</div>

<div class="button-group">

    <button
    type="button"
    onclick="location.href='home.jsp'">

        Back

    </button>

    <button
    type="submit"
    class="add-btn">

        Add

    </button>

</div>

	</form>

</div>

</body>
</html>