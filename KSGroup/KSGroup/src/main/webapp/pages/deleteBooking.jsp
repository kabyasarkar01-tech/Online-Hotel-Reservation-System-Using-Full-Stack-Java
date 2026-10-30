<%@ page import="java.sql.*" %>

<%
String customer_Id = (String)session.getAttribute("customer_Id");

if(customer_Id == null || customer_Id.equals("")) {

    response.sendRedirect("login.jsp");

    return;
}

String booking_Id = request.getParameter("booking_Id");

if(booking_Id == null || booking_Id.equals("")) {

    response.sendRedirect("rooms2.jsp");

    return;
}

Connection con = null;
PreparedStatement ps = null;

try {

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con = DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "username",
        "password"
    );

    /*
     * Store only the information that this customer
     * wants this booking hidden from his/her view.
     *
     * BOOKINGS itself is NOT changed.
     */

    ps = con.prepareStatement(
        "INSERT INTO USER_DELETED_BOOKINGS " +
        "(CUSTOMER_ID, BOOKING_ID) " +
        "VALUES (?, ?)"
    );

    ps.setString(1, customer_Id);
    ps.setString(2, booking_Id);

    ps.executeUpdate();

    response.sendRedirect("rooms2.jsp");

}
catch(Exception e) {

    out.println("<script>");

    out.println(
        "alert('Unable to delete booking from your view. Please try again.');"
    );

    out.println("window.location='rooms2.jsp';");

    out.println("</script>");

}
finally {

    try {
        if(ps != null)
            ps.close();
    }
    catch(Exception e) {}

    try {
        if(con != null)
            con.close();
    }
    catch(Exception e) {}

}
%>