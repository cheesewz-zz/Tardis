<cfimport prefix="layout" taglib="/tardis_calendar/system/cfpagelets"> 
<cfset qCalendars = application.calendarObj.getCalendars()>

<cfparam name="form.searchtype" default="basic">

<cfif form.searchtype IS "basic">
	<cfset qResults = application.calendarObj.basicSearch(form.allfields,form.calendarid)>
<cfelse>
	<cfset qResults = application.calendarObj.advancedSearch(form.calendarid,form.title_search,form.startdate_search,form.enddate_search,form.location_search,form.eventtype_search,form.synopsis_search,form.contact_search)>
</cfif>

<layout:page>

<cfoutput query="qCalendars">
<cfif CalendarID_R IS calendarid>
	<cfset thiscalendar = CalendarName_X>
</cfif>
</cfoutput>

<p id="heading"><cfoutput>#thiscalendar#</cfoutput>&#8212;Search Results</p>

<cfoutput query="qCalendars">
<cfif CalendarID_R IS calendarid>
	<strong id="text-orange"><a href="calendar.cfm?calendarid=#CalendarID_R#">#CalendarName_X#</a></strong><cfif CurrentRow EQ 1> | </cfif>
<cfelse>
	<strong><a href="calendar.cfm?calendarid=#CalendarID_R#">#CalendarName_X#</a></strong><cfif CurrentRow EQ 1> | </cfif>
</cfif>
</cfoutput>

<br><br>
<strong id="text-orange"><a href="dsp_search.cfm?calendarid=<cfoutput>#calendarid#</cfoutput>">Calendar Search</a></strong> | 
</p>
<br clear="all"/><br>

<cfif qResults.RecordCount>
	<cfoutput query="qResults">
	<cfif CalendarID_R IS "3CEB9ECE-5056-A166-B2CD6E678997731F">
		<cfset thisstyle = "heading2">	
	<cfelse>
		<cfset thisstyle = "heading5">
	</cfif>

	<table width="85%" border=0 align="center" cellpadding=4 cellspacing=0 id="table-border">
	<tr valign="top">
		<td align="left" colspan="2" id="#thisstyle#">#TITLE_X#</td>
	</tr>	
	<tr valign="top">
		<td width="10%" align="left"  nowrap><strong>Date: </strong></td>
		<td width="90%" align="left" >#DateFormat(EVENT_D,"mm/dd/yyyy")# - #DateFormat(END_D,"mm/dd/yyyy")#</td>
	</tr>
	<tr valign="top">
		<td width="10%" align="left"  nowrap><strong>Time: </strong></td>
		<td width="90%" align="left" >#TimeFormat(EVENT_T,"h:mm tt")# - #TimeFormat(END_T,"h:mm tt")#</td>
	</tr>
	<tr valign="top">
		<td width="10%" align="left"  nowrap><strong>Location: </strong></td>
		<td width="90%" align="left" >#LOCATION_X#</td>
	</tr>
	<tr valign="top">
		<td width="10%" align="left" valign="top"  nowrap><strong>Description: </strong></td>
		<td width="90%" align="left" >#SYNOPSIS_X#</td>
	</tr>
	<tr valign="top">
		<td width="10%" align="left"  nowrap><strong>Contact:  </strong></td>
		<td width="90%" align="left" >#CONTACT_N#</td>
	</tr>
	<tr valign="top">
		<td width="10%" align="left"  nowrap><strong>Contact Email:  </strong></td>
		<td width="90%" align="left" ><a href="mailto:#CONTACTEMAIL_X#" >#CONTACTEMAIL_X#</a></td>
	</tr>
	<tr valign="top">
		<td width="10%" align="left"  nowrap><strong>Contact Phone:  </strong></td>
		<td width="90%" align="left" >#CONTACTPHONE_R#</td>
	</tr>
	<cfif Len(INFOURL_X)>
	<tr valign="top">
		<td width="10%" align="left"  nowrap><strong>For More Info:  </strong></td>
		<td width="90%" align="left" ><a href="#INFOURL_X#" >#INFOURL_X#</a></td>
	</tr>
	</cfif>
	</table>
	</cfoutput>
<cfelse>
	No matching events.
</cfif>
</layout:page>