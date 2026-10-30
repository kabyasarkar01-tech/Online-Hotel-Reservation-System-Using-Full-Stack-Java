<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
	response.sendRedirect("adminLogin.jsp");
	return;
}

String message=request.getParameter("message");

if(message==null || message.trim().equals("")){
	response.sendRedirect("reports.jsp");
	return;
}

message=message.trim();

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

	/* Generate MESSAGE_ID */

	ps=con.prepareStatement(
		"select max(message_id) from contact_messages"
	);

	rs=ps.executeQuery();

	String messageId="M101";

	if(rs.next()){

		String maxId=rs.getString(1);

		if(maxId!=null && !maxId.trim().equals("")){

			int number=Integer.parseInt(
				maxId.substring(1)
			);

			messageId="M"+(number+1);
		}
	}

	rs.close();
	ps.close();


	/* Insert admin message */

	ps = con.prepareStatement(
    "insert into CONTACT_MESSAGES " +
    "(MESSAGE_ID, CUSTOMER_ID, FIRST_NAME, MIDDLE_NAME, LAST_NAME, " +
    "MESSAGE_TEXT, PARENT_ID, IS_ADMIN, CREATED_AT, UPDATED_AT, " +
    "PHONE, EMAIL, FULL_NAME) " +
    "values (?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?, ?)"
);

	ps.setString(1, messageId);
	ps.setString(2, null);
	ps.setString(3, "KS Group");
	ps.setString(4, null);
	ps.setString(5, "Admin");
	ps.setString(6, message);
	ps.setString(7, null);
	ps.setString(8, "Y");

	ps.setTimestamp(9, new Timestamp(System.currentTimeMillis()));

	ps.setTimestamp(10, null);   // IMPORTANT

	ps.setString(11, null);
	ps.setString(12, null);
	ps.setString(13, "KS Group Admin");

	ps.executeUpdate();

	ps.close();

	/* Return to Reports */

	response.sendRedirect("reports.jsp");

}
catch(Exception e){

	out.println("<h3>Error while sending message</h3>");
	out.println("<p>"+e.getMessage()+"</p>");

}
finally{

	try{
		if(rs!=null) rs.close();
	}catch(Exception e){}

	try{
		if(ps!=null) ps.close();
	}catch(Exception e){}

	try{
		if(con!=null) con.close();
	}catch(Exception e){}

}
%>