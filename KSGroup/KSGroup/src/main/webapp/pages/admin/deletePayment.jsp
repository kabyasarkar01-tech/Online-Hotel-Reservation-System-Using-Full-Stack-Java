<%@ page import="java.sql.*" %>

<%

String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){

    response.sendRedirect("adminLogin.jsp");

    return;

}


String booking_Id=request.getParameter("booking_Id");

if(booking_Id==null || booking_Id.equals("")){

    response.sendRedirect("payment.jsp");

    return;

}


Connection con=null;
PreparedStatement ps=null;


try{

    Class.forName(
        "oracle.jdbc.driver.OracleDriver"
    );


    con=DriverManager.getConnection(

        "jdbc:oracle:thin:@localhost:1521:xe",

        "username",

        "password"

    );


    ps=con.prepareStatement(

        "delete from PAYMENTS " +
        "where BOOKING_ID=?"

    );


    ps.setString(1,booking_Id);


    int result=
        ps.executeUpdate();


    if(result>0){

        response.sendRedirect(
            "payment.jsp?deleted=1"
        );

        return;

    }
    else{

        out.println(

            "<h3 style='text-align:center;" +
            "margin-top:100px;'>" +

            "Payment record not found." +

            "</h3>"

        );

    }


}
catch(Exception e){

    out.println(

        "<h3 style='color:red;" +
        "text-align:center;" +
        "margin-top:100px;'>" +

        "Delete Failed : " +
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