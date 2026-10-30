<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>

<%
response.setHeader("Cache-Control", "no-cache, no-store, must-revalidate");
response.setHeader("Pragma", "no-cache");
response.setDateHeader("Expires", 0);

String customerName = (String) session.getAttribute("customerName");

/*
 * Contact page requires login.
 */
if(customerName == null || customerName.equals("")){
    response.sendRedirect("register.jsp");
    return;
}
%>

<!doctype html>
<html lang="en">

<head>

<title>KS Group - Contact</title>

<meta charset="utf-8">

<meta name="viewport"
      content="width=device-width, initial-scale=1, shrink-to-fit=no">

<link href="https://fonts.googleapis.com/css?family=Playfair+Display:400,700,900|Rubik:300,400,700"
      rel="stylesheet">

<link rel="stylesheet" href="../css/bootstrap.css">
<link rel="stylesheet" href="../css/animate.css">
<link rel="stylesheet" href="../css/owl.carousel.min.css">
<link rel="stylesheet" href="../fonts/ionicons/css/ionicons.min.css">
<link rel="stylesheet" href="../fonts/fontawesome/css/font-awesome.min.css">
<link rel="stylesheet" href="../css/magnific-popup.css">
<link rel="stylesheet" href="../css/style.css">


<style>

/* ==================================================
   KS LOGO
   ================================================== */

.ks-logo{
    font-family:'Playfair Display',serif;
    font-size:28px;
    font-weight:900;
    letter-spacing:2px;
    color:#000!important;
    text-transform:uppercase;
}

.ks-logo span{
    color:#c59d5f;
}


/* ==================================================
   CONTACT FORM
   ================================================== */

.contact-area{
    min-height:450px;
    display:flex;
    justify-content:center;
    align-items:flex-start;
    padding-top:40px;
}

.contact-box{
    padding:15px;
}

.contact-box h2{
    color:#fff;
    text-align:center;
    margin-bottom:35px;
    font-weight:700;
    text-shadow:2px 2px 8px rgba(0,0,0,.6);
}

.contact-box label{
    color:#fff;
    font-weight:600;
}

.contact-box .form-control{
    background:rgba(255,255,255,.15);
    border:1px solid rgba(255,255,255,.65);
    color:#fff;
    border-radius:30px;
    height:48px;
}

.contact-box textarea.form-control{
    height:130px;
    border-radius:20px;
    resize:none;
    padding-top:12px;
}

.contact-box .form-control::placeholder{
    color:rgba(255,255,255,.85);
}

.contact-box .form-control:focus{
    background:rgba(255,255,255,.25);
    border-color:#fff;
    color:#fff;
    box-shadow:none;
}

.btn-send{
    width:100%;
    border-radius:30px;
    background:#c59d5f;
    color:#fff;
    border:none;
    height:50px;
    font-size:18px;
    font-weight:600;
    transition:.3s;
}

.btn-send:hover{
    background:#b08a4a;
    color:#fff;
}


/* ==================================================
   MESSAGES SECTION
   ================================================== */

.messages-section{
    background:#f5f5f5;
    padding:50px 0;
}

.messages-title{
    text-align:center;
    color:#444;
    font-family:'Playfair Display',serif;
    font-weight:700;
    margin-bottom:30px;
}

#messagesContainer{
    max-width:900px;
    margin:auto;
}


/* ==================================================
   MESSAGE CARD
   ================================================== */

.contact-message{
    background:#fff;
    padding:11px 16px;
    margin-bottom:8px;
    border-radius:8px;
    box-shadow:0 2px 8px rgba(0,0,0,.08);
    transition:.2s;
}

.contact-message.admin-message{
    border:1px solid #c59d5f;
    background:#fffaf0;
}


/* ==================================================
   MESSAGE HEADER
   ================================================== */

.message-header{
    display:flex;
    justify-content:space-between;
    align-items:center;
    margin-bottom:4px;
}

.message-author{
    font-weight:bold;
    color:#333;
    font-size:15px;
}

.message-time{
    color:#888;
    font-size:12px;
    white-space:nowrap;
}


/* ==================================================
   ADMIN BADGE
   ================================================== */

.admin-badge{
    display:inline-block;
    background:#c59d5f;
    color:white;
    padding:2px 6px;
    border-radius:4px;
    font-size:9px;
    margin-left:6px;
    vertical-align:middle;
}


/* ==================================================
   EDITED LABEL
   ================================================== */

.edited-label{
    color:#999;
    font-size:11px;
    font-weight:normal;
    margin-left:4px;
}


/* ==================================================
   MESSAGE TEXT
   ================================================== */

.message-text{
    color:#555;
    font-size:14px;
    line-height:1.35;
    white-space:pre-wrap;
    margin-bottom:5px;
}


/* ==================================================
   MESSAGE ACTIONS
   ================================================== */

.message-actions{
    margin-top:5px;
    min-height:18px;
}

/* ==================================================
   EXPAND / COLLAPSE REPLIES
   ================================================== */

.expand-replies-btn{
    background:none;
    border:none;
    color:#c59d5f;
    font-size:13px;
    font-weight:bold;
    cursor:pointer;
    padding:0;
}

.expand-replies-btn:hover{
    color:#b08a4a;
    text-decoration:underline;
}

.reply-toggle-container{
    margin-top:2px;
    margin-bottom:8px;
}

.replies-container{
    display:none;
}

.reply-btn,
.edit-btn,
.delete-btn{
    background:none;
    border:none;
    font-size:13px;
    font-weight:bold;
    cursor:pointer;
    padding:0;
}

.reply-btn{
    color:#c59d5f;
}

.reply-btn:hover{
    color:#b08a4a;
    text-decoration:underline;
}

.edit-btn{
    color:#007bff;
    margin-left:12px;
}

.edit-btn:hover{
    color:#0056b3;
    text-decoration:underline;
}

.delete-btn{
    color:#dc3545;
    margin-left:12px;
}

.delete-btn:hover{
    color:#bd2130;
    text-decoration:underline;
}


/* ==================================================
   REPLY / EDIT BOX
   ================================================== */

.reply-box{
    margin-top:8px;
}

.reply-box textarea{
    width:100%;
    min-height:65px;
    padding:8px 10px;
    border:1px solid #ccc;
    border-radius:6px;
    resize:vertical;
    box-sizing:border-box;
    font-family:Arial,sans-serif;
    font-size:14px;
}

.reply-box textarea:focus{
    outline:none;
    border-color:#c59d5f;
}


/* ==================================================
   REPLY BUTTONS
   ================================================== */

.reply-buttons{
    margin-top:6px;
}

.reply-submit-btn{
    background:#28a745;
    color:white;
    border:none;
    padding:6px 13px;
    border-radius:5px;
    font-size:13px;
    font-weight:bold;
    cursor:pointer;
}

.reply-submit-btn:hover{
    background:#218838;
}

.reply-cancel-btn{
    background:#6c757d;
    color:white;
    border:none;
    padding:6px 13px;
    border-radius:5px;
    font-size:13px;
    font-weight:bold;
    cursor:pointer;
    margin-left:5px;
}

.reply-cancel-btn:hover{
    background:#5a6268;
}


/* ==================================================
   PAGE NAVIGATION
   ================================================== */

.message-navigation{
    text-align:center;
    margin-top:25px;
}

.message-navigation button{
    background:#c59d5f;
    color:white;
    border:none;
    width:36px;
    height:36px;
    border-radius:50%;
    font-size:18px;
    font-weight:bold;
    cursor:pointer;
    margin:0 12px;
}

.message-navigation button:hover{
    background:#b08a4a;
}

#pageNumber{
    font-weight:bold;
    color:#555;
}


/* ==================================================
   MESSAGE MODAL
   ================================================== */

#messageModal{
    display:none;
    position:fixed;
    top:0;
    left:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,.60);
    justify-content:center;
    align-items:center;
    z-index:9999;
}

.message-modal-box{
    width:90%;
    max-width:450px;
    background:white;
    border-radius:12px;
    padding:35px;
    text-align:center;
    box-shadow:0 10px 30px rgba(0,0,0,.30);
}

.message-modal-box h3{
    font-family:'Playfair Display',serif;
    color:#c59d5f;
    font-weight:700;
    margin-bottom:18px;
}

.message-modal-box p{
    color:#555;
    font-size:16px;
    margin-bottom:25px;
}

.message-modal-buttons{
    display:flex;
    justify-content:center;
    gap:10px;
}

.modal-ok-btn{
    background:#c59d5f;
    color:white;
    border:none;
    padding:10px 30px;
    border-radius:25px;
    font-weight:bold;
    cursor:pointer;
}

.modal-ok-btn:hover{
    background:#b08a4a;
}

.modal-delete-btn{
    background:#dc3545;
    color:white;
    border:none;
    padding:10px 25px;
    border-radius:25px;
    font-weight:bold;
    cursor:pointer;
}

.modal-delete-btn:hover{
    background:#c82333;
}

.modal-cancel-btn{
    background:#6c757d;
    color:white;
    border:none;
    padding:10px 25px;
    border-radius:25px;
    font-weight:bold;
    cursor:pointer;
}

.modal-cancel-btn:hover{
    background:#5a6268;
}

</style>

</head>


<body>


<!-- ==================================================
     HEADER
     ================================================== -->

<header role="banner">

<nav class="navbar navbar-expand-md navbar-dark bg-light">

<div class="container">

<a class="navbar-brand ks-logo" href="../index.jsp">
    <span>KS</span> Group
</a>


<button class="navbar-toggler"
        type="button"
        data-toggle="collapse"
        data-target="#navbarsExample05">

    <span class="navbar-toggler-icon"></span>

</button>


<div class="collapse navbar-collapse navbar-light"
     id="navbarsExample05">


<ul class="navbar-nav ml-auto pl-lg-5 pl-0">


<!-- HOME -->

<li class="nav-item">

    <a class="nav-link" href="../index.jsp">
        Home
    </a>

</li>


<!-- ROOMS -->

<li class="nav-item">

    <a class="nav-link" href="rooms2.jsp">
        Rooms
    </a>

</li>


<!-- BLOG -->

<li class="nav-item">

    <a class="nav-link" href="blog.jsp">
        Blog
    </a>

</li>


<!-- ABOUT -->

<li class="nav-item">

    <a class="nav-link" href="about.jsp">
        About
    </a>

</li>


<!-- CONTACT -->

<li class="nav-item">

    <a class="nav-link active" href="contact.jsp">
        Contact
    </a>

</li>


<!-- CUSTOMER MENU -->

<li class="nav-item dropdown">

<a class="nav-link dropdown-toggle"
   href="#"
   id="customerMenu"
   data-toggle="dropdown"
   aria-haspopup="true"
   aria-expanded="false">

    <%=customerName%>

</a>


<div class="dropdown-menu dropdown-menu-right"
     aria-labelledby="customerMenu">


<!-- PROFILE -->

<a class="dropdown-item"
   href="profile.jsp">

    My Profile

</a>


<div class="dropdown-divider"></div>


<!-- LOGOUT -->

<a class="dropdown-item"
   href="logout.jsp">

    Logout

</a>


</div>

</li>


</ul>

</div>

</div>

</nav>

</header>



<!-- ==================================================
     CONTACT HERO
     ================================================== -->

<section class="site-hero site-hero-innerpage overlay"
         data-stellar-background-ratio="0.5"
         style="background-image:url(../images/big_image_1.jpg);">


<div class="container">


<div class="row contact-area">


<div class="col-lg-8">


<div class="contact-box">


<h2>Contact Us</h2>


<form id="contactForm"
      action="submitContactMessage.jsp"
      method="post">


<div class="form-group">

<textarea
    id="messageText"
    name="messageText"
    class="form-control"
    placeholder="Write your message..."
    maxlength="1000"
    required></textarea>

</div>


<div class="form-group">

<button type="submit"
        class="btn-send">

    Send Message

</button>

</div>


</form>


</div>

</div>

</div>

</div>

</section>



<!-- ==================================================
     MESSAGES
     ================================================== -->

<section class="messages-section">


<div class="container">


<h2 class="messages-title">

    What Our Guests Say

</h2>


<div id="messagesContainer">

    <!-- Messages will appear here -->

</div>


<div class="message-navigation">


<button type="button"
        id="previousBtn"
        onclick="changeMessagePage(-1)">

    &lt;

</button>


<span id="pageNumber">
    1
</span>


<button type="button"
        id="nextBtn"
        onclick="changeMessagePage(1)">

    &gt;

</button>


</div>


</div>

</section>



<!-- ==================================================
     FOOTER
     ================================================== -->

<footer class="site-footer">


<div class="container">


<div class="row mb-5">


<div class="col-md-4">

<h3>Phone Support</h3>

<p>24/7 Call us now.</p>

<p class="lead">

<a href="tel:+918649865030">
    +91 8649865030
</a>

</p>

<p class="lead">

<a href="tel:+919733376561">
    +91 9733376561
</a>

</p>

</div>



<div class="col-md-4">

<h3>Connect With Us</h3>

<p>Follow KS Group on social media.</p>


<p>

<a href="#" class="pl-0 p-3">
    <span class="fa fa-facebook"></span>
</a>

<a href="#" class="p-3">
    <span class="fa fa-twitter"></span>
</a>

<a href="#" class="p-3">
    <span class="fa fa-instagram"></span>
</a>

<a href="#" class="p-3">
    <span class="fa fa-vimeo"></span>
</a>

<a href="#" class="p-3">
    <span class="fa fa-youtube-play"></span>
</a>

</p>

</div>



<div class="col-md-4">

<h3>Newsletter</h3>

<p>
Subscribe to receive exclusive offers, latest updates,
and exciting news from KS Group.
</p>


<form action="#" class="subscribe">

<div class="form-group">

<button type="submit">

<span class="ion-ios-arrow-thin-right"></span>

</button>


<input type="email"
       class="form-control"
       placeholder="Enter email">

</div>

</form>

</div>


</div>



<div class="row justify-content-center">


<div class="col-md-7 text-center">

&copy;

<script>
document.write(new Date().getFullYear());
</script>

KS Group. All Rights Reserved.

</div>


</div>

</div>

</footer>



<!-- ==================================================
     LOADER
     ================================================== -->

<div id="loader" class="show fullscreen">

<svg class="circular"
     width="48px"
     height="48px">


<circle class="path-bg"
        cx="24"
        cy="24"
        r="22"
        fill="none"
        stroke-width="4"
        stroke="#eeeeee">
</circle>


<circle class="path"
        cx="24"
        cy="24"
        r="22"
        fill="none"
        stroke-width="4"
        stroke-miterlimit="10"
        stroke="#f4b214">
</circle>


</svg>

</div>



<!-- ==================================================
     JAVASCRIPT LIBRARIES
     ================================================== -->

<script src="../js/jquery-3.2.1.min.js"></script>
<script src="../js/jquery-migrate-3.0.0.js"></script>
<script src="../js/popper.min.js"></script>
<script src="../js/bootstrap.min.js"></script>
<script src="../js/owl.carousel.min.js"></script>
<script src="../js/jquery.waypoints.min.js"></script>
<script src="../js/jquery.stellar.min.js"></script>
<script src="../js/jquery.magnific-popup.min.js"></script>
<script src="../js/magnific-popup-options.js"></script>
<script src="../js/main.js"></script>



<script>

/* ==================================================
   CURRENT PAGE
   ================================================== */

var currentMessagePage = 1;


/* ==================================================
   CONTACT FORM VALIDATION
   ================================================== */

document.getElementById("contactForm").addEventListener(
    "submit",
    function(event){

        var message = document.getElementById("messageText").value.trim();

        if(message === ""){

            event.preventDefault();

            showMessageModal(
                "Message Required",
                "Please write something before sending your message."
            );

        }

    }
);


/* ==================================================
   LOAD MESSAGES
   ================================================== */

function loadMessages(page){

    var xhttp = new XMLHttpRequest();


    xhttp.onreadystatechange = function(){

        if(this.readyState == 4 && this.status == 200){
            var response =
                this.responseText.trim();


            /*
             * If requested page has no messages,
             * stay on current page.
             */

            if(response.includes("No messages available.")){

                return;

            }


            document.getElementById(
                "messagesContainer"
            ).innerHTML = response;


            currentMessagePage = page;


            document.getElementById(
                "pageNumber"
            ).innerHTML = page;


            updateTimes();

        }

    };


    xhttp.open(
        "GET",
        "getContactMessages.jsp?page=" + page,
        true
    );

    xhttp.send();

}


/* ==================================================
   PREVIOUS / NEXT PAGE
   ================================================== */

function changeMessagePage(direction){

    var newPage = currentMessagePage + direction;


    if(newPage < 1){

        return;

    }


    loadMessages(newPage);

}


/* ==================================================
   TIME AGO
   ================================================== */

function timeAgo(timestamp){

    var now =
        new Date().getTime();


    var difference =
        now - parseInt(timestamp);


    var seconds =
        Math.floor(difference / 1000);


    if(seconds < 60){

        return seconds +
            (seconds == 1
                ? " second ago"
                : " seconds ago");

    }


    var minutes =
        Math.floor(seconds / 60);


    if(minutes < 60){

        return minutes +
            (minutes == 1
                ? " minute ago"
                : " minutes ago");

    }


    var hours =
        Math.floor(minutes / 60);


    if(hours < 24){

        return hours +
            (hours == 1
                ? " hour ago"
                : " hours ago");

    }


    var days =
        Math.floor(hours / 24);


    if(days < 30){

        return days +
            (days == 1
                ? " day ago"
                : " days ago");

    }


    var months =
        Math.floor(days / 30);


    if(months < 12){

        return months +
            (months == 1
                ? " month ago"
                : " months ago");

    }


    var years =
        Math.floor(months / 12);


    return years +
        (years == 1
            ? " year ago"
            : " years ago");

}


/* ==================================================
   UPDATE MESSAGE TIMES
   ================================================== */

function updateTimes(){

    var elements =
        document.querySelectorAll(
            ".message-time"
        );


    elements.forEach(
        function(element){

            var timestamp =
                element.getAttribute(
                    "data-time"
                );


            element.innerHTML =
                timeAgo(timestamp);

        }
    );

}


/* ==================================================
   OPEN REPLY BOX
   ================================================== */

function openReplyBox(messageId){

    var box =
        document.getElementById(
            "replyBox_" + messageId
        );


    if(box){

        box.style.display = "block";


        var textarea =
            document.getElementById(
                "replyText_" + messageId
            );


        if(textarea){

            textarea.focus();

        }

    }

}


/* ==================================================
   CLOSE REPLY BOX
   ================================================== */

function closeReplyBox(messageId){

    var box =
        document.getElementById(
            "replyBox_" + messageId
        );


    if(box){

        box.style.display = "none";

    }

}


/* ==================================================
   OPEN EDIT BOX
   ================================================== */

function openEditBox(messageId){

    var box =
        document.getElementById(
            "editBox_" + messageId
        );


    if(box){

        box.style.display = "block";


        var textarea =
            document.getElementById(
                "editText_" + messageId
            );


        if(textarea){

            textarea.focus();

        }

    }

}


/* ==================================================
   CLOSE EDIT BOX
   ================================================== */

function closeEditBox(messageId){

    var box =
        document.getElementById(
            "editBox_" + messageId
        );


    if(box){

        box.style.display = "none";

    }

}


/* ==================================================
   MESSAGE MODAL
   ================================================== */

function showMessageModal(title,message){

    document.getElementById(
        "messageModalTitle"
    ).innerHTML = title;


    document.getElementById(
        "messageModalText"
    ).innerHTML = message;


    document.getElementById(
        "messageModalButtons"
    ).innerHTML =
        '<button ' +
        'type="button" ' +
        'class="modal-ok-btn" ' +
        'onclick="closeMessageModal()">' +
        'OK' +
        '</button>';


    document.getElementById(
        "messageModal"
    ).style.display = "flex";

}


/* ==================================================
   CLOSE MESSAGE MODAL
   ================================================== */

function closeMessageModal(){

    document.getElementById(
        "messageModal"
    ).style.display = "none";

}


/* ==================================================
   DELETE CONFIRMATION MODAL
   ================================================== */

function showDeleteModal(messageId){

    document.getElementById(
        "messageModalTitle"
    ).innerHTML =
        "Delete Message";


    document.getElementById(
        "messageModalText"
    ).innerHTML =
        "Are you sure you want to delete this message?<br><br>" +
        "<strong>All replies to this message will also be deleted.</strong>";


    document.getElementById(
        "messageModalButtons"
    ).innerHTML =
        '<button ' +
        'type="button" ' +
        'class="modal-delete-btn" ' +
        'onclick="confirmDeleteMessage(\'' +
        messageId +
        '\')">' +
        'Delete' +
        '</button>' +

        '<button ' +
        'type="button" ' +
        'class="modal-cancel-btn" ' +
        'onclick="closeMessageModal()">' +
        'Cancel' +
        '</button>';


    document.getElementById(
        "messageModal"
    ).style.display = "flex";

}


/* ==================================================
   EDIT MESSAGE
   ================================================== */

function submitEdit(messageId){

    var textarea =
        document.getElementById(
            "editText_" + messageId
        );


    if(!textarea){

        return;

    }


    var messageText =
        textarea.value.trim();


    if(messageText === ""){

        showMessageModal(
            "Message Required",
            "Please write something before saving."
        );

        return;

    }


    var xhttp =
        new XMLHttpRequest();


    xhttp.onreadystatechange = function(){

        if(this.readyState == 4 &&
           this.status == 200){

            var response =
                this.responseText.trim();


            if(response === "SUCCESS"){

                loadMessages(
                    currentMessagePage
                );

                return;

            }


            if(response === "LOGIN_REQUIRED"){

                window.location.href =
                    "login.jsp";

                return;

            }


            showMessageModal(
                "Edit Failed",
                "Unable to edit the message."
            );

        }

    };


    xhttp.open(
        "POST",
        "editContactMessage.jsp",
        true
    );


    xhttp.setRequestHeader(
        "Content-Type",
        "application/x-www-form-urlencoded"
    );


    xhttp.send(
        "messageId=" +
        encodeURIComponent(messageId) +
        "&messageText=" +
        encodeURIComponent(messageText)
    );

}


/* ==================================================
   DELETE MESSAGE
   ================================================== */

function deleteMessage(messageId){

    showDeleteModal(messageId);

}


/* ==================================================
   CONFIRM DELETE
   ================================================== */

function confirmDeleteMessage(messageId){

    closeMessageModal();


    var xhttp =
        new XMLHttpRequest();


    xhttp.onreadystatechange = function(){

        if(this.readyState == 4 &&
           this.status == 200){

            var response =
                this.responseText.trim();


            if(response === "SUCCESS"){

                showMessageModal(
                    "Message Deleted",
                    "Your message has been deleted successfully."
                );


                setTimeout(
                    function(){

                        loadMessages(
                            currentMessagePage
                        );

                    },
                    700
                );


                return;

            }


            if(response === "LOGIN_REQUIRED"){

                window.location.href =
                    "login.jsp";

                return;

            }


            if(response === "NOT_ALLOWED"){

                showMessageModal(
                    "Not Allowed",
                    "You are not allowed to delete this message."
                );

                return;

            }


            showMessageModal(
                "Delete Failed",
                "Unable to delete the message."
            );

        }

    };


    xhttp.open(
        "POST",
        "deleteContactMessage.jsp",
        true
    );


    xhttp.setRequestHeader(
        "Content-Type",
        "application/x-www-form-urlencoded"
    );


    xhttp.send(
        "messageId=" +
        encodeURIComponent(messageId)
    );

}


/* ==================================================
   SUBMIT REPLY
   ================================================== */

function submitReply(messageId){

    var textarea =
        document.getElementById(
            "replyText_" + messageId
        );


    if(!textarea){

        return;

    }


    var messageText =
        textarea.value.trim();


    if(messageText === ""){

        showMessageModal(
            "Reply Required",
            "Please write something before sending your reply."
        );

        return;

    }


    var xhttp =
        new XMLHttpRequest();


    xhttp.onreadystatechange = function(){

        if(this.readyState == 4 &&
           this.status == 200){

            var response =
                this.responseText.trim();


            if(response === "SUCCESS"){

                loadMessages(
                    currentMessagePage
                );

                return;

            }


            if(response === "LOGIN_REQUIRED"){

                window.location.href =
                    "login.jsp";

                return;

            }


            if(response === "EMPTY_MESSAGE"){

                showMessageModal(
                    "Reply Required",
                    "Please write something before sending your reply."
                );

                return;

            }


            showMessageModal(
                "Reply Failed",
                response
            );

        }

    };


    xhttp.open(
        "POST",
        "replyContactMessage.jsp",
        true
    );


    xhttp.setRequestHeader(
        "Content-Type",
        "application/x-www-form-urlencoded"
    );


    xhttp.send(
        "messageId=" +
        encodeURIComponent(messageId) +
        "&messageText=" +
        encodeURIComponent(messageText)
    );

}


/* ==================================================
   LOAD FIRST PAGE
   ================================================== */

window.addEventListener(
    "load",
    function(){

        loadMessages(1);

    }
);

/* ==================================================
SHOW / HIDE REPLIES
================================================== */

function toggleReplies(messageId){

 var replies =
     document.getElementById(
         "replies_" + messageId
     );

 var button =
     document.getElementById(
         "replyToggle_" + messageId
     );

 if(!replies || !button){

     return;

 }


 if(
     replies.style.display === "none" ||
     replies.style.display === ""
 ){

     replies.style.display = "block";

     button.innerHTML = "Hide Replies";

 }
 else{

     replies.style.display = "none";

     button.innerHTML = "Show Replies";

 }

}

</script>



<!-- ==================================================
     MESSAGE MODAL
     ================================================== -->

<div id="messageModal">


<div class="message-modal-box">


<h3 id="messageModalTitle">
    KS Group
</h3>


<p id="messageModalText">
    Operation completed.
</p>


<div class="message-modal-buttons"
     id="messageModalButtons">


<button type="button"
        class="modal-ok-btn"
        onclick="closeMessageModal()">

    OK

</button>


</div>

</div>

</div>


</body>

</html>