<%@ page import="java.sql.*" %>

<%

response.setContentType("text/plain");
response.setCharacterEncoding("UTF-8");


/* ==================================================
   SESSION CUSTOMER
   ================================================== */

String customerId =
    (String)session.getAttribute(
        "customer_Id"
    );


boolean customerLoggedIn =
    customerId != null &&
    !customerId.trim().equals("");


/* ==================================================
   GUEST MESSAGE OWNERSHIP
   ================================================== */

java.util.Set<String> guestMessageIds =

    (java.util.Set<String>)
    session.getAttribute(
        "guestMessageIds"
    );


/* ==================================================
   PARAMETER
   ================================================== */

String messageId =
    request.getParameter(
        "messageId"
    );

String messageText =
    request.getParameter(
        "messageText"
    );


if(
    messageId == null ||
    messageId.trim().equals("")
){

    out.print("INVALID_MESSAGE");
    return;

}


if(
    messageText == null ||
    messageText.trim().equals("")
){

    out.print("EMPTY_MESSAGE");
    return;

}


messageId =
    messageId.trim();


messageText =
    messageText.trim();


/* ==================================================
   CHECK OWNERSHIP
   ================================================== */

boolean allowed = false;


/*
 * ==================================================
 * REGISTERED CUSTOMER
 * ==================================================
 */

if(customerLoggedIn){

    Connection con = null;
    PreparedStatement ps = null;
    ResultSet rs = null;

    try{

        Class.forName(
            "oracle.jdbc.driver.OracleDriver"
        );

        con =
            DriverManager.getConnection(
                "jdbc:oracle:thin:@localhost:1521:xe",
                "username",
                "password"
            );


        ps =
            con.prepareStatement(

                "select MESSAGE_ID " +
                "from CONTACT_MESSAGES " +
                "where MESSAGE_ID=? " +
                "and CUSTOMER_ID=? " +
                "and IS_ADMIN='N'"

            );


        ps.setString(
            1,
            messageId
        );


        ps.setString(
            2,
            customerId
        );


        rs =
            ps.executeQuery();


        if(rs.next()){

            allowed = true;

        }


    }
    catch(Exception e){

        out.print(
            "ERROR:" +
            e.getMessage()
        );

        return;

    }
    finally{

        try{
            if(rs != null)
                rs.close();
        }
        catch(Exception e){}

        try{
            if(ps != null)
                ps.close();
        }
        catch(Exception e){}

        try{
            if(con != null)
                con.close();
        }
        catch(Exception e){}

    }

}


/*
 * ==================================================
 * GUEST USER
 * ==================================================
 *
 * Guest can edit ONLY a message that was created
 * during the current session.
 */

else{

    if(
        guestMessageIds != null &&
        guestMessageIds.contains(messageId)
    ){

        allowed = true;

    }

}


/* ==================================================
   NOT ALLOWED
   ================================================== */

if(!allowed){

    out.print("NOT_ALLOWED");
    return;

}


/* ==================================================
   UPDATE MESSAGE
   ================================================== */

Connection con = null;
PreparedStatement ps = null;

try{

    Class.forName(
        "oracle.jdbc.driver.OracleDriver"
    );


    con =
        DriverManager.getConnection(
            "jdbc:oracle:thin:@localhost:1521:xe",
            "username",
            "password"
        );


    /*
     * Guest:
     *     ownership was already verified using
     *     guestMessageIds.
     *
     * Customer:
     *     ownership was already verified using
     *     CUSTOMER_ID.
     *
     * Therefore MESSAGE_ID + IS_ADMIN='N'
     * is sufficient here.
     */

    ps =
        con.prepareStatement(

            "update CONTACT_MESSAGES " +
            "set MESSAGE_TEXT=?, " +
            "UPDATED_AT=SYSDATE " +
            "where MESSAGE_ID=? " +
            "and IS_ADMIN='N'"

        );


    ps.setString(
        1,
        messageText
    );


    ps.setString(
        2,
        messageId
    );


    int result =
        ps.executeUpdate();


    if(result > 0){

        out.print("SUCCESS");

    }
    else{

        out.print("NOT_ALLOWED");

    }

}
catch(Exception e){

    out.print(
        "ERROR:" +
        e.getMessage()
    );

}
finally{

    try{

        if(ps != null)
            ps.close();

    }
    catch(Exception e){}


    try{

        if(con != null)
            con.close();

    }
    catch(Exception e){}

}

%>