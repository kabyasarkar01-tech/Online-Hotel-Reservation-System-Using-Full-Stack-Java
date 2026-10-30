<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
    response.sendRedirect("adminLogin.jsp");
    return;
}

String deleteStatus=request.getParameter("delete");
String clearStatus=request.getParameter("clear");

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "username",
        "password"
    );

    String sql=
        "select MESSAGE_ID,CUSTOMER_ID,FIRST_NAME,MIDDLE_NAME,LAST_NAME,"+
        "MESSAGE_TEXT,PARENT_ID,IS_ADMIN,CREATED_AT,UPDATED_AT,PHONE,EMAIL,FULL_NAME "+
        "from CONTACT_MESSAGES "+
        "order by CREATED_AT desc";

    ps=con.prepareStatement(sql);
    rs=ps.executeQuery();
%>

<!DOCTYPE html>
<html>

<head>

<meta charset="UTF-8">

<title>Reports - KS Group</title>

<style>

body{
    margin:0;
    padding:0;
    font-family:Arial,sans-serif;
    background:#f5f5f5;
}

/* HEADER */

.header{
    background:#c59d5f;
    color:white;
    padding:18px;
    text-align:center;
    font-size:28px;
    font-weight:bold;
    letter-spacing:2px;
}

.header span{
    color:black;
}

/* MAIN CONTAINER */

.container{
    width:88%;
    max-width:1000px;
    margin:25px auto;
}

/* WRITE MESSAGE BOX */

.message-box{
    background:white;
    padding:18px 22px;
    border-radius:10px;
    box-shadow:0 5px 14px rgba(0,0,0,0.10);
    margin-bottom:22px;
}

.message-box h2{
    margin:0 0 12px 0;
    color:#444;
    text-align:center;
    font-size:21px;
}

.message-box textarea{
    width:100%;
    height:75px;
    padding:10px;
    box-sizing:border-box;
    border:1px solid #ccc;
    border-radius:7px;
    font-size:14px;
    font-family:Arial,sans-serif;
    resize:vertical;
    outline:none;
}

.message-box textarea:focus{
    border-color:#c59d5f;
}

.send-button{
    margin-top:10px;
    padding:9px 22px;
    font-size:14px;
    font-weight:bold;
    border:none;
    border-radius:7px;
    background:#28a745;
    color:white;
    cursor:pointer;
}

.send-button:hover{
    background:#218838;
}

/* MESSAGE CARD */

.message-card{
    background:white;
    padding:14px 17px;
    border-radius:9px;
    box-shadow:0 4px 12px rgba(0,0,0,0.08);
    margin-bottom:12px;
}

/* ADMIN MESSAGE */

.admin-message{
    border-left:5px solid #c59d5f;
}

/* CUSTOMER MESSAGE */

.user-message{
    border-left:5px solid #777;
}

/* MESSAGE HEADER */

.message-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:7px;
}

.sender{
    font-size:16px;
    font-weight:bold;
    color:#444;
}

.sender-type{
    font-size:11px;
    padding:3px 8px;
    border-radius:12px;
    background:#eee;
    color:#555;
    margin-left:6px;
}

.admin-type{
    background:#c59d5f;
    color:white;
}

.message-date{
    font-size:11px;
    color:#888;
}

/* MESSAGE TEXT */

.message-text{
    font-size:14px;
    line-height:1.4;
    color:#333;
    background:#f8f8f8;
    padding:9px 11px;
    border-radius:6px;
    margin:7px 0;
    white-space:pre-wrap;
    word-wrap:break-word;

    /* IMPORTANT */
    max-height:75px;
    overflow-y:auto;
}

/* CONTACT DETAILS */

.contact-details{
    font-size:12px;
    color:#777;
    margin-top:7px;
}

.contact-details span{
    margin-right:15px;
}

/* ACTIONS */

.actions{
    margin-top:8px;
    display:flex;
    gap:7px;
    flex-wrap:wrap;
}

.actions button{
    border:none;
    border-radius:6px;
    padding:7px 13px;
    font-size:12px;
    font-weight:bold;
    cursor:pointer;
}

/* REPLY */

.reply-btn{
    background:#c59d5f;
    color:white;
}

.reply-btn:hover{
    background:#b08a4a;
}

/* EDIT */

.edit-btn{
    background:#007bff;
    color:white;
}

.edit-btn:hover{
    background:#0069d9;
}

/* DELETE */

.delete-btn{
    background:#dc3545;
    color:white;
}

.delete-btn:hover{
    background:#c82333;
}

/* REPLY BOX */

.reply-box{
    margin-top:9px;
    padding:10px;
    background:#f5f5f5;
    border-radius:7px;
}

.reply-box textarea{
    width:100%;
    height:55px;
    padding:9px;
    box-sizing:border-box;
    border:1px solid #ccc;
    border-radius:6px;
    font-family:Arial,sans-serif;
    font-size:13px;
    resize:vertical;
}

.reply-box button{
    margin-top:7px;
    padding:7px 15px;
    border:none;
    border-radius:6px;
    background:#28a745;
    color:white;
    font-size:12px;
    font-weight:bold;
    cursor:pointer;
}

.reply-box button:hover{
    background:#218838;
}

/* BACK BUTTON */

.back{
    text-align:center;
    margin-top:25px;
    margin-bottom:25px;
}

.back a{
    text-decoration:none;
}

.back button{
    padding:10px 25px;
    font-size:14px;
    font-weight:bold;
    border:none;
    border-radius:7px;
    background:#c59d5f;
    color:white;
    cursor:pointer;
}

.back button:hover{
    background:#b08a4a;
}

/* NO MESSAGE */

.no-message{
    background:white;
    padding:25px;
    border-radius:9px;
    text-align:center;
    color:#777;
    box-shadow:0 4px 12px rgba(0,0,0,0.08);
}

/* DELETE DIALOG */

.dialog-overlay{
    display:none;
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.45);
    justify-content:center;
    align-items:center;
    z-index:9999;
}

.dialog-box{
    background:white;
    width:380px;
    max-width:90%;
    border-radius:10px;
    box-shadow:0 10px 30px rgba(0,0,0,0.25);
    overflow:hidden;
    text-align:center;
}

.dialog-title{
    background:#c59d5f;
    color:white;
    padding:15px;
    font-size:20px;
    font-weight:bold;
}

.dialog-message{
    padding:25px 20px 15px;
    font-size:15px;
    color:#444;
}

.dialog-buttons{
    display:flex;
    justify-content:center;
    gap:12px;
    padding:8px 20px 20px;
}

.dialog-buttons button{
    padding:9px 25px;
    border:none;
    border-radius:6px;
    font-size:14px;
    font-weight:bold;
    cursor:pointer;
}

.yes-btn{
    background:#28a745;
    color:white;
}

.yes-btn:hover{
    background:#218838;
}

.no-btn{
    background:#dc3545;
    color:white;
}

.no-btn:hover{
    background:#c82333;
}

.top-home{
    position:absolute;
    top:18px;
    left:20px;
}

.top-home a{
    text-decoration:none;
}

.top-home button{
    padding:8px 18px;
    font-size:13px;
    font-weight:bold;
    border:none;
    border-radius:6px;
    background:#007bff;
    color:white;
    cursor:pointer;
}

.top-home button:hover{
    background:#0069d9;
}

</style>

<script>

function showReply(id){

    var box=document.getElementById("reply-"+id);

    if(box.style.display==="block"){
        box.style.display="none";
    }
    else{
        box.style.display="block";
    }
}

</script>

</head>

<body>

<div class="top-home">
    <a href="home.jsp">
        <button type="button">
            Back
        </button>
    </a>
</div>

<div class="header">
    <span>KS</span> Group Admin Panel
</div>

<div class="container">

<!-- WRITE MESSAGE -->

<div class="message-box">

    <h2>Write a Message</h2>

    <form action="sendAdminMessage.jsp" method="post">
    <textarea
        name="message"
        placeholder="Write your message..."
        required></textarea>
    <br>

    <button
        type="submit"
        class="send-button">
        Send Message
    </button>

    <button
        type="button"
        class="send-button"
        onclick="openClearAllDialog()">
        Clear All
    </button>
</form>

</div>


<!-- ALL MESSAGES -->

<%

boolean found=false;

while(rs.next()){

    found=true;

    String messageId=rs.getString("MESSAGE_ID");
    String customerId=rs.getString("CUSTOMER_ID");

    String firstName=rs.getString("FIRST_NAME");
    String middleName=rs.getString("MIDDLE_NAME");
    String lastName=rs.getString("LAST_NAME");

    String messageText=rs.getString("MESSAGE_TEXT");
    String parentId=rs.getString("PARENT_ID");
    String isAdmin=rs.getString("IS_ADMIN");

    Timestamp createdAt=
        rs.getTimestamp("CREATED_AT");

    String phone=rs.getString("PHONE");
    String email=rs.getString("EMAIL");
    String fullName=rs.getString("FULL_NAME");

    String displayName;

    if(fullName!=null && !fullName.trim().equals("")){

        displayName=fullName;

    }
    else{

        displayName=firstName;

        if(middleName!=null &&
           !middleName.trim().equals("")){

            displayName+=" "+middleName;

        }

        if(lastName!=null &&
           !lastName.trim().equals("")){

            displayName+=" "+lastName;

        }

    }

    boolean adminMessage=
        "Y".equals(isAdmin);

%>

<div class="message-card <%=adminMessage ? "admin-message" : "user-message"%>">

    <!-- HEADER -->

    <div class="message-header">

        <div>

            <span class="sender">
                <%=displayName%>
            </span>

            <% if(adminMessage){ %>

                <span class="sender-type admin-type">
                    ADMIN
                </span>

            <% }else{ %>

                <span class="sender-type">
                    CUSTOMER
                </span>

            <% } %>

        </div>

        <div class="message-date">
            <%=createdAt%>
        </div>

    </div>


    <!-- MESSAGE -->

    <div class="message-text">
        <%=messageText%>
    </div>


    <!-- CUSTOMER DETAILS -->

    <% if(!adminMessage){ %>

    <div class="contact-details">

        <% if(customerId!=null){ %>

        <span>
            <strong>Customer ID:</strong>
            <%=customerId%>
        </span>

        <% } %>

        <% if(phone!=null){ %>

        <span>
            <strong>Phone:</strong>
            <%=phone%>
        </span>

        <% } %>

        <% if(email!=null){ %>

        <span>
            <strong>Email:</strong>
            <%=email%>
        </span>

        <% } %>

    </div>

    <% } %>


    <!-- ACTIONS -->

    <div class="actions">

        <% if(!adminMessage){ %>

        <button
            type="button"
            class="reply-btn"
            onclick="showReply('<%=messageId%>')">

            Reply

        </button>

        <% }else{ %>

        <button
            type="button"
            class="edit-btn"
            onclick="location.href='editAdminMessage.jsp?id=<%=messageId%>'">

            Edit

        </button>

        <% } %>


        <button
			    type="button"
			    class="delete-btn"
			    onclick="confirmDelete('<%=messageId%>')">
			
			    Delete
			
		</button>

    </div>


    <!-- REPLY BOX -->

    <% if(!adminMessage){ %>

    <div
        class="reply-box"
        id="reply-<%=messageId%>"
        style="display:none;">

        <form
            action="replyMessage.jsp"
            method="post">

            <input
                type="hidden"
                name="parentId"
                value="<%=messageId%>">

            <input
                type="hidden"
                name="customerId"
                value="<%=customerId%>">

            <textarea
                name="message"
                placeholder="Write your reply..."
                required></textarea>

            <br>

            <button
                type="submit">

                Send Reply

            </button>

        </form>

    </div>

    <% } %>

</div>

<%

}

if(!found){

%>

<div class="no-message">

    There are no messages yet.

</div>

<%

}

%>


</div>


<!-- DELETE DIALOG -->

<div
    id="deleteDialog"
    class="dialog-overlay">

    <div class="dialog-box">

        <div class="dialog-title">
            Delete Message
        </div>

        <div class="dialog-message">
            Are you sure you want to delete this message?
        </div>

        <div class="dialog-buttons">

    <button
        type="button"
        class="yes-btn"
        onclick="deleteMessage()">
        Yes
    </button>

    <button
        type="button"
        class="no-btn"
        onclick="closeDeleteDialog()">
        No
    </button>

</div>

    </div>

</div>

<!-- DELETE SUCCESS DIALOG -->

<div
    id="deleteSuccessDialog"
    class="dialog-overlay">

    <div class="dialog-box">

        <div class="dialog-title">

            Success

        </div>

        <div class="dialog-message">

            Message deleted successfully.

        </div>

        <div class="dialog-buttons">

            <button
                type="button"
                class="yes-btn"
                onclick="closeDeleteSuccess()">

                OK

            </button>

        </div>

    </div>

</div>

<!-- CLEAR ALL SUCCESS DIALOG -->

<div
    id="clearAllSuccessDialog"
    class="dialog-overlay">

    <div class="dialog-box">

        <div class="dialog-title">
            Success
        </div>

        <div class="dialog-message">
            All customer messages have been cleared successfully.
        </div>

        <div class="dialog-buttons">

            <button
                type="button"
                class="yes-btn"
                onclick="closeClearAllSuccess()">

                OK

            </button>

        </div>

    </div>

</div>

<!-- CLEAR ALL CONFIRMATION DIALOG -->

<div
    id="clearAllDialog"
    class="dialog-overlay">

    <div class="dialog-box">

        <div class="dialog-title">

            Clear All Messages

        </div>

        <div class="dialog-message">

            Are you sure you want to clear all messages written by customers?

        </div>

        <div class="dialog-buttons">

            <button
                type="button"
                class="yes-btn"
                onclick="clearAllMessages()">

                Yes

            </button>

            <button
                type="button"
                class="no-btn"
                onclick="closeClearAllDialog()">

                No

            </button>

        </div>

    </div>

</div>


<script>

let messageToDelete="";

/* ==================================================
   DELETE CONFIRMATION DIALOG
   ================================================== */

function confirmDelete(messageId){

    messageToDelete=messageId;

    document.getElementById(
        "deleteDialog"
    ).style.display="flex";

}

function closeDeleteDialog(){

    messageToDelete="";

    document.getElementById(
        "deleteDialog"
    ).style.display="none";

}

function deleteMessage(){

    if(messageToDelete===""){

        return;

    }

    window.location.href=
        "deleteMessage.jsp?messageId="+
        encodeURIComponent(messageToDelete);

}


/* ==================================================
   CLEAR ALL CUSTOMER MESSAGES
   ================================================== */

function openClearAllDialog(){

    document.getElementById(
        "clearAllDialog"
    ).style.display="flex";

}

function closeClearAllDialog(){

    document.getElementById(
        "clearAllDialog"
    ).style.display="none";

}

function clearAllMessages(){

    window.location.href=
        "clearCustomerMessages.jsp";

}


/* ==================================================
   DELETE SUCCESS DIALOG
   ================================================== */

function showDeleteSuccess(){

    document.getElementById(
        "deleteSuccessDialog"
    ).style.display="flex";

}

function closeDeleteSuccess(){

    document.getElementById(
        "deleteSuccessDialog"
    ).style.display="none";

}


/* ==================================================
   CLEAR ALL SUCCESS DIALOG
   ================================================== */

function showClearAllSuccess(){

    document.getElementById(
        "clearAllSuccessDialog"
    ).style.display="flex";

}

function closeClearAllSuccess(){

    document.getElementById(
        "clearAllSuccessDialog"
    ).style.display="none";

}

</script>


<%

if("success".equals(deleteStatus)){

%>

<script>

window.onload=function(){

    showDeleteSuccess();

};

</script>

<%

}

if("success".equals(clearStatus)){

%>

<script>

window.onload=function(){

    showClearAllSuccess();

};

</script>

<%

}

%>


</body>
</html>
<%

}
catch(Exception e){

    out.println(
        "<p>Error: "+
        e.getMessage()+
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