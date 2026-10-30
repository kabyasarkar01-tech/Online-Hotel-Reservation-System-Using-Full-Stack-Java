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

	con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","username","password"	);

	ps=con.prepareStatement("select HOTEL_ID,HOTEL_NAME, CITY from HOTELS order by HOTEL_ID"	);

	rs=ps.executeQuery();

}catch(Exception e){

	out.println(e);

}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>View Rooms - KS Group</title>

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
	width:95%;
	max-width:1300px;
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
	margin-bottom:25px;
}

label{
	display:block;
	margin-bottom:8px;
	font-weight:bold;
}

select{
	width:100%;
	padding:12px;
	border:1px solid #ccc;
	border-radius:6px;
	font-size:15px;
	box-sizing:border-box;
}

select:focus{
	outline:none;
	border-color:#c59d5f;
}

table{
	width:100%;
	border-collapse:collapse;
	margin-top:20px;
}

th{
	background:#c59d5f;
	color:white;
	padding:12px;
}

td{
	padding:12px;
	text-align:center;
	border-bottom:1px solid #ddd;
}

tr:hover{
	background:#f8f8f8;
}

.button-group{
	display:flex;
	justify-content:center;
	gap:20px;
	margin-top:30px;
}

.clear-btn{
	padding:14px 30px;
	background:#28a745;
	color:white;
	border:none;
	border-radius:8px;
	font-size:16px;
	font-weight:bold;
	cursor:pointer;
}

.clear-btn:hover{
	background:#218838;
}

.home-btn{
	padding:14px 30px;
	background:#c59d5f;
	color:white;
	border:none;
	border-radius:8px;
	font-size:16px;
	font-weight:bold;
	cursor:pointer;
}

.delete-btn{

padding:10px 18px;

background:#dc3545;

color:white;

border:none;

border-radius:6px;

font-weight:bold;

cursor:pointer;

}

.delete-btn:hover{

background:#c82333;

}

.home-btn:hover{
	background:#b08a4a;
}

.modal{
    display:none;
    position:fixed;
    left:0;
    top:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.5);
    z-index:1000;
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
    margin-bottom:25px;
    font-size:16px;
}

.yes-btn{

    flex:1;

    background:#dc3545;

    color:white;

    border:none;

    border-radius:8px;

    padding:12px;

    font-size:16px;

    font-weight:bold;

    cursor:pointer;

}

.yes-btn:hover{

    background:#c82333;

}

.no-btn{

    flex:1;

    background:#28a745;

    color:white;

    border:none;

    border-radius:8px;

    padding:12px;

    font-size:16px;

    font-weight:bold;

    cursor:pointer;

}

.no-btn:hover{

    background:#218838;

}

.hotel-preview {
    text-align: center;
    margin: 25px 0;
}

.hotel-image {
    width: 320px;
    height: 210px;
    object-fit: cover;
    border-radius: 10px;
    display: block;
    margin: 0 auto 15px auto;
}

.hotel-preview h3 {
    margin: 8px 0 5px 0;
    font-size: 22px;
}

.hotel-preview p {
    margin: 5px 0;
}

.room-count {
    font-size: 17px;
    margin-top: 10px !important;
}

.room-image {
    width: 100px;
    height: 70px;
    object-fit: cover;
    border-radius: 6px;
}

</style>

<script>

function getRooms(){

	var hotelId=
	document.getElementById("hotel_id").value;

	if(hotelId==""){

		document.getElementById(
			"roomData"
		).innerHTML="";

		return;
	}

	var xhttp=new XMLHttpRequest();

	xhttp.onreadystatechange=function(){

		if(this.readyState==4 &&
		   this.status==200){

			document.getElementById(
				"roomData"
			).innerHTML=this.responseText;
		}
	};

	xhttp.open("GET","getRooms.jsp?hotel_id="+hotelId,	true);
	xhttp.send();
}

function clearData(){

	document.getElementById("hotel_id").selectedIndex=0;
	document.getElementById("roomData").innerHTML="";
}

var deleteHotelId="";
var deleteRoomId="";

function deleteRoom(hotelId,roomId){

    deleteHotelId=hotelId;

    deleteRoomId=roomId;

    document.getElementById("deleteModal").style.display="block";

}

function closeDeleteModal(){

    deleteHotelId="";
    deleteRoomId="";

    document.getElementById("deleteModal").style.display="none";

}

function confirmDelete(){

    document.getElementById("deleteModal").style.display="none";

    window.location=
    "deleteRoom.jsp?hotel_Id="+deleteHotelId+
    "&room_Id="+deleteRoomId;

}
</script>

</head>

<body>

<div class="header">

	<span>KS</span> Group Admin Panel

</div>

<div class="container">

	<h2>View Rooms</h2>

	<div class="form-group">

		<label>Select Hotel</label>

		<select id="hotel_id" 	onchange="getRooms()">

			<option value=""	selected hidden>

				--Select Hotel--

			</option>

			<%
			while(rs.next()){
			%>

			<option value="<%=rs.getString("HOTEL_ID")%>">

				<%=rs.getString("HOTEL_ID")%>
				-
				<%=rs.getString("HOTEL_NAME")%>
				-
				<%=rs.getString("CITY")%>

			</option>

			<%
			}
			%>

		</select>

	</div>

	<div id="roomData">

	</div>

	<div class="button-group">

		<button type="button"
				class="clear-btn"
				onclick="clearData()">

			Clear

		</button>

		<button type="button"
				class="home-btn"
				onclick="window.location='home.jsp'">

			Back

		</button>

	</div>

</div>

<div id="deleteModal"
     class="modal">

    <div class="modal-content">

        <h3>Delete Room</h3>

        <p>

            Are you sure you want to delete this room?

        </p>

        <div class="button-group">

            <button
            type="button"
            class="yes-btn"
            onclick="confirmDelete()">

                Yes

            </button>

            <button
            type="button"
            class="no-btn"
            onclick="closeDeleteModal()">

                No

            </button>

        </div>

    </div>

</div>

</body>
</html>