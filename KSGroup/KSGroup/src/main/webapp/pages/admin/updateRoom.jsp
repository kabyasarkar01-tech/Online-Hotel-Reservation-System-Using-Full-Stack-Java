<%@ page import="java.sql.*" %>
<%@ page import="java.io.*" %>

<%

String hotel_Id="";
String room_Id="";
String category="";
String price="";
String capacity="";
String photo="";

String msg="Update Failed";
String btnClass="error-btn";

Connection con=null;
PreparedStatement ps=null;
PreparedStatement ps2=null;
DataInputStream in=null;
ResultSet rs=null;

try{

    String contentType=request.getContentType();

    if(contentType!=null &&
       contentType.indexOf("multipart/form-data")>=0){

        in=new DataInputStream(
        request.getInputStream());

        int formDataLength=request.getContentLength();

        byte dataBytes[]=new byte[formDataLength];

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
        new String(dataBytes,"ISO-8859-1");

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

        String[] parts=
        file.split("--"+boundary);

        for(String part:parts){

            if(part.contains("name=\"hotel_Id\"")){

                hotel_Id=
                part.substring(
                part.indexOf("\r\n\r\n")+4);

                hotel_Id=
                hotel_Id.substring(
                0,
                hotel_Id.indexOf("\r\n")).trim();

            }

            else if(part.contains("name=\"room_Id\"")){

                room_Id=
                part.substring(
                part.indexOf("\r\n\r\n")+4);

                room_Id=
                room_Id.substring(
                0,
                room_Id.indexOf("\r\n")).trim();

            }

            else if(part.contains("name=\"category\"")){

                category=
                part.substring(
                part.indexOf("\r\n\r\n")+4);

                category=
                category.substring(
                0,
                category.indexOf("\r\n")).trim();

            }

            else if(part.contains("name=\"price\"")){

                price=
                part.substring(
                part.indexOf("\r\n\r\n")+4);

                price=
                price.substring(
                0,
                price.indexOf("\r\n")).trim();

            }
            
            else if(part.contains("name=\"capacity\"")){

                capacity=
                part.substring(
                part.indexOf("\r\n\r\n")+4);

                capacity=
                capacity.substring(
                0,
                capacity.indexOf("\r\n")).trim();

            }
        }

        photo=
        hotel_Id+"_"+room_Id+"_"+photo;

        boolean newPhotoSelected=
        !photo.equals(hotel_Id+"_"+room_Id+"_");

        int pos=file.indexOf("filename=\"");

        pos=file.indexOf("\r\n",pos)+2;

        pos=file.indexOf("\r\n",pos)+2;

        pos=file.indexOf("\r\n",pos)+2;

        int boundaryLocation=
        file.indexOf(boundary,pos)-4;

        int startPos=
        file.substring(0,pos)
        .getBytes("ISO-8859-1").length;

        int endPos=
        file.substring(0,boundaryLocation)
        .getBytes("ISO-8859-1").length;

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

        con=DriverManager.getConnection(
        "jdbc:oracle:thin:@localhost:1521:xe",
        "username",
        "password");
        
                ps=con.prepareStatement(
        "select CATEGORY,PRICE,CAPACITY,PHOTO from ROOMS where HOTEL_ID=? and ROOM_ID=?");

        ps.setString(1,hotel_Id);
        ps.setString(2,room_Id);

        rs=ps.executeQuery();

        if(rs.next()){

            String oldCategory=rs.getString("CATEGORY");

            String oldPrice=String.valueOf(rs.getDouble("PRICE"));
            
            String oldCapacity=String.valueOf(rs.getInt("CAPACITY"));

            if(oldPrice.endsWith(".0")){

                oldPrice=oldPrice.substring(0,oldPrice.length()-2);

            }

            String oldPhoto=rs.getString("PHOTO");

            if(oldCategory.equals(category)
            		&& oldPrice.equals(price)
            		&& oldCapacity.equals(capacity)
            		&& !newPhotoSelected){

                msg="Please Change Credentials";

            }
            else{

                String finalPhoto=oldPhoto;

                if(newPhotoSelected){

                    if(oldPhoto!=null && !oldPhoto.equals("")){

                        File oldFile=
                        new File(folder,oldPhoto);

                        if(oldFile.exists()){

                            oldFile.delete();

                        }

                    }

                    File f=new File(folder,photo);

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

                ps2=con.prepareStatement(

                "update ROOMS set CATEGORY=?,PRICE=?,CAPACITY=?,PHOTO=? where HOTEL_ID=? and ROOM_ID=?"

                );

                ps2.setString(1,category);

                ps2.setDouble(2,Double.parseDouble(price));

                ps2.setInt(3,Integer.parseInt(capacity));

                ps2.setString(4,finalPhoto);

                ps2.setString(5,hotel_Id);

                ps2.setString(6,room_Id);

                int x=ps2.executeUpdate();

                if(x>0){

                    msg="Room Updated Successfully";

                    btnClass="success-btn";

                }

            }

        }

    }

}catch(Exception e){

    e.printStackTrace();

    msg="Update Failed : "+e.getMessage();

}finally{

    try{
        if(in!=null)
            in.close();
    }catch(Exception e){}

    try{
        if(rs!=null)
            rs.close();
    }catch(Exception e){}

    try{
        if(ps!=null)
            ps.close();
    }catch(Exception e){}

    try{
        if(ps2!=null)
            ps2.close();
    }catch(Exception e){}

    try{
        if(con!=null)
            con.close();
    }catch(Exception e){}
}
%>

<!DOCTYPE html>

<html>
<head>

<meta charset="UTF-8">

<title>Modify Room Status</title>

<style>

body{
	margin:0;
	padding:0;
	font-family:Arial,sans-serif;
	background:#f5f5f5;
}

.modal{
	display:block;
	position:fixed;
	left:0;
	top:0;
	width:100%;
	height:100%;
	background:rgba(0,0,0,0.5);
}

.modal-content{
	background:white;
	width:350px;
	margin:200px auto;
	padding:30px;
	border-radius:10px;
	text-align:center;
	box-shadow:0 8px 20px rgba(0,0,0,0.2);
}

.modal-content h3{
	color:#444;
	margin-bottom:20px;
}

.modal-content p{
	font-size:16px;
	color:#555;
	margin-bottom:25px;
}

.ok-btn{
	color:white;
	border:none;
	border-radius:8px;
	padding:12px;
	width:100%;
	font-size:16px;
	font-weight:bold;
	cursor:pointer;
}

.success-btn{
	background:#28a745;
}

.success-btn:hover{
	background:#218838;
}

.error-btn{
	background:#dc3545;
}

.error-btn:hover{
	background:#c82333;
}

</style>

<script>

function goBack(){

	window.location="modifyRoom.jsp";

}

</script>

</head>

<body>

<div class="modal">

	<div class="modal-content">

		<h3>Modify Room</h3>

		<p><%=msg%></p>

		<button
		class="ok-btn <%=btnClass%>"
		onclick="goBack()">

			OK

		</button>

	</div>

</div>

</body>
</html>