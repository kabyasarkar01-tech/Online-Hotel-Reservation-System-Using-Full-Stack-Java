<%@ page import="java.sql.*" %>

<%

String hotel_Id=request.getParameter("hotel_Id");

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

Class.forName("oracle.jdbc.driver.OracleDriver");

con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","username","password");

ps=con.prepareStatement("select HOTEL_NAME,CITY,PHOTO from HOTELS where HOTEL_ID=?");

ps.setString(1,hotel_Id);

rs=ps.executeQuery();

if(rs.next()){

	String photo=rs.getString("PHOTO");

	if(photo==null){
	    photo="";
	}

	out.print(
	    rs.getString("HOTEL_NAME")
	    +","
	    +rs.getString("CITY")
	    +","
	    +photo
	);

}

try{
    if(rs!=null)
        rs.close();
}catch(Exception e){}

try{
    if(ps!=null)
        ps.close();
}catch(Exception e){}

try{
    if(con!=null)
        con.close();
}catch(Exception e){}
%>