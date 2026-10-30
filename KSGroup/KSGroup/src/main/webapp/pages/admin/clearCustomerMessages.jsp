<%@ page import="java.sql.*" %>

<%

String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){

    response.sendRedirect("adminLogin.jsp");

    return;

}

Connection con=null;
PreparedStatement ps=null;

try{

    Class.forName("oracle.jdbc.driver.OracleDriver");

    con=DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "username",
        "password"
    );

    /*
     * Delete all messages written by customers
     */

    ps=con.prepareStatement(
        "delete from CONTACT_MESSAGES where IS_ADMIN='N'"
    );

    ps.executeUpdate();

    ps.close();

    /*
     * Redirect back to reports page
     */

    response.sendRedirect("reports.jsp?clear=success");

}
catch(Exception e){

    out.println(
        "<h3 style='color:red;text-align:center;margin-top:100px;'>" +
        "Error : " +
        e.getMessage() +
        "</h3>"
    );

}
finally{

    try{

        if(ps!=null)
            ps.close();

    }catch(Exception e){}

    try{

        if(con!=null)
            con.close();

    }catch(Exception e){}

}

%>