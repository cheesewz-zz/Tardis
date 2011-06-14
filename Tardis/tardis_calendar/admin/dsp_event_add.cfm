<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_calendar/system/cfpagelets"> 
	<cfset qCalendars = session.calendarObj.getCalendars()>
</cfsilent>

<layout:admin_page>
	<layout:error dsObj="application.dsObj">
	<cfoutput query="qCalendars">
		<cfset thiscalendarid = application.secObj.encryptValue(CalendarID_R,true,true)>
		
		<strong><a href="index.cfm?action=view.calendar&calendarid=#thiscalendarid#">#CalendarName_X#</a></strong><cfif CurrentRow EQ 1> | </cfif>
	</cfoutput>
	
	<p><p id="heading">Event Detail</p>	
	<br /><br />

<cfform name="addevent" action="index.cfm" method="post" format="flash" height="700">

<cfformgroup type="hdividedbox" visible="yes" enabled="yes">
	<cfformgroup type="vbox" visible="yes" enabled="yes" width="400">
		<cfformgroup type="vertical" height="400">
		<cfinput type="text" name="title" label="Event Title" message="You must enter an event title." required="yes" size="20" maxlength="100">
		<cfinput type="text" name="location" label="Event Location" message="You must enter an event location." required="yes" size="20" maxlength="100">
		<cfinput type="datefield" name="eventd" label="Event Date" required="yes" message="You must enter an event date." width="100">
		<cfinput type="datefield" name="endd" label="Event End Date" required="yes" message="You must enter an event end date." width="100">
		<cfinput type="radio" name="weekend" value="1" checked="yes" label="Event Included on Weekends"><cfinput type="radio" name="weekend" value="0" label="Event Not Included on Weekends">
		
		<cfformitem type="text" visible="yes" enabled="yes">Event Time:</cfformitem>
		<cfselect name="timea" label="Hour" width="50" required="yes">
			<option value="1">1</option>
			<option value="2">2</option>
			<option value="3">3</option>
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>
			<option value="7">7</option>
			<option value="8" selected="selected">8</option>
			<option value="9">9</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
		</cfselect>
		<cfselect name="timeb" label="Minute" width="50" required="yes">
			<option value="00" selected="selected">00</option>
			<option value="05">05</option>
			<option value="10">10</option>
			<option value="15">15</option>
			<option value="20">20</option>
			<option value="25">25</option>
			<option value="30">30</option>
			<option value="35">35</option>
			<option value="40">40</option>
			<option value="45">45</option>
			<option value="50">50</option>
			<option value="55">55</option>
		</cfselect>
		<cfselect name="timec" label="AM/PM" width="50" required="yes">
			<option value="AM" selected="selected">AM</option>
			<option value="PM">PM</option>
		</cfselect> 
		
		<cfinput type="checkbox" name="allday" value="1" label="All Day Event">
		
		<cfformitem type="text" visible="yes" enabled="yes">Event End Time:</cfformitem>
		
		<cfselect name="timed" multiple="no" width="50" required="yes">
			<option value="1">1</option>
			<option value="2">2</option>
			<option value="3">3</option>
			<option value="4">4</option>
			<option value="5">5</option>
			<option value="6">6</option>
			<option value="7">7</option>
			<option value="8" selected="selected">8</option>
			<option value="9">9</option>
			<option value="10">10</option>
			<option value="11">11</option>
			<option value="12">12</option>
		</cfselect>
		<cfselect name="timee" width="50" required="yes">
			<option value="00">00</option>
			<option value="05">05</option>
			<option value="10">10</option>
			<option value="15">15</option>
			<option value="20">20</option>
			<option value="25">25</option>
			<option value="30" selected="selected">30</option>
			<option value="35">35</option>
			<option value="40">40</option>
			<option value="45">45</option>
			<option value="50">50</option>
			<option value="55">55</option>
		</cfselect>
		<cfselect name="timef" width="50" required="yes">
			<option value="AM" selected="selected">AM</option>
			<option value="PM">PM</option>
		</cfselect>
		</cfformgroup>
	</cfformgroup>
	
	<cfformgroup type="vbox" visible="yes" enabled="yes" width="400">
		<cfformgroup type="vertical" height="400">
		<cftextarea name="synopsis" label="Event Description" required="yes" message="You must enter an event description." enabled="yes" height="100" width="200" visable="yes"></cftextarea>
		
		<cfselect name="calendarid" label="Event Calendar" width="200" required="yes" message="You must select an event calendar.">
			<option value="3CEB9ECE-5056-A166-B2CD6E678997731F" selected="selected">Default Calendar</option>
		</cfselect>
		
		<cfselect name="eventtype" label="Event Type" width="100" required="yes" message="You must select an event type.">
			<option value="1" selected="selected">Standard Events</option>
			<option value="2">Secondary Events</option>
		</cfselect>
		
		<cfinput type="text" name="contact" label="Event Contact Name" message="You must enter an event contact name." required="yes" size="20" maxlength="100">
		<cfinput type="text" name="contactemail" label="Event Contact Email" message="You must enter an event contact email." required="no" size="20" maxlength="100" validate="email">
		<cfinput type="text" name="contactphone" label="Event Contact Phone" message="You must enter a valid event contact phone." required="no" size="20" maxlength="24" validate="telephone">
		<cfinput type="text" name="infourl" label="Event Info URL" size="20" maxlength="255">
		</cfformgroup>
	</cfformgroup>
</cfformgroup>

<cfinput type="hidden" name="controller" value="FrontController">
<cfinput type="hidden" name="method" value="POST">
<cfinput type="hidden" name="remotemethod" value="calendarManager">
<cfinput type="hidden" name="componentmethod" value="addevent">	
<cfinput type="hidden" name="callbacktype" value="form">
<cfinput type="hidden" name="action" value="form.addevent">
<cfinput type="hidden" name="requesttoken" value="#application.secObj.issueRequestToken()#">	
<cfinput type="submit" name="submit" value="Add Event">
</cfform>

</layout:admin_page>