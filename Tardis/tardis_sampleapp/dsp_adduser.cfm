
<!--- Sample form template --->
<!--- Import the pagelet taglibs --->
<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_sampleapp/system/cfpagelets"> 
</cfsilent>

<layout:page>

<!--- Form with file upload --->
<cfform name="formwithfile" action="/tardis_sampleapp/" method="post" enctype="multipart/form-data">
<input type="hidden" name="controller" value="FrontController">
<input type="hidden" name="method" value="POST">
<input type="hidden" name="remotemethod" value="userManager">
<input type="hidden" name="componentmethod" value="addUser">	
<input type="hidden" name="callbacktype" value="form">
<input type="hidden" name="action" value="form.adduser">
<input type="hidden" name="requesttoken" value="<cfoutput>#application.secObj.issueRequestToken()#</cfoutput>">
<input type="text" name="firstname" value="shawn">
<input type="text" name="lastname" value="gorrell">
	
<!--- Any file fields need to have "file_" in the name to be stored --->
<input name="file_afile" type="file">
<input type="submit" name="Submit" value="submit">
</cfform>

<br><br>

<!--- Form without file upload --->
<cfform name="formwithoutfile" action="/tardis_sampleapp/" method="post">
<input type="hidden" name="controller" value="FrontController">
<input type="hidden" name="method" value="POST">
<input type="hidden" name="remotemethod" value="userManager">
<input type="hidden" name="componentmethod" value="addUser">
<input type="hidden" name="callbacktype" value="form">
<input type="hidden" name="action" value="form.adduser">
<input type="hidden" name="requesttoken" value="<cfoutput>#application.secObj.issueRequestToken()#</cfoutput>"> 
<!--- the <script> part of the formfield is to demonstrate the datastore replacing bad inputs --->
<input type="text" name="firstname" value="">
<input type="text" name="lastname" value="">

<input type="submit" name="Submit" value="submit">
</cfform>

<br>
Error Data:
<br>

<!--- Use the error output pagelet --->
<layout:error dsObj="application.dsObj">

</layout:page>
