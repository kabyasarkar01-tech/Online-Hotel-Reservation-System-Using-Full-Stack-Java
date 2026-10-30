<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%

String hotelId=request.getParameter("hotelId");

String msg="Delete Failed";
String btnClass="error-btn";

Connection con=null;
PreparedStatement ps=null;
PreparedStatement ps2=null;
PreparedStatement ps3=null;
ResultSet rs=null;

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:xe",
            "username",
            "password");

    String photo="";

    ps=con.prepareStatement(
            "select PHOTO from HOTELS where HOTEL_ID=?");

    ps.setString(1,hotelId);

    rs=ps.executeQuery();

    if(rs.next()){

        photo=rs.getString("PHOTO");

    }

    if(rs!=null){
        rs.close();
        rs=null;
    }

    if(ps!=null){
        ps.close();
        ps=null;
    }

    ps2=con.prepareStatement(
            "delete from ROOMS where HOTEL_ID=?");

    ps2.setString(1,hotelId);

    ps2.executeUpdate();

    ps3=con.prepareStatement(
            "delete from HOTELS where HOTEL_ID=?");

    ps3.setString(1,hotelId);

    int x=ps3.executeUpdate();

    if(x>0){

        if(photo!=null && !photo.equals("")){

            ServletContext context=pageContext.getServletContext();

            String filePath=context.getRealPath("/images");

            File image=new File(filePath,photo);

            if(image.exists()){

                image.delete();

            }

        }

        msg="Hotel Deleted Successfully";

        btnClass="success-btn";

    }

}catch(Exception e){

    e.printStackTrace();

    msg="Delete Failed : "+e.getMessage();

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
        if(ps2!=null)
            ps2.close();
    }catch(Exception e){}

    try{
        if(ps3!=null)
            ps3.close();
    }catch(Exception e){}

    try{
        if(con!=null)
            con.close();
    }catch(Exception e){}

}

%>

<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Delete Hotel</title>

<style>

body{
    margin:0;
    padding:0;
    font-family:Arial,sans-serif;
    background:#f5f5f5;
}

.modal{
    display:block;
    position:fixed;
    left:0;
    top:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.5);
}

.modal-content{
    background:white;
    width:350px;
    margin:200px auto;
    padding:30px;
    border-radius:10px;
    text-align:center;
    box-shadow:0 8px 20px rgba(0,0,0,0.2);
}

.modal-content h3{
    color:#444;
    margin-bottom:20px;
}

.modal-content p{
    font-size:16px;
    color:#555;
    margin-bottom:25px;
}

.ok-btn{
    color:white;
    border:none;
    border-radius:8px;
    padding:12px;
    width:100%;
    font-size:16px;
    font-weight:bold;
    cursor:pointer;
}

.success-btn{
    background:#28a745;
}

.success-btn:hover{
    background:#218838;
}

.error-btn{
    background:#dc3545;
}

.error-btn:hover{
    background:#c82333;
}

</style>

<script>

function goBack(){

    window.location="viewHotel.jsp";

}

</script>

</head>

<body>

<div class="modal">

<div class="modal-content">

<h3>Delete Hotel</h3>

<p><%=msg%></p>

<button class="ok-btn <%=btnClass%>" onclick="goBack()">

Back

</button>

</div>

</div>

</body>
</html>