<%@ page import="java.io.*" %>
<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
    response.sendRedirect("adminLogin.jsp");
    return;
}

String hotel_Id="";
String hotel_Name="";
String city="";
String photo="";

String msg="Hotel Could Not Be Added";

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
        photo=photo.substring(photo.lastIndexOf("\\")+1, photo.indexOf("\""));

        int lastIndex=contentType.lastIndexOf("=");

        String boundary=contentType.substring(lastIndex+1);

        String[] parts=file.split("--"+boundary);

        for(String part:parts){

            if(part.contains("name=\"hotel_Id\"")){

                hotel_Id=part.substring(part.indexOf("\r\n\r\n")+4);
                hotel_Id=hotel_Id.substring(0, hotel_Id.indexOf("\r\n")).trim();

            }
            else if(part.contains("name=\"hotel_Name\"")){

                hotel_Name=part.substring(part.indexOf("\r\n\r\n")+4);
                hotel_Name=hotel_Name.substring(0, hotel_Name.indexOf("\r\n")).trim();

            }
            else if(part.contains("name=\"city\"")){

                city=part.substring(part.indexOf("\r\n\r\n")+4);
                city=city.substring(0, city.indexOf("\r\n")).trim();

            }

        }
        
        photo = hotel_Id + "_" + photo;

        int pos=file.indexOf("filename=\"");
        pos=file.indexOf("\r\n",pos)+2;
        pos=file.indexOf("\r\n",pos)+2;
        pos=file.indexOf("\r\n",pos)+2;

        int boundaryLocation=file.indexOf(boundary,pos)-4;

        int startPos=file.substring(0,pos).getBytes("ISO-8859-1").length;

        int endPos=file.substring(0,boundaryLocation).getBytes("ISO-8859-1").length;

        ServletContext context = pageContext.getServletContext();

        String filePath = context.getRealPath("/images");

        File folder = new File(filePath);

        if(!folder.exists()){
            folder.mkdirs();
        }

        File f = new File(folder, photo);

        FileOutputStream fileOut=new FileOutputStream(f);

        fileOut.write(dataBytes,startPos,endPos-startPos);

        fileOut.flush();
        fileOut.close();

        Class.forName("oracle.jdbc.driver.OracleDriver");

        con=DriverManager.getConnection("jdbc:oracle:thin:@localhost:1521:xe","username","password");

        ps=con.prepareStatement("insert into HOTELS(HOTEL_ID,HOTEL_NAME,CITY,PHOTO) values(?,?,?,?)");

        ps.setString(1,hotel_Id);
        ps.setString(2,hotel_Name);
        ps.setString(3,city);
        ps.setString(4,photo);

        int x=ps.executeUpdate();

        if(x>0){

            msg="Hotel Added Successfully";

        }

    }

}catch(Exception e){

    e.printStackTrace();

    msg="Hotel Could Not Be Added : " + e.getMessage();

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
<title>Hotel Status</title>

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
    background:#28a745;
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
    background:#218838;
}

</style>

<script>

function goBack(){

    window.location="addHotel.jsp";

}

</script>

</head>

<body>

<div class="modal">

    <div class="modal-content">

        <h3>Hotel Status</h3>

        <p><%=msg%></p>

        <button class="ok-btn" onclick="goBack()">

            OK

        </button>

    </div>

</div>

</body>
</html>