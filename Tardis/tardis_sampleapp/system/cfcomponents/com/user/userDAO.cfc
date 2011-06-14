<cfcomponent>	
	<cffunction name="create" access="package" output="false" returntype="void">		
		<cfargument name="userobj" type="User" required="true">
	
		<cftry>
			<cfquery name="qCreateUser" datasource="#application.globals.dsn#">
			INSERT INTO users (id,firstname,lastname) 
			VALUES (
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userobj.getID()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userobj.getFirstName()#">,
					<cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userobj.getLastName()#">					
					)
			</cfquery>				
			
			<cfcatch type="any">
				<!--- Rethrow errors because you shouldn't handle it here. --->
				<cfrethrow>
			</cfcatch>
		</cftry>
		
		<cfreturn />	
	</cffunction>
	
	<cffunction name="retrieveUser" access="public" returntype="User" output="false">
		<cfargument name="id" type="string" required="true">		
		
		<cftry>		
			<cfquery name="qUser" datasource="#application.globals.dsn#" maxrows="1">
			SELECT 	id, firstname, lastname 
			FROM 	users
			WHERE 	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.id#"> 
			</cfquery>			
			
			<cfset obj = CreateObject("component", "User")>
			<cfset userObj = obj.populate(qUser.id,qUser.firstname,qUser.lastname)>			
			
			<cfcatch type="any">
				<!--- Rethrow Errors --->
				<cfrethrow>			
			</cfcatch>
		</cftry>
		
		<cfreturn userObj />
	</cffunction>
	
	<cffunction name="retrieveUsers" access="public" returntype="User[]" output="false">
			
		<cftry>		
			<cfquery name="qUsers" datasource="#application.globals.dsn#">
			SELECT 	id, firstname, lastname 
			FROM 	users 
			</cfquery>	
			
			<cfset aUsers = ArrayNew(1)>		
			
			<cfloop query="qUsers">
				<cfset obj = CreateObject("component", "User")>
				<cfset ArrayAppend(aUsers,obj.populate(qUsers.id,qUsers.firstname,qUsers.lastname))>	
			</cfloop>						
			
			<cfcatch type="any">
				<!--- Rethrow Errors --->
				<cfrethrow>			
			</cfcatch>
		</cftry>
		
		<cfreturn aUsers />
	</cffunction>
	
	<cffunction name="update" access="package" output="false" returntype="void">		
		<cfargument name="userobj" type="User" required="true">
	
		<cftry>
			<cfquery name="qUpdateUser" datasource="#application.globals.dsn#">
			UPDATE 	users 
			SET 	firstname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userobj.getFirstName()#">,
					lastname = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userobj.getLastName()#"> 
			WHERE	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userobj.getID()#"> 
			</cfquery>				
			
			<cfcatch type="any">
				<!--- Rethrow errors because you shouldn't handle it here. --->
				<cfrethrow>
			</cfcatch>
		</cftry>
		
		<cfreturn />	
	</cffunction>
	
	<cffunction name="delete" access="package" output="false" returntype="void">		
		<cfargument name="userobj" type="User" required="true">
	
		<cftry>
			<cfquery name="qDeleteUser" datasource="#application.globals.dsn#">
			DELETE FROM users 
			WHERE	id = <cfqueryparam cfsqltype="cf_sql_varchar" value="#arguments.userobj.getID()#"> 
			</cfquery>				
			
			<cfcatch type="any">
				<!--- Rethrow errors because you shouldn't handle it here. --->
				<cfrethrow>
			</cfcatch>
		</cftry>
		
		<cfreturn />	
	</cffunction>
</cfcomponent>