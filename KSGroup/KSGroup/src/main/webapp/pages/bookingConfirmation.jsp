<%@ page import="java.sql.*" %>

<%
String customer_Id=(String)session.getAttribute("customer_Id");

if(customer_Id==null || customer_Id.equals("")){

    response.sendRedirect("login.jsp");

    return;

}

String booking_Id=request.getParameter("booking_Id");

if(booking_Id==null || booking_Id.equals("")){

    response.sendRedirect("rooms2.jsp");

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

        "select " +

        "B.BOOKING_ID, " +

        "B.FROM_DATE, " +

        "B.TO_DATE, " +

        "B.NO_OF_PEOPLE, " +

        "B.TOTAL_AMOUNT, " +

        "R.CATEGORY, " +

        "R.PHOTO ROOMPHOTO, " +

        "H.HOTEL_NAME, " +

        "H.CITY, " +

        "H.PHOTO HOTELPHOTO " +

        "from BOOKINGS B " +

        "join ROOMS R " +

        "on B.HOTEL_ID=R.HOTEL_ID " +

        "and B.ROOM_ID=R.ROOM_ID " +

        "join HOTELS H " +

        "on B.HOTEL_ID=H.HOTEL_ID " +

        "where B.BOOKING_ID=? " +

        "and B.CUSTOMER_ID=?"

    );


    ps.setString(1,booking_Id);

    ps.setString(2,customer_Id);

    rs=ps.executeQuery();


    if(!rs.next()){

        out.println("Booking not found.");

        return;

    }


    String hotelPhoto=
        rs.getString("HOTELPHOTO");

    String roomPhoto=
        rs.getString("ROOMPHOTO");


    if(hotelPhoto==null)
        hotelPhoto="";


    if(roomPhoto==null)
        roomPhoto="";


    java.sql.Date fromDate=
        rs.getDate("FROM_DATE");

    java.sql.Date toDate=
        rs.getDate("TO_DATE");


    long difference=
        toDate.getTime()
        -fromDate.getTime();


    long noOfNights=
        difference/(1000L*60*60*24);

%>

<!DOCTYPE html>

<html lang="en">

<head>

<meta charset="UTF-8">

<meta name="viewport"
content="width=device-width, initial-scale=1">

<title>Booking Confirmation - KS Group</title>


<link
href="https://fonts.googleapis.com/css?family=Playfair+Display:400,700,900|Rubik:300,400,700"
rel="stylesheet">


<link
rel="stylesheet"
href="../css/bootstrap.css">

<link
rel="stylesheet"
href="../css/style.css">


<style>

body{

    background:#f5f5f5;

}


.ks-logo{

    font-family:'Playfair Display',serif;

    font-size:28px;

    font-weight:900;

    letter-spacing:2px;

    color:#000 !important;

    text-transform:uppercase;

}


.ks-logo span{

    color:#c59d5f;

}


.confirmation-container{

    width:90%;

    max-width:1000px;

    margin:60px auto;

}


.confirmation-card{

    background:white;

    border-radius:15px;

    box-shadow:0 8px 25px rgba(0,0,0,0.15);

    overflow:hidden;

}


.confirmation-header{

    background:#c59d5f;

    color:white;

    padding:30px;

    text-align:center;

}


.confirmation-header h1{

    margin:0;

    font-family:'Playfair Display',serif;

    font-weight:700;

}


.confirmation-header p{

    margin-top:10px;

    margin-bottom:0;

    font-size:17px;

}


.image-row{

    display:flex;

    gap:20px;

    padding:30px;

}


.image-box{

    flex:1;

    text-align:center;

}


.image-box h4{

    margin-bottom:15px;

    color:#444;

}


.confirmation-image{

    width:100%;

    height:280px;

    object-fit:cover;

    border-radius:10px;

    border:1px solid #ddd;

}


.details{

    padding:0 30px 30px 30px;

}


.detail-row{

    display:flex;

    border-bottom:1px solid #eee;

    padding:14px 5px;

    font-size:16px;

}


.detail-label{

    width:50%;

    font-weight:bold;

    color:#555;

}


.detail-value{

    width:50%;

    color:#333;

}


.paid{

    color:#28a745;

    font-weight:bold;

    font-size:18px;

}


.success-message{

    text-align:center;

    color:#28a745;

    font-size:20px;

    font-weight:bold;

    margin-bottom:20px;

}


.back-container{

    text-align:center;

    padding:0 30px 35px 30px;

}


.back-btn{

    display:inline-block;

    background:#c59d5f;

    color:white;

    border:none;

    border-radius:8px;

    padding:13px 40px;

    font-size:17px;

    font-weight:bold;

    text-decoration:none;

}


.back-btn:hover{

    background:#b08a4a;

    color:white;

    text-decoration:none;

}


@media(max-width:768px){

    .image-row{

        flex-direction:column;

    }

    .detail-row{

        display:block;

    }

    .detail-label,

    .detail-value{

        width:100%;

    }

    .detail-value{

        margin-top:5px;

    }

}

</style>

</head>


<body>


<!-- HEADER -->

<header role="banner">

<nav class="navbar navbar-expand-md navbar-dark bg-light">

<div class="container">


<a
class="navbar-brand ks-logo"
href="../index.jsp">

<span>KS</span> Group

</a>


</div>

</nav>

</header>


<!-- CONFIRMATION -->

<div class="confirmation-container">

<div class="confirmation-card">


<div class="confirmation-header">

<h1>

Booking Confirmed

</h1>

<p>

Your room has been successfully booked.

</p>

</div>


<div style="padding:30px 30px 0 30px;">

<div class="success-message">

Payment Successful

</div>

</div>


<!-- IMAGES -->

<div class="image-row">


<div class="image-box">

<h4>

<%=rs.getString("HOTEL_NAME")%>

</h4>


<%

if(!hotelPhoto.equals("")){

%>

<img

src="<%=request.getContextPath()%>/images/<%=hotelPhoto%>"

class="confirmation-image">

<%

}else{

%>

<img

src="../images/img_1.jpg"

class="confirmation-image">

<%

}

%>

</div>


<div class="image-box">

<h4>

<%=rs.getString("CATEGORY")%>

</h4>


<%

if(!roomPhoto.equals("")){

%>

<img

src="<%=request.getContextPath()%>/images/<%=roomPhoto%>"

class="confirmation-image">

<%

}else{

%>

<img

src="../images/img_1.jpg"

class="confirmation-image">

<%

}

%>

</div>


</div>


<!-- DETAILS -->

<div class="details">


<div class="detail-row">

<div class="detail-label">

Booking ID

</div>

<div class="detail-value">

<%=rs.getString("BOOKING_ID")%>

</div>

</div>


<div class="detail-row">

<div class="detail-label">

Hotel

</div>

<div class="detail-value">

<%=rs.getString("HOTEL_NAME")%>

</div>

</div>


<div class="detail-row">

<div class="detail-label">

City

</div>

<div class="detail-value">

<%=rs.getString("CITY")%>

</div>

</div>


<div class="detail-row">

<div class="detail-label">

Room Type

</div>

<div class="detail-value">

<%=rs.getString("CATEGORY")%>

</div>

</div>


<div class="detail-row">

<div class="detail-label">

No. of People

</div>

<div class="detail-value">

<%=rs.getInt("NO_OF_PEOPLE")%>

Person<%=rs.getInt("NO_OF_PEOPLE")==1?"":"s"%>

</div>

</div>


<div class="detail-row">

<div class="detail-label">

From Date

</div>

<div class="detail-value">

<%=rs.getDate("FROM_DATE")%>

</div>

</div>


<div class="detail-row">

<div class="detail-label">

To Date

</div>

<div class="detail-value">

<%=rs.getDate("TO_DATE")%>

</div>

</div>


<div class="detail-row">

<div class="detail-label">

No. of Nights

</div>

<div class="detail-value">

<%=noOfNights%>

Night<%=noOfNights==1?"":"s"%>

</div>

</div>


<div class="detail-row">

<div class="detail-label">

Paid Amount

</div>

<div class="detail-value paid">

Rs. <%=String.format("%.2f",
rs.getDouble("TOTAL_AMOUNT"))%>

</div>

</div>


</div>


<!-- BACK BUTTON -->

<div class="back-container">

<a
href="../index.jsp"
class="back-btn">

Back to Home

</a>

</div>


</div>

</div>


</body>

</html>


<%

}
catch(Exception e){

    out.println(

        "Unable to display booking confirmation : "
        +e.getMessage()

    );

}
finally{


    try{

        if(rs!=null)
            rs.close();

    }
    catch(Exception e){}


    try{

        if(ps!=null)
            ps.close();

    }
    catch(Exception e){}


    try{

        if(con!=null)
            con.close();

    }
    catch(Exception e){}

}

%>