<%@ page import="java.sql.*" %>

<%
String customerName=(String)session.getAttribute("customerName");

String customer_Id=(String)session.getAttribute("customer_Id");

int activeBookings=0;

if(customerName==null){

	response.sendRedirect("login.jsp");
	return;

}

String hotelName=request.getParameter("hotelName");
String city=request.getParameter("city");

if(hotelName==null)
	hotelName="";

if(city==null)
	city="";

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

	Class.forName("oracle.jdbc.driver.OracleDriver");

	con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","username","password");
	
	PreparedStatement psCount=null;
	ResultSet rsCount=null;

	psCount=con.prepareStatement(

	"select count(*) from BOOKINGS " +
	"where CUSTOMER_ID=? " +
	"and STATUS='BOOKED'"

	);

	psCount.setString(1,customer_Id);

	rsCount=psCount.executeQuery();

	if(rsCount.next()){

	    activeBookings=rsCount.getInt(1);

	}

	rsCount.close();
	psCount.close();

	String sql=
	"select HOTEL_ID,HOTEL_NAME,CITY,PHOTO " +
	"from HOTELS " +
	"where upper(HOTEL_NAME) like upper(?) " +
	"and upper(CITY) like upper(?) " +
	"order by HOTEL_NAME";

	ps=con.prepareStatement(sql);

	ps.setString(1,"%"+hotelName+"%");
	ps.setString(2,"%"+city+"%");

	rs=ps.executeQuery();
%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1">

<title>Search Hotels - KS Group</title>

<div class="container mt-4 mb-3">

    <a href="rooms2.jsp"
       class="btn"
       style="background:#c59d5f;
              color:white;
              border:none;">

        Back

    </a>

</div>

<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/style.css">

<style>

body{

	background:#f8f9fa;

}

.ks-logo{

	font-family:'Playfair Display',serif;

	font-size:28px;

	font-weight:900;

	letter-spacing:2px;

	color:#000!important;

}

.ks-logo span{

	color:#c59d5f;

}

.container-box{

	width:90%;

	max-width:1200px;

	margin:50px auto;

}

.hotel-card{

	background:#fff;

	border-radius:12px;

	box-shadow:0 6px 18px rgba(0,0,0,.12);

	padding:20px;

	margin-bottom:30px;

	overflow:hidden;

}

.hotel-photo{

	width:100%;

	height:240px;

	object-fit:cover;

	border-radius:10px;

	border:1px solid #ddd;

}

.hotel-title{

	font-size:28px;

	font-weight:bold;

	margin-top:10px;

	color:#333;

}

.hotel-city{

	font-size:18px;

	color:#666;

	margin-top:10px;

	margin-bottom:20px;

}

.view-btn{

	background:#c59d5f;

	color:#fff;

	border:none;

	padding:12px 30px;

	border-radius:8px;

	font-size:16px;

	font-weight:bold;

	cursor:pointer;

}

.view-btn:hover{

	background:#b08a4a;

}

.no-result{

	text-align:center;

	font-size:24px;

	color:#666;

	margin-top:80px;

}

</style>

</head>

<body>

<nav class="navbar navbar-expand-md navbar-dark bg-light">

<div class="container">

<a class="navbar-brand ks-logo" href="../index.jsp">

<span>KS</span> Group

</a>

</div>

</nav>

<div class="container-box">

<%
boolean found=false;

while(rs.next()){

	found=true;
%>

<div class="hotel-card">

	<div class="row">

		<div class="col-md-5">

<%
String photo=rs.getString("PHOTO");

if(photo!=null && !photo.equals("")){
%>

			<img
			src="<%=request.getContextPath()%>/images/<%=photo%>"
			class="hotel-photo">

<%
}
else{
%>

			<img
			src="../images/img_1.jpg"
			class="hotel-photo">

<%
}
%>

		</div>

		<div class="col-md-7 d-flex flex-column justify-content-center">

			<div class="hotel-title">

				<%=rs.getString("HOTEL_NAME")%>

			</div>

			<div class="hotel-city">

				<b>City :</b>
				<%=rs.getString("CITY")%>

			</div>

			<div>

				<form
action="hotelRooms.jsp"
method="post"
onsubmit="return checkBookingLimit();">

<input
type="hidden"
name="hotel_Id"
value="<%=rs.getString("HOTEL_ID")%>">

<input
type="hidden"
name="hotelName"
value="<%=hotelName%>">

<input
type="hidden"
name="city"
value="<%=city%>">

<div class="form-group mt-3">

<label>

From Date

</label>

<input
type="date"
name="fromDate"
class="form-control"
required>

</div>

<div class="form-group mt-3">

<label>

To Date

</label>

<input
type="date"
name="toDate"
class="form-control"
required>

</div>

<div class="form-group mt-3">

<label>

No. of People

</label>

<select
name="people"
class="form-control"
required>

<option value="1">1</option>

<option value="2">2</option>

<option value="3">3</option>

<option value="4">4</option>

</select>

</div>

<br>

<button
class="view-btn"
type="submit">

Search Available Rooms

</button>

</form>

			</div>

		</div>

	</div>

</div>

<%
}

if(!found){
%>

<div class="no-result">

	No Hotels Found

</div>

<%
}
%>

</div>

<script>

var activeBookings=<%=activeBookings%>;

function checkBookingLimit(){

    if(activeBookings>=5){

        alert(
        "You already have 5 active bookings.\n\nPlease cancel one of your existing bookings before booking another room."
        );

        return false;

    }

    return true;

}

document.addEventListener("DOMContentLoaded",function(){

    var today=new Date();

    today.setDate(today.getDate()+7);

    var minDate=today.toISOString().split("T")[0];

    var fromDates=document.getElementsByName("fromDate");

    var toDates=document.getElementsByName("toDate");

    for(var i=0;i<fromDates.length;i++){

        fromDates[i].min=minDate;

        fromDates[i].onchange=function(){

            var to=this.form.toDate;

            to.min=this.value;

        };

    }

});

</script>
</body>
</html>

<%

}catch(Exception e){

	out.println(e);

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