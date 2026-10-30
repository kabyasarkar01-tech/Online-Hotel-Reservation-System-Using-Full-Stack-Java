<%@ page import="java.sql.*" %>
<%@ page import="java.time.*" %>
<%@ page import="java.time.temporal.ChronoUnit" %>

<%
String customer_Id=(String)session.getAttribute("customer_Id");

if(customer_Id==null || customer_Id.equals("")){

    response.sendRedirect("login.jsp");
    return;

}

String hotelName=request.getParameter("hotelName");
String city=request.getParameter("city");

if(hotelName==null)
    hotelName="";

if(city==null)
    city="";

String hotel_Id=request.getParameter("hotel_Id");
String fromDate=request.getParameter("fromDate");
String toDate=request.getParameter("toDate");
String people=request.getParameter("people");

if(hotel_Id==null) hotel_Id="";
if(fromDate==null) fromDate="";
if(toDate==null) toDate="";
if(people==null) people="1";

int noOfPeople=Integer.parseInt(people);

LocalDate from=LocalDate.parse(fromDate);
LocalDate to=LocalDate.parse(toDate);

long noOfDays=

ChronoUnit.DAYS.between(from,to);

if(noOfDays<=0){

    noOfDays=1;

}

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","username","password");

    ps=con.prepareStatement(

    "select HOTEL_NAME,CITY " +

    "from HOTELS " +

    "where HOTEL_ID=?"

    );

    ps.setString(1,hotel_Id);

    rs=ps.executeQuery();

    if(rs.next()){

        hotelName=rs.getString("HOTEL_NAME");
        city=rs.getString("CITY");

    }

    rs.close();
    ps.close();

    ps=con.prepareStatement(

    "select " +

    "R.ROOM_ID," +

    "R.CATEGORY," +

    "R.CAPACITY," +

    "R.PRICE," +

    "R.PHOTO " +

    "from ROOMS R " +

    "where R.HOTEL_ID=? " +

    "and R.CAPACITY>=? " +

"and not exists(" +

    "select 1 " +
    "from BOOKINGS B " +

    "where B.HOTEL_ID=R.HOTEL_ID " +

    "and B.ROOM_ID=R.ROOM_ID " +

    "and B.STATUS='BOOKED' " +

    "and B.FROM_DATE < ? " +

    "and B.TO_DATE > ? " +

") " +

    "order by R.PRICE"

    );

    ps.setString(1,hotel_Id);

    ps.setInt(2,noOfPeople);

    ps.setDate(3,java.sql.Date.valueOf(to));

    ps.setDate(4,java.sql.Date.valueOf(from));

    rs=ps.executeQuery();

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1">

<title>

Available Rooms

</title>

<link rel="stylesheet"
href="../css/bootstrap.css">

<link rel="stylesheet"
href="../css/style.css">

<style>

body{

    background:#f5f5f5;

}

.container-box{

    width:90%;

    max-width:1200px;

    margin:40px auto;

}

.heading{

    text-align:center;

    margin-bottom:40px;

}

.heading h2{

    color:#333;

    font-weight:bold;

}

.heading p{

    color:#666;

    font-size:18px;

}

.back-btn{

    background:#c59d5f;

    color:white;

    border:none;

    padding:10px 25px;

    border-radius:8px;

    text-decoration:none;

    font-weight:bold;

}

.back-btn:hover{

    background:#b08a4a;

    color:white;

    text-decoration:none;

}

.room-card{

    background:white;

    border-radius:12px;

    box-shadow:0 6px 15px rgba(0,0,0,.12);

    overflow:hidden;

    margin-bottom:35px;

}

.room-photo{

    width:100%;

    height:240px;

    object-fit:cover;

}

.room-body{

    padding:20px;

}

.price{

    color:#28a745;

    font-size:22px;

    font-weight:bold;

}

.pay-btn{

    background:#28a745;

    color:white;

    border:none;

    border-radius:8px;

    padding:12px 30px;

    font-weight:bold;

    cursor:pointer;

}

.pay-btn:hover{

    background:#218838;

}

</style>

</head>

<body>

<div class="container-box">

<div class="mb-4">

<form
action="searchHotels.jsp"
method="post"
style="display:inline;">

<input
type="hidden"
name="hotelName"
value="<%=hotelName%>">

<input
type="hidden"
name="city"
value="<%=city%>">

<button
type="submit"
class="back-btn">

Back

</button>

</form>

</div>

<div class="heading">

<h2>

<%=hotelName%>

</h2>

<p>

<%=city%>

</p>

<p>

<b>From :</b>

<%=fromDate%>

&nbsp;&nbsp;&nbsp;

<b>To :</b>

<%=toDate%>

&nbsp;&nbsp;&nbsp;

<b>People :</b>

<%=noOfPeople%>

&nbsp;&nbsp;&nbsp;

<b>Nights :</b>

<%=noOfDays%>

</p>

</div>

<div class="row">

<%

boolean found=false;

while(rs.next()){

found=true;

double price=rs.getDouble("PRICE");

double payable=price*noOfDays;

%>

<div class="col-md-6">

<div class="room-card">

<%

String photo=rs.getString("PHOTO");

if(photo!=null && !photo.equals("")){

%>

<img

src="<%=request.getContextPath()%>/images/<%=photo%>"

class="room-photo">

<%

}else{

%>

<img

src="../images/no-image.png"

class="room-photo">

<%

}

%>

<div class="room-body">

<h3>

<%=rs.getString("CATEGORY")%>

</h3>

<hr>

<p>

<b>Capacity :</b>

<%=rs.getInt("CAPACITY")%>

Person<%=rs.getInt("CAPACITY")==1?"":"s"%>

</p>

<p>

<b>Price / Night :</b>

Rs.<%=String.format("%.2f",price)%>

</p>

<p class="price">

Payable :

Rs. <%=String.format("%.2f",payable)%>

</p>

<br>

<form
action="bookRoom.jsp"
method="post">

<input
type="hidden"
name="hotel_Id"
value="<%=hotel_Id%>">

<input
type="hidden"
name="room_Id"
value="<%=rs.getString("ROOM_ID")%>">

<input
type="hidden"
name="fromDate"
value="<%=fromDate%>">

<input
type="hidden"
name="toDate"
value="<%=toDate%>">

<input
type="hidden"
name="noOfPeople"
value="<%=noOfPeople%>">

<input
type="hidden"
name="totalAmount"
value="<%=payable%>">

<button
type="submit"
class="pay-btn">

Pay Rs. <%=String.format("%.2f",payable)%>

</button>

</form>

</div>

</div>

</div>

<%

}

if(!found){

%>

<div class="col-md-12">

<div class="alert alert-warning text-center">

<h4>

No Rooms Available

</h4>

<p>

No room matches your selected dates and number of people.

</p>

</div>

</div>

<%

}

%>

</div>

</div>

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