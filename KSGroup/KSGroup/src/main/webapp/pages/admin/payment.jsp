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

        "select " +

        "p.BOOKING_ID," +
        "p.CUSTOMER_ID," +
        "p.FIRST_NAME," +
        "p.MIDDLE_NAME," +
        "p.LAST_NAME," +
        "p.PAID_ON," +
        "p.PAID_AMOUNT," +

        "b.STATUS " +

        "from PAYMENTS p " +

        "left join BOOKINGS b " +
        "on p.BOOKING_ID=b.BOOKING_ID " +

        "order by p.BOOKING_ID"

    );

    rs=ps.executeQuery();

%>

<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Payments - KS Group</title>

<style>

body{

    margin:0;
    padding:0;
    font-family:Arial,sans-serif;
    background:#f5f5f5;

}


/* HEADER */

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

/* BACK BUTTON */

.top-home{
    position:absolute;
    top:18px;
    left:20px;
}

.top-home a{
    text-decoration:none;
}

.top-home button{
    padding:8px 18px;
    font-size:13px;
    font-weight:bold;
    border:none;
    border-radius:6px;
    background:#007bff;
    color:white;
    cursor:pointer;
}

.top-home button:hover{
    background:#0069d9;
}

/* CONTAINER */

.container{

    width:95%;
    max-width:1300px;
    margin:40px auto;

    background:white;

    padding:35px;

    border-radius:12px;

    box-shadow:
    0 8px 20px rgba(0,0,0,0.15);

}

h2{

    text-align:center;
    color:#444;
    margin-bottom:30px;

}


/* TABLE */

.table-container{

    overflow-x:auto;

}

table{

    width:100%;
    border-collapse:collapse;
    font-size:15px;

}

th{

    background:#c59d5f;
    color:white;
    padding:13px;
    text-align:center;

}

td{

    padding:13px;
    text-align:center;
    border-bottom:1px solid #ddd;

}

tr:nth-child(even){

    background:#f9f9f9;

}

tr:hover{

    background:#f1f1f1;

}


/* CANCELLED */

.cancelled{

    display:block;

    color:#dc3545;

    font-size:13px;

    font-weight:bold;

    margin-top:4px;

}


/* DELETE BUTTON */

.delete-btn{

    background:#dc3545;

    color:white;

    border:none;

    border-radius:7px;

    padding:10px 20px;

    font-size:14px;

    font-weight:bold;

    cursor:pointer;

}

.delete-btn:hover{

    background:#c82333;

}

/* MODAL */

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


/* MODAL CONTENT */

.modal-content{

    background:white;

    width:400px;

    margin:200px auto;

    padding:30px;

    border-radius:10px;

    text-align:center;

    box-shadow:
    0 8px 20px rgba(0,0,0,0.2);

}

.modal-content h3{

    color:#444;

    margin-bottom:20px;

}

.modal-content p{

    margin-bottom:25px;

    font-size:16px;

    color:#555;

}


/* MODAL BUTTON GROUP */

.button-group{

    display:flex;

    justify-content:center;

    gap:20px;

}


/* YES */

.yes-btn{

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

.yes-btn:hover{

    background:#218838;

}


/* NO */

.no-btn{

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

.no-btn:hover{

    background:#c82333;

}


/* SUCCESS MODAL */

.success-modal{

    display:none;

    position:fixed;

    z-index:2000;

    left:0;

    top:0;

    width:100%;

    height:100%;

    background:rgba(0,0,0,0.5);

}

.success-modal-content{

    background:white;

    width:400px;

    max-width:90%;

    margin:200px auto;

    padding:30px;

    border-radius:12px;

    text-align:center;

    box-shadow:
    0 8px 25px rgba(0,0,0,0.25);

}

.success-modal-content h3{

    color:#28a745;

    margin-bottom:15px;

}

.success-modal-content p{

    color:#555;

    font-size:16px;

    margin-bottom:25px;

}

.success-ok-btn{

    background:#28a745;

    color:white;

    border:none;

    border-radius:8px;

    padding:12px 35px;

    font-size:16px;

    font-weight:bold;

    cursor:pointer;

}

.success-ok-btn:hover{

    background:#218838;

}

</style>


<script>

var selectedBookingId="";


/* DELETE MODAL */

function openDeleteModal(bookingId){

    selectedBookingId=bookingId;

    document.getElementById(
        "deleteModal"
    ).style.display="block";

}


/* CLOSE DELETE MODAL */

function closeDeleteModal(){

    selectedBookingId="";

    document.getElementById(
        "deleteModal"
    ).style.display="none";

}


/* CONFIRM DELETE */

function confirmDelete(){

    if(selectedBookingId==""){

        return;

    }

    window.location=
        "deletePayment.jsp?booking_Id="
        +encodeURIComponent(selectedBookingId);

}


/* CLOSE SUCCESS */

function closeSuccessModal(){

    document.getElementById(
        "successModal"
    ).style.display="none";

}


/* SHOW SUCCESS AFTER DELETE */

window.onload=function(){

    const params=
        new URLSearchParams(
            window.location.search
        );

    if(params.get("deleted")=="1"){

        document.getElementById(
            "successModal"
        ).style.display="block";

        window.history.replaceState(
            {},
            document.title,
            "payment.jsp"
        );

    }

};

</script>

</head>


<body>

<div class="top-home">

    <a href="home.jsp">

        <button type="button">
            Back
        </button>

    </a>

</div>

<div class="header">

    <span>KS</span> Group Admin Panel

</div>


<div class="container">

<h2>

    Payments

</h2>


<div class="table-container">

<table>

<thead>

<tr>

<th>
Booking ID
</th>

<th>
Customer ID
</th>

<th>
Customer Name
</th>

<th>
Paid On
</th>

<th>
Paid Amount
</th>

<th>
Action
</th>

</tr>

</thead>


<tbody>

<%

boolean found=false;

while(rs.next()){

    found=true;

    String middleName=
        rs.getString("MIDDLE_NAME");

    if(middleName==null){

        middleName="";

    }

    String status=
        rs.getString("STATUS");

%>

<tr>


<!-- BOOKING ID -->

<td>

<%=rs.getString("BOOKING_ID")%>

</td>


<!-- CUSTOMER ID -->

<td>

<%=rs.getString("CUSTOMER_ID")%>

</td>


<!-- CUSTOMER NAME -->

<td>

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


<!-- PAID DATE -->

<td>

<%=rs.getDate("PAID_ON")%>

</td>


<!-- PAID AMOUNT -->

<td>

Rs.

<%=String.format(
    "%.2f",
    rs.getDouble("PAID_AMOUNT")
)%>


<%

if(
    "CANCELLED".equalsIgnoreCase(status)
){

%>

<span class="cancelled">

    CANCELLED

</span>

<%

}

%>

</td>


<!-- ACTION -->

<td>

<button

type="button"

class="delete-btn"

onclick="openDeleteModal(
'<%=rs.getString("BOOKING_ID")%>'
)">

Delete

</button>

</td>


</tr>


<%

}


if(!found){

%>

<tr>

<td
colspan="6"
style="
padding:30px;
color:#777;
font-size:16px;
">

No payment records found.

</td>

</tr>

<%

}

%>

</tbody>

</table>

</div>
</div>


<!-- DELETE MODAL -->

<div
id="deleteModal"
class="modal">

<div class="modal-content">

<h3>

Delete Payment

</h3>

<p>

Are you sure you want to delete this payment record?

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


<!-- SUCCESS MODAL -->

<div
id="successModal"
class="success-modal">

<div class="success-modal-content">

<h3>

Payment Deleted

</h3>

<p>

The payment record has been successfully deleted.

</p>

<button
type="button"
class="success-ok-btn"
onclick="closeSuccessModal()">

OK

</button>

</div>

</div>


</body>

</html>


<%

}
catch(Exception e){

    out.println(

        "<h3 style='color:red;" +
        "text-align:center;" +
        "margin-top:100px;'>" +

        "Error : " +
        e.getMessage() +

        "</h3>"

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

        if(con!=null)
            con.close();

    }catch(Exception e){}

}

%>