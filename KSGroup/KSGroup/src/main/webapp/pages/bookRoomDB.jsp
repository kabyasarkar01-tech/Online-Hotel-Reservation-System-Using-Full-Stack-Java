<%@ page import="java.sql.*" %>

<%

String customer_Id=(String)session.getAttribute("customer_Id");

if(customer_Id==null || customer_Id.equals("")){

    response.sendRedirect("login.jsp");

    return;

}

String hotel_Id=request.getParameter("hotel_Id");
String room_Id=request.getParameter("room_Id");
String fromDate=request.getParameter("fromDate");
String toDate=request.getParameter("toDate");
String noOfPeople=request.getParameter("noOfPeople");

Connection con=null;

PreparedStatement ps=null;
PreparedStatement ps2=null;
PreparedStatement ps3=null;
PreparedStatement ps4=null;

ResultSet rs=null;

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection(

        "jdbc:oracle:thin:@localhost:1521:xe",

        "username",

        "password"

    );

    /*
     * Start transaction
     */

    con.setAutoCommit(false);


    /*
     * First check whether the room is still available
     * for the selected date range.
     *
     * A room is unavailable if an existing booking overlaps
     * with the requested dates.
     */

    ps=con.prepareStatement(

        "select R.PRICE, R.CATEGORY, R.CAPACITY, " +
        "H.HOTEL_NAME " +
        "from ROOMS R " +
        "join HOTELS H " +
        "on R.HOTEL_ID=H.HOTEL_ID " +
        "where R.HOTEL_ID=? " +
        "and R.ROOM_ID=? " +
        "and R.STATUS='AVAILABLE' " +
        "and R.CAPACITY>=? " +
        "and not exists (" +
        "select 1 from BOOKINGS B " +
        "where B.HOTEL_ID=R.HOTEL_ID " +
        "and B.ROOM_ID=R.ROOM_ID " +
        "and B.STATUS='BOOKED' " +
        "and B.FROM_DATE < TO_DATE(?,'YYYY-MM-DD') " +
        "and B.TO_DATE > TO_DATE(?,'YYYY-MM-DD')" +
        ")"

    );

    ps.setString(1,hotel_Id);
    ps.setString(2,room_Id);
    ps.setInt(3,Integer.parseInt(noOfPeople));

    ps.setString(4,toDate);
    ps.setString(5,fromDate);

    rs=ps.executeQuery();


    /*
     * Room is no longer available
     */

    if(!rs.next()){

        con.rollback();

        response.sendRedirect(

            "hotelRooms.jsp?hotel_Id="
            +hotel_Id
            +"&fromDate="
            +fromDate
            +"&toDate="
            +toDate
            +"&noOfPeople="
            +noOfPeople
            +"&error=unavailable"

        );

        return;

    }


    double price=rs.getDouble("PRICE");

    String category=rs.getString("CATEGORY");

    String hotelName=rs.getString("HOTEL_NAME");


    /*
     * Calculate number of nights
     */

    java.sql.Date sqlFromDate=
        java.sql.Date.valueOf(fromDate);

    java.sql.Date sqlToDate=
        java.sql.Date.valueOf(toDate);

    long difference=
        sqlToDate.getTime()
        -sqlFromDate.getTime();

    long noOfNights=
        difference/(1000L*60*60*24);


    /*
     * Calculate total amount
     */

    double totalAmount=
        price*noOfNights;


    /*
     * Generate Booking ID
     *
     * B001
     * B002
     * B003
     * ...
     */

    String nextId="B001";


    ps2=con.prepareStatement(

    	    "select max(booking_id) from (" +
    	    "select booking_id from bookings " +
    	    "union all " +
    	    "select booking_id from payments" +
    	    ")"

    	);

    	ResultSet rs2=ps2.executeQuery();


    	if(rs2.next() && rs2.getString(1)!=null){

    	    String lastId=rs2.getString(1);

    	    int num=
    	        Integer.parseInt(
    	            lastId.substring(1)
    	        );

    	    nextId=
    	        "B"+String.format("%03d",num+1);

    	}

    	rs2.close();


    /*
     * Get customer details
     */

    ps3=con.prepareStatement(

        "select FIRST_NAME,MIDDLE_NAME,LAST_NAME " +
        "from CUSTOMERS " +
        "where CUSTOMER_ID=?"

    );

    ps3.setString(1,customer_Id);

    ResultSet customerRs=
        ps3.executeQuery();


    String firstName="";
    String middleName="";
    String lastName="";


    if(customerRs.next()){

        firstName=
            customerRs.getString("FIRST_NAME");

        middleName=
            customerRs.getString("MIDDLE_NAME");

        lastName=
            customerRs.getString("LAST_NAME");

    }

    customerRs.close();


    /*
     * Insert booking
     */

    ps4=con.prepareStatement(

        "insert into BOOKINGS " +
        "(BOOKING_ID,CUSTOMER_ID,HOTEL_ID,ROOM_ID," +
        "FROM_DATE,TO_DATE,NO_OF_PEOPLE,TOTAL_AMOUNT," +
        "BOOKING_DATE) " +

        "values " +
        "(?,?,?,?,?,?,?,?,SYSDATE)"

    );

    ps4.setString(1,nextId);
    ps4.setString(2,customer_Id);
    ps4.setString(3,hotel_Id);
    ps4.setString(4,room_Id);
    ps4.setDate(5,sqlFromDate);
    ps4.setDate(6,sqlToDate);
    ps4.setInt(7,Integer.parseInt(noOfPeople));
    ps4.setDouble(8,totalAmount);

    int bookingResult=
        ps4.executeUpdate();


    /*
     * Insert payment
     */

    PreparedStatement paymentPs=
        con.prepareStatement(

            "insert into PAYMENTS " +
            "(BOOKING_ID,CUSTOMER_ID,FIRST_NAME," +
            "MIDDLE_NAME,LAST_NAME,PAID_ON,HOTEL_NAME," +
            "PAID_AMOUNT,ROOM_TYPE,NO_OF_PEOPLE) " +

            "values " +
            "(?,?,?,?,?,SYSDATE,?,?,?,?)"

        );


    paymentPs.setString(1,nextId);
    paymentPs.setString(2,customer_Id);
    paymentPs.setString(3,firstName);
    paymentPs.setString(4,middleName);
    paymentPs.setString(5,lastName);
    paymentPs.setString(6,hotelName);
    paymentPs.setDouble(7,totalAmount);
    paymentPs.setString(8,category);
    paymentPs.setInt(
        9,
        Integer.parseInt(noOfPeople)
    );


    int paymentResult=
        paymentPs.executeUpdate();


    /*
     * Only commit when BOTH operations succeed.
     */

    if(bookingResult>0 && paymentResult>0){

        con.commit();

        /*
         * Go to confirmation page
         */

        response.sendRedirect(

            "bookingConfirmation.jsp"
            +"?booking_Id="+nextId

        );

        return;

    }
    else{

        con.rollback();

        out.println("Booking Failed.");

    }

    paymentPs.close();


}
catch(Exception e){

    try{

        if(con!=null)
            con.rollback();

    }
    catch(Exception ex){}

    out.println(
        "Booking Failed : "
        +e.getMessage()
    );

}
finally{


    try{

        if(rs!=null)
            rs.close();

    }
    catch(Exception e){}


    try{

        if(ps!=null)
            ps.close();

    }
    catch(Exception e){}


    try{

        if(ps2!=null)
            ps2.close();

    }
    catch(Exception e){}


    try{

        if(ps3!=null)
            ps3.close();

    }
    catch(Exception e){}


    try{

        if(ps4!=null)
            ps4.close();

    }
    catch(Exception e){}


    try{

        if(con!=null){

            con.setAutoCommit(true);

            con.close();

        }

    }
    catch(Exception e){}

}

%>