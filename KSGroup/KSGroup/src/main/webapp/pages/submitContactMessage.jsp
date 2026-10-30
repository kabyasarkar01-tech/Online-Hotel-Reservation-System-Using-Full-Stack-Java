<%@ page import="java.sql.*" %>

<%

String customerId =
    (String)session.getAttribute("customer_Id");


String message =
    request.getParameter("messageText");


if(
    message == null ||
    message.trim().equals("")
){
    response.sendRedirect("contact.jsp");
    return;
}

message = message.trim();


/*
 * ==================================================
 * GUEST INFORMATION
 * ==================================================
 */

String guestFullName =
    request.getParameter("fullName");

String guestPhone =
    request.getParameter("phoneNo");

String guestEmail =
    request.getParameter("emailId");


/*
 * ==================================================
 * CUSTOMER INFORMATION
 * ==================================================
 */

String firstName = null;
String middleName = null;
String lastName = null;


/*
 * ==================================================
 * FINAL VALUES
 * ==================================================
 */

String fullName = null;
String phoneNo = null;
String emailId = null;


Connection con = null;

PreparedStatement psCustomer = null;
PreparedStatement psInsert = null;

ResultSet rsCustomer = null;


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
     * LOGGED-IN CUSTOMER
     * ==================================================
     */

    if(
        customerId != null &&
        !customerId.trim().equals("")
    ){

        /*
         * Get customer details.
         */

        psCustomer =
            con.prepareStatement(
                "select FIRST_NAME," +
                "MIDDLE_NAME," +
                "LAST_NAME," +
                "PHONE," +
                "EMAIL " +
                "from CUSTOMERS " +
                "where CUSTOMER_ID=?"
            );


        psCustomer.setString(
            1,
            customerId
        );


        rsCustomer =
            psCustomer.executeQuery();


        if(!rsCustomer.next()){

            response.sendRedirect(
                "contact.jsp"
            );

            return;
        }


        firstName =
            rsCustomer.getString(
                "FIRST_NAME"
            );


        middleName =
            rsCustomer.getString(
                "MIDDLE_NAME"
            );


        lastName =
            rsCustomer.getString(
                "LAST_NAME"
            );


        phoneNo =
            rsCustomer.getString(
                "PHONE"
            );


        emailId =
            rsCustomer.getString(
                "EMAIL"
            );


        /*
         * Build complete customer name.
         */

        fullName = firstName;


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

    }


    /*
     * ==================================================
     * GUEST USER
     * ==================================================
     */

    else{

        /*
         * Full Name
         */

        if(
            guestFullName == null ||
            guestFullName.trim().equals("")
        ){

            response.sendRedirect(
                "contact.jsp"
            );

            return;
        }


        /*
         * Phone
         */

        if(
            guestPhone == null ||
            !guestPhone.matches("[0-9]{10}")
        ){

            response.sendRedirect(
                "contact.jsp"
            );

            return;
        }


        /*
         * Email
         */

        if(
            guestEmail == null ||
            guestEmail.trim().equals("")
        ){

            response.sendRedirect(
                "contact.jsp"
            );

            return;
        }


        /*
         * Store guest name as one complete name.
         */

        fullName =
            guestFullName.trim();


        phoneNo =
            guestPhone.trim();


        emailId =
            guestEmail.trim();


        /*
         * Because FIRST_NAME and LAST_NAME
         * are NOT NULL:
         *
         * FULL_NAME = actual guest name
         * FIRST_NAME = actual guest name
         * LAST_NAME = "-"
         */

        firstName =
            fullName;


        middleName =
            null;


        lastName =
            "-";

    }


    /*
     * ==================================================
     * INSERT MESSAGE
     * ==================================================
     *
     * MESSAGE_ID is generated directly by Oracle:
     *
     * M001
     * M002
     * M003
     * ...
     *
     * using CONTACT_MESSAGE_SEQ.
     *
     * There is NO MAX(MESSAGE_ID) anymore.
     *
     * ==================================================
     */

    psInsert =
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

            "(" +

            "'M' || LPAD(CONTACT_MESSAGE_SEQ.NEXTVAL,3,'0')," +

            "?," +
            "?," +
            "?," +
            "?," +
            "?," +
            "?," +
            "?," +

            "SYSDATE," +

            "NULL," +

            "?," +
            "?," +
            "?" +

            ")"

        );


    /*
     * ==================================================
     * CUSTOMER ID
     * ==================================================
     */

    if(
        customerId == null ||
        customerId.trim().equals("")
    ){

        psInsert.setNull(
            1,
            java.sql.Types.VARCHAR
        );

    }
    else{

        psInsert.setString(
            1,
            customerId
        );

    }


    /*
     * ==================================================
     * FIRST NAME
     * ==================================================
     */

    if(firstName == null){

        psInsert.setNull(
            2,
            java.sql.Types.VARCHAR
        );

    }
    else{

        psInsert.setString(
            2,
            firstName
        );

    }


    /*
     * ==================================================
     * MIDDLE NAME
     * ==================================================
     */

    if(middleName == null){

        psInsert.setNull(
            3,
            java.sql.Types.VARCHAR
        );

    }
    else{

        psInsert.setString(
            3,
            middleName
        );

    }


    /*
     * ==================================================
     * LAST NAME
     * ==================================================
     */

    if(lastName == null){

        psInsert.setNull(
            4,
            java.sql.Types.VARCHAR
        );

    }
    else{

        psInsert.setString(
            4,
            lastName
        );

    }


    /*
     * ==================================================
     * MESSAGE
     * ==================================================
     */

    psInsert.setString(
        5,
        message
    );


    /*
     * ==================================================
     * PARENT ID
     *
     * New message = no parent.
     * ==================================================
     */

    psInsert.setNull(
        6,
        java.sql.Types.VARCHAR
    );


    /*
     * ==================================================
     * IS ADMIN
     *
     * New message is always from customer/guest.
     * ==================================================
     */

    psInsert.setString(
        7,
        "N"
    );


    /*
     * ==================================================
     * PHONE
     * ==================================================
     */

    psInsert.setString(
        8,
        phoneNo
    );


    /*
     * ==================================================
     * EMAIL
     * ==================================================
     */

    psInsert.setString(
        9,
        emailId
    );


    /*
     * ==================================================
     * FULL NAME
     * ==================================================
     */

    psInsert.setString(
        10,
        fullName
    );


    /*
     * ==================================================
     * EXECUTE INSERT
     * ==================================================
     */

    int result =
        psInsert.executeUpdate();


    /*
     * ==================================================
     * SUCCESS
     * ==================================================
     */

    if(result > 0){

        /*
         * For a guest user, we need to remember
         * which message belongs to this browser session.
         *
         * Since the ID was generated by Oracle,
         * get the ID that was generated.
         */

        if(
            customerId == null ||
            customerId.trim().equals("")
        ){

            /*
             * Get the latest generated sequence value.
             */

            PreparedStatement seqPs =
                null;

            ResultSet seqRs =
                null;

            try{

                seqPs =
                    con.prepareStatement(
                        "select " +
                        "'M' || " +
                        "LPAD(CONTACT_MESSAGE_SEQ.CURRVAL,3,'0') " +
                        "from DUAL"
                    );


                seqRs =
                    seqPs.executeQuery();


                if(seqRs.next()){

                    String generatedMessageId =
                        seqRs.getString(1);


                    java.util.Set<String>
                        guestMessages =

                        (java.util.Set<String>)
                        session.getAttribute(
                            "guestMessageIds"
                        );


                    if(guestMessages == null){

                        guestMessages =
                            new java.util.HashSet<String>();

                    }


                    guestMessages.add(
                        generatedMessageId
                    );


                    session.setAttribute(
                        "guestMessageIds",
                        guestMessages
                    );

                }

            }
            finally{

                try{

                    if(seqRs != null)
                        seqRs.close();

                }
                catch(Exception e){}


                try{

                    if(seqPs != null)
                        seqPs.close();

                }
                catch(Exception e){}

            }

        }


        response.sendRedirect(
            "contact.jsp?message=success"
        );

        return;

    }
    else{

        response.sendRedirect(
            "contact.jsp?message=failed"
        );

        return;

    }


}
catch(Exception e){

    out.println(

        "<h3 style='color:red;" +
        "text-align:center;" +
        "margin-top:100px;'>" +

        "Message Failed : " +

        e.getMessage() +

        "</h3>"

    );

}
finally{


    try{

        if(rsCustomer != null)
            rsCustomer.close();

    }
    catch(Exception e){}


    try{

        if(psCustomer != null)
            psCustomer.close();

    }
    catch(Exception e){}


    try{

        if(psInsert != null)
            psInsert.close();

    }
    catch(Exception e){}


    try{

        if(con != null)
            con.close();

    }
    catch(Exception e){}

}

%>