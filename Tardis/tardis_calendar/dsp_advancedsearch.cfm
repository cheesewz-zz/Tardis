<cfimport prefix="layout" taglib="/tardis_calendar/system/cfpagelets"> 
<cfset qCalendars = application.calendarObj.getCalendars()>

<layout:page>

<cfoutput query="qCalendars">
<cfif CalendarID_R IS calendarid>
	<cfset thiscalendar = CalendarName_X>
</cfif>
</cfoutput>
	
<p id="heading"><cfoutput>#thiscalendar#</cfoutput>&#8212;Advanced Search</p>

<cfoutput query="qCalendars">
	<strong><a href="calendar.cfm?calendarid=#CalendarID_R#">#CalendarName_X#</a></strong><cfif CurrentRow EQ 1> | </cfif>
</cfoutput>

<br><br>
<strong id="text-orange"><a href="dsp_search.cfm?calendarid=<cfoutput>#calendarid#</cfoutput>">Calendar Search</a></strong> | 
</p>
<br clear="all"/><br>

<table width="85%"  border="0" align="center" cellpadding="10" cellspacing="0">
<tr>
	<td>
	<cfform name="SearchForm" action="dsp_searchresults.cfm" method="post" id="form-style">
	<table border=0 cellpadding=5 cellspacing=0 id="table-border">
	<tr>
		<td id="heading2">Customer Calendar Advanced Search</td>
	</tr>
	<tr id="bg-blue1">
		<td>
		<table border="0" cellspacing="0" cellpadding="5">
		<tr>
			<td><strong> Title: </strong></td>
			<td><cfinput name="title_search" size="30" maxlength="80"></td>
		</tr>
		<tr>
			<td><strong> Start Date: </strong></td>
			<td>
			<cfinput name="startdate_search" size="20" maxlength="10">
			<a href="#" onClick="window.dateField=document.SearchForm.startdate_search;calendar=window.open('calendar_picker.cfm?datefield=startdate_search', 'cal', 'WIDTH=325,HEIGHT=250')"><IMG src="/eventCal/images/cal.gif" width="35" height="35" border=0 align="absmiddle"></A> 
			</td>
		</tr>
		<tr>
			<td><strong> End Date: </strong></td>
			<td>
			<cfinput name="enddate_search" size="20" maxlength="10">
			<a href="#" onClick="window.dateField=document.SearchForm.enddate;calendar=window.open('calendar_picker.cfm?datefield=enddate_search', 'cal', 'WIDTH=325,HEIGHT=250')"><IMG src="/eventCal/images/cal.gif" width="35" height="35" border=0 align="absmiddle"></A> 
			</td>
		</tr>
		<tr>
			<td><strong> Location: </strong></td>
			<td><cfinput name="location_search" size="30" maxlength="80"></td>
		</tr>
		<tr>
			<td><strong> Type: </strong></td>
			<td>
			<cfselect name="eventtype_search">
				<option value="1">Standard Events</option>
				<option value="2">Secondary Events</option>
				<option value="0" selected>Both</option>
			</cfselect>
			</td>
		</tr>
		<tr>
			<td><strong> Description: </strong></td>
			<td><cfinput size="30" name="synopsis_search" maxlength="80"></td>
		</tr>
		<tr>
			<td><strong> Contact: </strong></td>
			<td><cfinput size="30" name="contact_search" maxlength="50"></td>
		</tr>
		<tr>
			<td>&nbsp;</td>
			<td align="right"><cfinput name="Submit" type="submit" id="form-button2" value="Search"></td>
		</tr>
		</table>
		</td>
	</tr>
	</table>
	<cfinput type="hidden" name="searchtype" value="advanced">
	<cfinput type="hidden" name="calendarid" value="#calendarid#">
	</cfform>
	</td>
	<td valign="top">
	<h1>Search Tips</h1>
	<p>
	Pressing the <strong>Search</strong> button without entering
	any information in any of the form's fields will return every
	event in	the	database.</p>
	<p>To limit the results that are returned, enter words or phrases
	into any of the form's fields. The results returned will only
	be the events whose fields contain the words or phrases that
	you	entered.</p>
	<p>You can also search for events by start date. Entering a date
	in the start date field limits the results returned to only those
	events whose date is greater than or equal to the date you entered.
	Entering a date in the end date field limits the results returned
	to only those events whose date is less than or equal to the
	date you entered. Of course, you can enter both a start date
	and an end date to limit	the results to the specified date range.</p>
	<p>By default, the event type is set to <strong>Both</strong>.
	You	can select <strong>Standard Events</strong> or <strong>Secondary 
	Events</strong> to limit the results to only the selected type
	of event.
	</p>
	</td>
</tr>
</table>
</layout:page>