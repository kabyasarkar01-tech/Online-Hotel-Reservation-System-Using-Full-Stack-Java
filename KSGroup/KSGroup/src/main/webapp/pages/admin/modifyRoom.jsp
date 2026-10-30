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

	con=DriverManager.getConnection(
	"jdbc:oracle:thin:@localhost:1521:xe",
	"username",
	"password"
	);

	ps=con.prepareStatement(
	"select HOTEL_ID, ROOM_ID, CATEGORY, PHOTO from ROOMS order by HOTEL_ID, ROOM_ID"
	);

	rs=ps.executeQuery();

}catch(Exception e){

	out.println(e);

}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Modify Room - KS Group</title>

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

input,
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

.home-btn{
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

.home-btn:hover{
	background:#b08a4a;
}

.update-btn{
	flex:1;
	padding:14px;
	background:#007bff;
	color:white;
	border:none;
	border-radius:8px;
	font-size:16px;
	font-weight:bold;
	cursor:pointer;
}

.update-btn:hover{
	background:#0056b3;
}

.modal{
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

.clear-btn{
	flex:1;
	padding:14px;
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

#alertModal .delete-btn{
    background:#dc3545;
    color:white;
    border:none;
    border-radius:8px;
    padding:12px;
    width:100%;
    font-size:16px;
    font-weight:bold;
    cursor:pointer;
}

#alertModal .delete-btn:hover{
    background:#c82333;
}
</style>

<script>

function getRoomDetails(){

	var value=document.getElementById("roomSelection").value;

	if(value==""){

		document.getElementById("hotel_Id").value="";
		document.getElementById("room_Id").value="";
		document.getElementById("category").value="";
		document.getElementById("price").value="";

		return;
	}

	var parts=value.split("|");

	var hotelId=parts[0];
	var roomId=parts[1];

	var xhttp=new XMLHttpRequest();

	xhttp.onreadystatechange=function(){

		if(this.readyState==4 &&
		   this.status==200){

			var data=this.responseText.split(",");

			document.getElementById("hotel_Id").value=hotelId;

			document.getElementById("room_Id").value=roomId;

			document.getElementById("category").value=data[0];

			document.getElementById("price").value=data[1];

			document.getElementById("capacity").value=data[2];

			var roomPhoto=data[3];

			var hotelPhoto=data[4];
			
			document.getElementById("oldRoomPhoto").value=roomPhoto;

			var hotelImg=document.getElementById("hotelPreview");

			if(hotelPhoto!=""){

			    hotelImg.src="<%=request.getContextPath()%>/images/"+hotelPhoto;

			    hotelImg.style.display="block";

			}else{

			    hotelImg.style.display="none";

			    hotelImg.src="";

			}

			var roomImg=document.getElementById("roomPreview");

			if(roomPhoto!=""){

			    roomImg.src="<%=request.getContextPath()%>/images/"+roomPhoto;

			    roomImg.style.display="block";

			    document.getElementById("removeBtn").style.display="inline-block";

			    document.getElementById("chooseBtn").innerHTML="Change File";

			}else{

			    roomImg.style.display="none";

			    roomImg.src="";

			    document.getElementById("removeBtn").style.display="none";

			    document.getElementById("chooseBtn").innerHTML="Choose File";

			}

		}
	};

	xhttp.open(
		"GET",
		"getRoomDetails.jsp?hotel_Id="
		+hotelId+
		"&room_Id="
		+roomId,
		true
	);

	xhttp.send();

}

function openConfirmModal(){

	if(document.getElementById("hotel_Id").value==""){

	    document.getElementById(
	        "alertModal"
	    ).style.display="block";

	    return;
	}

    document.getElementById(
        "confirmModal"
    ).style.display="block";

}

function closeConfirmModal(){

    document.getElementById(
        "confirmModal"
    ).style.display="none";

}

function closeAlertModal(){

    document.getElementById(
        "alertModal"
    ).style.display="none";

}

function clearForm(){

	document.getElementById(
		"modifyForm"
	).reset();

	document.getElementById(
		"hotel_Id"
	).value="";

	document.getElementById(
		"room_Id"
	).value="";

	document.getElementById(
		"category"
	).value="";

	document.getElementById(
		"price"
	).value="";

	document.getElementById(
		"confirmModal"
	).style.display="none";
	
	document.getElementById("hotelPreview").src="";

	document.getElementById("hotelPreview").style.display="none";

	document.getElementById("roomPreview").src="";

	document.getElementById("roomPreview").style.display="none";

	document.getElementById("photo").value="";

	document.getElementById("removeBtn").style.display="none";

	document.getElementById("removePhoto").value="no";

	document.getElementById("oldRoomPhoto").value="";

	document.getElementById("chooseBtn").innerHTML="Choose File";

}

function chooseRoomPhoto(){

    document.getElementById("photo").click();

}

function showRoomPhoto(){

    var file=document.getElementById("photo").files[0];

    if(file){

        document.getElementById("roomPreview").src=
        URL.createObjectURL(file);

        document.getElementById("roomPreview").style.display="block";

        document.getElementById("chooseBtn").innerHTML=file.name;

    }

}

</script>

</head>

<body>

<div class="header">

	<span>KS</span> Group Admin Panel

</div>

<div class="container">

	<h2>Modify Room</h2>

	<form id="modifyForm" action="updateRoom.jsp"  method="post"  enctype="multipart/form-data">

		<div class="form-group">

			<label>Select Room</label>

			<select id="roomSelection"
					name="roomSelection"
					onchange="getRoomDetails()"
					required>

				<option value="" disabled selected hidden>

					--Select Room--

				</option>

				<%
				while(rs.next()){
				%>

				<option value="<%=rs.getString("HOTEL_ID")%>|<%=rs.getString("ROOM_ID")%>">

					<%=rs.getString("HOTEL_ID")%>
					-
					<%=rs.getString("ROOM_ID")%>
					-
					<%=rs.getString("CATEGORY")%>

				</option>

				<%
				}
				%>

			</select>

		</div>

		<div class="form-group">

			<label>Hotel ID</label>

			<input type="text"
				   id="hotel_Id"
				   name="hotel_Id"
				   readonly>

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

			<input type="text"
				   id="room_Id"
				   name="room_Id"
				   readonly>

		</div>

		<div class="form-group">

			<label>Category</label>

			<input type="text"
				   id="category"
				   name="category"
				   required>

		</div>

		<div class="form-group">

			<label>Price</label>

			<input type="text"
				   id="price"
				   name="price"
				   required>

		</div>
		
		<div class="form-group">

    <label>Capacity</label>

    <select
    id="capacity"
    name="capacity"
    required>

        <option value="1">1 Person</option>

        <option value="2">2 People</option>

        <option value="3">3 People</option>

        <option value="4">4 People</option>

    </select>

</div>
		
		<div class="form-group">

<label>Room Photo</label>

<input
type="file"
name="photo"
id="photo"
accept="image/*"
style="display:none;"
onchange="showRoomPhoto()">

<input
type="hidden"
id="oldRoomPhoto"
value="">

<div class="button-group">

<button
type="button" id="chooseBtn" class="clear-btn" onclick="chooseRoomPhoto()">

Choose File

</button>

</div>

<br>

<img
id="roomPreview"
src=""
style="display:none;
width:100%;
height:220px;
object-fit:cover;
border-radius:8px;
border:1px solid #ccc;">

</div>

		<div class="button-group">

	<button type="button"
			class="update-btn"
			onclick="openConfirmModal()">

		Update

	</button>

	<button type="button"
			class="clear-btn"
			onclick="clearForm()">

		Clear

	</button>

	<button type="button"
			class="home-btn"
			onclick="window.location='home.jsp'">

		Back

	</button>

</div>

	</form>

</div>

<div id="confirmModal"
     class="modal"
     style="display:none;">

    <div class="modal-content">

        <h3>Confirm Update</h3>

        <p>

            Are you sure you want to modify this room?

        </p>

        <div class="button-group">
        
        <button type="submit"
            class="update-btn"
            form="modifyForm">

        Update

    </button>

    <button type="button"
            class="home-btn"
            onclick="closeConfirmModal()">

        Cancel

    </button>

</div>
        </div>

    </div>

</div>

<div id="alertModal"
     class="modal"
     style="display:none;">

    <div class="modal-content">

        <h3>Warning</h3>

        <p>

            Please select a room first.

        </p>

        <button type="button"
                class="update-btn"
                onclick="closeAlertModal()">

            OK

        </button>

    </div>

</div>

</body>
</html>