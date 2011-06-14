<!--- Sample pagelet implementation --->
<cfswitch expression="#thisTag.executionMode#">
	<cfcase value= "start">	
<!--- Set page to not cache content --->	
<cfheader name="Pragma" value="no-cache">
<cfheader name="Expires" value="0">
<cfheader name="cache-control" value="no-cache, no-store, must-revalidate, max-age=0">
<cfhtmlhead text="<META HTTP-EQUIV=""expires"" CONTENT=""mon, 06 jan 1990 00:00:01 gmt"">">	

<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<title>Tardis Sample App</title>
	<link href="/tardis_sampleapp/system/css/styles.css" rel=stylesheet type="text/css">
	<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
</head>
<body>

	</cfcase>
	<cfcase value="end">		

</body>
</html>
	</cfcase>
</cfswitch>