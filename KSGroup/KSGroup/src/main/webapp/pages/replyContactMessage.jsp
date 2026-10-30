<%@ page import="java.sql.*" %>

<%
response.setContentType("text/plain");
response.setCharacterEncoding("UTF-8");

/* ==================================================
   CHECK LOGGED-IN USER
   ================================================== */

String loggedCustomerId =
    (String)session.getAttribute("customer_Id");

String loggedAdmin =
    (String)session.getAttribute("admin");

boolean isCustomer =
    loggedCustomerId != null &&
    !loggedCustomerId.trim().equals("");

boolean isAdmin =
    loggedAdmin != null &&
    !loggedAdmin.trim().equals("");

/*
 * Customer takes priority.
 *
 * If a customer is logged in, the reply MUST be
 * stored as a customer reply.
 */
if(isCustomer){
    isAdmin = false;
}

if(!isCustomer && !isAdmin){
    out.print("LOGIN_REQUIRED");
    return;
}


/* ==================================================
   PARAMETERS
   ================================================== */

String messageId =
    request.getParameter("messageId");

String messageText =
    request.getParameter("messageText");

if(
    messageId == null ||
    messageId.trim().equals("")
){
    out.print("ERROR");
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
   DATABASE
   ================================================== */

Connection con = null;

PreparedStatement parentPs = null;
PreparedStatement customerPs = null;
PreparedStatement idPs = null;
PreparedStatement insertPs = null;

ResultSet parentRs = null;
ResultSet customerRs = null;
ResultSet idRs = null;

try{

    Class.forName(
        "oracle.jdbc.driver.OracleDriver"
    );

    con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "username",
        "password"
    );


    /* ==================================================
       VERIFY THAT THE MESSAGE BEING REPLIED TO EXISTS
       ================================================== */

    parentPs =
        con.prepareStatement(
            "select MESSAGE_ID " +
            "from CONTACT_MESSAGES " +
            "where MESSAGE_ID=?"
        );

    parentPs.setString(
        1,
        messageId
    );

    parentRs =
        parentPs.executeQuery();

    if(!parentRs.next()){

        out.print("ERROR");
        return;
    }


    /* ==================================================
       VARIABLES
       ================================================== */

    String customerId = null;

    String firstName = null;
    String middleName = null;
    String lastName = null;

    String phone = null;
    String email = null;
    String fullName = null;

    String newIsAdmin = null;


    /* ==================================================
       CUSTOMER REPLY
       ================================================== */

    if(isCustomer){

        /*
         * ALWAYS use the logged-in customer's ID.
         */
        customerId =
            loggedCustomerId;


        customerPs =
            con.prepareStatement(
                "select " +
                "FIRST_NAME," +
                "MIDDLE_NAME," +
                "LAST_NAME," +
                "PHONE," +
                "EMAIL " +
                "from CUSTOMERS " +
                "where CUSTOMER_ID=?"
            );

        customerPs.setString(
            1,
            loggedCustomerId
        );

        customerRs =
            customerPs.executeQuery();

        if(!customerRs.next()){

            out.print("ERROR");
            return;
        }


        firstName =
            customerRs.getString(
                "FIRST_NAME"
            );

        middleName =
            customerRs.getString(
                "MIDDLE_NAME"
            );

        lastName =
            customerRs.getString(
                "LAST_NAME"
            );

        phone =
            customerRs.getString(
                "PHONE"
            );

        email =
            customerRs.getString(
                "EMAIL"
            );


        /* BUILD FULL NAME */

        fullName =
            firstName;

        if(
            middleName != null &&
            !middleName.trim().equals("")
        ){

            fullName +=
                " " + middleName;
        }

        if(
            lastName != null &&
            !lastName.trim().equals("")
        ){

            fullName +=
                " " + lastName;
        }


        newIsAdmin = "N";
    }


    /* ==================================================
       ADMIN REPLY
       ================================================== */

    else{

        customerId = null;

        firstName = "KS Group";
        middleName = null;
        lastName = "Admin";

        phone = null;
        email = null;

        fullName = "KS Group Admin";

        newIsAdmin = "Y";
    }



    /* ==================================================
    INSERT REPLY
    ================================================== */

 insertPs =
     con.prepareStatement(

         "insert into CONTACT_MESSAGES " +

         "(" +

         "MESSAGE_ID," +
         "CUSTOMER_ID," +
         "FIRST_NAME," +
         "MIDDLE_NAME," +
         "LAST_NAME," +
         "MESSAGE_TEXT," +
         "PARENT_ID," +
         "IS_ADMIN," +
         "CREATED_AT," +
         "UPDATED_AT," +
         "PHONE," +
         "EMAIL," +
         "FULL_NAME" +

         ") " +

         "values " +

         "('M' || LPAD(CONTACT_MESSAGE_SEQ.NEXTVAL,3,'0'),?,?,?,?,?,?,?,SYSDATE,NULL,?,?,?)"

     );


 /* ==================================================
    CUSTOMER ID
    ================================================== */

 if(customerId == null){

     insertPs.setNull(
         1,
         java.sql.Types.VARCHAR
     );

 }
 else{

     insertPs.setString(
         1,
         customerId
     );

 }


 /* ==================================================
    FIRST NAME
    ================================================== */

 insertPs.setString(
     2,
     firstName
 );


 /* ==================================================
    MIDDLE NAME
    ================================================== */

 if(middleName == null){

     insertPs.setNull(
         3,
         java.sql.Types.VARCHAR
     );

 }
 else{

     insertPs.setString(
         3,
         middleName
     );

 }


 /* ==================================================
    LAST NAME
    ================================================== */

 insertPs.setString(
     4,
     lastName
 );


 /* ==================================================
    MESSAGE
    ================================================== */

 insertPs.setString(
     5,
     messageText
 );


 /* ==================================================
    PARENT MESSAGE
    ================================================== */

 insertPs.setString(
     6,
     messageId
 );


 /* ==================================================
    ADMIN / CUSTOMER
    ================================================== */

 insertPs.setString(
     7,
     newIsAdmin
 );


 /* ==================================================
    PHONE
    ================================================== */

 if(phone == null){

     insertPs.setNull(
         8,
         java.sql.Types.VARCHAR
     );

 }
 else{

     insertPs.setString(
         8,
         phone
     );

 }


 /* ==================================================
    EMAIL
    ================================================== */

 if(email == null){

     insertPs.setNull(
         9,
         java.sql.Types.VARCHAR
     );

 }
 else{

     insertPs.setString(
         9,
         email
     );

 }


 /* ==================================================
    FULL NAME
    ================================================== */

 insertPs.setString(
     10,
     fullName
 );


 /* ==================================================
    EXECUTE
    ================================================== */

 int result =
     insertPs.executeUpdate();

 if(result > 0){

     out.print("SUCCESS");

 }
 else{

     out.print("ERROR");

 }

}
catch(Exception e){

    /*
     * IMPORTANT:
     * Do not silently hide the actual database error
     * while testing.
     */
    out.print(
        "ERROR:" +
        e.getMessage()
    );

}
finally{

    try{
        if(parentRs != null)
            parentRs.close();
    }
    catch(Exception e){}

    try{
        if(customerRs != null)
            customerRs.close();
    }
    catch(Exception e){}

    try{
        if(idRs != null)
            idRs.close();
    }
    catch(Exception e){}

    try{
        if(parentPs != null)
            parentPs.close();
    }
    catch(Exception e){}

    try{
        if(customerPs != null)
            customerPs.close();
    }
    catch(Exception e){}

    try{
        if(idPs != null)
            idPs.close();
    }
    catch(Exception e){}

    try{
        if(insertPs != null)
            insertPs.close();
    }
    catch(Exception e){}

    try{
        if(con != null)
            con.close();
    }
    catch(Exception e){}
}

%>