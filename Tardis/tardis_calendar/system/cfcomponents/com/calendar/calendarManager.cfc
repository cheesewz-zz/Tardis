<cfcomponent>
	<cffunction name="calendarManager" access="public" output="false">		
		<!--- Initialize defaults --->		
		<cfparam name="status" type="string" default="error">
		<cfparam name="validationerrors" type="boolean" default="false">

		<!--- Get the data from the datastore instance --->
		<cfscript>
		thedata = application.dsObj.getMethodData();
		componentmethod = thedata.componentmethod;
		</cfscript>	
		
		<cfswitch expression="#componentmethod#">
		<cfcase value="addevent">
			<cftry>	
				<cfset status = "addeventsuccess">
				<cfset eventid = CreateUUID()>	
				<cfparam name="thedata.weekend" default="0">				
				
				<cfif thedata.timec IS "PM" AND thedata.timea NEQ 12>
					<cfset thedata.timea = thedata.timea + 12>
				</cfif>
				
				<cfif thedata.timec IS "AM" AND thedata.timea EQ 12>
					<cfset thedata.timea = "00">
				</cfif>
				
				<cfif thedata.timef IS "PM" AND thedata.timed NEQ 12>
					<cfset thedata.timed = thedata.timed + 12>
				</cfif>
				
				<cfif thedata.timef IS "AM" AND thedata.timed EQ 12>
					<cfset thedata.timed = "00">
				</cfif>				

				<cfset thedata.eventt = thedata.timea & ":" & thedata.timeb & ":00">
				<cfset thedata.endt = thedata.timed & ":" & thedata.timee & ":00">
				
				<cfif IsDefined("thedata.allday") AND thedata.allday EQ 1>
					<cfset thedata.eventt = "01:00:00">
					<cfset thedata.endt = "23:55:00">
				</cfif>				

				<cfscript>
				session.calendarObj.addevent(eventid,thedata.calendarid,thedata.weekend,thedata.eventtype,thedata.eventd,thedata.eventt,thedata.endd,thedata.endt,getAuthUser(),thedata.title,thedata.location,thedata.contact,thedata.contactemail,thedata.contactphone,thedata.infourl,thedata.synopsis);
				application.dsObj.setCallBackData("calendarid",thedata.calendarid);
				</cfscript>	
						
				<cfcatch type="any">
					<cfset application.logObj.doLog("Error", cfcatch)>
					<cfset status = "addeventerror">
					<cfset application.dsObj.setErrorData("Error:" & cfcatch.message)>
					<cfset application.dsObj.setCallBackData("errormessage",cfcatch.message)>
					<cfset application.dsObj.setMethodData(thedata)>
				</cfcatch>								
			</cftry>				
		</cfcase>	
		<cfcase value="updateevent">
			<cftry>	
				<cfset status = "updateeventsuccess">				
				
				<cfparam name="thedata.weekend" default="0">
				
				<cfif thedata.timec IS "PM" AND thedata.timea NEQ 12>
					<cfset thedata.timea = thedata.timea + 12>
				</cfif>
				
				<cfif thedata.timec IS "AM" AND thedata.timea EQ 12>
					<cfset thedata.timea = "00">
				</cfif>
				
				<cfif thedata.timef IS "PM" AND thedata.timed NEQ 12>
					<cfset thedata.timed = thedata.timed + 12>
				</cfif>
				
				<cfif thedata.timef IS "AM" AND thedata.timed EQ 12>
					<cfset thedata.timed = "00">
				</cfif>	
				
				<cfset thedata.eventt = thedata.timea & ":" & thedata.timeb & ":00">
				<cfset thedata.endt = thedata.timed & ":" & thedata.timee & ":00">
				
				<cfif IsDefined("thedata.allday") AND thedata.allday EQ 1>
					<cfset thedata.eventt = "01:00:00">
					<cfset thedata.endt = "23:55:00">
				</cfif>

				<cfscript>
				session.calendarObj.updateevent(thedata.eventid,thedata.calendarid,thedata.weekend,thedata.eventtype,thedata.eventd,thedata.eventt,thedata.endd,thedata.endt,getAuthUser(),thedata.title,thedata.location,thedata.contact,thedata.contactemail,thedata.contactphone,thedata.infourl,thedata.synopsis);
				application.dsObj.setCallBackData("eventid",thedata.eventid);
				application.dsObj.setCallBackData("calendarid",thedata.calendarid);
				</cfscript>	
						
				<cfcatch type="any">	
					<cfset application.logObj.doLog("Error", cfcatch)>
					<cfset status = "updateeventerror">
					<cfscript>
					application.dsObj.setCallBackData("eventid",thedata.eventid);
					application.dsObj.setCallBackData("calendarid",thedata.calendarid);
					</cfscript>	
					<cfset application.dsObj.setErrorData("Error:" & cfcatch.message)>
					<cfset application.dsObj.setCallBackData("errormessage",cfcatch.message)>
					<cfset application.dsObj.setMethodData(thedata)>
				</cfcatch>								
			</cftry>				
		</cfcase>	
		<cfcase value="deleteevent">
			<cftry>	
				<cfset status = "deleteeventsuccess">

				<cfscript>
				session.calendarObj.deleteevent(thedata.eventid);
				application.dsObj.setCallBackData("eventid",thedata.eventid);
				application.dsObj.setCallBackData("calendarid",thedata.calendarid);
				</cfscript>	
						
				<cfcatch type="any">
					<cfset application.logObj.doLog("Error", cfcatch)>
					<cfscript>
					application.dsObj.setCallBackData("eventid",thedata.eventid);
					application.dsObj.setCallBackData("calendarid",thedata.calendarid);
					</cfscript>	
					<cfset status = "deleteeventerror">
					<cfset application.dsObj.setErrorData("Error:" & cfcatch.message)>
					<cfset application.dsObj.setCallBackData("errormessage",cfcatch.message)>
					<cfset application.dsObj.setMethodData(thedata)>
				</cfcatch>								
			</cftry>				
		</cfcase>
		</cfswitch>
		<!--- End Business Logic Block --->		
		<!--- Set the service message --->
		<cfset application.dsObj.setServiceMessage(status)>
	</cffunction>
</cfcomponent>