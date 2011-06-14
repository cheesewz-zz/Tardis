<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_calendar/system/cfpagelets"> 
	
	<cfset qCalendars = session.calendarObj.getCalendars()>
</cfsilent>

<layout:admin_page>
<br />
<blockquote>
<cfoutput query="qCalendars">
<cfset thiscalendarid = application.secObj.encryptValue(CalendarID_R,true,true)>
<a href="index.cfm?action=view.calendar&calendarid=#thiscalendarid#" class="heading">#CalendarName_X#</a>
<br />
</cfoutput>
<a href="index.cfm?action=view.logout">Logout</a>
</blockquote>
</layout:admin_page>