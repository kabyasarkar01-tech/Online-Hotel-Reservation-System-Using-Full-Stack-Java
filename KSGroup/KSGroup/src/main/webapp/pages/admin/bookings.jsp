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
        "select distinct CITY from HOTELS order by CITY"
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

<title>Bookings - KS Group</title>

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
    width:95%;
    max-width:1300px;
    margin:40px auto;
    background:white;
    padding:35px;
    border-radius:12px;
    box-shadow:0 8px 20px rgba(0,0,0,0.15);
}

h2{
    text-align:center;
    color:#444;
    margin-bottom:35px;
}

.search-box{

    display:grid;
    grid-template-columns:2fr 1fr 1fr 1fr;
    gap:20px;
    align-items:end;

}

.form-group label{

    display:block;
    margin-bottom:8px;
    font-weight:bold;
    color:#444;

}

.form-group input,
.form-group select{

    width:100%;
    padding:12px;
    border:1px solid #ccc;
    border-radius:6px;
    font-size:15px;
    box-sizing:border-box;

}

.form-group input:focus,
.form-group select:focus{

    outline:none;
    border-color:#c59d5f;

}

.search-btn{

    padding:13px;
    background:#007bff;
    color:white;
    border:none;
    border-radius:8px;
    font-size:16px;
    font-weight:bold;
    cursor:pointer;

}

.search-btn:hover{
    background:#0056b3;
}

.clear-btn{

    padding:13px 35px;
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

#bookingResult{
    margin-top:35px;
}

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

.to-date-row{
    display:flex;
    gap:10px;
    align-items:center;
}

.to-date-row input{
    width:100%;
    flex:1;
    box-sizing:border-box;
}

.to-date-row .clear-btn{
    padding:12px 20px;
    white-space:nowrap;
}

.search-box{
    display:grid;
    grid-template-columns:2fr 1fr 1fr;
    gap:20px;
    align-items:end;
}

.search-button-container{
    text-align:center;
    margin-top:25px;
}

.search-button-container .search-btn{
    padding:13px 45px;
}

/* MODAL */

.modal{

    display:none;
    position:fixed;
    z-index:1000;
    left:0;
    top:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.5);
    align-items:center;
    justify-content:center;

}

.modal-content{

    background:white;
    padding:25px;
    border-radius:10px;
    width:400px;
    text-align:center;
    box-shadow:0 8px 20px rgba(0,0,0,0.2);

}

.modal-content h3{
    margin-top:0;
    color:#444;
}

.modal-content p{
    margin:20px 0;
    color:#555;
    font-size:16px;
}


/* CHECKOUT */

.checkout-btn{

    background:#28a745;
    color:white;
    border:none;
    padding:12px 18px;
    border-radius:8px;
    font-size:15px;
    font-weight:bold;
    cursor:pointer;

}

.checkout-btn:hover{
    background:#218838;
}


/* DELETE */

.delete-btn{

    background:#dc3545;
    color:white;
    border:none;
    padding:12px 25px;
    border-radius:8px;
    font-size:15px;
    font-weight:bold;
    cursor:pointer;

}

.delete-btn:hover{
    background:#c82333;
}


/* MODAL BUTTONS */

.yes-btn{

    background:#28a745;
    color:white;
    border:none;
    padding:10px 25px;
    border-radius:5px;
    cursor:pointer;
    font-weight:bold;

}

.yes-btn:hover{
    background:#218838;
}

.no-btn{

    background:#dc3545;
    color:white;
    border:none;
    padding:10px 25px;
    border-radius:5px;
    cursor:pointer;
    font-weight:bold;

}

.no-btn:hover{
    background:#c82333;
}

.ok-btn{

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

.ok-btn:hover{
    background:#c82333;
}

.success-modal{

    display:none;
    position:fixed;
    z-index:9999;
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
    box-shadow:0 8px 25px rgba(0,0,0,0.25);

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


/* =========================================
   SEARCH BOOKINGS
   ========================================= */

function searchBookings(){

    var city=document.getElementById("city").value;
    var from=document.getElementById("fromDate").value;
    var to=document.getElementById("toDate").value;

    if(city=="" || from=="" || to==""){

        document.getElementById("alertModal").style.display="flex";

        document.querySelector("#alertModal p").innerHTML=
            "Please fill all search fields.";

        return;

    }

    if(from>to){

        document.getElementById("alertModal").style.display="flex";

        document.querySelector("#alertModal p").innerHTML=
            "To Date cannot be before From Date.";

        return;

    }

    var xhttp=new XMLHttpRequest();

    xhttp.onreadystatechange=function(){

        if(this.readyState==4 && this.status==200){

            document.getElementById("bookingResult").innerHTML=
                this.responseText;

        }

    };

    xhttp.open(
        "GET",
        "getBookings.jsp?city="
        +encodeURIComponent(city)
        +"&fromDate="
        +encodeURIComponent(from)
        +"&toDate="
        +encodeURIComponent(to),
        true
    );

    xhttp.send();

}


/* =========================================
   CLEAR SEARCH
   ========================================= */

function clearSearch(){

    document.getElementById("city").selectedIndex=0;

    document.getElementById("fromDate").value="";

    document.getElementById("toDate").value="";

    document.getElementById("bookingResult").innerHTML="";

}


/* =========================================
   ALERT MODAL
   ========================================= */

function closeAlertModal(){

    document.getElementById("alertModal").style.display="none";

}


/* =========================================
   CHECKOUT / DELETE VARIABLES
   ========================================= */

var selectedBookingId="";

var selectedAction="";


/* =========================================
   OPEN CHECKOUT MODAL
   ========================================= */

function openCheckoutModal(bookingId){

    selectedBookingId=bookingId;

    selectedAction="CHECKOUT";

    document.getElementById("actionModalTitle").innerHTML=
        "Confirm Checkout";

    document.getElementById("actionModalText").innerHTML=
        "Are you sure this customer has checked out?";

    document.getElementById("actionModal").style.display="flex";

}


/* =========================================
   OPEN DELETE MODAL
   ========================================= */

   function openDeleteModal(bookingId){

	    selectedBookingId=bookingId;

	    selectedAction="DELETE";

	    document.getElementById("actionModalTitle").innerHTML=
	        "Delete Booking";

	    document.getElementById("actionModalText").innerHTML=
	        "Are you sure you want to delete this booking?";

	    document.getElementById("actionModal").style.display="flex";

	}


/* =========================================
   CLOSE ACTION MODAL
   ========================================= */

function closeActionModal(){

    document.getElementById("actionModal").style.display="none";

    selectedBookingId="";

    selectedAction="";

}


/* =========================================
   CONFIRM ACTION
   ========================================= */

function confirmAction(){

    if(selectedBookingId==""){
        return;
    }

    var id=selectedBookingId;

    var action=selectedAction;

    closeActionModal();


    if(action=="CHECKOUT"){

        window.location=
            "checkoutBooking.jsp?booking_Id="
            +encodeURIComponent(id);

    }
    else if(action=="DELETE"){

        var city=document.getElementById("city").value;
        var from=document.getElementById("fromDate").value;
        var to=document.getElementById("toDate").value;

        window.location=
            "deleteBooking.jsp?booking_Id="
            +encodeURIComponent(id)
            +"&city="
            +encodeURIComponent(city)
            +"&fromDate="
            +encodeURIComponent(from)
            +"&toDate="
            +encodeURIComponent(to);

    }

}

function closeSuccessModal(){

    document.getElementById("successModal").style.display="none";

}

window.onload=function(){

    const params=new URLSearchParams(window.location.search);

    if(params.get("deleted")=="1"){

        document.getElementById("successModal").style.display="block";

        /*
         * Remove ?deleted=1 from URL
         * after showing the message.
         */

        window.history.replaceState(
            {},
            document.title,
            "bookings.jsp"
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

<h2>Bookings</h2>


<div class="search-box">


<div class="form-group">

<label>City</label>

<select id="city">

<option value="" selected hidden>

--Select City--

</option>

<%

while(rs.next()){

%>

<option value="<%=rs.getString("CITY")%>">

<%=rs.getString("CITY")%>

</option>

<%

}

%>

</select>

</div>



<div class="form-group">

<label>From Date</label>

<input
type="date"
id="fromDate">

</div>



<div class="form-group">

<label>To Date</label>

<div class="to-date-row">

<input
type="date"
id="toDate">

<button
type="button"
class="clear-btn"
onclick="clearSearch()">

Clear

</button>

</div>

</div>


</div>


<div class="search-button-container">

<button
type="button"
class="search-btn"
onclick="searchBookings()">

Search

</button>

</div>


<div id="bookingResult"></div>


</div>



<!-- ALERT MODAL -->

<div id="alertModal" class="modal">

<div class="modal-content">

<h3>Warning</h3>

<p>

Please fill all search fields.

</p>

<button
type="button"
class="ok-btn"
onclick="closeAlertModal()">

OK

</button>

</div>

</div>



<!-- CHECKOUT / DELETE MODAL -->

<div id="actionModal" class="modal">

<div class="modal-content">

<h3 id="actionModalTitle">

Confirm

</h3>

<p id="actionModalText">

Are you sure?

</p>

<div class="button-group">

<button
type="button"
class="yes-btn"
onclick="confirmAction()">

Yes

</button>

<button
type="button"
class="no-btn"
onclick="closeActionModal()">

No

</button>

</div>

</div>

</div>



<!-- SUCCESS MODAL -->

<div id="successModal" class="success-modal">

    <div class="success-modal-content">

        <h3>Booking Deleted</h3>

        <p>

            The booking has been successfully deleted.

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