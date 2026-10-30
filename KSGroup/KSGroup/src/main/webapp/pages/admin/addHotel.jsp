<%@ page language="java" contentType="text/html; charset=UTF-8"
pageEncoding="UTF-8"%>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
    response.sendRedirect("adminLogin.jsp");
    return;
}
%>

<%@ page import="java.sql.*" %>

<%
String nextId="H101";

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection(
    "jdbc:oracle:thin:@localhost:1521:xe",
    "username",
    "password");

    ps=con.prepareStatement(
    "select max(hotel_id) from hotels");

    rs=ps.executeQuery();

    if(rs.next() && rs.getString(1)!=null){

        String lastId=rs.getString(1);

        int num=Integer.parseInt(lastId.substring(1));

        nextId="H"+(num+1);

    }

}catch(Exception e){

    out.println(e);

}
%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Add Hotel - KS Group</title>

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

input[type=text]{
    width:100%;
    padding:12px;
    border:1px solid #ccc;
    border-radius:6px;
    font-size:15px;
    box-sizing:border-box;
}

input[type=text]:focus{
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

.add-btn{
    background:#28a745;
}

.add-btn:hover{
    background:#218838;
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
    display:none;
    margin-top:15px;
}

.remove-btn{
    width:100%;
    padding:14px;
    margin-top:15px;
    background:#dc3545;
    color:white;
    border:none;
    border-radius:8px;
    font-size:17px;
    font-weight:bold;
    cursor:pointer;
    display:none;
}

.remove-btn:hover{
    background:#c82333;
}

</style>

<script>

function showFileName(){

    var file=document.getElementById("photo");

    var label=document.getElementById("photoLabel");

    var preview=document.getElementById("preview");

    var removeBtn=document.getElementById("removeBtn");

    if(file.files.length>0){

        label.innerHTML=file.files[0].name;

        preview.src=URL.createObjectURL(file.files[0]);

        preview.style.display="block";

        removeBtn.style.display="block";

    }
    else{

        label.innerHTML="Choose Photo";

        preview.style.display="none";

        removeBtn.style.display="none";

    }

}

function removePhoto(){

    var file=document.getElementById("photo");

    var label=document.getElementById("photoLabel");

    var preview=document.getElementById("preview");

    var removeBtn=document.getElementById("removeBtn");

    file.value="";

    label.innerHTML="Choose Photo";

    preview.src="";

    preview.style.display="none";

    removeBtn.style.display="none";

}

</script>

</head>

<body>

<div class="header">

    <span>KS</span> Group Admin Panel

</div>

<div class="container">

<h2>Add Hotel</h2>

<form action="addHotelDB.jsp"
      method="post"
      enctype="multipart/form-data">

<div class="form-group">

<label>Hotel ID</label>

<input type="text"
       name="hotel_Id"
       value="<%=nextId%>"
       readonly>

</div>

<div class="form-group">

<label>Hotel Name</label>

<input type="text"
       name="hotel_Name"
       required>

</div>

<div class="form-group">

<label>City</label>

<input type="text"
       name="city"
       required>

</div>

<div class="form-group">

    <label>Hotel Photo</label>

    <input type="file"
           id="photo"
           name="photo"
           accept="image/*"
           required
           style="display:none;"
           onchange="showFileName()">

    <label for="photo"
           class="photo-btn"
           id="photoLabel">

        Choose File

    </label>

    <img id="preview">

    <button type="button"
            id="removeBtn"
            class="remove-btn"
            onclick="removePhoto()">

        Remove File

    </button>

</div>
<button type="submit"
        class="add-btn">

    Add

</button>

</form>

<br>

<a href="home.jsp">

<button type="button">

Back

</button>

</a>

</div>

</body>
</html>