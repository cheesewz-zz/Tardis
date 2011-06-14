<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_calendar/system/cfpagelets"> 
</cfsilent>

<layout:admin_page>
	<blockquote>
	<br />
	<p class="bold">Error(s) handling your request:</p>
	
	<!--- Use the error output pagelet --->
	<layout:error dsObj="application.dsObj">
	
	<br />
	<a href="index.cfm?action=view.login">Login</a>
	<br />
</layout:admin_page>