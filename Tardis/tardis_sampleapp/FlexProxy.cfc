<!--- This is an example proxy component for Flex. 
If you change the scope storage or names of instantiated framework pieces 
you'll need to modify doCommand --->
<cfcomponent displayname="FlexProxy" hint="FlexProxy to Tardis components">
	<cffunction name="doCommand" access="remote" returntype="string">
		<cfargument name="componentmethod" type="any" required="yes">
		<cfargument name="remotemethod" type="any" required="yes">
		
		<cftry>
			<cfif session.secObj.userHasAccess(arguments.remotemethod,arguments.componentmethod)>
				<!--- Validate input from the form scope to make sure variables comply with rules --->
				<cfif NOT(session.valObj.validateInputData(form))>
					<cfset session.dsObj.setErrorData("Error. Validation Failed.")>
					<cfset session.dsObj.setServiceMessage("Error. Validation Failed.")>
				<!--- If it passes validation do the gesture --->
				<cfelse>
					<cfset session.dsObj.setMethodData(arguments)>
					<cfset session.fcObj.doGesture(arguments.remotemethod)>
				</cfif>				
			<cfelse>
				<cfset session.dsObj.setErrorData("Error. Unauthorized Method.")>
				<cfset session.dsObj.setServiceMessage("Error. Unauthorized Method.")>
			</cfif>	
			
			<cfcatch type="any">					
				<cfif LCase(cfcatch.message) CONTAINS "is undefined">
					<cfset session.dsObj.setErrorData("Error. Undefined Component Method.")>
					<cfset session.dsObj.setServiceMessage("Error. Undefined Component Method.")>
				</cfif>
			</cfcatch>
		</cftry>
		
		<cfreturn session.dsObj.getServiceMessage()>
	</cffunction>
	<!--- This is just an example of returning error data. You can modify this to return errors however you like.--->
	<cffunction name="getErrorData" access="remote" returntype="string">
		<cfset var retValue = "">
		<cfset var errors = session.dsObj.getErrorData()>
		
		<cfloop index="i" from="1" to="#ArrayLen(errors)#">
			<cfset retValue = retValue & errors[i].ERRORDETAIL & " ">
		</cfloop> 
		
		<cfreturn retValue />	
	</cffunction>
</cfcomponent>