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


if(
    messageId == null ||
    messageId.trim().equals("")
){

    out.print("INVALID_MESSAGE");
    return;

}


messageId =
    messageId.trim();


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
   DATABASE
   ================================================== */

Connection con = null;

PreparedStatement deleteRepliesPs = null;
PreparedStatement deleteMessagePs = null;


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
     * ==================================================
     * DELETE ALL DESCENDANT REPLIES
     * ==================================================
     *
     * If:
     *
     * M001
     *   |
     *   M002
     *      |
     *      M003
     *
     * deleting M002 also deletes M003.
     */

    deleteRepliesPs =
        con.prepareStatement(

            "delete from CONTACT_MESSAGES " +
            "where MESSAGE_ID in " +
            "(" +

                "select MESSAGE_ID " +
                "from CONTACT_MESSAGES " +

                "start with PARENT_ID=? " +

                "connect by prior MESSAGE_ID=PARENT_ID" +

            ")"

        );


    deleteRepliesPs.setString(
        1,
        messageId
    );


    deleteRepliesPs.executeUpdate();


    /*
     * ==================================================
     * DELETE SELECTED MESSAGE
     * ==================================================
     */

    deleteMessagePs =
        con.prepareStatement(

            "delete from CONTACT_MESSAGES " +
            "where MESSAGE_ID=? " +
            "and IS_ADMIN='N'"

        );


    deleteMessagePs.setString(
        1,
        messageId
    );


    int result =
        deleteMessagePs.executeUpdate();


    if(result > 0){

        /*
         * Remove the deleted message from the
         * guest session ownership list.
         */

        if(!customerLoggedIn){

            if(guestMessageIds != null){

                guestMessageIds.remove(
                    messageId
                );

                session.setAttribute(
                    "guestMessageIds",
                    guestMessageIds
                );

            }

        }


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

        if(deleteRepliesPs != null)
            deleteRepliesPs.close();

    }
    catch(Exception e){}


    try{

        if(deleteMessagePs != null)
            deleteMessagePs.close();

    }
    catch(Exception e){}


    try{

        if(con != null)
            con.close();

    }
    catch(Exception e){}

}

%>