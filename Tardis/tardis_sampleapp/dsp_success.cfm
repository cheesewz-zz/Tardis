<!--- Sample view template --->
<!--- Import the pagelet taglibs --->
 
<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_sampleapp/system/cfpagelets"> 
	<cfset requesttoken = URLEncodedFormat(application.secObj.issueRequestToken())>
</cfsilent>
 
<layout:page>
	<a href="?action=view.homepage&requesttoken=<cfoutput>#requesttoken#</cfoutput>">Back to homepage</a>
	<br /><br />
	<!--- Dump some data so that you can see what happened --->
	<cfdump var="#application.dsObj.getCallBackData()#" label="CallBack Data">
	<cfdump var="#application.dsObj.getMethodData()#" label="Method Data">
	
	<br>
	Errors:
	<br>
	<!--- Use the error output pagelet --->
	<layout:error dsObj="application.dsObj" />
</layout:page>