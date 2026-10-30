<%@ page import="java.sql.*" %>

<%
String confirm=request.getParameter("confirm");

if(confirm==null){
%>

<!DOCTYPE html>
<html>
<head>

<meta charset="UTF-8">

<title>Delete Account</title>

<link rel="stylesheet" href="../css/bootstrap.css">

<link href="https://fonts.googleapis.com/css?family=Playfair+Display:400,700,900|Rubik:300,400,700" rel="stylesheet">

<style>

body{

    margin:0;
    padding:0;
    height:100vh;

    display:flex;
    justify-content:center;
    align-items:center;

    background:url("../images/big_image_1.jpg");
    background-size:cover;
    background-position:center;

    font-family:'Rubik',sans-serif;

}

.overlay{

    position:fixed;
    top:0;
    left:0;

    width:100%;
    height:100%;

    background:rgba(0,0,0,.55);

}

.box{

    position:relative;

    width:90%;
    max-width:520px;

    background:#fff;

    border-radius:12px;

    padding:40px;

    text-align:center;

    box-shadow:0 10px 30px rgba(0,0,0,.35);

    z-index:100;

}

h2{

    font-family:'Playfair Display',serif;

    color:#dc3545;

    margin-bottom:20px;

}

p{

    font-size:18px;

    color:#444;

    margin-bottom:35px;

}

.btn{

    width:160px;

    padding:12px;

    border:none;

    border-radius:30px;

    color:white;

    font-weight:bold;

    text-decoration:none;

    display:inline-block;

    margin:8px;

}

.yes{

    background:#dc3545;

}

.yes:hover{

    background:#c82333;

    color:white;

}

.no{

    background:#28a745;

}

.no:hover{

    background:#218838;

    color:white;

}

</style>

</head>

<body>

<div class="overlay"></div>

<div class="box">

<h2>Delete Account</h2>

<p>

Are you sure you want to delete your account?<br>

This action cannot be undone.

</p>

<a
href="deleteAccount.jsp?confirm=yes"
class="btn yes">

Yes

</a>

<a
href="profile.jsp"
class="btn no">

No

</a>

</div>

</body>

</html>

<%

return;

}

String customerId=(String)session.getAttribute("customer_Id");

if(customerId==null){

    response.sendRedirect("login.jsp");
    return;

}

Connection con=null;
PreparedStatement ps=null;

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection(
    "jdbc:oracle:thin:@localhost:1521:xe",
    "username",
    "password");

    ps=con.prepareStatement(
    "delete from customers where customer_id=?");

    ps.setString(1,customerId);

    int x=ps.executeUpdate();

    if(x>0){

        session.invalidate();

        response.sendRedirect(
        "message.jsp?msg="+
        java.net.URLEncoder.encode(
        "Account Deleted Successfully.",
        "UTF-8")
        +"&nextPage=../index.jsp"
        +"&button="+
        java.net.URLEncoder.encode(
        "Home",
        "UTF-8"));

        return;

    }
    else{

        response.sendRedirect(
        "message.jsp?msg="+
        java.net.URLEncoder.encode(
        "Unable to Delete Account.",
        "UTF-8")
        +"&nextPage=profile.jsp"
        +"&button="+
        java.net.URLEncoder.encode(
        "Back",
        "UTF-8"));

        return;

    }

}
catch(Exception e){

    response.sendRedirect(
    "message.jsp?msg="+
    java.net.URLEncoder.encode(
    "Error : "+e.getMessage(),
    "UTF-8")
    +"&nextPage=profile.jsp"
    +"&button="+
    java.net.URLEncoder.encode(
    "Back",
    "UTF-8"));

    return;

}
finally{

    try{

        if(ps!=null)
            ps.close();

        if(con!=null)
            con.close();

    }
    catch(Exception ex){}

}
%>