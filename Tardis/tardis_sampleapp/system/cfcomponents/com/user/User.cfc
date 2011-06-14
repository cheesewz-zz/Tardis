<cfcomponent>
	<cfproperty name="id" type="string" default="">
	<cfproperty name="firstname" type="string" default="">
	<cfproperty name="lastname" type="string" default="">
	
	<cfset this.id = "">
	<cfset this.firstname = "">
	<cfset this.lastname = "">
	
	<cffunction name="populate" output="false" access="public" returntype="User">
		<cfargument name="id" type="string" required="true">
		<cfargument name="firstname" type="string" required="true">
		<cfargument name="lastname" type="string" required="true">
		
		<cfscript>
		setID(arguments.id);
		setFirstName(arguments.firstname);
		setLastName(arguments.lastname);
		</cfscript>

		<cfreturn this />
	</cffunction>
	
	<cffunction name="getID" output="false" access="public" returntype="string">
		<cfreturn this.id>
	</cffunction>
	<cffunction name="setID" output="false" access="public" returntype="void">
		<cfargument name="val" required="false" type="string">
		<cfset this.id = arguments.val>
	</cffunction>
	
	<cffunction name="getFirstName" output="false" access="public" returntype="string">
		<cfreturn this.firstname>
	</cffunction>
	<cffunction name="setFirstName" output="false" access="public" returntype="void">
		<cfargument name="val" required="false" type="string">
		<cfset this.firstname = arguments.val>
	</cffunction>
	
	<cffunction name="getLastName" output="false" access="public" returntype="string">
		<cfreturn this.lastname>
	</cffunction>
	<cffunction name="setLastName" output="false" access="public" returntype="void">
		<cfargument name="val" required="false" type="string">
		<cfset this.lastname = arguments.val>
	</cffunction>	
</cfcomponent>