<%@ page import="java.sql.*" %>

<%
String customer_Id=(String)session.getAttribute("customer_Id");

if(customer_Id==null || customer_Id.equals("")){

    response.sendRedirect("login.jsp");

    return;

}


Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","username","password");

    ps = con.prepareStatement(
    	    "select * from (" +
    	    " select B.BOOKING_ID," +
    	    " B.STATUS," +
    	    " R.CATEGORY," +
    	    " R.CAPACITY," +
    	    " R.PHOTO," +
    	    " B.NO_OF_PEOPLE," +
    	    " B.FROM_DATE," +
    	    " B.TO_DATE," +
    	    " B.TOTAL_AMOUNT" +
    	    " from BOOKINGS B" +
    	    " join ROOMS R" +
    	    " on B.HOTEL_ID=R.HOTEL_ID" +
    	    " and B.ROOM_ID=R.ROOM_ID" +
    	    " where B.CUSTOMER_ID=?" +
    	    " and not exists (" +
    	    "     select 1" +
    	    "     from USER_DELETED_BOOKINGS UDB" +
    	    "     where UDB.CUSTOMER_ID=B.CUSTOMER_ID" +
    	    "     and UDB.BOOKING_ID=B.BOOKING_ID" +
    	    " )" +
    	    " order by B.BOOKING_DATE desc" +
    	    " ) where rownum<=5"
    	);

    	ps.setString(1,customer_Id);

    	rs=ps.executeQuery();

%>

<style>

.booking-card{

    background:white;

    border-radius:12px;

    box-shadow:0 6px 15px rgba(0,0,0,.12);

    margin-bottom:30px;

    overflow:hidden;

}

.booking-photo{

    width:100%;

    height:220px;

    object-fit:cover;

}

.booking-body{

    padding:20px;

}

.booking-body h4{

    margin-bottom:15px;

    color:#444;

}

.booking-info{

    font-size:16px;

    margin-bottom:8px;

}

.cancel-btn{

    background:#dc3545;

    color:white;

    border:none;

    border-radius:8px;

    padding:10px 25px;

    font-weight:bold;

    cursor:pointer;

}

.cancel-btn:hover{

    background:#c82333;

}

.delete-btn{

    background:#dc3545;

    color:white;

    border:none;

    border-radius:8px;

    padding:10px 30px;

    font-weight:bold;

    cursor:pointer;

}

.delete-btn:hover{

    background:#c82333;

}

.cancelled-box{

    width:100%;

    background:#dc3545;

    color:white;

    font-size:28px;

    font-weight:bold;

    text-align:center;

    padding:18px;

    border-radius:8px;

    margin:20px 0;

}

.checkout-box{

    width:100%;

    background:#6c757d;

    color:white;

    font-size:28px;

    font-weight:bold;

    text-align:center;

    padding:18px;

    border-radius:8px;

    margin:20px 0;

}

</style>

<div class="row">

<%

boolean found=false;

while(rs.next()){
    found=true;
%>

<div class="col-md-6">

<div class="booking-card">

<%

String photo=rs.getString("PHOTO");

if(photo!=null && !photo.equals("")){

%>

<img

src="<%=request.getContextPath()%>/images/<%=photo%>"

class="booking-photo">

<%

}else{

%>

<img

src="../images/no-image.png"

class="booking-photo">

<%

}

%>

<div class="booking-body">

<h4>

<%=rs.getString("CATEGORY")%>

</h4>

<div class="booking-info">

<b>Booking ID :</b>

<%=rs.getString("BOOKING_ID")%>

</div>

<div class="booking-info">

<b>Room Capacity :</b>

<%=rs.getInt("CAPACITY")%>

Person<%=rs.getInt("CAPACITY")==1?"":"s"%>

</div>

<div class="booking-info">

<b>Booked For :</b>

<%=rs.getInt("NO_OF_PEOPLE")%>

Person<%=rs.getInt("NO_OF_PEOPLE")==1?"":"s"%>

</div>

<%
String bookingStatus = rs.getString("STATUS");
%>

<%
if("CANCELLED".equalsIgnoreCase(bookingStatus)){
%>

<div class="cancelled-box">

    CANCELLED

</div>

<%
}
else if("CHECKED_OUT".equalsIgnoreCase(bookingStatus)){
%>

<div class="checkout-box">

    CHECKED OUT

</div>

<%
}
else{
%>

<div class="booking-info">

<b>From :</b>

<%=rs.getDate("FROM_DATE")%>

</div>

<div class="booking-info">

<b>To :</b>

<%=rs.getDate("TO_DATE")%>

</div>

<%
}
%>

<div class="booking-info">

<b>Paid :</b>

Rs. <%=String.format("%.2f",rs.getDouble("TOTAL_AMOUNT"))%>

</div>

<br>

<%
if("BOOKED".equalsIgnoreCase(bookingStatus)){
%>

<button

type="button"

class="cancel-btn"

onclick="cancelBooking(

'<%=rs.getString("BOOKING_ID")%>',

'<%=rs.getDouble("TOTAL_AMOUNT") * 0.75 %>'

)">

Cancel Booking

</button>

<%
}
else{
%>

<button

type="button"

class="delete-btn"

onclick="deleteBooking(

'<%=rs.getString("BOOKING_ID")%>'

)">

Delete

</button>

<%
}
%>

</div>

</div>

</div>

<%

}

if(!found){

%>

<div class="col-md-12 text-center">

<h4>

No Rooms Booked Yet

</h4>

</div>

<%

}

%>

</div>

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