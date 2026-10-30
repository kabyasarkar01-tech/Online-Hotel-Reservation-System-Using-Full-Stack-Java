<%@ page import="java.sql.*" %>

<%
String customerName=(String)session.getAttribute("customerName");

if(customerName==null){

    response.sendRedirect("login.jsp");

    return;

}

String hotel_Id=request.getParameter("hotel_Id");
String room_Id=request.getParameter("room_Id");
String fromDate=request.getParameter("fromDate");
String toDate=request.getParameter("toDate");
String noOfPeople=request.getParameter("noOfPeople");
String totalAmount=request.getParameter("totalAmount");

if(hotel_Id==null ||
   room_Id==null ||
   fromDate==null ||
   toDate==null ||
   noOfPeople==null ||
   totalAmount==null){

    response.sendRedirect("rooms2.jsp");

    return;

}

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

String hotelName="";
String city="";
String hotelPhoto="";

String category="";
String roomPhoto="";
double roomPrice=0;

try{

    Class.forName(
        "oracle.jdbc.driver.OracleDriver"
    );

    con=DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "username",
        "password"
    );

    ps=con.prepareStatement(

        "select " +

        "H.HOTEL_NAME," +
        "H.CITY," +
        "H.PHOTO HOTELPHOTO," +

        "R.CATEGORY," +
        "R.PRICE," +
        "R.PHOTO ROOMPHOTO " +

        "from HOTELS H " +

        "join ROOMS R " +
        "on H.HOTEL_ID=R.HOTEL_ID " +

        "where H.HOTEL_ID=? " +
        "and R.ROOM_ID=?"

    );

    ps.setString(1,hotel_Id);
    ps.setString(2,room_Id);

    rs=ps.executeQuery();

    if(rs.next()){

        hotelName=
            rs.getString("HOTEL_NAME");

        city=
            rs.getString("CITY");

        hotelPhoto=
            rs.getString("HOTELPHOTO");

        category=
            rs.getString("CATEGORY");

        roomPrice=
            rs.getDouble("PRICE");

        roomPhoto=
            rs.getString("ROOMPHOTO");

    }
    else{

        response.sendRedirect("rooms2.jsp");

        return;

    }

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


<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1">

<title>Book Room - KS Group</title>

<link rel="stylesheet"
      href="../css/bootstrap.css">

<link rel="stylesheet"
      href="../css/style.css">


<style>

body{

    background:#f5f5f5;

}


/* MAIN CONTAINER */

.booking-container{

    width:90%;

    max-width:1000px;

    margin:60px auto;

}


/* CARD */

.booking-card{

    background:white;

    border-radius:15px;

    box-shadow:
    0 8px 20px rgba(0,0,0,0.15);

    overflow:hidden;

}


/* TITLE */

.booking-title{

    background:#c59d5f;

    color:white;

    padding:20px;

    text-align:center;

    font-size:28px;

    font-weight:bold;

}


/* IMAGE */

.image-box{

    padding:20px;

}

.image-box img{

    width:100%;

    height:300px;

    object-fit:cover;

    border-radius:10px;

    margin-bottom:20px;

}


/* DETAILS */

.details{

    padding:30px;

}

.hotel-name{

    font-size:28px;

    font-weight:bold;

    color:#333;

    margin-bottom:5px;

}

.city{

    color:#777;

    font-size:18px;

    margin-bottom:20px;

}

.detail{

    font-size:17px;

    margin-bottom:12px;

}


/* PAY BUTTON */

.pay-btn{

    width:100%;

    padding:15px;

    background:#28a745;

    color:white;

    border:none;

    border-radius:8px;

    font-size:19px;

    font-weight:bold;

    cursor:pointer;

}

.pay-btn:hover{

    background:#218838;

}


/* BACK BUTTON */

.back-btn{

    width:100%;

    padding:15px;

    background:#6c757d;

    color:white;

    border:none;

    border-radius:8px;

    font-size:17px;

    cursor:pointer;

    margin-top:12px;

}

.back-btn:hover{

    background:#5a6268;

}


/* CONFIRMATION MODAL */

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

}


.modal-content h3{

    margin-bottom:20px;

}


.button-group{

    display:flex;

    gap:15px;

}


.yes-btn{

    flex:1;

    background:#28a745;

    color:white;

    border:none;

    border-radius:8px;

    padding:12px;

    cursor:pointer;

    font-weight:bold;

}


.yes-btn:hover{

    background:#218838;

}


.no-btn{

    flex:1;

    background:#dc3545;

    color:white;

    border:none;

    border-radius:8px;

    padding:12px;

    cursor:pointer;

    font-weight:bold;

}


.no-btn:hover{

    background:#c82333;

}

</style>

</head>


<body>


<div class="booking-container">


<div class="booking-card">


<div class="booking-title">

    Confirm Your Booking

</div>


<div class="row">


<!-- IMAGES -->

<div class="col-md-6 image-box">


<!-- HOTEL IMAGE -->

<%

if(hotelPhoto!=null &&
   !hotelPhoto.equals("")){

%>

<img
src="<%=request.getContextPath()%>/images/<%=hotelPhoto%>"
alt="Hotel Image">

<%

}
else{

%>

<img
src="../images/img_1.jpg"
alt="Hotel Image">

<%

}

%>


<!-- ROOM IMAGE -->

<%

if(roomPhoto!=null &&
   !roomPhoto.equals("")){

%>

<img
src="<%=request.getContextPath()%>/images/<%=roomPhoto%>"
alt="Room Image">

<%

}
else{

%>

<img
src="../images/img_1.jpg"
alt="Room Image">

<%

}

%>


</div>


<!-- BOOKING DETAILS -->

<div class="col-md-6 details">


<div class="hotel-name">

    <%=hotelName%>

</div>


<div class="city">

    <b>City :</b>
    <%=city%>

</div>


<hr>


<div class="detail">

    <b>Room Type :</b>

    <%=category%>

</div>


<div class="detail">

    <b>No. of People :</b>

    <%=noOfPeople%>

</div>

<div class="detail">

    <b>No. of Nights :</b>

    <%
    java.text.SimpleDateFormat sdf =
        new java.text.SimpleDateFormat("yyyy-MM-dd");

    java.util.Date from =
        sdf.parse(fromDate);

    java.util.Date to =
        sdf.parse(toDate);

    long difference =
        to.getTime() - from.getTime();

    long noOfNights =
        difference / (1000 * 60 * 60 * 24);
    %>

    <%=noOfNights%>

</div>


<div class="detail">

    <b>From :</b>

    <%=fromDate%>

</div>


<div class="detail">

    <b>To :</b>

    <%=toDate%>

</div>


<div class="detail">

    <b>Room Price :</b>

    Rs.
    <%=String.format("%.2f",roomPrice)%>

    / day

</div>


<hr>


<div class="detail"
     style="font-size:22px;">

    <b>Payable Amount :</b>

    <br>

    Rs.

    <%=String.format(
        "%.2f",
        Double.parseDouble(totalAmount)
    )%>

</div>


<br>


<!-- PAY BUTTON -->

<button
type="button"
class="pay-btn"
onclick="openConfirmModal()">

    Pay Rs.

    <%=String.format(
        "%.2f",
        Double.parseDouble(totalAmount)
    )%>

</button>


<!-- BACK BUTTON -->

<button
type="button"
class="back-btn"
onclick="history.back()">

    Back

</button>


</div>

</div>

</div>

</div>



<!-- CONFIRMATION MODAL -->

<div id="confirmModal"
     class="modal">


<div class="modal-content">


<h3>

    Confirm Booking

</h3>


<p>

    Are you sure to book this room?

</p>


<div class="button-group">


<button
type="button"
class="yes-btn"
onclick="confirmBooking()">

    Yes

</button>


<button
type="button"
class="no-btn"
onclick="closeConfirmModal()">

    No

</button>


</div>


</div>

</div>



<!-- BOOKING FORM -->

<form
id="bookingForm"
action="bookRoomDB.jsp"
method="post">


<input
type="hidden"
name="hotel_Id"
value="<%=hotel_Id%>">


<input
type="hidden"
name="room_Id"
value="<%=room_Id%>">


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
value="<%=totalAmount%>">


</form>



<script>


function openConfirmModal(){

    document.getElementById(
        "confirmModal"
    ).style.display="block";

}


function closeConfirmModal(){

    document.getElementById(
        "confirmModal"
    ).style.display="none";

}


function confirmBooking(){

    document.getElementById(
        "bookingForm"
    ).submit();

}


</script>


</body>

</html>