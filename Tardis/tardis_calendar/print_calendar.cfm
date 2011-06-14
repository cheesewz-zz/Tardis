<cfsilent>
<cfimport prefix="layout" taglib="/tardis_calendar/system/cfpagelets"> 
<cfset qCalendars = application.calendarObj.getCalendars()>

<cfparam name="calendarid" default="3CEB9ECE-5056-A166-B2CD6E678997731F">

<!--- Check to see if a specific date was requested or show today --->
<cfif IsDefined("showdate")>
	<cfset datetodisplay = showdate>
<cfelse>
	<cfset datetodisplay = DateFormat(Now(), "mm/dd/yyyy")>
</cfif>

<!--- Set up the first day of the month requested --->
<cfset firstday = "#DateFormat(datetodisplay,'mm')#/01/#DateFormat(datetodisplay, 'yyyy')#">

<!--- Set what day the first day of the month is on --->
<cfif DateFormat(firstday, 'DDD') EQ "SUN">
	<cfset loopstart = 0>
</cfif>

<cfif DateFormat(firstday, 'DDD') EQ "MON">
	<cfset loopstart = 1>
</cfif>

<cfif DateFormat(firstday, 'DDD') EQ "TUE">
	<cfset loopstart = 2>
</cfif>

<cfif DateFormat(firstday, 'DDD') EQ "WED">
	<cfset loopstart = 3>
</cfif>

<cfif DateFormat(firstday, 'DDD') EQ "THU">
	<cfset loopstart = 4>
</cfif>

<cfif DateFormat(firstday, 'DDD') EQ "FRI">
	<cfset loopstart = 5>
</cfif>

<cfif DateFormat(firstday, 'DDD') EQ "SAT">
	<cfset loopstart = 6>
</cfif>

<cfset DateCount = 1>

<cfset datetoadd = DaysInMonth(datetodisplay) - 1>
<cfset odbclastday =  CreateODBCDate(DateAdd('d', datetoadd, firstday))>
<cfset odbcfirstday = CreateODBCDate(firstday)>

<cfif IsDefined("calendarid")>
	<cfset events = application.calendarObj.getCalendarEvents(odbcfirstday,odbclastday,calendarid)>
<cfelse>
	<cfset events = application.calendarObj.getCalendarEvents(odbcfirstday,odbclastday)>
</cfif>

<cfif calendarid IS "3CEB9ECE-5056-A166-B2CD6E678997731F">
	<cfset thisstyle = "heading2">
<cfelse>
	<cfset thisstyle = "heading5">
</cfif>
</cfsilent>

<layout:print_page>

<cfoutput query="qCalendars">
<cfif CalendarID_R IS calendarid>
	<cfset thiscalendar = CalendarName_X>
</cfif>
</cfoutput>

<p id="heading"><cfoutput>#thiscalendar#</cfoutput></p>

<table width="100%" border="0" cellspacing="0" cellpadding="4" id="table-calendar">
<tr id="<cfoutput>#thisstyle#</cfoutput>">
	<td align=CENTER colspan="7"><cfoutput>#thiscalendar#</cfoutput></td>
</tr>
<tr id="heading4">
	<td align="center" colspan="7">
	<cfoutput>
	#MonthAsString(Month(datetodisplay))# #Year(datetodisplay)#
	</cfoutput>
	</td>
</tr>
<tr id="heading4">	
	<td align="center" width="14%" class="field">Sunday</td>
	<td align="center" width="14%" class="field">Monday</td>
	<td align="center" width="14%" class="field">Tuesday</td>
	<td align="center" width="14%" class="field">Wednesday</td>
	<td align="center" width="14%" class="field">Thursday</td>
	<td align="center" width="14%" class="field">Friday</td>
	<td align="center" width="14%" class="field">Saturday</td>
</tr>
<tr>
	<cfif loopstart NEQ 0>
	<cfloop from="1" to="#loopstart#" index="firstweek">
	<td align="center" width="14%" height="75" >&nbsp;</td>
	</cfloop>
	</cfif>

	<cfset WEEK1 = 7 - loopstart>
	<cfloop from="1" to="#week1#" index="Loop2">
	<cfoutput>
	<td align="right" valign="top" width="14%" height="75" class="field5">
	</cfoutput>
	<cfoutput>#DateCount#<br /></cfoutput>
	<cfoutput QUERY="Events">
	<cfif End_D NEQ "">
		<cfif DateCount GTE (DatePart("d", Event_D)) and DateCount LTE (DatePart("d", End_D))>
			<cfif Weekend_C NEQ 1>
				<cfif #DayOfWeekAsString(DayOfWeek(Month(datetodisplay) & '/' & DateCount & '/' & Year(datetodisplay)))# NEQ 'Saturday'
					and #DayOfWeekAsString(DayOfWeek(Month(datetodisplay) & '/' & DateCount & '/' & Year(datetodisplay)))# NEQ 'Sunday'>
						
						<cfif EventTypeID_R EQ 1>
							<cfset thisclass = "field2">
						<cfelse>
							<cfset thisclass = "field1">
						</cfif>
						
						<a href="index.cfm?action=view.event&eventid=#EventID_R#" class="#thisclass#">#Title_X#</a><br />
				</cfif>
			<cfelse>
				<cfif EventTypeID_R EQ 1>
					<cfset thisclass = "field2">
				<cfelse>
					<cfset thisclass = "field1">
				</cfif>
					<a href="index.cfm?action=view.event&eventid=#EventID_R#" class="#thisclass#">#Title_X#</a><br />
			</cfif>
		</cfif>
	<cfelse>
		<cfif (DatePart("d", Event_D) EQ DateCount)>
			<cfif EventTypeID_R EQ 1>
				<cfset thisclass = "field2">
			<cfelse>
				<cfset thisclass = "field1">
			</cfif>
				<a href="dsp_event.cfm?eventid=#EventID_R#" class="#thisclass#">#Title_X#</a><br />
		</cfif>
	</cfif>
	</cfoutput>

	<cfset DateCount = DateCount + 1>
	</td>
	</cfloop>

	</tr>
	<cfset WeekIndex = 0>
	<cfset LOOPto= DaysInMonth(datetodisplay) - 1>
	<cfloop from="#week1#" to="#loopto#" index="Loop3">
	<cfif WeekIndex EQ 0><tr></cfif>
	<cfoutput>
	<td align="right" valign="top" width="14%" height="75" class="field5">
	</cfoutput>
	<cfoutput>#DateCount#<br /></cfoutput>
	<cfoutput QUERY="Events">
	<cfif End_D NEQ "">
		<cfif DateCount GTE (DatePart("d", Event_D)) and DateCount LTE (DatePart("d", End_D))>
			<cfif Weekend_C NEQ 1>
				<cfif #DayOfWeekAsString(DayOfWeek(Month(datetodisplay) & '/' & DateCount & '/' & Year(datetodisplay)))# NEQ 'Saturday'
					and #DayOfWeekAsString(DayOfWeek(Month(datetodisplay) & '/' & DateCount & '/' & Year(datetodisplay)))# NEQ 'Sunday'>
						<cfif EventTypeID_R EQ 1>
							<cfset thisclass = "field2">
						<cfelse>
							<cfset thisclass = "field1">
						</cfif>						
						<a href="dsp_event.cfm?eventid=#EventID_R#" class="#thisclass#">#Title_X#</a><br />
				</cfif>
			<cfelse>
				<cfif EventTypeID_R EQ 1>
					<cfset thisclass = "field2">
				<cfelse>
					<cfset thisclass = "field1">
				</cfif>
					<a href="dsp_event.cfm?eventid=#EventID_R#" class="#thisclass#">#Title_X#</a><br />
			</cfif>
		</cfif>
	<cfelse>
		<cfif (DatePart("d", Event_D) EQ DateCount)>
			<cfif EventTypeID_R EQ 1>
				<cfset thisclass = "field2">
			<cfelse>
				<cfset thisclass = "field1">
			</cfif>
				<a href="dsp_event.cfm?eventid=#EventID_R#" class="#thisclass#">#Title_X#</a><br />
		</cfif>
	</cfif>
	</cfoutput>
	</td>
	<cfset WeekIndex = WeekIndex + 1><cfset DateCount = DateCount + 1>
	<cfif WeekIndex EQ 7></tr><cfset WeekIndex = 0></cfif>
	</cfloop>

	<cfif WeekIndex NEQ 0>
	<cfloop from="#WeekIndex#" to="6" index="Loop4">
	<td align="center" width="14%" height="75" bgcolor="EEEEEE">&nbsp;</td>
	</cfloop>
	</cfif>
</tr>
</table>
</layout:print_page>