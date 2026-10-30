<%@ page import="java.sql.*" %>

<%
String admin=(String)session.getAttribute("admin");

if(admin==null || admin.equals("")){
    response.sendRedirect("adminLogin.jsp");
    return;
}

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
    "select * from CUSTOMERS order by CUSTOMER_ID"
    );

    rs=ps.executeQuery();
%>

<!DOCTYPE html>

<html>
<head>

<meta charset="UTF-8">

<title>Customers - KS Group</title>

<style>

body{
    margin:0;
    padding:0;
    font-family:Arial,sans-serif;
    background:#f5f5f5;
}

.header{
    background:#c59d5f;
    color:white;
    padding:20px;
    text-align:center;
    font-size:30px;
    font-weight:bold;
    letter-spacing:2px;
}

.header span{
    color:black;
}

.container{
    width:98%;
    max-width:1500px;
    margin:40px auto;
    background:white;
    padding:30px;
    border-radius:12px;
    box-shadow:0 8px 20px rgba(0,0,0,0.15);
}

h2{
    text-align:center;
    color:#444;
    margin-bottom:30px;
}

table{
    width:100%;
    border-collapse:collapse;
}

th{
    background:#c59d5f;
    color:white;
    padding:12px;
    text-align:center;
}

td{
    padding:12px;
    text-align:center;
    border-bottom:1px solid #ddd;
}

tr:nth-child(even){
    background:#f9f9f9;
}

tr:hover{
    background:#f1f1f1;
}

.customer-photo{
    width:120px;
    height:90px;
    object-fit:cover;
    border-radius:8px;
    border:1px solid #ccc;
}

.delete-btn{

    background:#dc3545;
    color:white;
    border:none;
    border-radius:6px;
    padding:10px 18px;
    font-weight:bold;
    cursor:pointer;

}

.delete-btn:hover{

    background:#c82333;

}

.modal{
    display:none;
    position:fixed;
    left:0;
    top:0;
    width:100%;
    height:100%;
    background:rgba(0,0,0,0.5);
    z-index:1000;
}

.modal-content{
    background:white;
    width:400px;
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
    margin-bottom:25px;
    font-size:16px;
}

.button-group{

    display:flex;
    justify-content:center;
    gap:20px;

}

.yes-btn{

    flex:1;
    background:#28a745;
    color:white;
    border:none;
    border-radius:8px;
    padding:12px;
    font-size:16px;
    font-weight:bold;
    cursor:pointer;

}

.yes-btn:hover{

    background:#218838;

}

.no-btn{

    flex:1;
    background:#dc3545;
    color:white;
    border:none;
    border-radius:8px;
    padding:12px;
    font-size:16px;
    font-weight:bold;
    cursor:pointer;

}

.no-btn:hover{

    background:#c82333;

}

.top-home{
    position:absolute;
    top:18px;
    left:20px;
}

.top-home a{
    text-decoration:none;
}

.top-home button{
    padding:8px 18px;
    font-size:13px;
    font-weight:bold;
    border:none;
    border-radius:6px;
    background:#007bff;
    color:white;
    cursor:pointer;
}

.top-home button:hover{
    background:#0069d9;
}

</style>

<script>

var deleteCustomer_id="";

function deleteCustomer(customer_id){

    deleteCustomer_id=customer_id;

    document.getElementById(
    "deleteModal"
    ).style.display="block";

}

function closeDeleteModal(){

    deleteCustomer_id="";

    document.getElementById(
    "deleteModal"
    ).style.display="none";

}

function confirmDelete(){

    document.getElementById(
    "deleteModal"
    ).style.display="none";

    window.location=
    "deleteCustomer.jsp?customer_Id="+
    deleteCustomer_id;

}

</script>

</head>

<body>

<div class="top-home">

    <a href="home.jsp">

        <button type="button">
            Back
        </button>

    </a>

</div>

<div class="header">

    <span>KS</span> Group Admin Panel

</div>

<div class="container">

	<h2>Customers</h2>

	<table>

		<tr>

			<th>Customer ID</th>

			<th>Name</th>

			<th>Gender</th>

			<th>Email</th>

			<th>Password</th>

			<th>Date of Birth</th>

			<th>Phone</th>

			<th>Photo</th>

			<th></th>

		</tr>

<%
while(rs.next()){
%>

		<tr>

			<td>

				<%=rs.getString("CUSTOMER_ID")%>

			</td>

			<td>

<%
String firstName=rs.getString("FIRST_NAME");
String middleName=rs.getString("MIDDLE_NAME");
String lastName=rs.getString("LAST_NAME");

if(firstName==null){
    firstName="";
}

if(middleName==null){
    middleName="";
}

if(lastName==null){
    lastName="";
}
%>

<%=firstName%>

<%
if(!middleName.equals("")){
%>

<%=middleName%>

<%
}
%>

<%=lastName%>

</td>

			<td>

				<%=rs.getString("GENDER")%>

			</td>

			<td>

				<%=rs.getString("EMAIL")%>

			</td>

			<td>

				<%=rs.getString("PASSWORD")%>

			</td>

			<td>

				<%=rs.getDate("DOB")%>

			</td>

			<td>

				<%=rs.getString("PHONE")%>

			</td>

			<td>

<%
String photo=rs.getString("PHOTO");

if(photo!=null && !photo.equals("")){
%>

<img
src="<%=request.getContextPath()%>/images/<%=photo%>"
class="customer-photo">

<%
}else{
%>



<%
}
%>

			</td>

			<td>

				<button
				type="button"
				class="delete-btn"
				onclick="deleteCustomer('<%=rs.getString("CUSTOMER_ID")%>')">

					Delete

				</button>

			</td>

		</tr>

<%
}
%>

	</table>

</div>

<div id="deleteModal"
	class="modal">

	<div class="modal-content">

		<h3>Delete Customer</h3>

		<p>

			Are you sure you want to delete this customer?

		</p>

		<div class="button-group">

			<button
			type="button"
			class="yes-btn"
			onclick="confirmDelete()">

				Yes

			</button>

			<button
			type="button"
			class="no-btn"
			onclick="closeDeleteModal()">

				No

			</button>

		</div>

	</div>

</div>

<%
}catch(Exception e){

	out.println(e);

}finally{

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

}
%>

</body>
</html>