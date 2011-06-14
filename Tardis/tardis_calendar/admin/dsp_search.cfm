<cfimport prefix="layout" taglib="/tardis_calendar/system/cfpagelets"> 
<cfset callbackdata = application.dsObj.getCallBackData()>
<cfset qCalendars = session.calendarObj.getCalendars()>

<cfif NOT(IsDefined("calendarid")) AND NOT(StructIsEmpty(callbackdata)) AND StructKeyExists(callbackdata,"calendarid")>
	<cfset calendarid = callbackdata.calendarid>
	<cfset calendarid = application.secObj.encryptValue(calendarid,true,false)>
</cfif>

<cfset calendarid = application.secObj.stripEncryptedDelimiter(calendarid)>
<cfset calendarid = application.secObj.decryptValue(calendarid)>

<layout:admin_page>

<cfoutput query="qCalendars">
<cfif CalendarID_R IS calendarid>
	<cfset thiscalendar = CalendarName_X>
</cfif>
</cfoutput>
	
<p id="heading"><cfoutput>#thiscalendar#</cfoutput></p>

<cfoutput query="qCalendars">
<cfif CalendarID_R IS calendarid>
	<strong id="text-orange">#CalendarName_X#</strong><cfif CurrentRow EQ 1> | </cfif>
<cfelse>
	<strong><a href="index.cfm?action=view.calendar&calendarid=#CalendarID_R#">#CalendarName_X#</a></strong><cfif CurrentRow EQ 1> | </cfif>
</cfif>
</cfoutput>

<br><br>
<strong><a href="index.cfm?action=view.addevent">Add Posting</a></strong> | 
<strong id="text-orange">Calendar Search</strong> | 
</p>
<br clear="all"/><br>

<cfform action="dsp_searchresults.cfm" method="post" name="SearchForm" id="form-style">
<table border="0" cellpadding="5" cellspacing="0" id="table-border">
<tr id="heading2">
	<td>Calendar Search</td>
</tr>
<tr id="bg-blue1">
	<td>
	<table border="0" cellspacing="0" cellpadding="10">
	<tr>
		<td>
		<cfinput name="allfields" size="40" maxlength="80" required="yes" message="You must enter a search term.">
		&nbsp;		
		<input name="Submit" type="submit" id="form-button2" value="Search">
		</td>
	</tr>
	</table>
	</td>
</tr>
</table>
<cfinput type="hidden" name="searchtype" value="basic">
<cfinput type="hidden" name="calendarid" value="#calendarid#">
</cfform>
<h1>Search Tips</h1>

<p>
Please enter a word or a phrase in the box above and click <strong>Search</strong>. The search
will look for the keyword(s) in the Title, Location, Description and/or Contact
fields. You will not get any results unless all words entered are in at least
one of the fields. 
</p>

<p>
To specify which field to search or to search by date, use the <strong><a href="index.cfm?action=view.advancedsearch&calendarid=<cfoutput>#URLEncodedFormat(calendarid)#</cfoutput>">Advanced Search</a></strong>. 
</p>

</layout:admin_page>