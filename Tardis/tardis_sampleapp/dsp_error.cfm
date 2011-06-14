<!--- Sample error template --->
<!--- Import the pagelet taglibs --->
<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_sampleapp/system/cfpagelets"> 
	<cfset requesttoken = URLEncodedFormat(application.secObj.issueRequestToken())>
	<!--- Dump a request snapshot to demonstrate the functionality--->
	<cfset application.logObj.dumpRequestSnapshot(application.requestsnapshotdirectory,"errorsnapshot")>
</cfsilent>

<layout:page>

<a href="?action=view.homepage&requesttoken=<cfoutput>#requesttoken#</cfoutput>">Back to homepage</a>
<br /><br />

<table border="1" cellspacing="0" cellpadding="10" align="center">	
<tr>
	<td class="normal">
	Error(s) handling your request:<br><br>
	
	<!--- Use the error output pagelet --->
	<layout:error dsObj="application.dsObj">
	
	</td>
</tr>	
</table>

<!--- Dump some data so that you can see what happened --->
<cfdump var="#application.dsObj.getCallBackData()#" label="CallBack Data">
<cfdump var="#application.dsObj.getMethodData()#" label="Method Data">
</layout:page>