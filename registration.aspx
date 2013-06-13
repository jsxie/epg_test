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
    void RegisterClass(string strClassID, string strStudentID)
    {        
        //get the database connection string from Web.Config
        string sqlConnectString = System.Configuration.ConfigurationManager.AppSettings["dbUIUC"];
        //create the SqlConnection object
        SqlConnection nConnEPG = new SqlConnection(sqlConnectString);
        //open the database
        nConnEPG.Open();
        
        //execute stored procedure dbo.usp_getLoginAccount
        //create the SqlCommand object
        SqlCommand cmd = new SqlCommand("dbo.usp_registerClass", nConnEPG);
        //CommandType is StoredProcedure
        cmd.CommandType = CommandType.StoredProcedure;
        //Specify the StoredProcedure parameters
        //NOTE: The order of the parameters must be exactly the same as that of the stored procedure dbo.usp_getLoginAccount
        cmd.Parameters.Add(new SqlParameter("@classID", strClassID));
        cmd.Parameters.Add(new SqlParameter("@studentID", strStudentID));
        //execute the stored procedure
        //NOTE: if the stroed procedure returns value then call cmd.ExecuteReader()
        //      if the stroed procedure does not return value then call cmd.ExecuteNonQuery()
        cmd.ExecuteNonQuery();
    }

    void UnregisterClass(string strClassID, string strStudentID)
    {
        //get the database connection string from Web.Config
        string sqlConnectString = System.Configuration.ConfigurationManager.AppSettings["dbUIUC"];
        //create the SqlConnection object
        SqlConnection nConnEPG = new SqlConnection(sqlConnectString);
        //open the database
        nConnEPG.Open();

        //execute stored procedure dbo.usp_getLoginAccount
        //create the SqlCommand object
        SqlCommand cmd = new SqlCommand("dbo.usp_unregisterClass", nConnEPG);
        //CommandType is StoredProcedure
        cmd.CommandType = CommandType.StoredProcedure;
        //Specify the StoredProcedure parameters
        //NOTE: The order of the parameters must be exactly the same as that of the stored procedure dbo.usp_getLoginAccount
        cmd.Parameters.Add(new SqlParameter("@classID", strClassID));
        cmd.Parameters.Add(new SqlParameter("@studentID", strStudentID));
        //execute the stored procedure
        //NOTE: if the stroed procedure returns value then call cmd.ExecuteReader()
        //      if the stroed procedure does not return value then call cmd.ExecuteNonQuery()
        cmd.ExecuteNonQuery();
    }
</script>

<%
    //if Session["studentID"] is null then user's session has expired. User is required to sign-in again
    //NOTE: this checking is very important. Without it any user can by pass your login page and go directly to this page!
    if (null == Session["studentID"])
        Response.Redirect("login.aspx");
    
    //get the semester from Web.Config
    string strSemester = System.Configuration.ConfigurationManager.AppSettings["semester"]; 
    
    string strAct = Request.Form["btnDone"];
    //check if the button has been clicked by checking strAct
    //NOTE: if strAct is null or empty then the button has not been clicked
    if (!string.IsNullOrEmpty(strAct) &&    //strAct is not empty
        0 == strAct.CompareTo("Done"))     //strAct == "Done"
    {//user has clicked the button "Done"
        Response.Redirect("home.aspx");
    }

    strAct = Request.Form["btnUnregister"];
    //check if the button has been clicked by checking strAct
    //NOTE: if strAct is null or empty then the button has not been clicked
    if (!string.IsNullOrEmpty(strAct) &&    //strAct is not empty
        0 == strAct.CompareTo(">>"))     //strAct == ">>"
    {//user has clicked the button ">>"
        //Unregister the class
        string strClassID = Request.Form["cboClassRegistered"];
        if (!string.IsNullOrEmpty(strClassID))
        {//execute stored procedure dbo.usp_UnregisterClass
            UnregisterClass(strClassID, Session["studentID"].ToString());
        }
    }

    strAct = Request.Form["btnRegister"];
    //check if the button has been clicked by checking strAct
    //NOTE: if strAct is null or empty then the button has not been clicked
    if (!string.IsNullOrEmpty(strAct) &&    //strAct is not empty
        0 == strAct.CompareTo("<<"))     //strAct == "<<"
    {//user has clicked the button "<<"
        //register the class
        string strClassID = Request.Form["cboClassAvailable"];
        if (!string.IsNullOrEmpty(strClassID))
        {//execute stored procedure dbo.usp_RegisterClass
            RegisterClass(strClassID, Session["studentID"].ToString());
        }
    }
%>

<html>

<head>
<title>Registration</title>
</head>
<body>

<form name="RegistrationForm" method="post" action="registration.aspx">
	<table width="100%">
		<tr><td width="45%" align="right" valign="bottom" >
			Registered classes:</td>
			<td width="10%" align="center" valign="bottom" >
			</td>
			<td width="45%" align="left" valign="bottom" >
			Available classes:</td>
		</tr>
		<tr><td width="45%" align="right" valign="top" >
               <select name="cboClassRegistered" size="5" >
<%
    //get the database connection string from Web.Config
    string sqlConnectString = System.Configuration.ConfigurationManager.AppSettings["dbUIUC"];
    //create the SqlConnection object
    SqlConnection nConnEPG = new SqlConnection(sqlConnectString);
    //open the database
    nConnEPG.Open();

    //execute stored procedure dbo.usp_getRegisteredClass
    //create the SqlCommand object
    using (SqlCommand cmd = new SqlCommand("dbo.usp_getRegisteredClass", nConnEPG))
    {//release comradCMD at end of the using statement
        //CommandType is StoredProcedure
        cmd.CommandType = CommandType.StoredProcedure;
        //Specify the StoredProcedure parameters
        //NOTE: The order of the parameters must be exactly the same as that of the stored procedure dbo.usp_getRegisteredClass
        cmd.Parameters.Add(new SqlParameter("@studentID", Session["studentID"].ToString()));
        cmd.Parameters.Add(new SqlParameter("@semester", strSemester));
        //execute the stored procedure
        //NOTE: if the stroed procedure returns value then call cmd.ExecuteReader()
        //      if the stroed procedure does not return value then call cmd.ExecuteNonQuery()
        SqlDataReader classReader = cmd.ExecuteReader();

        //read the record        
        bool bFirst = true;
        while (classReader.Read())
        {//reading the record is successful, now retrieve the fields that will be returned
            string strClass = classReader["course_name"] + "(" + classReader["Professor"] + ", " + classReader["start_time"] + " to " + classReader["end_time"] + ")";
            string strClassID = classReader["class_id"].ToString();
            if (bFirst)
            {
                bFirst = false;
%>
                <option selected value="<%= strClassID%>" ><%= strClass%></option>
<%          }
            else
            {
%>
                <option value="<%= strClassID%>" ><%= strClass%></option>
<%          }
        }//while (classReader.Read())
        classReader.Close();
    }//using (SqlCommand
%>
                </select>
			</td>
			<td width="10%" align="center" valign="middle" >
            <input type="submit" name="btnUnregister" value=">>"/><br/>
            <input type="submit" name="btnRegister" value="<<"/>
			</td>
			<td width="45%" align="left" valign="top" >
               <select name="cboClassAvailable" size="5" >
<%
    //execute stored procedure dbo.usp_getAvailableClass
    //create the SqlCommand object
    using (SqlCommand cmd = new SqlCommand("dbo.usp_getAvailableClass", nConnEPG))
    {//release comradCMD at end of the using statement
        //CommandType is StoredProcedure
        cmd.CommandType = CommandType.StoredProcedure;
        //Specify the StoredProcedure parameters
        //NOTE: The order of the parameters must be exactly the same as that of the stored procedure dbo.usp_getAvailableClass
        cmd.Parameters.Add(new SqlParameter("@studentID", Session["studentID"].ToString()));
        cmd.Parameters.Add(new SqlParameter("@semester", strSemester));
        //execute the stored procedure
        //NOTE: if the stroed procedure returns value then call cmd.ExecuteReader()
        //      if the stroed procedure does not return value then call cmd.ExecuteNonQuery()
        SqlDataReader classReader = cmd.ExecuteReader();

        //read the record        
        bool bFirst = true;
        while (classReader.Read())
        {//reading the record is successful, now retrieve the fields that will be returned
            string strClass = classReader["course_name"] + "(" + classReader["Professor"] + ", " + classReader["start_time"] + " to " + classReader["end_time"] + ")";
            string strClassID = classReader["class_id"].ToString();
            if (bFirst)
            {
                bFirst = false;
%>
                <option selected value="<%= strClassID%>" ><%= strClass%></option>
<%          }
            else
            {
%>
                <option value="<%= strClassID%>" ><%= strClass%></option>
<%          }
        }//while (classReader.Read())
        classReader.Close();
    }//using (SqlCommand)
%>
                </select>
			</td>
		</tr>
		<tr><td width="45%" align="right" valign="bottom" >
			</td>
			<td width="10%" align="center" valign="bottom" >
            <input type="submit" name="btnDone" value="Done"/>
			</td>
			<td width="45%" align="left" valign="bottom" >
			</td>
		</tr>
	</table>
</form>

</body>
</html>
