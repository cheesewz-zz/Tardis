<!--- Sample pagelet implementation onload="window.print()" --->
<cfswitch expression="#thisTag.executionMode#">
<cfcase value= "start">		
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>Tardis Calendar</title>
<link rel="stylesheet" type="text/css" href="/tardis_calendar/system/css/ss-site.css" />
<link rel="stylesheet" type="text/css" href="/tardis_calendar/system/css/ss-menutop.css" />
</head>

<body >	
<table width="100%" border="0" cellspacing="0" cellpadding="0">
<tr>
	<td valign="top" id="general">
</cfcase>
<cfcase value="end">	
	</td>
</tr>
</table>
</body>
</html> 
</cfcase>
</cfswitch>