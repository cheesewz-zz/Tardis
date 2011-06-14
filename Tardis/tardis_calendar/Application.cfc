<cfcomponent>
	<cfset this.name = "tardis_calendar2">
	<cfset this.clientmanagement = "false">
	<cfset this.sessionmanagement = "false">
	<cfset this.applicationtimeout = "#createtimespan(0,8,0,0)#">
	
	<cfparam name="bRefresh" type="boolean" default="FALSE">
	
	<cffunction name="onError" output="true">
		<cfargument name="exception" required="true" type="any" />
		<cfargument name="eventname" required="true" type="string" />	
		<!--- This is just an example of what you can do with onError, 
		your code could/should be different --->
		<cfset var thiserrordetail = "">
		<cfset var thiserrormessage = "">
		<cfset var thiserrorstacktrace = "">
		<cfset var thiserrorlinenumber = "">
		<cfset var thiserrortemplate = "">
		<cfset var thiserrortype = "">
		<cfset var thiserrorserver = CGI.SERVERNAME>
		<cfset var thiserrorapplication = this.name>
		<cfset var thiserrorlogmessage = "">
		
		<cfif IsDefined("arguments.Exception.Message")>
			<cfset thiserrormessage = thiserrormessage & arguments.Exception.Message>
			<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Message: " & thiserrormessage & " ">
		</cfif>
		
		<cfif IsDefined("arguments.Exception.Detail")>
			<cfset thiserrordetail = thiserrordetail & arguments.Exception.Detail>
			<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Detail: " & thiserrordetail & " ">
		</cfif>
		
		<cfif IsDefined("arguments.Exception.StackTrace")>
			<cfset thiserrorstacktrace = thiserrorstacktrace & arguments.Exception.StackTrace>
			<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Stack Trace: " & thiserrorstacktrace & " ">
		</cfif>
		
		<cftry>
			<cfif IsDefined("arguments.Exception.TagContext")>
				<cfset thiserrorlinenumber = thiserrorlinenumber & arguments.Exception.TagContext[1].LINE>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Line Number: " & thiserrorlinenumber & " ">
				<cfset thiserrortemplate = thiserrortemplate & arguments.Exception.TagContext[1].TEMPLATE><br>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Template: " & thiserrortemplate & " ">
				<cfset thiserrortype = thiserrortype & arguments.Exception.TagContext[1].TYPE>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Type: " & thiserrortype & " ">
			</cfif>	
			
			<cfcatch><!--- Watch out for null pointer exceptions ---></cfcatch>
		</cftry>	
		
	   	<!--- Log error. You are logging all uncaught errors aren't you? --->
	    <cflog file="#this.name#" type="error" text="#thiserrorlogmessage#">

	   	<!--- Display an error message if there is a page context. --->
	   	<cfif NOT (arguments.EventName IS "onSessionEnd") OR (arguments.EventName IS "onApplicationEnd")>
		  	<cfoutput>
			 	<h2>An unexpected error occurred.</h2>
			 	<p>Please provide the following information to technical support:</p>
			 	<p>Error Message: #thiserrormessage#</p>
			 	<p>Error Details: #thiserrordetail#<br>
		  	</cfoutput>				
			
			<!--- If notification is enabled and number of messages sent is less than maximum notifications --->
			<cfif application.globals.errornotify AND application.errormessagecount LT application.globals.errornotifymaxmessages>	
			<cfmail from="#application.globals.errornotifyfrom#" to="#application.globals.errornotifyemails#" subject="#thiserrorapplication# Unhandled Exception - SERVER #cgi.SERVER_NAME#">
#thiserrorapplication# generated an unhandled exception at #Now()#.

Error Message: #thiserrormessage#

Error Detail: #thiserrordetail#

Error Template: #thiserrortemplate#

Error Line Number: #thiserrorlinenumber#

Error Type: #thiserrortype#

Error Stack Trace: #thiserrorstacktrace#					
			</cfmail>			
			
				<!--- Increment Notification Count --->
				<cfset application.errormessagecount = application.errormessagecount + 1>				
			</cfif>
			
			<!--- If notification is enabled and number of messages sent is equal/greater than maximum notifications, log that the notifications are shut off --->
			<cfif application.globals.errornotify AND application.errormessagecount GTE application.globals.errornotifymaxmessages>	
				<cflog file="#this.name#" type="error" text="Maximum error notifications met, no further messages will be sent.">
			</cfif>
		
 		</cfif>
		
	   	<!--- End Example --->
	</cffunction>	
		
	<cffunction name="onApplicationStart" output="false">
		<!--- Intialize app configuration --->
		<cfset application.applicationpath = ExpandPath('.')>
		<cfset application.configdirectory = application.applicationpath & "\system\config\">
		<cfset application.errormessagecount = 0>
	
		<!--- Intialize app configuration --->
		<cf_globals 
			scope="APPLICATION" 
			varname="globals" 
			filename="application-config.xml" 
			configDirectory="#application.configdirectory#" 
			bCopyToRequest="FALSE">		
			
		<cfobject type="component" name="application.calendarObj" component="tardis_calendar.system.cfcomponents.com.calendar.calendar">		
	</cffunction>
	
	<cffunction name="onRequestStart" output="true">
		<cfargument name="request" required="true"/>
		
		<cfoutput>herro</cfoutput>
		
		<cfif bRefresh>
			<!--- Re-intialize app configuration --->			
			<!--- Intialize app configuration --->
			<cfset application.applicationpath = ExpandPath('.')>
			<cfset application.configdirectory = application.applicationpath & "\system\config\">
			<cfset application.errormessagecount = 0>
		
			<!--- Intialize app configuration --->
			<cf_globals 
				scope="APPLICATION" 
				varname="globals" 
				filename="application-config.xml" 
				configDirectory="#application.configdirectory#" 
				bCopyToRequest="FALSE">		

			<!--- End Framework pieces --->
			<cfobject type="component" name="application.calendarObj" component="tardis_calendar.system.cfcomponents.com.calendar.calendar">	
		</cfif>	
	</cffunction>

	
</cfcomponent>