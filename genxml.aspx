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
//    if (null == Session["studentID"])
//        Response.Redirect("login.aspx");
        
    //get the semester from Web.Config
    string strSemester = System.Configuration.ConfigurationManager.AppSettings["semester"];

    //get the database connection string from Web.Config
    string sqlConnectString = System.Configuration.ConfigurationManager.AppSettings["dbUIUC"];
    //create the SqlConnection object
    SqlConnection nConnEPG = new SqlConnection(sqlConnectString);
    //open the database
    nConnEPG.Open();

    //execute stored procedure dbo.usp_getLoginAccount
    //create the SqlCommand object
    SqlCommand cmd = new SqlCommand("dbo.usp_getClasses", nConnEPG);
    //CommandType is StoredProcedure
    cmd.CommandType = CommandType.StoredProcedure;
    //Specify the StoredProcedure parameters
    //NOTE: The order of the parameters must be exactly the same as that of the stored procedure dbo.usp_getLoginAccount
    cmd.Parameters.Add(new SqlParameter("@semester", strSemester));
    SqlDataAdapter adapterZapper = new SqlDataAdapter(cmd);
    DataSet ds = new DataSet("classes");
    adapterZapper.Fill(ds, "class");
    
    // Send the XML data to the web browser for download.
    Response.Clear();
    Response.ContentType = "text/xml";
    Response.Write(ds.GetXml());

    try
    {
        ds.WriteXml("d:\\classes.xml");
    }
    catch (Exception ex)
    {
        Response.Write(ex.Message.ToString());
    }
 
    Response.End();
 
%>
