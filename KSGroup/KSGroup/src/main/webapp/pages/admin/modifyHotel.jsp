<%@ page import="java.sql.*" %>

<%
Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

Class.forName("oracle.jdbc.driver.OracleDriver");

con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","username","password");

ps=con.prepareStatement("select HOTEL_ID, HOTEL_NAME,CITY from HOTELS order by hotel_Id");

rs=ps.executeQuery();
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Modify Hotel</title>

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
    margin:60px auto;
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

button{
    width:100%;
    padding:14px;
    background:#c59d5f;
    color:white;
    border:none;
    border-radius:8px;
    font-size:17px;
    font-weight:bold;
    cursor:pointer;
}

button:hover{
    background:#b08a4a;
}

.modify-btn{
    background:#28a745;
}

.modify-btn:hover{
    background:#218838;
}

.clear-btn{
	background:#dc3545;
}

.clear-btn:hover{
	background:#c82333;
}

.photo-btn{

    display:block;
    width:100%;
    padding:14px;
    background:#007bff;
    color:white;
    text-align:center;
    border-radius:8px;
    font-size:17px;
    font-weight:bold;
    cursor:pointer;
    box-sizing:border-box;

}

.photo-btn:hover{

    background:#0056b3;

}

#preview{

    width:100%;
    max-height:220px;
    object-fit:cover;
    border:1px solid #ccc;
    border-radius:8px;
    margin-top:15px;
    display:none;

}
</style>

<script>

function getHotelData(){

    var hotel_Id=document.getElementById("hotel_Id").value;

    if(hotel_Id=="") return;

    var xhttp=new XMLHttpRequest();

    xhttp.onreadystatechange=function(){

        if(this.readyState==4 && this.status==200){

            var data=this.responseText.split(",");

            document.getElementById("hotel_Name").value=data[0];

            document.getElementById("city").value=data[1];
            
            document.getElementById("photo").value="";

            if(data[2]!=""){

                document.getElementById("preview").src=
                "<%=request.getContextPath()%>/images/"+data[2];

                document.getElementById("preview").style.display="block";

                document.getElementById("removeBtn").style.display="block";

                document.getElementById("photoLabel").innerHTML="Change File";

            }
            else{

                document.getElementById("preview").src="";

                document.getElementById("preview").style.display="none";

                document.getElementById("removeBtn").style.display="none";

                document.getElementById("photoLabel").innerHTML="Choose File";

            }

            document.getElementById("removePhoto").value="no";
        }

    };

    xhttp.open("GET","getHotelDetails.jsp?hotel_Id="+hotel_Id,true);
    xhttp.send();

}

function showPhoto(){

    var file=document.getElementById("photo");

    if(file.files.length>0){
    	
    	document.getElementById("removePhoto").value="no";

        document.getElementById("preview").src=
        URL.createObjectURL(file.files[0]);

        document.getElementById("preview").style.display="block";

        document.getElementById("removeBtn").style.display="block";

        document.getElementById("photoLabel").innerHTML=file.files[0].name;

    }

}

function clearForm(){

    document.getElementById("hotel_Id").selectedIndex = 0;

    document.getElementById("hotel_Name").value = "";

    document.getElementById("city").value = "";

    document.getElementById("photo").value = "";

    document.getElementById("preview").src = "";

    document.getElementById("preview").style.display = "none";

    document.getElementById("photoLabel").innerHTML = "Choose File";

    document.getElementById("removePhoto").value = "no";

}

</script>

</head>

<body>

<div class="header">
	<span>KS</span> Group Admin Panel
</div>

<div class="container">

	<h2>Modify Hotel</h2>

	<form action="updateHotel.jsp" method="post" enctype="multipart/form-data">

		<div class="form-group">

			<label>Select Hotel</label>

			<select id="hotel_Id" 	name="hotel_Id"	onchange="getHotelData()" required>
				<option value="" selected disabled hidden>
					---Select Hotel---
				</option>

				<%
				while(rs.next()){
				%>

				<option value="<%=rs.getString("hotel_Id")%>">

					<%=rs.getString("hotel_Id")%>
					-
					<%=rs.getString("hotel_Name")%>
					(
					<%=rs.getString("CITY")%>
					)

				</option>

				<%
				}
				%>

			</select>

		</div>

		<div class="form-group">

			<label>Hotel Name</label>

			<input type="text"   id="hotel_Name"   name="hotel_Name" required>

		</div>

		<div class="form-group">

			<label>City</label>

			<input type="text"   id="city"   name="city"   required>

		</div>
		
		<div class="form-group">

<label>Hotel Photo</label>

<input type="file"
       id="photo"
       name="photo"
       accept="image/*"
       style="display:none;"
       onchange="showPhoto()">

<label
       id="photoLabel"
       class="photo-btn"
       for="photo">

Choose File

</label>

<img id="preview">

<input
       type="hidden"
       id="removePhoto"
       name="removePhoto"
       value="no">

</div>

		<button type="submit" class="modify-btn">
			Update
		</button>

		<br><br>

		<button type="button" class="clear-btn" onclick="clearForm()">
			Clear
		</button>

	</form>
	<br>

<a href="home.jsp">
	<button type="button">Back</button>
</a>

</div>

</body>
</html>