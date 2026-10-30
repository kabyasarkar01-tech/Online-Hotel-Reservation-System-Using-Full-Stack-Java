<%@ page import="java.sql.*" %>

<%

/* ==================================================
   IDENTIFY LOGGED-IN USER
   ================================================== */

String loggedAdmin =
    (String)session.getAttribute("admin");

String loggedCustomerId =
    (String)session.getAttribute("customer_Id");

boolean isAdminUser =
    loggedAdmin != null &&
    !loggedAdmin.trim().equals("");

boolean isCustomerUser =
    loggedCustomerId != null &&
    !loggedCustomerId.trim().equals("");

/* At least one user must be logged in */

if(!isAdminUser && !isCustomerUser){

    response.sendRedirect("index.jsp");
    return;
}


/* ==================================================
   GET PARAMETERS
   ================================================== */

String parentId =
    request.getParameter("parentId");

String message =
    request.getParameter("message");


if(
    parentId == null ||
    parentId.trim().equals("") ||
    message == null ||
    message.trim().equals("")
){

    if(isAdminUser){
        response.sendRedirect("reports.jsp");
    }
    else{
        response.sendRedirect("contact.jsp");
    }

    return;
}


parentId = parentId.trim();
message = message.trim();


/* ==================================================
   DATABASE VARIABLES
   ================================================== */

Connection con = null;
PreparedStatement ps = null;
ResultSet rs = null;


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
       GET THE MESSAGE BEING REPLIED TO
       ================================================== */

    ps = con.prepareStatement(

        "select " +
        "MESSAGE_ID, " +
        "CUSTOMER_ID, " +
        "FIRST_NAME, " +
        "MIDDLE_NAME, " +
        "LAST_NAME, " +
        "PHONE, " +
        "EMAIL, " +
        "FULL_NAME, " +
        "IS_ADMIN " +
        "from CONTACT_MESSAGES " +
        "where MESSAGE_ID=?"

    );

    ps.setString(1,parentId);

    rs = ps.executeQuery();


    if(!rs.next()){

        rs.close();
        ps.close();
        con.close();

        out.println("<script>");

        out.println(
            "alert('Message not found.');"
        );

        if(isAdminUser){

            out.println(
                "window.location='reports.jsp';"
            );

        }
        else{

            out.println(
                "window.location='contact.jsp';"
            );

        }

        out.println("</script>");

        return;
    }


    /* ==================================================
       INFORMATION FROM PARENT MESSAGE
       ================================================== */

    String parentCustomerId =
        rs.getString("CUSTOMER_ID");

    String parentFirstName =
        rs.getString("FIRST_NAME");

    String parentMiddleName =
        rs.getString("MIDDLE_NAME");

    String parentLastName =
        rs.getString("LAST_NAME");

    String parentPhone =
        rs.getString("PHONE");

    String parentEmail =
        rs.getString("EMAIL");

    String parentFullName =
        rs.getString("FULL_NAME");

    String parentIsAdmin =
        rs.getString("IS_ADMIN");


    rs.close();
    rs = null;

    ps.close();
    ps = null;


    /* ==================================================
       GENERATE NEW MESSAGE ID
       ================================================== */

    ps = con.prepareStatement(
        "select max(message_id) " +
        "from CONTACT_MESSAGES"
    );

    rs = ps.executeQuery();

    String messageId = "M101";


    if(rs.next()){

        String maxId =
            rs.getString(1);

        if(
            maxId != null &&
            !maxId.trim().equals("")
        ){

            int number =
                Integer.parseInt(
                    maxId.substring(1)
                );

            messageId =
                "M" + (number + 1);
        }
    }


    rs.close();
    rs = null;

    ps.close();
    ps = null;


    /* ==================================================
       VARIABLES FOR NEW REPLY
       ================================================== */

    String customerId = null;

    String firstName = null;

    String middleName = null;

    String lastName = null;

    String phone = null;

    String email = null;

    String fullName = null;

    String newMessageIsAdmin = null;


    /* ==================================================
       ADMIN REPLY
       ================================================== */

    if(isAdminUser){

        /*
         * Keep the conversation's customer ID.
         *
         * This is important because an admin reply
         * must still belong to the customer's
         * conversation.
         */

        customerId =
            parentCustomerId;


        /*
         * Admin identity
         */

        firstName =
            "KS Group";

        middleName =
            null;

        lastName =
            "Admin";

        fullName =
            "KS Group Admin";


        /*
         * Keep customer's contact details.
         */

        phone =
            parentPhone;

        email =
            parentEmail;


        /*
         * Mark this message as ADMIN.
         */

        newMessageIsAdmin =
            "Y";
    }


    /* ==================================================
       CUSTOMER REPLY
       ================================================== */

    else if(isCustomerUser){

        /*
         * Always use the logged-in customer's ID.
         *
         * DO NOT use parentCustomerId here because
         * the parent could be an ADMIN message.
         */

        customerId =
            loggedCustomerId;


        /*
         * Get the customer's actual information
         * from one of their own previous messages.
         */

        PreparedStatement customerPs = null;

        ResultSet customerRs = null;


        try{

            customerPs = con.prepareStatement(

                "select " +
                "FIRST_NAME, " +
                "MIDDLE_NAME, " +
                "LAST_NAME, " +
                "PHONE, " +
                "EMAIL, " +
                "FULL_NAME " +
                "from CONTACT_MESSAGES " +
                "where CUSTOMER_ID=? " +
                "and IS_ADMIN='N' " +
                "order by CREATED_AT asc"

            );


            customerPs.setString(
                1,
                loggedCustomerId
            );


            customerRs =
                customerPs.executeQuery();


            if(customerRs.next()){

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

                fullName =
                    customerRs.getString(
                        "FULL_NAME"
                    );
            }

        }
        finally{

            try{

                if(customerRs != null)
                    customerRs.close();

            }
            catch(Exception e){}


            try{

                if(customerPs != null)
                    customerPs.close();

            }
            catch(Exception e){}
        }


        /*
         * If customer information was not found
         * for some reason, use information from
         * the parent message as fallback.
         */

        if(
            firstName == null ||
            firstName.trim().equals("")
        ){

            firstName =
                parentFirstName;
        }


        if(
            middleName == null
        ){

            middleName =
                parentMiddleName;
        }


        if(
            lastName == null ||
            lastName.trim().equals("")
        ){

            lastName =
                parentLastName;
        }


        if(
            phone == null ||
            phone.trim().equals("")
        ){

            phone =
                parentPhone;
        }


        if(
            email == null ||
            email.trim().equals("")
        ){

            email =
                parentEmail;
        }


        if(
            fullName == null ||
            fullName.trim().equals("")
        ){

            fullName =
                parentFullName;
        }


        /*
         * Mark this message as CUSTOMER.
         */

        newMessageIsAdmin =
            "N";
    }


    /* ==================================================
       INSERT REPLY
       ================================================== */

    ps = con.prepareStatement(

        "insert into CONTACT_MESSAGES " +
        "(MESSAGE_ID, CUSTOMER_ID, FIRST_NAME, " +
        "MIDDLE_NAME, LAST_NAME, MESSAGE_TEXT, " +
        "PARENT_ID, IS_ADMIN, CREATED_AT, UPDATED_AT, " +
        "PHONE, EMAIL, FULL_NAME) " +

        "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"

    );


    ps.setString(
        1,
        messageId
    );


    ps.setString(
        2,
        customerId
    );


    ps.setString(
        3,
        firstName
    );


    ps.setString(
        4,
        middleName
    );


    ps.setString(
        5,
        lastName
    );


    ps.setString(
        6,
        message
    );


    /*
     * IMPORTANT
     *
     * The new reply is a child of the
     * exact message being replied to.
     *
     * Therefore:
     *
     * Customer
     *     M101
     *
     * Admin reply
     *     M102 -> PARENT_ID = M101
     *
     * Customer reply
     *     M103 -> PARENT_ID = M102
     *
     * Admin reply
     *     M104 -> PARENT_ID = M103
     */

    ps.setString(
        7,
        parentId
    );


    ps.setString(
        8,
        newMessageIsAdmin
    );


    /*
     * CREATED_AT
     */

    ps.setTimestamp(
        9,
        new Timestamp(
            System.currentTimeMillis()
        )
    );


    /*
     * UPDATED_AT
     *
     * NULL means the message has never
     * been edited.
     */

    ps.setTimestamp(
        10,
        null
    );


    ps.setString(
        11,
        phone
    );


    ps.setString(
        12,
        email
    );


    ps.setString(
        13,
        fullName
    );


    ps.executeUpdate();

    ps.close();
    ps = null;


    /* ==================================================
       RETURN TO CORRECT PAGE
       ================================================== */

    if(isAdminUser){

        response.sendRedirect(
            "reports.jsp"
        );

    }
    else{

        response.sendRedirect(
            "contact.jsp"
        );

    }

    return;


}
catch(Exception e){

    out.println(
        "<h3>Error while sending reply</h3>"
    );

    out.println(
        "<p>" +
        e.getMessage() +
        "</p>"
    );

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

%>