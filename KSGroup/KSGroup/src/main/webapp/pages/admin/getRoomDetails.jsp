<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
	return;
}

String hotel_Id=request.getParameter("hotel_Id");
String room_Id=request.getParameter("room_Id");

Connection con=null;
PreparedStatement ps=null;
ResultSet rs=null;

try{

	Class.forName("oracle.jdbc.driver.OracleDriver");

	con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","username","password");

	ps=con.prepareStatement("select R.CATEGORY, R.PRICE, R.CAPACITY, R.PHOTO, H.PHOTO HOTELPHOTO from ROOMS R join HOTELS H on R.HOTEL_ID=H.HOTEL_ID where R.HOTEL_ID=? and R.ROOM_ID=?");

	ps.setString(1,hotel_Id);
	ps.setString(2,room_Id);

	rs=ps.executeQuery();

	if(rs.next()){

		String roomPhoto=rs.getString("PHOTO");
		if(roomPhoto==null)
		    roomPhoto="";

		String hotelPhoto=rs.getString("HOTELPHOTO");
		if(hotelPhoto==null)
		    hotelPhoto="";

		out.print(
				rs.getString("CATEGORY")
				+","
				+
				rs.getDouble("PRICE")
				+","
				+
				rs.getInt("CAPACITY")
				+","
				+
				roomPhoto
				+","
				+
				hotelPhoto
				);

	}

}catch(Exception e){

	out.print(",");

}finally{

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