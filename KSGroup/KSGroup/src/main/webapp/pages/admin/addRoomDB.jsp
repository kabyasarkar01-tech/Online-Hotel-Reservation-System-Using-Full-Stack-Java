	<%@ page import="java.sql.*" %>
	<%@ page import="java.io.*" %>
	
	<%
	String admin=(String)session.getAttribute("admin");
	
	if(admin==null || admin.equals("")){
		response.sendRedirect("adminLogin.jsp");
		return;
	}
	
	String hotel_id="";
	String room_id="";
	String category="";
	String photo="";
	double price=0;
	int capacity=0;
	
	String msg="";
	String redirectPage="";
	String buttonColor="#28a745";
	String hoverColor="#218838";
	
	Connection con=null;
	PreparedStatement ps=null;
	DataInputStream in=null;
	
	try{
	
	    String contentType=request.getContentType();
	
	    if(contentType!=null && contentType.indexOf("multipart/form-data")>=0){
	
	        in=new DataInputStream(request.getInputStream());
	
	        int formDataLength=request.getContentLength();
	
	        byte dataBytes[]=new byte[formDataLength];
	
	        int byteRead=0;
	        int totalBytesRead=0;
	
	        while(totalBytesRead<formDataLength){
	
	            byteRead=in.read(dataBytes,totalBytesRead,
	                    formDataLength-totalBytesRead);
	
	            totalBytesRead+=byteRead;
	        }
	
	        String file=new String(dataBytes,"ISO-8859-1");
	
	        photo=file.substring(file.indexOf("filename=\"")+10);
	        photo=photo.substring(0,photo.indexOf("\n"));
	        photo=photo.substring(photo.lastIndexOf("\\")+1,
	                              photo.indexOf("\""));
	
	        int lastIndex=contentType.lastIndexOf("=");
	
	        String boundary=contentType.substring(lastIndex+1);
	
	        String[] parts=file.split("--"+boundary);
	
	        for(String part:parts){
	
	            if(part.contains("name=\"hotel_id\"")){
	
	                hotel_id=part.substring(part.indexOf("\r\n\r\n")+4);
	                hotel_id=hotel_id.substring(0,
	                        hotel_id.indexOf("\r\n")).trim();
	
	            }
	            else if(part.contains("name=\"room_id\"")){
	
	                room_id=part.substring(part.indexOf("\r\n\r\n")+4);
	                room_id=room_id.substring(0,
	                        room_id.indexOf("\r\n")).trim();
	
	            }
	            else if(part.contains("name=\"category\"")){
	
	                category=part.substring(part.indexOf("\r\n\r\n")+4);
	                category=category.substring(0,
	                        category.indexOf("\r\n")).trim();
	
	            }
	            else if(part.contains("name=\"price\"")){
	
	                String p=part.substring(part.indexOf("\r\n\r\n")+4);
	                p=p.substring(0,p.indexOf("\r\n")).trim();
	
	                price=Double.parseDouble(p);
	
	            }
	            else if(part.contains("name=\"capacity\"")){

	                String c=part.substring(part.indexOf("\r\n\r\n")+4);

	                c=c.substring(0,c.indexOf("\r\n")).trim();

	                capacity=Integer.parseInt(c);

	            }
	
	        }
	
	        photo=room_id+"_"+photo;
	
	        if(photo.equals(room_id+"_")){
	
	            photo=null;
	
	        }
	
	        if(photo!=null){
	
	            int pos=file.indexOf("filename=\"");
	
	            pos=file.indexOf("\r\n",pos)+2;
	            pos=file.indexOf("\r\n",pos)+2;
	            pos=file.indexOf("\r\n",pos)+2;
	
	            int boundaryLocation=file.indexOf(boundary,pos)-4;
	
	            int startPos=file.substring(0,pos)
	                    .getBytes("ISO-8859-1").length;
	
	            int endPos=file.substring(0,boundaryLocation)
	                    .getBytes("ISO-8859-1").length;
	
	            ServletContext context=pageContext.getServletContext();
	
	            String filePath=context.getRealPath("/images");
	
	            File folder=new File(filePath);
	
	            if(!folder.exists()){
	
	                folder.mkdirs();
	
	            }
	
	            File f=new File(folder,photo);
	
	            FileOutputStream fileOut=null;
	
	            try{
	
	                fileOut=new FileOutputStream(f);
	
	                fileOut.write(dataBytes,startPos,endPos-startPos);
	
	                fileOut.flush();
	
	            }finally{
	
	                if(fileOut!=null)
	                    fileOut.close();
	
	            }
	
	        }
	
	        Class.forName("oracle.jdbc.driver.OracleDriver");
	
	        con=DriverManager.getConnection(
	        "jdbc:oracle:thin:@localhost:1521:xe",
	        "username",
	        "password"
	        );
	
	        ps=con.prepareStatement("insert into ROOMS (HOTEL_ID,ROOM_ID,CATEGORY,PRICE,PHOTO,CAPACITY,STATUS) values(?,?,?,?,?,?,?)");
	
	        ps.setString(1,hotel_id);
	        ps.setString(2,room_id);
	        ps.setString(3,category);
	        ps.setDouble(4,price);
	        ps.setString(5,photo);
	        ps.setInt(6,capacity);
	        ps.setString(7,"Available");
	
	        int x=ps.executeUpdate();
	
	        if(x>0){
	
	            msg="Room Added Successfully";
	            redirectPage="addRoom.jsp";
	            buttonColor="#28a745";
	            hoverColor="#218838";
	
	        }
	        else{
	
	            msg="Room Could Not Be Added";
	            redirectPage="addRoom.jsp";
	            buttonColor="#dc3545";
	            hoverColor="#c82333";
	
	        }
	
	    }
	
	}catch(SQLIntegrityConstraintViolationException e){
		
		if(photo!=null){
	
		    ServletContext context=pageContext.getServletContext();
	
		    String filePath=context.getRealPath("/images");
	
		    File f=new File(filePath,photo);
	
		    if(f.exists()){
	
		        f.delete();
	
		    }
	
		}
	
		msg="This Room ID already exists for the selected Hotel.";
	    redirectPage="addRoom.jsp";
	    buttonColor="#dc3545";
	    hoverColor="#c82333";
	
	}catch(Exception e){
		
		if(photo!=null){
	
		    ServletContext context=pageContext.getServletContext();
	
		    String filePath=context.getRealPath("/images");
	
		    File f=new File(filePath,photo);
	
		    if(f.exists()){
	
		        f.delete();
	
		    }
	
		}
	
	    e.printStackTrace();
	
	    msg="Room Could Not Be Added : "+e.getMessage();
	    redirectPage="addRoom.jsp";
	    buttonColor="#dc3545";
	    hoverColor="#c82333";
	
	}finally{
	
	    try{
	        if(in!=null)
	            in.close();
	    }catch(Exception e){}
	
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
	
	<!DOCTYPE html>
	<html>
	<head>
	<meta charset="UTF-8">
	<title>Room Status</title>
	
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
		background:<%=buttonColor%>;
		color:white;
		border:none;
		border-radius:8px;
		padding:12px;
		width:100%;
		font-size:16px;
		font-weight:bold;
		cursor:pointer;
	}
	
	.ok-btn:hover{
		background:<%=hoverColor%>;
	}
	
	
	
	</style>
	
	<script>
	
	function goToPage(){
	
		window.location="<%=redirectPage%>";
	
	}
	
	</script>
	
	</head>
	
	<body>
	
	<div id="messageModal" class="modal">
	
		<div class="modal-content">
	
			<h3>Room Status</h3>
	
			<p><%=msg%></p>
	
			<button class="ok-btn" onclick="goToPage()">
	
				OK
	
			</button>
	
		</div>
	
	</div>
	
	</body>
	</html>