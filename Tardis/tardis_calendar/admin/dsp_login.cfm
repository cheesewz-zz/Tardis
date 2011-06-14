<cfif getAuthUser() IS NOT "">
	<cflocation url="index.cfm?action=view.homepage" addtoken="no">
</cfif>

<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_calendar/system/cfpagelets"> 
</cfsilent>

<!--- <layout:admin_page> --->
<cfform action="dsp_login.cfm" method="post" name="loginform">
<table border="0" cellspacing="2" cellpadding="2">
<tr>
	<td class="bold">Loginid</td>
	<td class="normal"><cfinput name="j_username" type="text" size="25" required="yes" message="You must enter a loginid." /></td>
</tr>
<tr>
	<td class="bold">Password</td>
	<td class="normal"><cfinput name="j_password" type="password" size="25" required="yes" message="You must enter a password." /></td>
</tr>
</table>
<input type="submit" value="Login">
</cfform>
<!--- </layout:admin_page> --->