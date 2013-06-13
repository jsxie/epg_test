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

<script language="C#" runat="server">
    bool GetUserAccount(string strLoginID, string strPassword, out string studentID, out string studentName)
    {//if loginID and password are valid then return true, otherwise return false
        
        //initialize variables that will be returned
        studentID = "";
        studentName = "";

        //get the database connection string from Web.Config
        string sqlConnectString = System.Configuration.ConfigurationManager.AppSettings["dbUIUC"];
        //create the SqlConnection object
        SqlConnection nConnEPG = new SqlConnection(sqlConnectString);
        //open the database
        nConnEPG.Open();
        
        //execute stored procedure dbo.usp_getLoginAccount
        //create the SqlCommand object
        SqlCommand cmd = new SqlCommand("dbo.usp_getLoginAccount", nConnEPG);
        //CommandType is StoredProcedure
        cmd.CommandType = CommandType.StoredProcedure;
        //Specify the StoredProcedure parameters
        //NOTE: The order of the parameters must be exactly the same as that of the stored procedure dbo.usp_getLoginAccount
        cmd.Parameters.Add(new SqlParameter("@loginID", strLoginID));
        cmd.Parameters.Add(new SqlParameter("@loginPassword", strPassword));
        //execute the stored procedure
        //NOTE: if the stroed procedure returns value then call cmd.ExecuteReader()
        //      if the stroed procedure does not return value then call cmd.ExecuteNonQuery()
        SqlDataReader loginReader = cmd.ExecuteReader();
        
        //read the record        
        if (loginReader.Read())
        {//reading the record is successful, now retrieve the fields that will be returned
            studentID = loginReader["student_id"].ToString();
            studentName = loginReader["first_name"].ToString() + " " + loginReader["last_name"].ToString();

            //return true since LoginID and Password are valid
            return true;
        }

        //return false since we could not find login record in database that matches LoginID and Password 
        return false;
    }
</script>

<%
//initialize variables
string strMsg = "";
string strLoginID = "";
string strPassword = "";

//Get the value of the button (idenified by name "_action")
string strAct = Request.Form["_action"];
//check if the button has been clicked by checking strAct
//NOTE: if strAct is null or empty then the button has not been clicked
if (!string.IsNullOrEmpty(strAct) &&    //strAct is not empty
    0 == strAct.CompareTo("Login"))     //strAct == "Login"
{//user has clicked the button "Login"
    
    //get the LoginID from the field "txtLoginID"
    strLoginID = Request.Form["txtLoginID"];
    //get the Password from the field "txtPassword"
    strPassword = Request.Form["txtPassword"];

    //check if LoginID and Password are valid
    string studentID, studentName;
    if (GetUserAccount(strLoginID, strPassword, out studentID, out studentName))
    {//valid user
        //Use Session object to store studentID and studentName
        //we will need them in other pages to identify the id of the student who has just signed-in
        Session.Add("studentID", studentID);
        Session.Add("studentName", studentName);

        //valid user can now go to the home page
        Response.Redirect("home.aspx");
    }
    else
    {//invalid user, post error message
        strMsg = "Invalid login. Please check your UserName and Password and try again.";
    }
}
%>

<html>

<head>
<title>Login</title>
</head>
<body>

<form name="LoginForm" method="post" action="login.aspx">

<table width="100%">
	<tr><td width="50%" align="left" valign="bottom" >
		<table width="100%">
			<tr><td width="25%" align="right" valign="bottom" >
				UserName:</td>
				<td width="75%" align="left" valign="bottom" >
				<input type="text" name="txtLoginID" value="<%=strLoginID%>" size="10" maxlength="10"/>
				</td>
			</tr>
			<tr><td width="25%" align="right" valign="bottom" >
				Password:</td>
				<td width="75%" align="left" valign="bottom" >
				<input type="password" name="txtPassword" size="10" maxlength="10"/>
				</td>
			</tr>
			<tr><td width="25%" align="right" valign="bottom" ></td>
				<td width="75%" align="left" valign="bottom" >
				<input type="submit" name="_action" value="Login"/>
				</td>
			</tr>
		</table>
		</td>
	</tr>
</table>

	<% if (strMsg.Length>0) {%>
    <span style="COLOR:red"><%=strMsg%></span>
    <%}%>
</form>
</body>
</html>
