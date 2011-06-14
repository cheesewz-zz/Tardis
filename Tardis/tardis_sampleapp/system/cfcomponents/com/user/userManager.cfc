<cfcomponent>
	<cffunction name="userManager" access="public" output="false">		
		<!--- Initialize defaults --->		
		<cfparam name="status" type="string" default="error">
		<cfparam name="validationerrors" type="boolean" default="false">

		<!--- Get the data from the datastore instance --->
		<cfscript>
		thedata = application.dsObj.getMethodData();
		componentmethod = thedata.componentmethod;
		</cfscript>	
				
		<cfswitch expression="#componentmethod#">
		<cfcase value="addUser">
			<cftry>	
				<cfset status = "addusersuccess">	
				
				<!--- Sample of performing business logic --->
				<cfset obj = CreateObject("component", "User")>
				<cfset userObj = obj.populate(CreateUUID(),thedata.firstname,thedata.lastname)>	
				<cfset session.userDAOObj.create(userObj)>	
								
				<!--- Example of how to handle a file --->			
				<cfif IsDefined("thedata.file_afile") AND Len(thedata.file_afile) AND thedata.file_afile IS NOT "Zero length file field.">
					<!--- Make a new file for illustration purposes --->
					<cfset fileext = Right(thedata.file_afile,Len(thedata.file_afile) - Find(".",thedata.file_afile,1))>								
					<cfset thisFileName = CreateUUID() & "." & fileext>		
					<!--- Rename the uploaded file to the new filename for illustration --->
					<cffile 
						action="rename" 
						destination="#application.fileuploaddirectory##thisFileName#" 
						source="#application.fileuploaddirectory##thedata.file_afile#">			
				</cfif>					

				<cfset application.dsObj.setCallBackData("status","addusersuccess")>			
				<cfset application.dsObj.setCallBackData("errormessage","")>
				<cfset application.logObj.doLog("Information", "User: #thedata.firstname# #thedata.lastname# added.")>	
						
				<cfcatch type="any">
					<!--- Handle errors. Set error data, callback data and save method data for retrieving in the error view if desired --->
					<cfset status = "addusererror">
					<cfset application.dsObj.setErrorData("Error:" & cfcatch.message)>
					<cfset application.dsObj.setCallBackData("errormessage",cfcatch.message)>
					<cfset application.dsObj.setMethodData(thedata)>
					<cfset application.logObj.doLog("Error", cfcatch)>
				</cfcatch>								
			</cftry>				
		</cfcase>		
		<cfcase value="updateUser">
			<cftry>	
				<cfset status = "updateusersuccess">
				
				<!--- Sample of performing business logic --->
				<cfset obj = CreateObject("component", "User")>
				<cfset userObj = obj.populate(thedata.id,thedata.firstname,thedata.lastname)>	
				<cfset session.userDAOObj.update(userObj)>	

				<cfset application.dsObj.setCallBackData("status","updateusersuccess")>			
				<cfset application.dsObj.setCallBackData("errormessage","")>	
				<cfset application.logObj.doLog("Information", "User: #thedata.firstname# #thedata.lastname# updated.")>	
					
				<cfcatch type="any">
					<!--- Handle errors. Set error data, callback data and save method data for retrieving in the error view if desired --->
					<cfset status = "updateusererror">
					<cfset application.dsObj.setErrorData("Error:" & cfcatch.message)>
					<cfset application.dsObj.setCallBackData("errormessage",cfcatch.message)>
					<cfset application.dsObj.setMethodData(thedata)>
					<cfset application.logObj.doLog("Error", cfcatch)>
				</cfcatch>								
			</cftry>				
		</cfcase>		
		<cfcase value="deleteUser">
			<cftry>	
				<cfset status = "deleteusersuccess">
				
				<!--- Sample of performing business logic --->
				<cfset obj = CreateObject("component", "User")>
				<cfset userObj = obj.populate(thedata.id,thedata.firstname,thedata.lastname)>	
				<cfset session.userDAOObj.delete(userObj)>	

				<cfset application.dsObj.setCallBackData("status","deleteusersuccess")>			
				<cfset application.dsObj.setCallBackData("errormessage","")>	
				<cfset application.logObj.doLog("Information", "User: #thedata.firstname# #thedata.lastname# deleted.")>	
					
				<cfcatch type="any">
					<!--- Handle errors. Set error data, callback data and save method data for retrieving in the error view if desired --->
					<cfset status = "deleteusererror">
					<cfset application.dsObj.setErrorData("Error:" & cfcatch.message)>
					<cfset application.dsObj.setCallBackData("errormessage",cfcatch.message)>
					<cfset application.dsObj.setMethodData(thedata)>
					<cfset application.logObj.doLog("Error", cfcatch)>
				</cfcatch>								
			</cftry>				
		</cfcase>		
		</cfswitch>
		<!--- End Business Logic Block --->

		<!--- Set the service message --->
		<cfset application.dsObj.setServiceMessage(status)>
	</cffunction>
</cfcomponent>