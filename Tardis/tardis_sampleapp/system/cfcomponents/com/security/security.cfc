<cfcomponent extends="tardis.security.security">
	<cffunction name="authenticate" access="public" returntype="string">	
		<cfargument name="username" type="string" required="yes">
		<cfargument name="password" type="string" required="yes">
		<cfargument name="role" type="string" required="yes">
		
		<cfset var result = true>
		
		<!--- This is just a stub, your implementation would be different --->
		<cflogin idletimeout="20">
			<cfloginuser name="#arguments.username#" password="#arguments.password#" roles="#arguments.role#">
		</cflogin>		
		
		<!--- Use logger to record login event --->
		<cfset application.logObj.doLog("Information", "#arguments.username# logged in")>	
		
		<cfreturn result/>
	</cffunction>
</cfcomponent>