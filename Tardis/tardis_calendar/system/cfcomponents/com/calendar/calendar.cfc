<cfcomponent>
	<!--- Search --->
	<cffunction name="basicSearch" access="public" returntype="query" output="false">	
		<cfargument name="searchterm" type="string" required="yes">
		<cfargument name="calendarid" type="string" required="yes">
		
		<cfquery name="thisquery" datasource="#application.globals.dsn#">
		SELECT 	EventID_R,Weekend_C,EventTypeID_R,Event_D,Event_T,End_D,End_T ,CalendarID_R,AuthorID_R,Title_X,Location_X,Contact_N,ContactEmail_X,ContactPhone_R,InfoURL_X,Synopsis_X 
		FROM 	Events_Events
		WHERE	(Title_X LIKE '%#arguments.searchterm#%' OR 
				Location_X LIKE '%#arguments.searchterm#%' OR 
				Contact_N LIKE '%#arguments.searchterm#%' OR 
				ContactEmail_X LIKE '%#arguments.searchterm#%' OR 
				InfoURL_X LIKE '%#arguments.searchterm#%' OR 
				Synopsis_X LIKE '%#arguments.searchterm#%') AND 
				CalendarID_R = <cfqueryparam value="#arguments.calendarid#" cfsqltype="CF_SQL_CHAR" maxlength="35">  
		</cfquery>
		
		<cfreturn thisquery />
	</cffunction>
	<cffunction name="advancedSearch" access="public" returntype="query" output="false">	
		<cfargument name="calendarid" type="string" required="yes">
		<cfargument name="title" type="string" required="yes">
		<cfargument name="startdate" type="string" required="yes">
		<cfargument name="enddate" type="string" required="yes">
		<cfargument name="location" type="string" required="yes">
		<cfargument name="eventtype" type="numeric" required="yes">
		<cfargument name="synopsis" type="string" required="yes">
		<cfargument name="contact" type="string" required="yes">
		
		<cfquery name="thisquery" datasource="#application.globals.dsn#">
		SELECT 	EventID_R,Weekend_C,EventTypeID_R,Event_D,Event_T,End_D,End_T ,CalendarID_R,AuthorID_R,Title_X,Location_X,Contact_N,ContactEmail_X,ContactPhone_R,InfoURL_X,Synopsis_X 
		FROM 	Events_Events
		WHERE	CalendarID_R = <cfqueryparam value="#arguments.calendarid#" cfsqltype="CF_SQL_CHAR" maxlength="35">  
		
				<cfif Len(Trim(arguments.title))>
				AND Title_X LIKE '%#arguments.title#%' 
				</cfif>
				
				<cfif Len(Trim(arguments.location))>
				AND Location_X LIKE '%#arguments.location#%' 
				</cfif>
				
				<cfif Len(Trim(arguments.startdate))>
				AND Event_D >=  <cfqueryparam value="#arguments.startdate#" cfsqltype="CF_SQL_TIMESTAMP"> 
				</cfif>
				
				<cfif Len(Trim(arguments.enddate))>
				AND End_D <= <cfqueryparam value="#arguments.enddate#" cfsqltype="CF_SQL_TIMESTAMP"> 
				</cfif>
				
				<cfif arguments.eventtype GT 0>
				AND EventTypeID_R = <cfqueryparam value="#arguments.eventtype#" cfsqltype="CF_SQL_INTEGER"> 
				</cfif>
				
				<cfif Len(Trim(arguments.synopsis))>
				AND Synopsis_X LIKE '%#arguments.synopsis#%' 
				</cfif>
				
				<cfif Len(Trim(arguments.contact))>
				AND Contact_N LIKE '%#arguments.contact#%' OR ContactEmail_X LIKE '%#arguments.contact#%' 
				</cfif>				
		</cfquery>
		
		<cfreturn thisquery />
	</cffunction>
	
	<!--- Getters --->
	<cffunction name="getCalendars" access="public" returntype="query" output="false">		
		<cfquery name="thisquery" datasource="#application.globals.dsn#">
		SELECT 		CalendarID_R, CalendarName_X 
		FROM 		Event_Calendars
		ORDER BY 	CalendarName_X
		</cfquery>
		
		<cfreturn thisquery />
	</cffunction>	
	<cffunction name="getCalendarEvents" access="public" returntype="query" output="false">		
		<cfargument name="firstday" type="string" required="yes">
		<cfargument name="lastday" type="string" required="yes">
		<cfargument name="calendarid" type="string" required="no">
		
		<cfquery name="thisquery" datasource="#application.globals.dsn#">
		SELECT 	EventID_R,Weekend_C,EventTypeID_R,Event_D,Event_T,End_D,End_T ,CalendarID_R,AuthorID_R,Title_X,Location_X,Contact_N,ContactEmail_X,ContactPhone_R,InfoURL_X,Synopsis_X 
		FROM 	Events_Events
		WHERE 	Event_D BETWEEN #arguments.firstday# AND #arguments.lastday#
				<cfif IsDefined("arguments.calendarid") AND Len(arguments.calendarid)>
				AND CalendarID_R IN (<cfqueryparam value="#arguments.calendarid#" cfsqltype="CF_SQL_CHAR" maxlength="35" list="yes">)
				</cfif>
		</cfquery>
		
		<cfreturn thisquery />
	</cffunction>
	<cffunction name="getEventByID" access="public" returntype="query" output="false">		
		<cfargument name="eventid" type="string" required="yes">
		
		<cfquery name="thisquery" datasource="#application.globals.dsn#">
		SELECT 	EventID_R,Weekend_C,EventTypeID_R,Event_D,Event_T,End_D,End_T ,CalendarID_R,AuthorID_R,Title_X,Location_X,Contact_N,ContactEmail_X,ContactPhone_R,InfoURL_X,Synopsis_X 
		FROM 	Events_Events
		WHERE 	EventID_R = <cfqueryparam value="#arguments.eventid#" cfsqltype="CF_SQL_CHAR" maxlength="35" list="yes">
		</cfquery>
		
		<cfreturn thisquery />
	</cffunction>	
	
	<cffunction name="getCalendarYearList" access="public" returntype="string" output="false">		
		<cfargument name="calendarid" type="string" required="yes">
		
		<cfset yearlist = "">
		
		<cfquery name="thisquery" datasource="#application.globals.dsn#">
		SELECT 	MAX(Event_D) AS MaxDate, MIN(Event_D) AS MinDate
		FROM 	Events_Events
		WHERE 	CalendarID_R IN (<cfqueryparam value="#arguments.calendarid#" cfsqltype="CF_SQL_CHAR" maxlength="35" list="yes">)
		</cfquery>
		
		<cfif thisquery.recordcount AND Len(thisquery.MinDate) AND Len(thisquery.MaxDate)>
			<cfset minyear = Year(thisquery.MinDate)>
			<cfset maxyear = Year(thisquery.MaxDate)>
			
			<cfset theyear = minyear>
			
			<cfloop condition="theyear LTE maxyear">
				<cfset yearlist = ListAppend(yearlist,theyear)>
				<cfset theyear = theyear + 1> 
			</cfloop>
		<cfelse>
			<cfset yearlist = Year(Now())>
		</cfif>
		
		<cfreturn yearlist />
	</cffunction>
	
		
	<!--- Setters --->
	<cffunction name="addevent" access="package" output="false" returntype="void" roles="admin">			
		<cfargument name="eventid" type="string" required="true">
		<cfargument name="calendarid" type="string" required="true">
		<cfargument name="weekend" type="numeric" required="true">
		<cfargument name="eventtype" type="numeric" required="true">
		<cfargument name="eventd" type="string" required="true">
		<cfargument name="eventt" type="string" required="true">
		<cfargument name="endd" type="string" required="true">
		<cfargument name="endt" type="string" required="true">
		<cfargument name="authorid" type="string" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="location" type="string" required="true">
		<cfargument name="contact" type="string" required="true">
		<cfargument name="contactemail" type="string" required="true">
		<cfargument name="contactphone" type="string" required="false">
		<cfargument name="infourl" type="string" required="false">
		<cfargument name="synopsis" type="string" required="true">
			
		<cftry>
			<cfstoredproc procedure="addevent" datasource="#application.globals.dsn#" returncode="yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_CHAR" value="#arguments.eventid#" maxlength="35" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_BIT" value="#arguments.weekend#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" value="#arguments.eventtype#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.eventd#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.eventt#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.endd#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.endt#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_CHAR" value="#arguments.calendarid#" maxlength="35" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_CHAR" value="#arguments.authorid#" maxlength="7" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.title#" maxlength="100" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.location#" maxlength="100" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.contact#" maxlength="100" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.contactemail#" maxlength="100" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.contactphone#" maxlength="24" null="#NOT(YesNoFormat(Len(Trim(arguments.contactphone))))#">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.infourl#" maxlength="255" null="#NOT(YesNoFormat(Len(Trim(arguments.infourl))))#">
				<cfprocparam type="In" cfsqltype="CF_SQL_LONGVARCHAR" value="#arguments.synopsis#" maxlength="2000" null="no">		
			</cfstoredproc>
			
			<cfcatch type="any">
				<cflog file="eventCal" application="No" text="Error Detail: #cfcatch.detail# Error Message: #cfcatch.message#">
				<cfrethrow>
			</cfcatch>
		</cftry>
		
		<cfreturn />	
	</cffunction>	
	<cffunction name="updateevent" access="package" output="false" returntype="void" roles="admin">		
		<cfargument name="eventid" type="string" required="true">
		<cfargument name="calendarid" type="string" required="true">
		<cfargument name="weekend" type="numeric" required="true">
		<cfargument name="eventtype" type="numeric" required="true">
		<cfargument name="eventd" type="string" required="true">
		<cfargument name="eventt" type="string" required="true">
		<cfargument name="endd" type="string" required="true">
		<cfargument name="endt" type="string" required="true">
		<cfargument name="authorid" type="string" required="true">
		<cfargument name="title" type="string" required="true">
		<cfargument name="location" type="string" required="true">
		<cfargument name="contact" type="string" required="true">
		<cfargument name="contactemail" type="string" required="true">
		<cfargument name="contactphone" type="string" required="false">
		<cfargument name="infourl" type="string" required="false">
		<cfargument name="synopsis" type="string" required="true">
	
		<cftry>
			<cfstoredproc procedure="updateevent" datasource="#application.globals.dsn#" returncode="yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_CHAR" value="#eventid#" maxlength="35" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_BIT" value="#arguments.weekend#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_INTEGER" value="#arguments.eventtype#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.eventd#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.eventt#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.endd#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_TIMESTAMP" value="#arguments.endt#" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_CHAR" value="#arguments.calendarid#" maxlength="35" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_CHAR" value="#arguments.authorid#" maxlength="7" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.title#" maxlength="100" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.location#" maxlength="100" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.contact#" maxlength="100" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.contactemail#" maxlength="100" null="no">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.contactphone#" maxlength="24" null="#NOT(YesNoFormat(Len(Trim(arguments.contactphone))))#">
				<cfprocparam type="In" cfsqltype="CF_SQL_VARCHAR" value="#arguments.infourl#" maxlength="255" null="#NOT(YesNoFormat(Len(Trim(arguments.infourl))))#">
				<cfprocparam type="In" cfsqltype="CF_SQL_LONGVARCHAR" value="#arguments.synopsis#" maxlength="2000" null="no">	
			</cfstoredproc>
			
			<cfcatch type="any">
				<cflog file="eventCal" application="No" text="Error Detail: #cfcatch.detail# Error Message: #cfcatch.message#">
				<cfrethrow>
			</cfcatch>
		</cftry>
		
		<cfreturn />	
	</cffunction>	
	<cffunction name="deleteevent" access="package" output="false" returntype="void" roles="admin">		
		<cfargument name="eventid" type="string" required="no">
	
		<cftry>
			<cfstoredproc procedure="deleteevent" datasource="#application.globals.dsn#" returncode="yes">
				<cfprocparam type="In" cfsqltype="CF_SQL_CHAR" value="#arguments.eventid#" null="no">
			</cfstoredproc>
			
			<cfcatch type="any">
				<cflog file="eventCal" application="No" text="Error Detail: #cfcatch.detail# Error Message: #cfcatch.message#">
				<cfrethrow>
			</cfcatch>
		</cftry>
		
		<cfreturn />	
	</cffunction>
</cfcomponent>