<%@ page import="java.sql.*" %>

<%

String username=request.getParameter("username");
String password=request.getParameter("password");

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

boolean loginSuccess=false;
boolean defaultCredentials=false;

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "username",
        "password"
    );

    ps=con.prepareStatement(
        "select * from KSGROUP_ADMIN where USERNAME=? and PASSWORD=?"
    );

    ps.setString(1,username);
    ps.setString(2,password);

    rs=ps.executeQuery();

    if(rs.next()){

        loginSuccess=true;

        session.setAttribute("admin",username);

        if(username.equals("admin") && password.equals("admin")){
            defaultCredentials=true;
        }
    }

%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Login</title>

<style>

body{
    margin:0;
    padding:0;
    font-family:Arial,sans-serif;
    background:#f5f5f5;
}

/* DIALOG */

.dialog-overlay{

    position:fixed;

    top:0;
    left:0;

    width:100%;
    height:100%;

    background:rgba(0,0,0,0.5);

    display:flex;

    justify-content:center;
    align-items:center;

    z-index:9999;
}

.dialog-box{

    background:white;

    width:400px;
    max-width:90%;

    border-radius:10px;

    box-shadow:
    0 10px 30px rgba(0,0,0,0.25);

    overflow:hidden;

    text-align:center;
}

.dialog-title{

    background:#c59d5f;

    color:white;

    padding:15px;

    font-size:20px;

    font-weight:bold;
}

.dialog-message{

    padding:25px 20px 15px;

    font-size:15px;

    color:#444;
}

.dialog-buttons{

    display:flex;

    justify-content:center;

    padding:8px 20px 20px;
}

.ok-btn{

    background:#28a745;

    color:white;

    border:none;

    border-radius:6px;

    padding:9px 30px;

    font-size:14px;

    font-weight:bold;

    cursor:pointer;
}

.ok-btn:hover{

    background:#218838;
}

</style>

<script>

function goToChangePassword(){

    window.location="changePassword.jsp";

}

function goToLogin(){

    window.location="adminLogin.jsp";

}

</script>

</head>

<body>

<%

if(loginSuccess && defaultCredentials){

%>

<!-- DEFAULT CREDENTIALS DIALOG -->

<div class="dialog-overlay">

    <div class="dialog-box">

        <div class="dialog-title">

            Change Credentials

        </div>

        <div class="dialog-message">

            Your default credentials are still being used.<br>
            Please change your username and password.

        </div>

        <div class="dialog-buttons">

            <button
                type="button"
                class="ok-btn"
                onclick="goToChangePassword()">

                OK

            </button>

        </div>

    </div>

</div>

<%

}else if(!loginSuccess){

%>

<!-- LOGIN FAILED DIALOG -->

<div class="dialog-overlay">

    <div class="dialog-box">

        <div class="dialog-title">

            Login Failed

        </div>

        <div class="dialog-message">

            Please enter the correct username and password.

        </div>

        <div class="dialog-buttons">

            <button
                type="button"
                class="ok-btn"
                onclick="goToLogin()">

                OK

            </button>

        </div>

    </div>

</div>

<%

}else{

    response.sendRedirect("home.jsp");

}

%>

</body>

</html>

<%

}catch(Exception e){

    out.println(
        "<h3 style='color:red;text-align:center;margin-top:100px;'>" +
        "Error : " + e.getMessage() +
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