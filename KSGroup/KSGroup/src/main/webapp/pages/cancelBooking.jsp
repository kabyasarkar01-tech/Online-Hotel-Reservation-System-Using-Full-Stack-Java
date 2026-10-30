<%@ page import="java.sql.*" %>

<%
String customer_Id=(String)session.getAttribute("customer_Id");

if(customer_Id==null || customer_Id.equals("")){

    response.sendRedirect("login.jsp");

    return;

}

String booking_Id=request.getParameter("booking_Id");

if(booking_Id==null || booking_Id.equals("")){

    response.sendRedirect("rooms2.jsp");

    return;

}

Connection con=null;

PreparedStatement ps=null;
PreparedStatement ps2=null;
PreparedStatement ps3=null;

ResultSet rs=null;

String msg="Cancellation Failed";
String btnClass="error-btn";

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "username",
        "password"
    );

    /*
     * Start transaction
     *
     * Booking cancellation and payment update
     * will happen together.
     */

    con.setAutoCommit(false);


    /*
     * First check that this booking belongs
     * to the logged-in customer.
     */

    ps=con.prepareStatement(

        "select TOTAL_AMOUNT, STATUS " +
        "from BOOKINGS " +
        "where BOOKING_ID=? " +
        "and CUSTOMER_ID=?"

    );

    ps.setString(1,booking_Id);
    ps.setString(2,customer_Id);

    rs=ps.executeQuery();


    if(rs.next()){

        double paidAmount=rs.getDouble("TOTAL_AMOUNT");

        String status=rs.getString("STATUS");


        if(!"BOOKED".equalsIgnoreCase(status)){

            msg="This booking has already been cancelled.";

            con.rollback();

        }
        else{

            /*
             * Refund = 75% of paid amount
             */

            double refundAmount=paidAmount*0.75;


            /*
             * =====================================
             * 1. Change booking status
             * =====================================
             */

            ps2=con.prepareStatement(

                "update BOOKINGS " +

                "set STATUS=? " +

                "where BOOKING_ID=? " +

                "and CUSTOMER_ID=? " +

                "and STATUS='BOOKED'"

            );

            ps2.setString(1,"CANCELLED");
            ps2.setString(2,booking_Id);
            ps2.setString(3,customer_Id);


            int x=ps2.executeUpdate();


            if(x>0){

                /*
                 * =====================================
                 * 2. Change payment amount to 25%
                 * =====================================
                 *
                 * Example:
                 *
                 * ₹10,000 → ₹2,500
                 */

                ps3=con.prepareStatement(

                    "update PAYMENTS " +

                    "set PAID_AMOUNT=PAID_AMOUNT*0.25 " +

                    "where BOOKING_ID=?"

                );

                ps3.setString(1,booking_Id);

                int paymentUpdated=ps3.executeUpdate();


                if(paymentUpdated>0){

                    /*
                     * Both operations successful.
                     */

                    con.commit();


                    msg="Booking Cancelled Successfully. " +
                        "Refund Amount : Rs." +
                        String.format("%.2f",refundAmount);

                    btnClass="success-btn";

                }
                else{

                    /*
                     * Payment record not found.
                     * Cancel the entire transaction.
                     */

                    con.rollback();

                    msg="Cancellation Failed : Payment record not found.";

                }

            }
            else{

                con.rollback();

                msg="Cancellation Failed.";

            }

        }

    }
    else{

        con.rollback();

        msg="Booking not found.";

    }

}
catch(Exception e){

    try{

        if(con!=null)
            con.rollback();

    }
    catch(Exception ex){}

    e.printStackTrace();

    msg="Cancellation Failed : "+e.getMessage();

}
finally{

    try{

        if(rs!=null)
            rs.close();

    }catch(Exception e){}


    try{

        if(ps!=null)
            ps.close();

    }catch(Exception e){}


    try{

        if(ps2!=null)
            ps2.close();

    }catch(Exception e){}


    try{

        if(ps3!=null)
            ps3.close();

    }catch(Exception e){}


    try{

        if(con!=null){

            con.setAutoCommit(true);
            con.close();

        }

    }catch(Exception e){}

}
%>


<!DOCTYPE html>

<html>

<head>

<meta charset="UTF-8">

<title>Cancel Booking - KS Group</title>

<style>

body{

    margin:0;

    padding:0;

    background:#f5f5f5;

    font-family:Arial,sans-serif;

}

.modal-content{

    background:white;

    width:450px;

    margin:180px auto;

    padding:35px;

    border-radius:12px;

    box-shadow:0 8px 20px rgba(0,0,0,0.15);

    text-align:center;

}

.modal-content h3{

    color:#444;

    margin-bottom:20px;

}

.modal-content p{

    font-size:17px;

    color:#555;

    margin-bottom:25px;

}

.ok-btn{

    width:100%;

    padding:13px;

    border:none;

    border-radius:8px;

    color:white;

    font-size:16px;

    font-weight:bold;

    cursor:pointer;

}

.success-btn{

    background:#28a745;

}

.success-btn:hover{

    background:#218838;

}

.error-btn{

    background:#dc3545;

}

.error-btn:hover{

    background:#c82333;

}

</style>

<script>

function goBack(){

    window.location="rooms2.jsp";

}

</script>

</head>

<body>

<div class="modal-content">

    <h3>

        Cancel Booking

    </h3>

    <p>

        <%=msg%>

    </p>

    <button
        class="ok-btn <%=btnClass%>"
        onclick="goBack()">

        OK

    </button>

</div>

</body>

</html>