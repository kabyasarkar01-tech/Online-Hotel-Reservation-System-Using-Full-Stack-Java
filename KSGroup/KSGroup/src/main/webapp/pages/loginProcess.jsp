<%@ page import="java.sql.*" %>

<%
String email=request.getParameter("email");
String password=request.getParameter("password");

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

	ps=con.prepareStatement(

	"select customer_id,first_name,password from customers where lower(email)=lower(?)"

	);

	ps.setString(1,email);

	rs=ps.executeQuery();

	if(rs.next()){

		String dbPassword=rs.getString("password");

		if(dbPassword.equals(password)){

			session.setAttribute(
			"customer_Id",
			rs.getString("customer_id")
			);

			session.setAttribute(
			"customerName",
			rs.getString("first_name")
			);

			response.sendRedirect("../index.jsp");

			return;

		}
		else{

			response.sendRedirect(
			"message.jsp?msg="+
			java.net.URLEncoder.encode(
			"Incorrect Password.",
			"UTF-8")
			+"&nextPage=login.jsp"
			+"&button="+
			java.net.URLEncoder.encode(
			"Back",
			"UTF-8")
			);

			return;

		}

	}
	else{

		response.sendRedirect(
		"message.jsp?msg="+
		java.net.URLEncoder.encode(
		"Email ID does not exist.",
		"UTF-8")
		+"&nextPage=login.jsp"
		+"&button="+
		java.net.URLEncoder.encode(
		"Back",
		"UTF-8")
		);

		return;

	}

}
catch(Exception e){

	response.sendRedirect(
	"message.jsp?msg="+
	java.net.URLEncoder.encode(
	"Error : "+e.getMessage(),
	"UTF-8")
	+"&nextPage=login.jsp"
	+"&button="+
	java.net.URLEncoder.encode(
	"Back",
	"UTF-8")
	);

	return;

}
finally{

	try{

		if(rs!=null)
			rs.close();

		if(ps!=null)
			ps.close();

		if(con!=null)
			con.close();

	}
	catch(Exception ex){}

}
%>