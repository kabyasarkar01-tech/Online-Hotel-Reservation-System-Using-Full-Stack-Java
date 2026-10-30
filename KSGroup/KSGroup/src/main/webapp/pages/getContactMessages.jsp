<%@ page import="java.sql.*" %>

<%

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

int pageNo=1;

String pageParam=request.getParameter("page");

if(pageParam!=null){

    try{

        pageNo=Integer.parseInt(pageParam);

    }
    catch(Exception e){

        pageNo=1;

    }

}

if(pageNo<1)
    pageNo=1;


/* ==================================================
   PAGINATION

   5 ROOT CONVERSATIONS PER PAGE

   Replies do NOT count as conversations.
   ================================================== */

int conversationsPerPage=5;

int startConversation=
    (pageNo-1)*conversationsPerPage;


/* ==================================================
   CURRENT SESSION USER
   ================================================== */

String loggedCustomerId=
    (String)session.getAttribute(
        "customer_Id"
    );

String loggedAdmin=
    (String)session.getAttribute(
        "admin"
    );


boolean customerLoggedIn=
    loggedCustomerId!=null &&
    !loggedCustomerId.trim().equals("");


boolean adminLoggedIn=
    loggedAdmin!=null &&
    !loggedAdmin.trim().equals("");


/* ==================================================
   GUEST MESSAGE OWNERSHIP
   ================================================== */

java.util.Set<String> guestMessageIds=
    (java.util.Set<String>)
    session.getAttribute(
        "guestMessageIds"
    );


try{

    Class.forName(
        "oracle.jdbc.driver.OracleDriver"
    );


    con=DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "username",
        "password"
    );


    /* ==================================================
       GET ROOT CONVERSATIONS

       IMPORTANT:

       Only PARENT_ID IS NULL messages are counted
       for pagination.

       Both customer and admin root messages are
       ordered purely by timestamp.

       Newest message appears first.
       ================================================== */

    ps=con.prepareStatement(

        "select MESSAGE_ID " +

        "from CONTACT_MESSAGES " +

        "where PARENT_ID is null " +

        "order by CREATED_AT desc"

    );


    rs=ps.executeQuery();


    int conversationIndex=0;

    boolean found=false;


    /* ==================================================
       LOOP THROUGH ROOT CONVERSATIONS
       ================================================== */

    while(rs.next()){


        String parentId=
            rs.getString(
                "MESSAGE_ID"
            );


        /* ==================================================
           SKIP ROOT CONVERSATIONS FROM PREVIOUS PAGES
           ================================================== */

        if(
            conversationIndex <
            startConversation
        ){

            conversationIndex++;

            continue;

        }


        /* ==================================================
           STOP AFTER 5 ROOT CONVERSATIONS
           ================================================== */

        if(
            conversationIndex >=
            startConversation+
            conversationsPerPage
        ){

            break;

        }


        found=true;


        /* ==================================================
           CHECK WHETHER THIS ROOT HAS REPLIES

           If there is at least one direct child, then
           the conversation has replies.

           Any nested reply must have a direct parent,
           so this is sufficient to determine whether
           the root has replies.
           ================================================== */

        PreparedStatement replyCountPs=
            con.prepareStatement(

                "select count(*) " +

                "from CONTACT_MESSAGES " +

                "where PARENT_ID=?"

            );


        replyCountPs.setString(
            1,
            parentId
        );


        ResultSet replyCountRs=
            replyCountPs.executeQuery();


        int replyCount=0;


        if(replyCountRs.next()){

            replyCount=
                replyCountRs.getInt(1);

        }


        replyCountRs.close();
        replyCountPs.close();


        boolean hasReplies=
            replyCount>0;


        /* ==================================================
           GET COMPLETE CONVERSATION

           ROOT
             |
             +-- Reply
             |     |
             |     +-- Reply
             |
             +-- Reply

           The hierarchy remains together.
           ================================================== */

        PreparedStatement messagePs=
            con.prepareStatement(

                "select " +

                "MESSAGE_ID, " +
                "CUSTOMER_ID, " +
                "FIRST_NAME, " +
                "MIDDLE_NAME, " +
                "LAST_NAME, " +
                "FULL_NAME, " +
                "MESSAGE_TEXT, " +
                "PARENT_ID, " +
                "IS_ADMIN, " +
                "CREATED_AT, " +
                "UPDATED_AT, " +
                "LEVEL AS MESSAGE_LEVEL " +

                "from CONTACT_MESSAGES " +

                "start with MESSAGE_ID=? " +

                "connect by prior MESSAGE_ID=PARENT_ID " +

                "order siblings by CREATED_AT asc"

            );


        messagePs.setString(
            1,
            parentId
        );


        ResultSet messageRs=
            messagePs.executeQuery();


        boolean rootPrinted=false;


        while(messageRs.next()){


            /* ==================================================
               MESSAGE INFORMATION
               ================================================== */

            String messageId=
                messageRs.getString(
                    "MESSAGE_ID"
                );


            String customerId=
                messageRs.getString(
                    "CUSTOMER_ID"
                );


            String firstName=
                messageRs.getString(
                    "FIRST_NAME"
                );


            String middleName=
                messageRs.getString(
                    "MIDDLE_NAME"
                );


            String lastName=
                messageRs.getString(
                    "LAST_NAME"
                );


            String storedFullName=
                messageRs.getString(
                    "FULL_NAME"
                );


            String messageText=
                messageRs.getString(
                    "MESSAGE_TEXT"
                );


            String messageParentId=
                messageRs.getString(
                    "PARENT_ID"
                );


            String isAdmin=
                messageRs.getString(
                    "IS_ADMIN"
                );


            Timestamp createdAt=
                messageRs.getTimestamp(
                    "CREATED_AT"
                );


            Timestamp updatedAt=
                messageRs.getTimestamp(
                    "UPDATED_AT"
                );


            int messageLevel=
                messageRs.getInt(
                    "MESSAGE_LEVEL"
                );


            /* ==================================================
               BUILD DISPLAY NAME
               ================================================== */

            String fullName;


            if(
                storedFullName!=null &&
                !storedFullName.trim().equals("")
            ){

                fullName=
                    storedFullName;

            }
            else{

                fullName=
                    firstName!=null
                    ? firstName
                    : "";


                if(
                    middleName!=null &&
                    !middleName.trim().equals("")
                ){

                    fullName +=
                        " "+middleName;

                }


                if(
                    lastName!=null &&
                    !lastName.trim().equals("")
                ){

                    fullName +=
                        " "+lastName;

                }

            }


            /* ==================================================
               CHECK GUEST OWNERSHIP
               ================================================== */

            boolean guestOwnsMessage=false;


            if(
                guestMessageIds!=null &&
                messageId!=null &&
                guestMessageIds.contains(messageId)
            ){

                guestOwnsMessage=true;

            }


            /* ==================================================
               CALCULATE MESSAGE INDENT

               LEVEL 1 = ROOT
               LEVEL 2 = REPLY
               LEVEL 3 = REPLY TO REPLY
               etc.
               ================================================== */

            int indentLevel=
                messageLevel-1;


            if(indentLevel<0)
                indentLevel=0;


            int indentPixels=
                indentLevel*35;


            /* ==================================================
               CUSTOMER OWNERSHIP
               ================================================== */

            boolean customerOwnsMessage=false;


            if(
                customerLoggedIn &&
                customerId!=null &&
                customerId.equals(
                    loggedCustomerId
                ) &&
                "N".equalsIgnoreCase(
                    isAdmin
                )
            ){

                customerOwnsMessage=true;

            }


            /* ==================================================
               CAN EDIT / DELETE
               ================================================== */

            boolean canEditMessage=false;

            boolean canDeleteMessage=false;


            /* ==================================================
               REGISTERED CUSTOMER

               Only their own non-admin messages.
               ================================================== */

            if(customerOwnsMessage){

                canEditMessage=true;

                canDeleteMessage=true;

            }


            /* ==================================================
               GUEST

               Only messages stored in guest session.
               ================================================== */

            else if(
                !customerLoggedIn &&
                !adminLoggedIn &&
                guestOwnsMessage &&
                "N".equalsIgnoreCase(
                    isAdmin
                )
            ){

                canEditMessage=true;

                canDeleteMessage=true;

            }


            /* ==================================================
               ROOT MESSAGE
               ================================================== */

            if(messageLevel==1){

%>

<!-- ==================================================
     ROOT MESSAGE
     ================================================== -->

<div
    id="message_<%=messageId%>"
    class="contact-message <%=

        "Y".equalsIgnoreCase(isAdmin)

        ? "admin-message"

        : ""

    %>"
>

    <!-- ==================================================
         MESSAGE HEADER
         ================================================== -->

    <div class="message-header">

        <span class="message-author">

            <%=fullName%>


            <%

            if(
                "Y".equalsIgnoreCase(
                    isAdmin
                )
            ){

            %>

                <span class="admin-badge">

                    ADMIN

                </span>

            <%

            }


            if(updatedAt!=null){

            %>

                <span class="edited-label">

                    (edited)

                </span>

            <%

            }

            %>

        </span>


        <span
            class="message-time"
            data-time="<%=createdAt.getTime()%>"
        >

        </span>

    </div>


    <!-- ==================================================
         MESSAGE TEXT
         ================================================== -->

    <div class="message-text">

        <%=messageText%>

    </div>


    <!-- ==================================================
         MESSAGE ACTIONS
         ================================================== -->

    <div class="message-actions">

<%

/* ==================================================
   REPLY BUTTON

   Registered customer -> YES
   Admin                -> YES
   Guest                -> NO
   ================================================== */

if(
    customerLoggedIn ||
    adminLoggedIn
){

%>

        <button
            type="button"
            class="reply-btn"
            onclick="openReplyBox('<%=messageId%>')"
        >

            Reply

        </button>

<%

}


/* ==================================================
   EDIT BUTTON
   ================================================== */

if(canEditMessage){

%>

        <button
            type="button"
            class="edit-btn"
            onclick="openEditBox('<%=messageId%>')"
        >

            Edit

        </button>

<%

}


/* ==================================================
   DELETE BUTTON
   ================================================== */

if(canDeleteMessage){

%>

        <button
            type="button"
            class="delete-btn"
            onclick="deleteMessage('<%=messageId%>')"
        >

            Delete

        </button>

<%

}

%>

    </div>


    <!-- ==================================================
         REPLY BOX
         ================================================== -->

    <div
        id="replyBox_<%=messageId%>"
        class="reply-box"
        style="display:none;"
    >

        <textarea
            id="replyText_<%=messageId%>"
            placeholder="Write your reply..."
            maxlength="1000"
        ></textarea>


        <div class="reply-buttons">

            <button
                type="button"
                class="reply-submit-btn"
                onclick="submitReply('<%=messageId%>')"
            >

                Send Reply

            </button>


            <button
                type="button"
                class="reply-cancel-btn"
                onclick="closeReplyBox('<%=messageId%>')"
            >

                Cancel

            </button>

        </div>

    </div>


<%

/* ==================================================
   EDIT BOX
   ================================================== */

if(canEditMessage){

%>

    <div
        id="editBox_<%=messageId%>"
        class="reply-box"
        style="display:none;"
    >

        <textarea
            id="editText_<%=messageId%>"
            maxlength="1000"
        ><%=messageText%></textarea>


        <div class="reply-buttons">

            <button
                type="button"
                class="reply-submit-btn"
                onclick="submitEdit('<%=messageId%>')"
            >

                Save Changes

            </button>


            <button
                type="button"
                class="reply-cancel-btn"
                onclick="closeEditBox('<%=messageId%>')"
            >

                Cancel

            </button>

        </div>

    </div>

<%

}

%>

</div>


<%

/* ==================================================
   SHOW REPLIES BUTTON

   Only if this root actually has replies.
   ================================================== */

if(hasReplies){

%>

<div
    class="reply-toggle-container"
    style="margin-left:0px;"
>

    <button
        type="button"
        id="replyToggle_<%=messageId%>"
        class="expand-replies-btn"
        onclick="toggleReplies('<%=messageId%>')"
    >

        Show Replies

    </button>

</div>


<!-- ==================================================
     HIDDEN REPLIES CONTAINER

     All replies belonging to this root are placed
     inside this container.

     This includes nested replies.
     ================================================== -->

<div
    id="replies_<%=messageId%>"
    class="replies-container"
>


<%

}


rootPrinted=true;


            }

            else{


                /* ==================================================
                   REPLY MESSAGE

                   LEVEL 2+
                   ================================================== */

%>


<div
    id="message_<%=messageId%>"
    class="contact-message <%=

        "Y".equalsIgnoreCase(isAdmin)

        ? "admin-message"

        : ""

    %>"
    style="margin-left:<%=indentPixels%>px;"
>


    <!-- ==================================================
         REPLY HEADER
         ================================================== -->

    <div class="message-header">

        <span class="message-author">

            <%=fullName%>


            <%

            if(
                "Y".equalsIgnoreCase(
                    isAdmin
                )
            ){

            %>

                <span class="admin-badge">

                    ADMIN

                </span>

            <%

            }


            if(updatedAt!=null){

            %>

                <span class="edited-label">

                    (edited)

                </span>

            <%

            }

            %>

        </span>


        <span
            class="message-time"
            data-time="<%=createdAt.getTime()%>"
        >

        </span>

    </div>


    <!-- ==================================================
         REPLY TEXT
         ================================================== -->

    <div class="message-text">

        <%=messageText%>

    </div>


    <!-- ==================================================
         REPLY ACTIONS
         ================================================== -->

    <div class="message-actions">

<%

/* ==================================================
   REPLY BUTTON
   ================================================== */

if(
    customerLoggedIn ||
    adminLoggedIn
){

%>

        <button
            type="button"
            class="reply-btn"
            onclick="openReplyBox('<%=messageId%>')"
        >

            Reply

        </button>

<%

}


/* ==================================================
   EDIT
   ================================================== */

if(canEditMessage){

%>

        <button
            type="button"
            class="edit-btn"
            onclick="openEditBox('<%=messageId%>')"
        >

            Edit

        </button>

<%

}


/* ==================================================
   DELETE
   ================================================== */

if(canDeleteMessage){

%>

        <button
            type="button"
            class="delete-btn"
            onclick="deleteMessage('<%=messageId%>')"
        >

            Delete

        </button>

<%

}

%>

    </div>


    <!-- ==================================================
         REPLY BOX
         ================================================== -->

    <div
        id="replyBox_<%=messageId%>"
        class="reply-box"
        style="display:none;"
    >

        <textarea
            id="replyText_<%=messageId%>"
            placeholder="Write your reply..."
            maxlength="1000"
        ></textarea>


        <div class="reply-buttons">

            <button
                type="button"
                class="reply-submit-btn"
                onclick="submitReply('<%=messageId%>')"
            >

                Send Reply

            </button>


            <button
                type="button"
                class="reply-cancel-btn"
                onclick="closeReplyBox('<%=messageId%>')"
            >

                Cancel

            </button>

        </div>

    </div>


<%

/* ==================================================
   EDIT BOX
   ================================================== */

if(canEditMessage){

%>

    <div
        id="editBox_<%=messageId%>"
        class="reply-box"
        style="display:none;"
    >

        <textarea
            id="editText_<%=messageId%>"
            maxlength="1000"
        ><%=messageText%></textarea>


        <div class="reply-buttons">

            <button
                type="button"
                class="reply-submit-btn"
                onclick="submitEdit('<%=messageId%>')"
            >

                Save Changes

            </button>


            <button
                type="button"
                class="reply-cancel-btn"
                onclick="closeEditBox('<%=messageId%>')"
            >

                Cancel

            </button>

        </div>

    </div>

<%

}

%>

</div>


<%

            }

        }


        /* ==================================================
           CLOSE REPLIES CONTAINER

           It was opened immediately after the root.
           ================================================== */

        if(hasReplies){

%>

</div>

<%

        }


        messageRs.close();

        messagePs.close();


        /* ==================================================
           MOVE TO NEXT ROOT CONVERSATION

           IMPORTANT:

           Replies never increment this counter.
           ================================================== */

        conversationIndex++;

    }


    /* ==================================================
       NO MESSAGES
       ================================================== */

    if(!found){

%>

<p
    style="
        text-align:center;
        color:#777;
        font-size:17px;
        padding:30px;
    "
>

    No messages available.

</p>

<%

    }

%>


<script>

window.currentPage=<%=pageNo%>;

</script>


<%

}

catch(Exception e){

    out.println(

        "<p style='color:red;'>" +

        "Unable to load messages : " +

        e.getMessage() +

        "</p>"

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

        if(con!=null)
            con.close();

    }
    catch(Exception e){}

}

%>