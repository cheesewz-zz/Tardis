<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_calendar/system/cfpagelets">
	 
	<cfset callbackdata = application.dsObj.getCallBackData()>
	
	<cfif NOT(IsDefined("eventid")) AND NOT(StructIsEmpty(callbackdata)) AND StructKeyExists(callbackdata,"eventid")>
		<cfset eventid = callbackdata.eventid>
		<cfset eventid = application.secObj.encryptValue(eventid,true,false)>
	</cfif>	
	
	<cfset eventid = application.secObj.stripEncryptedDelimiter(eventid)>
	<cfset eventid = application.secObj.decryptValue(eventid)>	
	
	<cfset qEvent = session.calendarObj.getEventByID(eventid)>	

	<cfset eventtime = TimeFormat(qEvent.EVENT_T,"hh:mm:tt")>
	<cfset endtime = TimeFormat(qEvent.END_T,"hh:mm:tt")>
	
	<cfset eventhour = ListGetAt(eventtime,1,":")>
	
	<cfif eventhour GT 12>
		<cfset eventhour = eventhour - 12>
	</cfif>
	
	<cfset eventminute = ListGetAt(eventtime,2,":")>
	<cfset eventampm = ListGetAt(eventtime,3,":")>
	
	<cfset endhour = ListGetAt(endtime,1,":")>
	
	<cfif endhour GT 12>
		<cfset endhour = eventhour - 12>
	</cfif>
	
	<cfset endminute = ListGetAt(endtime,2,":")>
	<cfset endampm = ListGetAt(endtime,3,":")>
	<cfset qCalendars = session.calendarObj.getCalendars()>
</cfsilent>

<layout:admin_page>

	<cfoutput query="qCalendars">
		<cfset thiscalendarid = application.secObj.encryptValue(CalendarID_R,true,true)>
		<strong><a href="index.cfm?action=view.calendar&calendarid=#thiscalendarid#">#CalendarName_X#</a></strong><cfif CurrentRow EQ 1> | </cfif>
	</cfoutput>
	
	<p><p id="heading">Event Detail</p>
	<br /><br />
	<layout:error dsObj="application.dsObj">
	
<cfform name="addevent" action="index.cfm" method="post" format="flash" height="700">

<cfformgroup type="hdividedbox" visible="yes" enabled="yes">
	<cfformgroup type="vbox" visible="yes" enabled="yes" width="400">
		<cfformgroup type="vertical" height="400">
		<cfinput type="text" name="title" value="#qEvent.TITLE_X#" label="Event Title" message="You must enter an event title." required="yes" size="20" maxlength="100">
		<cfinput type="text" name="location" value="#qEvent.LOCATION_X#" label="Event Location" message="You must enter an event location." required="yes" size="20" maxlength="100">
		<cfinput type="datefield" name="eventd" value="#DateFormat(qEvent.EVENT_D,'mm/dd/yyyy')#" label="Event Date" required="yes" message="You must enter an event date." width="100">
		<cfinput type="datefield" name="endd" value="#DateFormat(qEvent.END_D,'mm/dd/yyyy')#" label="Event End Date" required="yes" message="You must enter an event end date." width="100">
		<cfinput type="radio" name="weekend" value="1" checked="#YesNoFormat(qEvent.WEEKEND_C)#" label="Event Included on Weekends">
		<cfinput type="radio" name="weekend" value="0" checked="#NOT(YesNoFormat(qEvent.WEEKEND_C))#" label="Event Not Included on Weekends">
		
		<cfformitem type="text" visible="yes" enabled="yes">Event Time:</cfformitem>
		<cfselect name="timea" label="Hour" width="50" required="yes">
			<option value="1" <cfif eventhour EQ 1>selected="selected"</cfif>>1</option>
			<option value="2" <cfif eventhour EQ 2>selected="selected"</cfif>>2</option>
			<option value="3" <cfif eventhour EQ 3>selected="selected"</cfif>>3</option>
			<option value="4" <cfif eventhour EQ 4>selected="selected"</cfif>>4</option>
			<option value="5" <cfif eventhour EQ 5>selected="selected"</cfif>>5</option>
			<option value="6" <cfif eventhour EQ 6>selected="selected"</cfif>>6</option>
			<option value="7" <cfif eventhour EQ 7>selected="selected"</cfif>>7</option>
			<option value="8" <cfif eventhour EQ 8>selected="selected"</cfif>>8</option>
			<option value="9" <cfif eventhour EQ 9>selected="selected"</cfif>>9</option>
			<option value="10" <cfif eventhour EQ 10>selected="selected"</cfif>>10</option>
			<option value="11" <cfif eventhour EQ 11>selected="selected"</cfif>>11</option>
			<option value="12" <cfif eventhour EQ 12>selected="selected"</cfif>>12</option>
		</cfselect>
		<cfselect name="timeb" label="Minute" width="50" required="yes">
			<option value="00" <cfif eventminute IS "00">selected="selected"</cfif>>00</option>
			<option value="05" <cfif eventminute IS "05">selected="selected"</cfif>>05</option>
			<option value="10" <cfif eventminute IS "10">selected="selected"</cfif>>10</option>
			<option value="15" <cfif eventminute IS "15">selected="selected"</cfif>>15</option>
			<option value="20" <cfif eventminute IS "20">selected="selected"</cfif>>20</option>
			<option value="25" <cfif eventminute IS "25">selected="selected"</cfif>>25</option>
			<option value="30" <cfif eventminute IS "30">selected="selected"</cfif>>30</option>
			<option value="35" <cfif eventminute IS "35">selected="selected"</cfif>>35</option>
			<option value="40" <cfif eventminute IS "40">selected="selected"</cfif>>40</option>
			<option value="45" <cfif eventminute IS "45">selected="selected"</cfif>>45</option>
			<option value="50" <cfif eventminute IS "50">selected="selected"</cfif>>50</option>
			<option value="55" <cfif eventminute IS "55">selected="selected"</cfif>>55</option>
		</cfselect>
		<cfselect name="timec" label="AM/PM" width="50" required="yes">
			<option value="AM" <cfif eventampm IS "AM">selected="selected"</cfif>>AM</option>
			<option value="PM" <cfif eventampm IS "PM">selected="selected"</cfif>>PM</option>
		</cfselect> 
		
		<cfinput type="checkbox" name="allday" value="1" label="All Day Event">
		
		<cfformitem type="text" visible="yes" enabled="yes">Event End Time:</cfformitem>
		
		<cfselect name="timed" multiple="no" width="50" required="yes">
			<option value="1" <cfif endhour EQ 1>selected="selected"</cfif>>1</option>
			<option value="2" <cfif endhour EQ 2>selected="selected"</cfif>>2</option>
			<option value="3" <cfif endhour EQ 3>selected="selected"</cfif>>3</option>
			<option value="4" <cfif endhour EQ 4>selected="selected"</cfif>>4</option>
			<option value="5" <cfif endhour EQ 5>selected="selected"</cfif>>5</option>
			<option value="6" <cfif endhour EQ 6>selected="selected"</cfif>>6</option>
			<option value="7" <cfif endhour EQ 7>selected="selected"</cfif>>7</option>
			<option value="8" <cfif endhour EQ 8>selected="selected"</cfif>>8</option>
			<option value="9" <cfif endhour EQ 9>selected="selected"</cfif>>9</option>
			<option value="10" <cfif endhour EQ 10>selected="selected"</cfif>>10</option>
			<option value="11" <cfif endhour EQ 11>selected="selected"</cfif>>11</option>
			<option value="12" <cfif endhour EQ 12>selected="selected"</cfif>>12</option>
		</cfselect>
		<cfselect name="timee" width="50" required="yes">
			<option value="00" <cfif endminute IS "00">selected="selected"</cfif>>00</option>
			<option value="05" <cfif endminute IS "05">selected="selected"</cfif>>05</option>
			<option value="10" <cfif endminute IS "10">selected="selected"</cfif>>10</option>
			<option value="15" <cfif endminute IS "15">selected="selected"</cfif>>15</option>
			<option value="20" <cfif endminute IS "20">selected="selected"</cfif>>20</option>
			<option value="25" <cfif endminute IS "25">selected="selected"</cfif>>25</option>
			<option value="30" <cfif endminute IS "30">selected="selected"</cfif>>30</option>
			<option value="35" <cfif endminute IS "35">selected="selected"</cfif>>35</option>
			<option value="40" <cfif endminute IS "40">selected="selected"</cfif>>40</option>
			<option value="45" <cfif endminute IS "45">selected="selected"</cfif>>45</option>
			<option value="50" <cfif endminute IS "50">selected="selected"</cfif>>50</option>
			<option value="55" <cfif endminute IS "55">selected="selected"</cfif>>55</option>
		</cfselect>
		<cfselect name="timef" width="50" required="yes">
			<option value="AM" <cfif endampm IS "AM">selected="selected"</cfif>>AM</option>
			<option value="PM" <cfif endampm IS "PM">selected="selected"</cfif>>PM</option>
		</cfselect>
		</cfformgroup>
	</cfformgroup>
	
	<cfformgroup type="vbox" visible="yes" enabled="yes" width="400">
		<cfformgroup type="vertical" height="400">
		<cftextarea name="synopsis" value="#qEvent.SYNOPSIS_X#" label="Event Description" required="yes" message="You must enter an event description." enabled="yes" height="100" width="200" visable="yes"></cftextarea>
		
		<cfselect name="calendarid" label="Event Calendar" width="200" required="yes" message="You must select an event calendar.">
			<option value="3CEB9ECE-5056-A166-B2CD6E678997731F" <cfif qEvent.CALENDARID_R IS "3CEB9ECE-5056-A166-B2CD6E678997731F">selected="selected"</cfif>>Default Calendar</option>
		</cfselect>
		
		<cfselect name="eventtype" label="Event Type" width="100" required="yes" message="You must select an event type.">
			<option value="1" <cfif qEvent.EVENTTYPEID_R EQ 1>selected="selected"</cfif>>Standard Events</option>
			<option value="2" <cfif qEvent.EVENTTYPEID_R EQ 2>selected="selected"</cfif>>Secondary Events</option>
		</cfselect>
		
		<cfinput type="text" name="contact" value="#qEvent.Contact_N#" label="Event Contact Name" message="You must enter an event contact name." required="yes" size="20" maxlength="100">
 		<cfinput type="text" name="contactemail" value="#qEvent.CONTACTEMAIL_X#" label="Event Contact Email" message="You must enter an event contact email." required="no" size="20" maxlength="100" validate="email">
		<cfinput type="text" name="contactphone" value="#qEvent.CONTACTPHONE_R#" label="Event Contact Phone" message="You must enter a valid event contact phone." required="no" size="20" maxlength="24" validate="telephone">
		<cfinput type="text" name="infourl" value="#qEvent.INFOURL_X#" label="Event Info URL" size="20" maxlength="255">
		</cfformgroup>
	</cfformgroup>
</cfformgroup>

<cfinput type="hidden" name="eventid" value="#application.secObj.encryptValue(qEvent.EVENTID_R,true,false)#">
<cfinput type="hidden" name="controller" value="FrontController">
<cfinput type="hidden" name="method" value="POST">
<cfinput type="hidden" name="remotemethod" value="calendarManager">
<cfinput type="hidden" name="componentmethod" value="updateevent">	
<cfinput type="hidden" name="callbacktype" value="form">
<cfinput type="hidden" name="action" value="form.updateevent">
<cfinput type="hidden" name="requesttoken" value="#application.secObj.issueRequestToken()#">	
<cfinput type="submit" name="submit" value="Update Event">
</cfform>

</layout:admin_page>