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

<cfif Month(datetodisplay) EQ 1>
	<cfset prevdate = 12 & '/01/' & (Year(datetodisplay)-1)>
	<cfset nextdate = (Month(datetodisplay)+1) & '/01/' & Year(datetodisplay)>
<cfelse>
	<cfif Month(datetodisplay) EQ 12>
		<cfset prevdate = (Month(datetodisplay)-1) & '/01/' & Year(datetodisplay)>
		<cfset nextdate = 1 & '/01/' & (Year(datetodisplay)+1)>
	<cfelse>
		<cfset prevdate = (Month(datetodisplay)-1) & '/01/' & Year(datetodisplay)>
		<cfset nextdate = (Month(datetodisplay)+1) & '/01/' & Year(datetodisplay)>
	</cfif>
</cfif>

<!--- Get the range of years that contain events --->
<cfset lYearList = application.calendarObj.getCalendarYearList(calendarid)>

<!--- Set the previous and next calendar years --->
<cfset nextyear = Year(DateFormat(datetodisplay, "mm/dd/yyyy"))+1>
<cfset lastyear = Year(DateFormat(datetodisplay, "mm/dd/yyyy"))-1>

<!--- Limit the year paging of the calendar to only include years that contain events --->
<cfif NOT(ListContains(lYearlist,nextyear))>
	<cfset nextyear = Year(DateFormat(datetodisplay, "mm/dd/yyyy"))>
</cfif>

<cfif NOT(ListContains(lYearlist,lastyear))>
	<cfset lastyear = Year(DateFormat(datetodisplay, "mm/dd/yyyy"))>
</cfif>

<cfset prevprevyeardate = Month(datetodisplay) & '/' & Day(datetodisplay) & '/' & lastyear>
<cfset nextnextyeardate = Month(datetodisplay) & '/' & Day(datetodisplay) & '/' & nextyear>
</cfsilent>

<layout:page>

<script language="javascript">
function goThere(theMonth){
	if (document.all){
		var list = document.all.dateForm.SelectYear;
	}else{
		var list = document.forms.dateForm.SelectYear;
	}
	
	var yeartogoto = list.options[list.selectedIndex].value;
	var gotodate = theMonth + '/01/' + yeartogoto;
	
	location = 'calendar.cfm?calendarid=<cfoutput>#calendarid#</cfoutput>&showdate=' + gotodate;

}

function goThereMonth(theYear){
	if (document.all)	{
		var list = document.all.dateForm.SelectMonth;
	}else{
		var list = document.forms.dateForm.SelectMonth;
	}
	var monthtogoto = list.options[list.selectedIndex].value;
	var gotodate = monthtogoto + '/01/' + theYear;
	
	location = 'calendar.cfm?calendarid=<cfoutput>#calendarid#</cfoutput>&showdate=' + gotodate;
}
</script>

<cfoutput query="qCalendars">
<cfif CalendarID_R IS calendarid>
	<cfset thiscalendar = CalendarName_X>
</cfif>
</cfoutput>

<p id="heading"><cfoutput>#thiscalendar#</cfoutput></p>
<p>

<cfoutput query="qCalendars">
<cfif CalendarID_R IS calendarid>
	<strong id="text-orange">#CalendarName_X#</strong><cfif CurrentRow EQ 1> | </cfif>
<cfelse>
	<strong><a href="calendar.cfm?calendarid=#CalendarID_R#">#CalendarName_X#</a></strong><cfif CurrentRow EQ 1> | </cfif>
</cfif>
</cfoutput>

<br><br>
<strong><a href="dsp_search.cfm?calendarid=<cfoutput>#calendarid#</cfoutput>">Calendar Search</a></strong> | 
<strong><a href="print_calendar.cfm?<cfoutput>#cgi.QUERY_STRING#</cfoutput>" target="_blank">Print Calendar</a></strong>  
</p>
<br clear="all"/><br>

<table width="100%" border="0" cellspacing="0" cellpadding="4" id="table-calendar">
<tr id="<cfoutput>#thisstyle#</cfoutput>">
	<td align=CENTER colspan="7"><cfoutput>#UCase(thiscalendar)#</cfoutput></td>
</tr>
<tr id="heading4">
<form name="dateForm">
<td align="center" colspan="7">
<a href="calendar.cfm?calendarid=<cfoutput>#calendarid#</cfoutput>&showdate=<cfoutput>#prevprevyeardate#</cfoutput>" class="field3">
<img src="/tardis_calendar/images/bayearbk.gif" border="0" alt="Previous Year"></a>
&nbsp;&nbsp;
<a href="calendar.cfm?calendarid=<cfoutput>#calendarid#</cfoutput>&showdate=<cfoutput>#prevdate#</cfoutput>" class="field3">
<img src="/tardis_calendar/images/bamonthbk.gif" border="0" alt="Previous Month"></a>
&nbsp;
<cfoutput>
<select name="SelectMonth" onchange="goThereMonth(#Year(datetodisplay)#)">
<option value="#MonthAsString(Month(datetodisplay))#">#MonthAsString(Month(datetodisplay))#
<option value="1">January</option>
<option value="2">February</option>
<option value="3">March</option>
<option value="4">April</option>
<option value="5">May</option>
<option value="6">June</option>
<option value="7">July</option>
<option value="8">August</option>
<option value="9">September</option>
<option value="10">October</option>
<option value="11">November</option>
<option value="12">December</option>
</select>
</cfoutput>
&nbsp; 
<cfoutput>
<select name="SelectYear" onchange="goThere(#Month(datetodisplay)#,null)">
<cfset selectedyear = Year(datetodisplay)>
<cfloop index="i" list="#lYearList#">
<option value="#i#" <cfif i EQ selectedyear>selected</cfif>>#i#</option>
</cfloop>
</select>
</cfoutput>
&nbsp;
<a href="calendar.cfm?calendarid=<cfoutput>#calendarid#</cfoutput>&showdate=<cfoutput>#nextdate#</cfoutput>" class="field3">
<img src="/tardis_calendar/images/bamonthup.gif" border="0" alt="Next Month"></a>&nbsp;&nbsp;
<a href="calendar.cfm?calendarid=<cfoutput>#calendarid#</cfoutput>&showdate=<cfoutput>#nextnextyeardate#</cfoutput>" class="field3">
<img src="/tardis_calendar/images/bayearup.gif" border="0" alt="Next Year"></a>
<br>
</form>
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

	<cfset week1 = 7 - loopstart>
	<cfloop from="1" to="#week1#" index="Loop2">
	<cfoutput>
	<td align="right" valign="top" width="14%" height="75" class="field5">
	</cfoutput>
	<cfoutput>#DateCount#<br /></cfoutput>
	<!--- loop over the events ---> 
	<cfoutput QUERY="Events">
	<!--- check to see if there is an end date for this event --->
	<cfif End_D NEQ "">
		<!--- check if event month is equal to display month and end month --->
		<cfif (DatePart("m", Event_D) EQ DatePart("m", datetodisplay)) and (DatePart("m", Event_D) EQ DatePart("m", End_d))>
			<!--- check if calendar day is equal to or between the event date and end date ---> 
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
	<cfset loopto= DaysInMonth(datetodisplay) - 1>
	<cfloop from="#week1#" to="#loopto#" index="Loop3">
	<cfif WeekIndex EQ 0><tr></cfif>
	<cfoutput>
	<td align="right" valign="top" width="14%" height="75" class="field5">
	</cfoutput>
	<cfoutput>#DateCount#<br /></cfoutput>
	<!--- loop over the events ---> 
	<cfoutput query="Events">
	<!--- check to see if there is an end date for this event --->
	<cfif End_D NEQ "">
		<!--- check if event month is equal to display month and end month --->
		<cfif (DatePart("m", Event_D) EQ DatePart("m", datetodisplay)) and (DatePart("m", Event_D) EQ DatePart("m", End_d))>
			<!--- check if calendar day is equal to or between the event date and end date ---> 
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
	<cfset WeekIndex = WeekIndex + 1>
	<cfset DateCount = DateCount + 1>
	<cfif WeekIndex EQ 7></tr><cfset WeekIndex = 0></cfif>
	</cfloop>

	<cfif WeekIndex NEQ 0>
	<cfloop from="#WeekIndex#" to="6" index="Loop4">
	<td align="center" width="14%" height="75" bgcolor="EEEEEE">&nbsp;</td>
	</cfloop>
	</cfif>
</tr>
</table>
</layout:page>