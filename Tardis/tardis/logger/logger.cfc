<cfcomponent displayname="logger" hint="Logger component" extends="tardis.base.base">	
	<cfset instance.errormessagecount = 0>

	<cffunction name="init" access="public" output="false" returntype="tardis.logger.logger" displayname="init" hint="Method to initialize and return component instance" description="Methods parses XML configuration file, sets instance variable values and returns component instance.">
		<cfargument name="configdirectory" required="yes" />
		<cfargument name="configfilename" required="yes" />			

		<cfset this.config(arguments.configdirectory,arguments.configfilename)>			
		<cfset instance.errormessagecount = 0>
		
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="doLog" access="public" output="false" returntype="void" displayname="doLog" hint="Handle logging request." description="Method to handle incoming logging request.">
		<cfargument name="loglevel" type="string" required="true" />
		<cfargument name="logmessage" type="any" required="true" />		
		
		<!--- Call writeLog() method --->
		<cfset this.writeLog(arguments.loglevel,arguments.logmessage)>
		
		<!--- If error message matches notification threshold, call notifyLog() method --->
		<cfif ListContainsNoCase(instance.config.params.notifylevel,arguments.loglevel)>
			<cfset notifyLog(arguments.loglevel,arguments.logmessage)>
		</cfif>
	
		<cfreturn />
	</cffunction>
	
	<cffunction name="writeLog" access="private" output="false" returntype="void" displayname="writeLog" hint="Write message to log file." description="Method to write message to log file.">
		<cfargument name="loglevel" type="string" required="true" />
		<cfargument name="logmessage" type="any" required="true" />				
		
		<cfset var thiserrordetail = "">
		<cfset var thiserrormessage = "">
		<cfset var thiserrorstacktrace = "">
		<cfset var thiserrorlinenumber = "">
		<cfset var thiserrortemplate = "">
		<cfset var thiserrortype = "">
		<cfset var thiserrorserver = CGI.SERVERNAME>
		<cfset var thiserrorapplication = application.applicationname>
		<cfset var thiserrorlogmessage = "">		
		
		<!--- If log message is a simple string, set logmessage, else deconstruct error structure --->
		<cfif IsSimpleValue(arguments.logmessage)>
			<cfset thiserrorlogmessage = arguments.logmessage>
		<cfelse>
			<cfif IsDefined("arguments.logmessage.Message")>
				<cfset thiserrormessage = thiserrormessage & arguments.logmessage.Message>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Message: " & thiserrormessage & " ">
			</cfif>
			
			<cfif IsDefined("arguments.logmessage.Detail")>
				<cfset thiserrordetail = thiserrordetail & arguments.logmessage.Detail>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Detail: " & thiserrordetail & " ">
			</cfif>
			
			<cfif IsDefined("arguments.logmessage.StackTrace")>
				<cfset thiserrorstacktrace = thiserrorstacktrace & arguments.logmessage.StackTrace>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Stack Trace: " & thiserrorstacktrace & " ">
			</cfif>
			
			<cftry>
				<cfif IsDefined("arguments.logmessage.TagContext")>
					<cfset thiserrorlinenumber = thiserrorlinenumber & arguments.logmessage.TagContext[1].LINE>
					<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Line Number: " & thiserrorlinenumber & " ">
					<cfset thiserrortemplate = thiserrortemplate & arguments.logmessage.TagContext[1].TEMPLATE><br>
					<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Template: " & thiserrortemplate & " ">
					<cfset thiserrortype = thiserrortype & arguments.logmessage.TagContext[1].TYPE>
					<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Type: " & thiserrortype & " ">
				</cfif>	
				<cfcatch><!--- Watch out for null pointer exceptions ---></cfcatch>
			</cftry>		
		</cfif>	
		
		<cflog file="#thiserrorapplication#" type="#arguments.loglevel#" text="#HTMLEditFormat(thiserrorlogmessage)#">
				
		<cfreturn />
	</cffunction>
	
	<cffunction name="notifyLog" access="private" output="false" returntype="void" displayname="notifyLog" hint="Notify users of error." description="Method to notify users of application error.">
		<cfargument name="loglevel" type="string" required="true" />
		<cfargument name="logmessage" type="any" required="true" />

		<cfset var thiserrordetail = "">
		<cfset var thiserrormessage = "">
		<cfset var thiserrorstacktrace = "">
		<cfset var thiserrorlinenumber = "">
		<cfset var thiserrortemplate = "">
		<cfset var thiserrortype = "">
		<cfset var thiserrorserver = CGI.SERVERNAME>
		<cfset var thiserrorapplication = application.applicationname>
		<cfset var thiserrorlogmessage = "">		
		
		<!--- If log message is a simple string, set logmessage, else deconstruct error structure --->
		<cfif IsSimpleValue(arguments.logmessage)>
			<cfset thiserrorlogmessage = arguments.logmessage>
		<cfelse>
			<cfif IsDefined("arguments.logmessage.Message")>
				<cfset thiserrormessage = thiserrormessage & arguments.logmessage.Message>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Message: " & thiserrormessage & " ">
			</cfif>
			
			<cfif IsDefined("arguments.logmessage.Detail")>
				<cfset thiserrordetail = thiserrordetail & arguments.logmessage.Detail>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Detail: " & thiserrordetail & " ">
			</cfif>
			
			<cfif IsDefined("arguments.logmessage.StackTrace")>
				<cfset thiserrorstacktrace = thiserrorstacktrace & arguments.logmessage.StackTrace>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Stack Trace: " & thiserrorstacktrace & " ">
			</cfif>
			
			<cfif IsDefined("arguments.logmessage.TagContext")>
				<cfset thiserrorlinenumber = thiserrorlinenumber & arguments.logmessage.TagContext[1].LINE>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Line Number: " & thiserrorlinenumber & " ">
				<cfset thiserrortemplate = thiserrortemplate & arguments.logmessage.TagContext[1].TEMPLATE><br>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Template: " & thiserrortemplate & " ">
				<cfset thiserrortype = thiserrortype & arguments.logmessage.TagContext[1].TYPE>
				<cfset thiserrorlogmessage = thiserrorlogmessage & "Error Type: " & thiserrortype & " ">
			</cfif>
		</cfif>
		
		<cfif instance.errormessagecount LT instance.config.params.notifymaxmessages>	
			<!--- If log message is a simple string, set logmessage, else deconstruct error structure then send notification email --->
			<cfif IsSimpleValue(arguments.logmessage)>
				<cfmail from="#instance.config.params.notifyfrom#" to="#instance.config.params.notifyemails#" subject="#thiserrorapplication# Unhandled Exception - SERVER #cgi.SERVER_NAME#">
#thiserrorapplication# generated an unhandled exception at #Now()#.
	
Error Message: #arguments.logmessage#
				</cfmail>		
			<cfelse>
				<cfmail from="#instance.config.params.notifyfrom#" to="#instance.config.params.notifyemails#" subject="#thiserrorapplication# Unhandled Exception - SERVER #cgi.SERVER_NAME#">
#thiserrorapplication# generated an unhandled exception at #Now()#.
	
Error Message: #thiserrormessage#
	
Error Detail: #thiserrordetail#
	
Error Template: #thiserrortemplate#
	
Error Line Number: #thiserrorlinenumber#
	
Error Type: #thiserrortype#
	
Error Stack Trace: #thiserrorstacktrace#					
				</cfmail>
			</cfif>
			
			<cfset instance.errormessagecount = instance.errormessagecount + 1>
		<cfelse>
			<cfset this.doLog("WARNING","Maximum Logger error notifications met, no further messages will be sent.")>
		</cfif>
							
		<cfreturn />
	</cffunction>

	<cffunction name="dumpRequestSnapshot" access="public" output="false" returntype="boolean" displayname="dumpRequestSnapshot" hint="Accepts filename and directory arguments and writes a file that contains form, cgi, and url data to it for debugging.">
		<cfargument name="snapshotdirectory" type="string" required="true" />
		<cfargument name="snapshotfile" type="any" required="true" />	
		
		<cfset var result = true>
		<cfset var postData = "">	
		<cfset var i = "">	
		
		<cftry>
			<!--- START: Write URL & Form Data to Log --->
			<cfset postData = "">
			<cfset postData = "*****STARTING REQUEST SNAPSHOT*****">
			<cflock name="write_lock" type="exclusive" timeout="30"> 
				<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
			</cflock>
			
			<cfset postData = Now()>
			<cflock name="write_lock" type="exclusive" timeout="30"> 
				<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
			</cflock>
			
			<cfif isDefined("url") AND NOT(isSimpleValue(url)) AND NOT (structIsEmpty(url))>
				<cfset postData = "-----URL DATA-----">
				<cflock name="write_lock" type="exclusive" timeout="30"> 
					<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
				</cflock>
				
				<cfloop item="i" collection="#url#">
					<cfset postData = i & ":" & " " & url[i]>
				    <cflock name="write_lock" type="exclusive" timeout="30"> 
					<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
					</cflock>
				</cfloop>
				
				<cfset postData = "-----END URL DATA-----">
				<cflock name="write_lock" type="exclusive" timeout="30"> 
					<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
				</cflock>
			</cfif>
			
			<cfif IsDefined("form") AND NOT(isSimpleValue(form)) AND NOT (structIsEmpty(form))>	
				<cfset postData = "-----FORM DATA-----">
				<cflock name="write_lock" type="exclusive" timeout="30"> 
					<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
				</cflock>
				
				<cfloop index="i" list="#form.FieldNames#">
					<cfset postData = i & ":" & " " & Form[i]>
				    <cflock name="write_lock" type="exclusive" timeout="30"> 
					<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
					</cflock>
				</cfloop>
				
				<cfset postData = "-----END URL DATA-----">
				<cflock name="write_lock" type="exclusive" timeout="30"> 
					<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
				</cflock>
			</cfif>
			
			<cfif IsDefined("cgi")>	
				<cfset postData = "-----CGI DATA-----">
				<cflock name="write_lock" type="exclusive" timeout="30"> 
					<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
				</cflock>
				
				<cfloop item="i" collection="#cgi#">
					<cfset postData = i & ":" & " " & cgi[i]>
				    <cflock name="write_lock" type="exclusive" timeout="30"> 
					<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
					</cflock>
				</cfloop>
				
				<cfset postData = "-----END CGI DATA-----">
				<cflock name="write_lock" type="exclusive" timeout="30"> 
					<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
				</cflock>
			</cfif>
			
			<cfset postData = "*****ENDING REQUEST SNAPSHOT*****">
			
			<cflock name="write_lock" type="exclusive" timeout="30"> 
				<cffile action="append" file="#arguments.snapshotdirectory#\#arguments.snapshotfile#.txt" mode="777" output="#postData#" addnewline="yes">
			</cflock>			
			
			<cfcatch type="any">
				<cfset result = false>
			</cfcatch>
		</cftry>
		
		<cfreturn result />
	</cffunction>
</cfcomponent>