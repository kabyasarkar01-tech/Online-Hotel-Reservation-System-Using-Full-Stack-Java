<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
    return;
}

String city=request.getParameter("city");
String fromDate=request.getParameter("fromDate");
String toDate=request.getParameter("toDate");

Connection con=null;

PreparedStatement ps=null;
ResultSet rs=null;

PreparedStatement psHotel=null;
ResultSet rsHotel=null;

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "username",
        "password"
    );


    /* =========================================
       GET HOTELS OF SELECTED CITY
       ========================================= */

    psHotel=con.prepareStatement(

        "select HOTEL_NAME, PHOTO " +
        "from HOTELS " +
        "where CITY=? " +
        "order by HOTEL_NAME"

    );

    psHotel.setString(1,city);

    rsHotel=psHotel.executeQuery();


    /* =========================================
       GET BOOKINGS
       ========================================= */

    ps=con.prepareStatement(

        "select " +

        "b.BOOKING_ID," +
        "b.HOTEL_ID," +
        "b.CUSTOMER_ID," +
        "b.STATUS," +

        "c.FIRST_NAME," +
        "c.MIDDLE_NAME," +
        "c.LAST_NAME," +

        "b.FROM_DATE," +
        "b.TO_DATE," +
        "b.BOOKING_DATE," +
        "b.NO_OF_PEOPLE," +

        "b.ROOM_ID," +

        "r.CATEGORY," +
        "r.PHOTO," +

        "h.HOTEL_NAME " +

        "from BOOKINGS b " +

        "join CUSTOMERS c " +
        "on b.CUSTOMER_ID=c.CUSTOMER_ID " +

        "join ROOMS r " +
        "on b.HOTEL_ID=r.HOTEL_ID " +
        "and b.ROOM_ID=r.ROOM_ID " +

        "join HOTELS h " +
        "on b.HOTEL_ID=h.HOTEL_ID " +

        "where h.CITY=? " +

        "and b.FROM_DATE < TO_DATE(?,'YYYY-MM-DD') + 1 " +

        "and b.TO_DATE >= TO_DATE(?,'YYYY-MM-DD') " +

        "order by b.BOOKING_ID"

    );


    ps.setString(1,city);

    ps.setString(2,toDate);

    ps.setString(3,fromDate);

    rs=ps.executeQuery();

%>


<!-- HOTEL PREVIEW -->

<div style="
display:flex;
flex-wrap:wrap;
justify-content:center;
gap:25px;
margin-bottom:35px;
">

<%

while(rsHotel.next()){

%>

<div style="
width:260px;
background:white;
border-radius:12px;
box-shadow:0 5px 15px rgba(0,0,0,0.2);
padding:15px;
text-align:center;
">

<img

src="../../images/<%=rsHotel.getString("PHOTO")%>"

style="
width:230px;
height:150px;
object-fit:cover;
border-radius:10px;
">

<h3 style="
margin-top:12px;
color:#444;
">

<%=rsHotel.getString("HOTEL_NAME")%>

</h3>

</div>

<%

}

%>

</div>


<!-- BOOKING TABLE -->

<div style="overflow-x:auto;">

<table
style="
width:100%;
border-collapse:collapse;
font-size:14px;
">

<thead>

<tr
style="
background:#c59d5f;
color:white;
">

<th style="padding:12px;">
Booking ID
</th>

<th style="padding:12px;">
Name
</th>

<th style="padding:12px;">
Hotel
</th>

<th style="padding:12px;">
From
</th>

<th style="padding:12px;">
To
</th>

<th style="padding:12px;">
Booked On
</th>

<th style="padding:12px;">
Room ID
</th>

<th style="padding:12px;">
Type
</th>

<th style="padding:12px;">
People
</th>

<th style="padding:12px;">
Room Image
</th>

<th style="padding:12px;">
Action
</th>

</tr>

</thead>


<tbody>

<%

boolean found=false;

while(rs.next()){

    found=true;

    String middleName=rs.getString("MIDDLE_NAME");

    if(middleName==null){
        middleName="";
    }

    String status=rs.getString("STATUS");

%>


<tr style="border-bottom:1px solid #ddd;">


<!-- BOOKING ID -->

<td align="center" style="padding:12px;">

<%=rs.getString("BOOKING_ID")%>

</td>


<!-- CUSTOMER NAME -->

<td align="center" style="padding:12px;">

<%=rs.getString("FIRST_NAME")%>

<%

if(!middleName.equals("")){

%>

<%=middleName%>

<%

}

%>

<%=rs.getString("LAST_NAME")%>

</td>


<!-- HOTEL -->

<td align="center" style="padding:12px;">

<%=rs.getString("HOTEL_NAME")%>

</td>


<!-- FROM DATE -->

<td align="center" style="padding:12px;">

<%

if("CANCELLED".equalsIgnoreCase(status)){

%>

<span style="
color:#dc3545;
font-weight:bold;
">

CANCELLED

</span>

<%

}
else if("CHECKED_OUT".equalsIgnoreCase(status)){

%>

<span style="
color:#6c757d;
font-weight:bold;
">

CHECKED OUT

</span>

<%

}
else{

%>

<%=rs.getDate("FROM_DATE")%>

<%

}

%>

</td>


<!-- TO DATE -->

<td align="center" style="padding:12px;">

<%

if("CANCELLED".equalsIgnoreCase(status)){

%>

<span style="
color:#dc3545;
font-weight:bold;
">

CANCELLED

</span>

<%

}
else if("CHECKED_OUT".equalsIgnoreCase(status)){

%>

<span style="
color:#6c757d;
font-weight:bold;
">

CHECKED OUT

</span>

<%

}
else{

%>

<%=rs.getDate("TO_DATE")%>

<%

}

%>

</td>


<!-- BOOKING DATE -->

<td align="center" style="padding:12px;">

<%=rs.getDate("BOOKING_DATE")%>

</td>


<!-- ROOM ID -->

<td align="center" style="padding:12px;">

<%=rs.getString("ROOM_ID")%>

</td>


<!-- ROOM TYPE -->

<td align="center" style="padding:12px;">

<%=rs.getString("CATEGORY")%>

</td>


<!-- PEOPLE -->

<td align="center" style="padding:12px;">

<%=rs.getInt("NO_OF_PEOPLE")%>

</td>


<!-- ROOM IMAGE -->

<td align="center" style="padding:12px;">

<img

src="../../images/<%=rs.getString("PHOTO")%>"

style="
width:150px;
height:100px;
border-radius:8px;
object-fit:cover;
">

</td>


<!-- ACTION -->

<td align="center" style="padding:12px;">

<%

if("BOOKED".equalsIgnoreCase(status)){

%>

<button
type="button"
class="checkout-btn"

onclick="openCheckoutModal(
'<%=rs.getString("BOOKING_ID")%>'
)">

Check Out

</button>

<%

}
else if(
    "CANCELLED".equalsIgnoreCase(status)
    ||
    "CHECKED_OUT".equalsIgnoreCase(status)
){

%>

<button
type="button"
class="delete-btn"

onclick="openDeleteModal(
'<%=rs.getString("BOOKING_ID")%>',
'<%=city%>',
'<%=fromDate%>',
'<%=toDate%>'
)">

Delete

</button>

<%

}

%>

</td>


</tr>


<%

}

%>


<%

if(!found){

%>

<tr>

<td
colspan="12"
style="
text-align:center;
padding:30px;
color:#777;
font-size:16px;
">

No bookings found for the selected city and date range.

</td>

</tr>

<%

}

%>

</tbody>

</table>

</div>


<%

}
catch(Exception e){

    out.println(

        "<div style=" +
        "'color:red;text-align:center;" +
        "padding:20px;'>" +

        e.getMessage() +

        "</div>"

    );

}
finally{

    try{

        if(rs!=null)
            rs.close();

    }catch(Exception e){}


    try{

        if(ps!=null)
            ps.close();

    }catch(Exception e){}


    try{

        if(rsHotel!=null)
            rsHotel.close();

    }catch(Exception e){}


    try{

        if(psHotel!=null)
            psHotel.close();

    }catch(Exception e){}


    try{

        if(con!=null)
            con.close();

    }catch(Exception e){}

}

%>