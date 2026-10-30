<%@ page import="java.sql.*" %>

<%
String firstName=request.getParameter("firstName");
String middleName=request.getParameter("middleName");
String lastName=request.getParameter("lastName");
String gender=request.getParameter("gender");
String email=request.getParameter("email");
String password=request.getParameter("password");
String dob=request.getParameter("dob");
String phone=request.getParameter("phone");

/* NAME VALIDATION */

if(!firstName.matches("[A-Za-z]+")){

    response.sendRedirect(
        "message.jsp?msg="+
        java.net.URLEncoder.encode(
            "First Name can contain letters only.",
            "UTF-8"
        )
        +"&nextPage=register.jsp"
        +"&button="+
        java.net.URLEncoder.encode(
            "Back",
            "UTF-8"
        )
    );

    return;
}


if(middleName!=null && !middleName.equals("")
        && !middleName.matches("[A-Za-z]+")){

    response.sendRedirect(
        "message.jsp?msg="+
        java.net.URLEncoder.encode(
            "Middle Name can contain letters only.",
            "UTF-8"
        )
        +"&nextPage=register.jsp"
        +"&button="+
        java.net.URLEncoder.encode(
            "Back",
            "UTF-8"
        )
    );

    return;
}


if(!lastName.matches("[A-Za-z]+")){

    response.sendRedirect(
        "message.jsp?msg="+
        java.net.URLEncoder.encode(
            "Surname can contain letters only.",
            "UTF-8"
        )
        +"&nextPage=register.jsp"
        +"&button="+
        java.net.URLEncoder.encode(
            "Back",
            "UTF-8"
        )
    );

    return;
}


/* EMAIL CHARACTER VALIDATION */

if(!email.matches("[A-Za-z0-9_.@]+")){

    response.sendRedirect(
        "message.jsp?msg="+
        java.net.URLEncoder.encode(
            "Email can contain letters, numbers, underscore (_), @ and dot (.) only.",
            "UTF-8"
        )
        +"&nextPage=register.jsp"
        +"&button="+
        java.net.URLEncoder.encode(
            "Back",
            "UTF-8"
        )
    );

    return;
}


/* DATE VALIDATION */

java.sql.Date dobDate=java.sql.Date.valueOf(dob);

java.sql.Date today=
    new java.sql.Date(System.currentTimeMillis());

if(dobDate.after(today)){

    response.sendRedirect(
        "message.jsp?msg="+
        java.net.URLEncoder.encode(
            "Date of Birth cannot be a future date.",
            "UTF-8"
        )
        +"&nextPage=register.jsp"
        +"&button="+
        java.net.URLEncoder.encode(
            "Back",
            "UTF-8"
        )
    );

    return;
}

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

	Class.forName("oracle.jdbc.driver.OracleDriver");

	con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","username","password");

	/* Check if Email Already Exists */

	ps=con.prepareStatement(
	"select email from customers where lower(email)=lower(?)"
	);

	ps.setString(1,email);

	rs=ps.executeQuery();

	if(rs.next()){

		response.sendRedirect(
				"message.jsp?msg="+
				java.net.URLEncoder.encode(
				"Email ID already registered.",
				"UTF-8")
				+"&nextPage=register.jsp"
				+"&button="+
				java.net.URLEncoder.encode(
				"Back",
				"UTF-8")
				);

				return;

	}

	rs.close();
	ps.close();

	/* Generate Customer ID */

	ps=con.prepareStatement(
	"select max(customer_id) from customers"
	);

	rs=ps.executeQuery();

	String customer_id="C001";

	if(rs.next()){

		String maxId=rs.getString(1);

		if(maxId!=null){

			int number=Integer.parseInt(maxId.substring(1));

			customer_id=String.format("C%03d", number + 1);

		}

	}

	rs.close();
	ps.close();

	/* Insert Customer */

	ps=con.prepareStatement(

	"insert into customers(customer_id,first_name,middle_name,last_name,gender,email,password,dob,phone)values(?,?,?,?,?,?,?,?,?)"
	);

	ps.setString(1,customer_id);
	ps.setString(2,firstName);
	ps.setString(3,middleName);
	ps.setString(4,lastName);
	ps.setString(5,gender);
	ps.setString(6,email);
	ps.setString(7,password);
	ps.setDate(8,dobDate);
	ps.setString(9,phone);

	int x=ps.executeUpdate();

	if(x>0){

		response.sendRedirect(
				"message.jsp?msg="+
				java.net.URLEncoder.encode(
				"Registration Successful.",
				"UTF-8")
				+"&nextPage=login.jsp"
				+"&button="+
				java.net.URLEncoder.encode(
				"Continue",
				"UTF-8")
				);

				return;

	}
	else{

		response.sendRedirect(
				"message.jsp?msg="+
				java.net.URLEncoder.encode(
				"Registration Failed.",
				"UTF-8")
				+"&nextPage=register.jsp"
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
			+"&nextPage=register.jsp"
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