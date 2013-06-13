<%@ Page Language="C#" %>
<%@ Import Namespace="System" %>
<%@ Import Namespace="System.Collections" %>
<%@ Import Namespace="System.Configuration" %>
<%@ Import Namespace="System.Data" %>
<%@ Import Namespace="System.Data.SqlClient" %>
<%@ Import Namespace="System.Xml" %>
<%@ Import Namespace="System.Linq" %>
<%@ Import Namespace="System.Web" %>
<%@ Import Namespace="System.Web.Security" %>
<%@ Import Namespace="System.Web.UI" %>
<%@ Import Namespace="System.Web.UI.HtmlControls" %>
<%@ Import Namespace="System.Web.UI.WebControls" %>
<%@ Import Namespace="System.Web.UI.WebControls.WebParts" %>
<%@ Import Namespace="System.Xml.Linq" %>

<%
    //if Session["studentID"] is null then user's session has expired. User is required to sign-in again
    //NOTE: this checking is very important. Without it any user can by pass your login page and go directly to this page!
    if (null == Session["studentID"])
        Response.Redirect("login.aspx");
        
    //get the semester from Web.Config
    string strSemester = System.Configuration.ConfigurationManager.AppSettings["semester"];
%>

<html>

<head>
<title>Home</title>
</head>
<body>

<p>Welcome <%=Session["studentName"]%>!</p>
<p>Here're the classes you have registered for <%= strSemester%>:</p>
<table width="100%">
	<tr>
        <td width="25%" align="left" valign="bottom" ><b>Course</b></td>
        <td width="25%" align="left" valign="bottom" ><b>Instructor</b></td>
        <td width="25%" align="left" valign="bottom" ><b>Start Time</b></td>
        <td width="25%" align="left" valign="bottom" ><b>End Time</b></td>
    </tr>
<%
    //get the database connection string from Web.Config
    string sqlConnectString = System.Configuration.ConfigurationManager.AppSettings["dbUIUC"];
    //create the SqlConnection object
    SqlConnection nConnEPG = new SqlConnection(sqlConnectString);
    //open the database
    nConnEPG.Open();

    //execute stored procedure dbo.usp_getLoginAccount
    //create the SqlCommand object
    SqlCommand cmd = new SqlCommand("dbo.usp_getRegisteredClass", nConnEPG);
    //CommandType is StoredProcedure
    cmd.CommandType = CommandType.StoredProcedure;
    //Specify the StoredProcedure parameters
    //NOTE: The order of the parameters must be exactly the same as that of the stored procedure dbo.usp_getLoginAccount
    cmd.Parameters.Add(new SqlParameter("@studentID", Session["studentID"].ToString()));
    cmd.Parameters.Add(new SqlParameter("@semester", strSemester));
    //execute the stored procedure
    //NOTE: if the stroed procedure returns value then call cmd.ExecuteReader()
    //      if the stroed procedure does not return value then call cmd.ExecuteNonQuery()
    SqlDataReader classReader = cmd.ExecuteReader();
    
    //read the record        
    while (classReader.Read())
     {//reading the record is successful, now retrieve the fields that will be returned
%>
	<tr>
        <td width="25%" align="left" valign="bottom" ><%= classReader["course_name"]%></td>
        <td width="25%" align="left" valign="bottom" ><%= classReader["Professor"]%></td>
        <td width="25%" align="left" valign="bottom" ><%= classReader["start_time"]%></td>
        <td width="25%" align="left" valign="bottom" ><%= classReader["end_time"]%></td>
    </tr>
<%
     }//while (classReader.Read())
%>
</table>
<p><a href="registration.aspx">Click here to change it.</a></p>
</body>
</html>
