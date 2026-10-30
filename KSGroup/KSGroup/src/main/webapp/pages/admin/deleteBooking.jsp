<%@ page import="java.sql.*" %>

<%

String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){

    response.sendRedirect("adminLogin.jsp");

    return;

}

String booking_Id=request.getParameter("booking_Id");

String city=request.getParameter("city");
String fromDate=request.getParameter("fromDate");
String toDate=request.getParameter("toDate");


if(booking_Id==null || booking_Id.equals("")){

    response.sendRedirect("bookings.jsp");

    return;

}


Connection con=null;

PreparedStatement psStatus=null;
PreparedStatement psDelete=null;

ResultSet rsStatus=null;


try{

    Class.forName(
        "oracle.jdbc.driver.OracleDriver"
    );


    con=DriverManager.getConnection(

        "jdbc:oracle:thin:@localhost:1521:xe",

        "username",

        "password"

    );


    /*
     * Check booking status
     */

    psStatus=con.prepareStatement(

        "select STATUS " +
        "from BOOKINGS " +
        "where BOOKING_ID=?"

    );

    psStatus.setString(1,booking_Id);

    rsStatus=psStatus.executeQuery();


    if(!rsStatus.next()){

        out.println(

            "<h3 style='text-align:center;" +
            "margin-top:100px;'>" +

            "Booking not found." +

            "</h3>"

        );

        return;

    }


    String status=rsStatus.getString("STATUS");


    /*
     * Only CANCELLED and CHECKED_OUT
     * bookings can be deleted.
     */

    if(
        !"CANCELLED".equalsIgnoreCase(status)
        &&
        !"CHECKED_OUT".equalsIgnoreCase(status)
    ){

        out.println(

            "<h3 style='color:red;" +
            "text-align:center;" +
            "margin-top:100px;'>" +

            "This booking cannot be deleted." +

            "</h3>"

        );

        return;

    }


    /*
     * Delete ONLY the booking.
     *
     * Payment record remains in PAYMENTS.
     */

    psDelete=con.prepareStatement(

        "delete from BOOKINGS " +

        "where BOOKING_ID=? " +

        "and STATUS in " +

        "('CANCELLED','CHECKED_OUT')"

    );


    psDelete.setString(1,booking_Id);


    int result=psDelete.executeUpdate();


    if(result>0){

        response.sendRedirect(
            "bookings.jsp?deleted=1" +
            "&city=" + java.net.URLEncoder.encode(city,"UTF-8") +
            "&fromDate=" + java.net.URLEncoder.encode(fromDate,"UTF-8") +
            "&toDate=" + java.net.URLEncoder.encode(toDate,"UTF-8")
        );

        return;

    }else{

        out.println(

            "<h3 style='text-align:center;" +
            "margin-top:100px;'>" +

            "Unable to delete this booking." +

            "</h3>"

        );

    }


}
catch(Exception e){

    out.println(

        "<h3 style='color:red;" +
        "text-align:center;" +
        "margin-top:100px;'>" +

        "Delete Failed : " +
        e.getMessage() +

        "</h3>"

    );

}
finally{


    try{

        if(rsStatus!=null)
            rsStatus.close();

    }
    catch(Exception e){}


    try{

        if(psStatus!=null)
            psStatus.close();

    }
    catch(Exception e){}


    try{

        if(psDelete!=null)
            psDelete.close();

    }
    catch(Exception e){}


    try{

        if(con!=null)
            con.close();

    }
    catch(Exception e){}

}

%>