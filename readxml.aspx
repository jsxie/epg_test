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
 
    DataSet ds = new DataSet("classes");
    
    ds.ReadXml("d:\\classes.xml");
    
    // Send the XML data to the web browser for download.
    Response.Clear();
    Response.ContentType = "text/xml";
    Response.Write(ds.GetXml());
    Response.End();
 
%>
