<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
    return;
}

String hotel_id=request.getParameter("hotel_id");

Connection con=null;

PreparedStatement hotelPs=null;
PreparedStatement countPs=null;
PreparedStatement roomPs=null;

ResultSet hotelRs=null;
ResultSet countRs=null;
ResultSet rs=null;

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "username",
        "password"
    );


    /* =========================
       GET HOTEL INFORMATION
       ========================= */

    hotelPs=con.prepareStatement(
        "select HOTEL_NAME, CITY, PHOTO " +
        "from HOTELS " +
        "where HOTEL_ID=?"
    );

    hotelPs.setString(1,hotel_id);

    hotelRs=hotelPs.executeQuery();


    String hotelName="";
    String city="";
    String hotelPhoto="";


    if(hotelRs.next()){

        hotelName=hotelRs.getString("HOTEL_NAME");
        city=hotelRs.getString("CITY");
        hotelPhoto=hotelRs.getString("PHOTO");

    }


    /* =========================
       GET TOTAL ROOM COUNT
       ========================= */

    countPs=con.prepareStatement(
        "select count(*) " +
        "from ROOMS " +
        "where HOTEL_ID=?"
    );

    countPs.setString(1,hotel_id);

    countRs=countPs.executeQuery();


    int roomCount=0;

    if(countRs.next()){

        roomCount=countRs.getInt(1);

    }


    /* =========================
       DISPLAY HOTEL INFORMATION
       ========================= */

%>

<div class="hotel-preview">

    <%
    if(hotelPhoto!=null && !hotelPhoto.equals("")){
    %>

        <img
            src="../../images/<%=hotelPhoto%>"
            alt="Hotel Image"
            class="hotel-image"
        >

    <%
    }else{
    %>

        <div class="no-hotel-image">
            No Image
        </div>

    <%
    }
    %>


    <h3>
        <%=hotelName%>
    </h3>


    <p>
        City : <%=city%>
    </p>


    <p class="room-count">

        Total Rooms : 
        <strong><%=roomCount%></strong>

    </p>

</div>


<%
    /* =========================
       GET ROOMS
       ========================= */

    roomPs=con.prepareStatement(
        "select ROOM_ID, CATEGORY, PRICE, CAPACITY, PHOTO " +
        "from ROOMS " +
        "where HOTEL_ID=? " +
        "order by ROOM_ID"
    );

    roomPs.setString(1,hotel_id);

    rs=roomPs.executeQuery();


    boolean found=false;
%>


<table class="room-table">

    <tr>

        <th>Room ID</th>

        <th>Category</th>

        <th>Price</th>

        <th>Capacity</th>

        <th>Room</th>

        <th></th>

    </tr>


<%
while(rs.next()){

    found=true;
%>


    <tr>

        <td>

            <%=rs.getString("ROOM_ID")%>

        </td>


        <td>

            <%=rs.getString("CATEGORY")%>

        </td>


        <td>

            <%=rs.getDouble("PRICE")%>

        </td>


        <td>

            <%=rs.getInt("CAPACITY")%>
            Person<%=rs.getInt("CAPACITY")==1?"":"s"%>

        </td>


        <td>

            <%
            String roomPhoto=rs.getString("PHOTO");

            if(roomPhoto!=null && !roomPhoto.equals("")){
            %>

                <img
                    src="../../images/<%=roomPhoto%>"
                    alt="Room Image"
                    class="room-image"
                >

            <%
            }else{
            %>

                No Image

            <%
            }
            %>

        </td>


        <td>

            <button
                type="button"
                class="delete-btn"
                onclick="deleteRoom(
                    '<%=hotel_id%>',
                    '<%=rs.getString("ROOM_ID")%>'
                )"
            >

                Delete

            </button>

        </td>

    </tr>


<%
}


if(!found){
%>


    <tr>

        <td colspan="6">

            No Rooms Found

        </td>

    </tr>


<%
}
%>

</table>


<%

}catch(Exception e){

    out.println(e);

}finally{


    try{
        if(hotelRs!=null)
            hotelRs.close();
    }catch(Exception e){}


    try{
        if(hotelPs!=null)
            hotelPs.close();
    }catch(Exception e){}


    try{
        if(countRs!=null)
            countRs.close();
    }catch(Exception e){}


    try{
        if(countPs!=null)
            countPs.close();
    }catch(Exception e){}


    try{
        if(rs!=null)
            rs.close();
    }catch(Exception e){}


    try{
        if(roomPs!=null)
            roomPs.close();
    }catch(Exception e){}


    try{
        if(con!=null)
            con.close();
    }catch(Exception e){}

}
%>