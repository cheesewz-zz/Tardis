<!--- Sample form template --->
<!--- Import the pagelet taglibs --->
<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_sampleapp/system/cfpagelets"> 
</cfsilent>

<cfset aUserObj = session.userDAOObj.retrieveUsers()>
<cfset requesttoken = URLEncodedFormat(application.secObj.issueRequestToken())>

<layout:page>

<a href="?action=view.homepage&requesttoken=<cfoutput>#requesttoken#</cfoutput>">Back to homepage</a>
<br /><br />

<table border="1" cellspacing="3" cellpadding="3">
  <tr>
    <td><strong>First Name</strong></td>
    <td><strong>Last Name</strong></td>
    <td><strong>Functions</strong></td>
  </tr>
  
  <cfloop index="i" from="1" to="#ArrayLen(aUserObj)#">
  <cfset thisuserid = application.secObj.encryptValue(aUserObj[i].getID(),true,true)>
  <tr>
    <td><cfoutput>#aUserObj[i].getFirstName()#</cfoutput></td>
    <td><cfoutput>#aUserObj[i].getLastName()#</cfoutput></td>
    <td>
	<cfoutput>
	<a href="?action=view.updateuser&id=#thisuserid#&requesttoken=#requesttoken#">update</a> | 
	<a href="?action=view.deleteuser&id=#thisuserid#&requesttoken=#requesttoken#">delete</a>
	</cfoutput>
	</td>
  </tr>
  </cfloop>
</table>
</layout:page>