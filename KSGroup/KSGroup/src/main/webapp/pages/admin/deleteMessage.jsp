<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
	response.sendRedirect("adminLogin.jsp");
	return;
}

String messageId=request.getParameter("messageId");

if(messageId==null || messageId.trim().equals("")){
	response.sendRedirect("reports.jsp");
	return;
}

messageId=messageId.trim();

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
	 * Delete the selected message.
	 */

	ps=con.prepareStatement(
		"delete from CONTACT_MESSAGES "+
		"where MESSAGE_ID=?"
	);

	ps.setString(1,messageId);

	int result=ps.executeUpdate();

	ps.close();

	if(result>0){

	    response.sendRedirect(
	        "reports.jsp?delete=success"
	    );

	}
	else{

	    response.sendRedirect(
	        "reports.jsp?delete=failed"
	    );

	}

	return;

}
catch(Exception e){

	out.println("<h3>Error while deleting message</h3>");
	out.println("<p>"+e.getMessage()+"</p>");

}
finally{

	try{
		if(ps!=null) ps.close();
	}catch(Exception e){}

	try{
		if(con!=null) con.close();
	}catch(Exception e){}

}
%>