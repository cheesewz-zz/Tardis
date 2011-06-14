<cfcomponent extends="tardis.security.security">
	<cffunction name="isAdmin" access="public" returntype="boolean">
		<cfargument name="userid" type="string" required="yes">
		
		<cfset theresult = false>
		
		<cfif ListFindNocase(application.globals.adminlist,arguments.userid)>
			<cfset theresult = true>
		</cfif>
		
		<cfreturn theresult />
	</cffunction>
	<cffunction name="authenticateUser" access="public" returntype="numeric" output="false">
		<cfargument name="login" type="string" required="true">
		<cfargument name="password" type="string" required="true">
		
		<cfset var AuthenticateRet = 0>
		
		<cftry>
			<cfinvoke 
			 webservice="#application.globals.appsecwsdl#"
			 method="authenticate"
			 returnvariable="retValue">
				<cfinvokeargument name="userID" value="#arguments.login#"/>
				<cfinvokeargument name="password" value="#arguments.password#"/>
			</cfinvoke>
			
			<cfset AuthenticateRet = retValue.getIsAuth()>	
			
			<cfif AuthenticateRet IS 0>
				<cflog file="eventCal" application="No" text="Failed Login Attempt (AD login/password combo failed): #arguments.login#">
			</cfif>
			<cfcatch type="any">
				<cflog file="eventCal" application="No" text="Error Detail: #cfcatch.detail# Error Message: #cfcatch.message#">
				<cfset fObj = CreateObject("JAVA", "coldfusion.server.ServiceFactory")>
				<cfset rpcService = fObj.getXmlRpcService()>
				
				<cfscript>
				rpcService.refreshWebService(application.globals.appsecwsdl);
				</cfscript>
				
				<cfinvoke 
					 webservice="#application.globals.appsecwsdl#"
					 method="authenticate"
					 returnvariable="retValue">
						<cfinvokeargument name="userID" value="#arguments.login#"/>
						<cfinvokeargument name="password" value="#arguments.password#"/>
				</cfinvoke>
				
				<cfset AuthenticateRet = retValue.getIsAuth()>	
			</cfcatch>
		</cftry>

		<cfreturn AuthenticateRet>	
	</cffunction>	
</cfcomponent>