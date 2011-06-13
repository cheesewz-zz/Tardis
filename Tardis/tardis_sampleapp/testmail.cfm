<cfdump var="#session#"><cfabort>
<cfsavecontent variable="theVar">
	<cfdump var="#variables#">
</cfsavecontent>

<cfmail subject="dump" from="crochunter@animalplanet.com" to="shawn.gorrell@atl.frb.org">
<cfmailpart type="html">
<!DOCTYPE html PUBLIC "-//W3C//DTD XHTML 1.0 Transitional//EN" "http://www.w3.org/TR/xhtml1/DTD/xhtml1-transitional.dtd">
<html xmlns="http://www.w3.org/1999/xhtml">
<head>
<meta http-equiv="Content-Type" content="text/html; charset=iso-8859-1" />
<title>DUMP</title>
</head>

<body>
#theVar#
</body>
</html>

</cfmailpart>
</cfmail>