<%@page import="common.DB_Connection"%>
<%@page import="java.sql.Connection"%>
<%@page import="java.sql.ResultSet"%>
<%@page import="java.sql.Statement"%>

<!DOCTYPE html>
<html>
<title>LuXe</title>
<meta charset="UTF-8">
<meta name="viewport" content="width=device-width, initial-scale=1">
<link rel="icon" type="image/png" href="../images/logo.png">
<link rel="stylesheet" href="https://www.w3schools.com/w3css/4/w3.css">
<link rel="stylesheet" href="https://fonts.googleapis.com/css?family=Raleway">
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/4.7.0/css/font-awesome.min.css">
<style>
body,h1,h2,h3,h4,h5,h6 {font-family: "Raleway", Arial, Helvetica, sans-serif}

.btn {
  border: 2px solid black;
  background-color: white;
  color: black;
  padding: 8px 16px;
  font-size: 15px;
  cursor: pointer;
  transition: 0.25s;
  border-radius: 20px;
}

.success {
  border-color: #4CAF50;
  color: green;
}

.success:hover {
  background-color: #4CAF50;
  color: white;
}

.danger {
  border-color: #f44336;
  color: red;
}

.danger:hover {
  background: #f44336;
  color: white;
}

.ConfirmedLbl{
  background-color: MediumSeaGreen;
  color: white;
  padding: 8px 16px;
  font-size: 15px;
  text-align: center;
}
.notfound{
		top: 50%;
        left: 50%;
        position: absolute;
        transform: translate(-50%, -50%);
        box-sizing: border-box;
        padding: 70px 30px;
}
.Alink{

		text-decoration: none;
		border: none;
        outline: none;
        height: 40px;
        background: DodgerBlue;
        color: #fff;
        font-size: 18px;
        border-radius: 20px;
        transition: 0.25s;
        padding: 8px 16px;
}
.Alink:hover{
  		cursor: pointer;
        background: #ffc107;
        color: #000;
}
</style>
<body class="w3-light-grey">

<!-- Navigation Bar -->
<div class="w3-bar w3-white w3-large">
  <a href="home.jsp" class="w3-bar-item w3-button  w3-mobile"><img src="../images/logo.png" style="width: 25px;height: 25px;"></a>
  <a href="myrequests.jsp" class="w3-bar-item w3-button w3-blue w3-mobile">My Requests</a>
  <a href="rooms.jsp" class="w3-bar-item w3-button w3-mobile">Rooms</a>
  <a href="about.jsp" class="w3-bar-item w3-button w3-mobile">About</a>
  <a href="contact.jsp" class="w3-bar-item w3-button w3-mobile">Contact</a>
  <a href="../logout.jsp" id="user_name_div" title="logout" class="w3-bar-item w3-button w3-right w3-light-grey w3-mobile"><%= session.getAttribute( "LogedInUserName" ) %></a>
  <script type="text/javascript">
    var pp = document.getElementById('user_name_div').innerText;
    if(pp == "null"){
      window.location.href = "../login.jsp";
    }
  </script>
</div>

<!-- page content -->
<div style="width: 100%; min-height: 750px;">
		<div class="w3-container w3-margin-top" id="rooms">
			<h3>My Requests</h3>
			<div class="w3-row-padding w3-padding-16">
				<%
					try {
						Statement statement = null;
						ResultSet resultSet = null;
						String Countrow="";
						String CurrentUser = session.getAttribute("LogedInUserName").toString();
						
						DB_Connection obj_DB_Connection = new DB_Connection();
						Connection connection = obj_DB_Connection.get_connection();
						statement = connection.createStatement();
						String sql = "SELECT COUNT(id) FROM rooms Where RequestMadeBy = '" + CurrentUser + "'";
						resultSet = statement.executeQuery(sql);
						while (resultSet.next()) {
							Countrow = resultSet.getString(1);
							if(Countrow.equals("0")){
								%>

								<div class="notfound">
								<center><img alt="ntfound" src="../images/ntfound.png">
								<h4>No Requests found</h4>
								<a href="home.jsp" class="Alink">Make a Request</a></</center>
								</div>

								<%
							}
						}
					} catch (Exception e) {
						e.printStackTrace();
					}
				%>


				<%
					try {
						String CurrentUser = session.getAttribute("LogedInUserName").toString();
						Statement statement = null;
						ResultSet resultSet = null;

						DB_Connection obj_DB_Connection = new DB_Connection();
						Connection connection = obj_DB_Connection.get_connection();
						statement = connection.createStatement();
						String sql = "SELECT * FROM rooms Where RequestMadeBy = '" + CurrentUser + "' ORDER BY dateNtime ASC";
						
						resultSet = statement.executeQuery(sql);
						while (resultSet.next()) {
				%>

				<div class="w3-third w3-margin-bottom">
					<div class="w3-container w3-white">
						<table>
							<tr>
								<td><h3>Requested At :</h3></td>
								<td><label
									style="font-family: monospace; color: gray; border: 2px solid gray; padding: 8px;">
										<%=resultSet.getString("dateNtime")%></label></td>
							</tr>
						</table>

						<ul>
							<li>Adults : <b><%=resultSet.getString("Adults")%></b></li>
							<li>Kids : <b><%=resultSet.getString("Kids")%></b></li>
							<li>CheckIn Date : <b><%=resultSet.getString("CheckIn")%></b></li>
							<li>CheckOut Date : <b><%=resultSet.getString("CheckOut")%></b></li>
							<%
								if (resultSet.getString("Status").equals("1")) {
							%>
							<li>Room No : <b
								style="background-color: yellow; padding: 2px 8px 2px 8px;"><%=resultSet.getString("RoomNo")%></b></li>
						</ul>
						<p class="ConfirmedLbl">Confirmed</p>
						<%
							} else {
						%>
						</ul>

						<form action="../DeletRequestByUser" method="post">
							<input style="display: none;" type="text" name="req_id"
								value='<%=resultSet.getString("id")%>'>
							<button type="submit" class="btn danger"
								style="margin-left: 20px; margin-bottom: 20px;">Delete</button>
						</form>
						<%
							}
						%>


					</div>
				</div>

				<%
					}
					%>

					<%
					} catch (Exception e) {
						e.printStackTrace();
					}
				%>

			</div>

		</div>
	</div>

<!-- Footer -->
<footer class="w3-padding-16 w3-black w3-center w3-margin-top">
  <h5>Find Us On</h5>
  <div class="w3-xlarge w3-padding-16">
    <i class="fa fa-facebook-official w3-hover-opacity"></i>
    <i class="fa fa-instagram w3-hover-opacity"></i>
    <i class="fa fa-snapchat w3-hover-opacity"></i>
    <i class="fa fa-pinterest-p w3-hover-opacity"></i>
    <i class="fa fa-twitter w3-hover-opacity"></i>
    <i class="fa fa-linkedin w3-hover-opacity"></i>
  </div>
</footer>


</body>
</html>
