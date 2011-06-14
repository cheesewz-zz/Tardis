<cfset CalendarDate = Now()>


<cfset PrevMonthString = MonthAsString(DatePart("m",DateAdd("m", -1,CalendarDate)))>
<cfset PrevMonth = DateFormat(DateAdd("m", -1,CalendarDate), "mm/dd/yy")>
<cfset NextMonthString = MonthAsString(DatePart("m",DateAdd("m", 1,CalendarDate)))>
<cfset NextMonth = DateFormat(DateAdd("m", 1,CalendarDate), "mm/dd/yy")>
<cfset Month = MonthAsString(DatePart("m",CalendarDate))>
<cfset MonthNum = Month(CalendarDate)>
<cfset Year =DatePart("yyyy",CalendarDate)>
<cfset NumOfDays = DaysInMonth(CalendarDate)>
<cfset DayOfWeek = DayOfWeek(CalendarDate)>
<cfset DayNum = Day(CalendarDate)>
<cfset FirstDay =  DayOfWeek(MonthNum & "/1/" & Year)>
<cfset NumberOfRows = ((FirstDay + NumOfDays )/ 7) + 1>
<cfset FirstRowCount = 1>
<cfset count = 1>

<!doctype html public "-//W3C//DTD HTML 3.2//EN">
<html>
<head>
<script LANGUAGE="JavaScript">
<!--
function adddate(thedate)
{
	formatted_date = <CFOUTPUT>#MonthNum#</CFOUTPUT> + "/" + thedate + "/" + <CFOUTPUT>#Year#</CFOUTPUT>;
 	opener.document.SearchForm.<cfoutput>#url.datefield#</cfoutput>.value=formatted_date;
	close();
}
//-->
</script>

<style type="text/css">
A, A:LINK, A:VISITED
{
	text-decoration: none;
	color: black;
}

A:HOVER 
{
	text-decoration: underline;
}
.normal 
{
	font-family: MS Sans Serif;
	font-size: 10pt;
	color: black; 
	text-decoration: none;
}

.title
{
	font-family: MS Sans Serif;
	font-size: 12pt;
	color: black; 
	text-decoration: none;
	font-weight : bold;
}

.bold 
{
	font-family: MS Sans Serif;
	font-size: 10pt;
	color: black; 
	text-decoration: none;
	font-weight : bold;
}
</style>
	<title><cfoutput>#Month#</cfoutput> Calendar</title>
</head>

<body>
<center>
<table border="1" cellpadding="1" cellspacing="2" width="294">
<tr>
	<td align="center" bgcolor="#3366cc" class="bold">
		<cfoutput>
		<a href="calendar.cfm?startdate=#PrevMonth#&datefield=#url.datefield#">#Left(PrevMonthString, 3)#</a>
		</cfoutput>
	</td>
	<td colspan="5" align="center" bgcolor="white" class="title">
		<cfoutput>#Month# #Year#</cfoutput>
	</td>
	<td align="center" bgcolor="#3366cc" class="bold">
		<cfoutput>
		<a href="calendar.cfm?startdate=#NextMonth#&datefield=#url.datefield#">#Left(NextMonthString, 3)#</a>
		</cfoutput>
	</td>
</tr>
<tr bgcolor="#CDE6FF" align="center">
	<td class="bold">Sun</td>
	<td class="bold">Mon</td>
	<td class="bold">Tues</td>
	<td class="bold">Wed</td>
	<td class="bold">Thurs</td>
	<td class="bold">Fri</td>
	<td class="bold">Sat</td>
</tr>
<cfloop index="row" from="1" to="#NumberOfRows#">
<tr>
<cfloop index="cell" from="1" to="7">
	<cfif count GT NumOfDays>
		<cfbreak>
	</cfif>
	<cfif FirstRowCount LT FirstDay>
		<cfoutput>
			<td width="40" valign="top" align="right" class="normal">&nbsp;</td>
		</cfoutput>
		<cfset FirstRowCount = IncrementValue(FirstRowCount)>
	<cfelse>
			<cfoutput>
			<cfif count IS DayNum AND Month(Now()) IS MonthNum AND Year IS  DatePart("yyyy",Now())>
				<td width="40" valign="top" align="right" bgcolor="white" class="normal"><a href="javascript:adddate(#count#);">#count#</a></td>
			<cfelse>
				<td width="40" valign="top" align="right" class="normal"><a href="javascript:adddate(#count#);">#count#</a></td>
			</cfif>
			</cfoutput>
		<cfset count = IncrementValue(count)>
	</cfif>
</cfloop>
</tr>
</cfloop>
</table>
</center>
<form>
<center>
<input type="BUTTON" value="Close" onClick="self.close()">
</center>
</form>
</body>
</html>
