<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%

String customer_Id=(String)session.getAttribute("customer_Id");

if(customer_Id==null){

	response.sendRedirect("login.jsp");
	return;

}

String first_Name="";
String middle_Name="";
String last_Name="";
String gender="";
String email="";
String password="";
String dob="";
String phone="";
String photo="";
String removePhoto="no";

Connection con=null;
PreparedStatement ps=null;
PreparedStatement ps2=null;
ResultSet rs=null;
DataInputStream in=null;

try{

	String contentType=request.getContentType();

	if(contentType!=null &&
	contentType.indexOf("multipart/form-data")>=0){

		in=new DataInputStream(
		request.getInputStream());

		int formDataLength=
		request.getContentLength();

		byte dataBytes[]=
		new byte[formDataLength];

		int byteRead=0;
		int totalBytesRead=0;

		while(totalBytesRead<formDataLength){

			byteRead=in.read(
			dataBytes,
			totalBytesRead,
			formDataLength-totalBytesRead);

			totalBytesRead+=byteRead;

		}

		String file=
		new String(
		dataBytes,
		"ISO-8859-1");

		photo=file.substring(
		file.indexOf("filename=\"")+10);

		photo=photo.substring(
		0,
		photo.indexOf("\n"));

		photo=photo.substring(
		photo.lastIndexOf("\\")+1,
		photo.indexOf("\""));

		int lastIndex=
		contentType.lastIndexOf("=");

		String boundary=
		contentType.substring(lastIndex+1);

		String parts[]=
		file.split("--"+boundary);

		for(String part:parts){

			if(part.contains("name=\"firstName\"")){

				first_Name=
				part.substring(
				part.indexOf("\r\n\r\n")+4);

				first_Name=
				first_Name.substring(
				0,
				first_Name.indexOf("\r\n")).trim();

			}

			else if(part.contains("name=\"middleName\"")){

				middle_Name=
				part.substring(
				part.indexOf("\r\n\r\n")+4);

				middle_Name=
				middle_Name.substring(
				0,
				middle_Name.indexOf("\r\n")).trim();

			}

			else if(part.contains("name=\"lastName\"")){

				last_Name=
				part.substring(
				part.indexOf("\r\n\r\n")+4);

				last_Name=
				last_Name.substring(
				0,
				last_Name.indexOf("\r\n")).trim();

			}

			else if(part.contains("name=\"gender\"")){

				gender=
				part.substring(
				part.indexOf("\r\n\r\n")+4);

				gender=
				gender.substring(
				0,
				gender.indexOf("\r\n")).trim();

			}

			else if(part.contains("name=\"email\"")){

				email=
				part.substring(
				part.indexOf("\r\n\r\n")+4);

				email=
				email.substring(
				0,
				email.indexOf("\r\n")).trim();

			}

			else if(part.contains("name=\"password\"")){

				password=
				part.substring(
				part.indexOf("\r\n\r\n")+4);

				password=
				password.substring(
				0,
				password.indexOf("\r\n")).trim();

			}

			else if(part.contains("name=\"dob\"")){

				dob=
				part.substring(
				part.indexOf("\r\n\r\n")+4);

				dob=
				dob.substring(
				0,
				dob.indexOf("\r\n")).trim();

			}

			else if(part.contains("name=\"phone\"")){

				phone=
				part.substring(
				part.indexOf("\r\n\r\n")+4);

				phone=
				phone.substring(
				0,
				phone.indexOf("\r\n")).trim();

			}

			else if(part.contains("name=\"removePhoto\"")){

				removePhoto=
				part.substring(
				part.indexOf("\r\n\r\n")+4);

				removePhoto=
				removePhoto.substring(
				0,
				removePhoto.indexOf("\r\n")).trim();

			}

		}

		boolean newPhotoSelected=false;

		if(photo!=null && !photo.trim().equals("")){

		    photo=customer_Id+"_"+photo;

		    newPhotoSelected=true;

		}

		int startPos=0;
		int endPos=0;

		if(newPhotoSelected){

		    int pos=file.indexOf("filename=\"");

		    pos=file.indexOf("\r\n",pos)+2;

		    pos=file.indexOf("\r\n",pos)+2;

		    pos=file.indexOf("\r\n",pos)+2;

		    int boundaryLocation=file.indexOf(boundary,pos)-4;

		    startPos=file.substring(
		    0,
		    pos).getBytes("ISO-8859-1").length;

		    endPos=file.substring(
		    0,
		    boundaryLocation).getBytes("ISO-8859-1").length;

		}

		ServletContext context=
		pageContext.getServletContext();

		String filePath=
		context.getRealPath("/images");

		File folder=
		new File(filePath);

		if(!folder.exists()){

			folder.mkdirs();

		}

		Class.forName(
		"oracle.jdbc.driver.OracleDriver");

		con=
		DriverManager.getConnection(

		"jdbc:oracle:thin:@localhost:1521:xe",

		"username",

		"password"

		);

		ps=
		con.prepareStatement(

		"select * from customers where customer_id=?"

		);

		ps.setString(
		1,
		customer_Id);

		rs=ps.executeQuery();
		
		if(rs.next()){
			String oldFirstName=rs.getString("FIRST_NAME");
			String oldMiddleName=rs.getString("MIDDLE_NAME");
			String oldLastName=rs.getString("LAST_NAME");
			String oldGender=rs.getString("GENDER");
			String oldEmail=rs.getString("EMAIL");
			String oldPassword=rs.getString("PASSWORD");
			String oldDob=String.valueOf(rs.getDate("DOB"));
			String oldPhone=rs.getString("PHONE");
			String oldPhoto=rs.getString("PHOTO");

	if(oldFirstName.equals(first_Name)
	&& ((oldMiddleName==null?"":oldMiddleName).equals(middle_Name))
	&& oldLastName.equals(last_Name)
	&& oldGender.equals(gender)
	&& oldEmail.equals(email)
	&& oldPassword.equals(password)
	&& oldDob.equals(dob)
	&& oldPhone.equals(phone)
	&& !newPhotoSelected
	&& removePhoto.equals("no")){

		response.sendRedirect(
		"message.jsp?msg="+
		java.net.URLEncoder.encode(
		"Please Change Credentials.",
		"UTF-8")
		+"&nextPage=profile.jsp"
		+"&button="+
		java.net.URLEncoder.encode(
		"Back",
		"UTF-8"));

		return;

	}

	String finalPhoto=oldPhoto;

	if(removePhoto.equals("yes")){

	    if(oldPhoto!=null &&
	       !oldPhoto.equals("") &&
	       !oldPhoto.equals("default-user.png")){

	        File oldFile=new File(folder,oldPhoto);

	        if(oldFile.exists()){

	            oldFile.delete();

	        }

	    }

	    finalPhoto="default-user.png";

	}
	else if(newPhotoSelected){

		if(oldPhoto!=null &&
				!oldPhoto.equals("") &&
				!oldPhoto.equals("default-user.png")){

				    File oldFile=new File(folder,oldPhoto);

				    if(oldFile.exists()){

				        oldFile.delete();

				    }

				}

		File f=
		new File(folder,photo);

		FileOutputStream fileOut=
		new FileOutputStream(f);

		fileOut.write(
		dataBytes,
		startPos,
		endPos-startPos);

		fileOut.flush();

		fileOut.close();

		finalPhoto=photo;

	}

	ps2=
	con.prepareStatement(

	"update customers set first_name=?,middle_name=?,last_name=?,gender=?,email=?,password=?,dob=?,phone=?,photo=? where customer_id=?"

	);

	ps2.setString(1,first_Name);
	ps2.setString(2,middle_Name);
	ps2.setString(3,last_Name);
	ps2.setString(4,gender);
	ps2.setString(5,email);
	ps2.setString(6,password);
	ps2.setDate(
	7,
	java.sql.Date.valueOf(dob));
	ps2.setString(8,phone);
	ps2.setString(9,finalPhoto);
	ps2.setString(10,customer_Id);

	int x=ps2.executeUpdate();

	if(x>0){

		session.setAttribute(
		"customerName",
		first_Name);

		response.sendRedirect(
		"message.jsp?msg="+
		java.net.URLEncoder.encode(
		"Profile Updated Successfully.",
		"UTF-8")
		+"&nextPage=../index.jsp"
		+"&button="+
		java.net.URLEncoder.encode(
		"Continue",
		"UTF-8"));

		return;

	}
	else{

		response.sendRedirect(
		"message.jsp?msg="+
		java.net.URLEncoder.encode(
		"Profile Update Failed.",
		"UTF-8")
		+"&nextPage=profile.jsp"
		+"&button="+
		java.net.URLEncoder.encode(
		"Back",
		"UTF-8"));

		return;

	}

}

}

}
catch(Exception e){

	response.sendRedirect(
	"message.jsp?msg="+
	java.net.URLEncoder.encode(
	"Error : "+e.getMessage(),
	"UTF-8")
	+"&nextPage=profile.jsp"
	+"&button="+
	java.net.URLEncoder.encode(
	"Back",
	"UTF-8"));

	return;

}
finally{

	try{

		if(in!=null)
			in.close();

	}
	catch(Exception e){}

	try{

		if(rs!=null)
			rs.close();

	}
	catch(Exception e){}

	try{

		if(ps!=null)
			ps.close();

	}
	catch(Exception e){}

	try{

		if(ps2!=null)
			ps2.close();

	}
	catch(Exception e){}

	try{

		if(con!=null)
			con.close();

	}
	catch(Exception e){}

}

%>