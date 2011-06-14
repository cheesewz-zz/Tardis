<!--- Sample form template --->
<!--- Import the pagelet taglibs --->
<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_sampleapp/system/cfpagelets"> 
</cfsilent>

<cfset thisUserId = application.secObj.stripEncryptedDelimiter(url.id)>
<cfset thisUserId = application.secObj.decryptValue(thisUserId)>
<cfset aUserObj = session.userDAOObj.retrieveUser(thisUserId)>

<layout:page>
<!--- Form without file upload --->
<cfform name="formwithoutfile" action="/tardis_sampleapp/" method="post" enctype="application/x-www-form-urlencoded">
<input type="hidden" name="controller" value="FrontController">
<input type="hidden" name="method" value="POST">
<input type="hidden" name="remotemethod" value="userManager">
<input type="hidden" name="componentmethod" value="updateUser">
<input type="hidden" name="callbacktype" value="form">
<input type="hidden" name="action" value="form.updateuser">
<input type="hidden" name="id" value="<cfoutput>#application.secObj.encryptValue(aUserObj.getID(),true,false)#</cfoutput>">
<input type="text" name="firstname" value="<cfoutput>#aUserObj.getFirstName()#</cfoutput>">
<input type="text" name="lastname" value="<cfoutput>#aUserObj.getLastName()#</cfoutput>">
<input type="hidden" name="requesttoken" value="<cfoutput>#application.secObj.issueRequestToken()#</cfoutput>">
<input type="submit" name="Submit" value="update">
</cfform>
<br>
Error Data:
<br>
<!--- Use the error output pagelet --->
<layout:error dsObj="application.dsObj">

</layout:page>
