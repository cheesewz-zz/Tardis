<!--- 

Development notes:

There are 3 variables which always need to be passed to the controller method and remoteMethod.
The value of method will always be "POST", as do is the helper method which will execute the remoteMethod.
 --->
 
<cfsilent>
	<!--- Import the coldfusion taglibs --->  
	<cfimport prefix="layout" taglib="/tardis_sampleapp/system/cfpagelets"> 
</cfsilent>

<layout:page>

<!--- Create an argument collection --->
<cfscript>
args = StructNew();
args.method = "POST";
args.remotemethod = "userManager";
args.componentmethod = "addUser";
args.firstname = "Bubb";
args.lastname = "Gorrell";
args.callbacktype = "service";
</cfscript>

<cftry>
	<cfparam name="args.remotemethod">
	<cfparam name="args.componentmethod">
			
	<cfcatch type="any">	
		<cfdump var="#cfcatch#">
		<cfif LCase(cfcatch.message) CONTAINS "componentmethod">
			<cfset application.dsObj.setErrorData("Error. Undefined Component Method.")>
			<cfset application.dsObj.setServiceMessage("Error. Undefined Component Method.")>
		<cfelseif LCase(cfcatch.message) CONTAINS "remotemethod">
			<cfset application.dsObj.setErrorData("Error. Undefined Remote Method.")>
			<cfset application.dsObj.setServiceMessage("Error. Undefined Remote Method.")>
		</cfif>
	</cfcatch>
</cftry>
		
<cftry>
	<cfif application.secObj.userHasAccess(args.remotemethod,args.componentmethod)>
		<cfset application.dsObj.setMethodData(args)>
		<cfset application.fcObj.doGesture(args.remotemethod)>
	<cfelse>
		<cfset application.dsObj.setErrorData("Error. Unauthorized Method.")>
		<cfset application.dsObj.setServiceMessage("Error. Unauthorized Method.")>
	</cfif>	
			
	<cfcatch type="any">	
		<cfdump var="#cfcatch#">
		<cfif LCase(cfcatch.message) CONTAINS "is undefined">
			<cfset application.dsObj.setErrorData("Error. Undefined Component Method.")>
			<cfset application.dsObj.setServiceMessage("Error. Undefined Component Method.")>
		</cfif>
	</cfcatch>
</cftry>

<!--- Get the message (result) from the last method call --->
Return Value - <cfoutput>#application.dsObj.getServiceMessage()#</cfoutput><br><br>

<cfdump var="#application.dsObj.getInstance()#">
</layout:page>
