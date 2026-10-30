<%@ page import="java.sql.*" %>

<%

String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){

    response.sendRedirect("adminLogin.jsp");

    return;

}


String booking_Id=request.getParameter("booking_Id");


if(booking_Id==null || booking_Id.equals("")){

    response.sendRedirect("bookings.jsp");

    return;

}


Connection con=null;

PreparedStatement ps=null;


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
     * Only a BOOKED booking can be
     * checked out.
     */

    ps=con.prepareStatement(

        "update BOOKINGS " +

        "set STATUS='CHECKED_OUT' " +

        "where BOOKING_ID=? " +

        "and STATUS='BOOKED'"

    );


    ps.setString(1,booking_Id);


    int result=ps.executeUpdate();


    if(result>0){

        /*
         * Booking is now CHECKED_OUT.
         *
         * Because the user-side availability
         * query checks only STATUS='BOOKED',
         * this room is immediately available
         * again for future bookings.
         */

        response.sendRedirect("bookings.jsp");

        return;

    }
    else{

        out.println(

            "<h3 style='text-align:center;" +
            "margin-top:100px;'>" +

            "Unable to check out this booking." +

            "</h3>"

        );

    }


}
catch(Exception e){

    out.println(

        "<h3 style='color:red;" +
        "text-align:center;" +
        "margin-top:100px;'>" +

        "Checkout Failed : "
        +e.getMessage() +

        "</h3>"

    );

}
finally{


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