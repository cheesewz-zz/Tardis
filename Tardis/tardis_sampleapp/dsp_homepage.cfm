<!--- Sample view template --->
<!--- Import the pagelet taglibs --->
<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_sampleapp/system/cfpagelets"> 
	<cfset requesttoken = URLEncodedFormat(application.secObj.issueRequestToken())>
</cfsilent>

<layout:page>
<!--- <meta http-equiv="refresh" content="1"> --->
<!--- These are what your urls should look like, 
map actions to templates in the controller-config.xml viewManager section --->
<a href="?action=view.adduser&requesttoken=<cfoutput>#requesttoken#</cfoutput>">Add User View</a>
<br><br>
<a href="?action=view.viewusers&requesttoken=<cfoutput>#requesttoken#</cfoutput>">View Users User View</a>
</layout:page>