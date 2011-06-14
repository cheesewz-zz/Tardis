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
	<cfset qCalendars = session.calendarObj.getCalendars()>
</cfsilent>

<layout:admin_page>	
	<cfoutput query="qCalendars">
		<cfset thiscalendarid = application.secObj.encryptValue(CalendarID_R,true,true)>
		<strong><a href="index.cfm?action=view.calendar&calendarid=#thiscalendarid#">#CalendarName_X#</a></strong><cfif CurrentRow EQ 1> | </cfif>
	</cfoutput>
	
	<p><p id="heading">Event Detail</p>
  	
	<br /><br />
	<strong><a href="index.cfm?action=view.addevent">Add Posting</a></strong>
	</p>
		
  	<br clear="all"/>
  	<br>
	<cfoutput query="qEvent">
	<cfif CalendarID_R IS "3CEB9ECE-5056-A166-B2CD6E678997731F">
		<cfset thisstyle = "heading2">	
	<cfelse>
		<cfset thisstyle = "heading5">
	</cfif>
	
	<layout:error dsObj="application.dsObj">
	
	<cfform name="deleteevent" action="index.cfm" method="post">
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
	<tr>
		<td colspan="2" align="center"><cfinput type="submit" name="submit" value="Delete Event"></td>
	</tr>
	</table>
	<cfinput type="hidden" name="calendarid" value="#application.secObj.encryptValue(CALENDARID_R,true,false)#">
	<cfinput type="hidden" name="eventid" value="#application.secObj.encryptValue(EVENTID_R,true,false)#">
	<cfinput type="hidden" name="controller" value="FrontController">
	<cfinput type="hidden" name="method" value="POST">
	<cfinput type="hidden" name="remotemethod" value="calendarManager">
	<cfinput type="hidden" name="componentmethod" value="deleteevent">	
	<cfinput type="hidden" name="callbacktype" value="form">
	<cfinput type="hidden" name="action" value="form.deleteevent">
	<cfinput type="hidden" name="requesttoken" value="#application.secObj.issueRequestToken()#">	
	</cfform>	
	</cfoutput>
	
</layout:admin_page>