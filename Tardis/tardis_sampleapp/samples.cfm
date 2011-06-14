<!--- Sample view template --->
<!--- Import the pagelet taglibs --->
<cfsilent>
	<cfimport prefix="layout" taglib="/tardis_sampleapp/system/cfpagelets"> 
</cfsilent>

<layout:page>
<!--- Dump some data so that you can see what is going on --->
<br /><br />
<cfdump var="#application#" label="Application Scope" expand="no">
<br />
<cfdump var="#session#" label="Session Scope" expand="no">

<br />
<!--- Demonstate use of the validation component --->
Example of using the validation component methods (testing cheesewz@yahoo.com with the email validator):

<strong><cfdump var='#application.valObj.doValidation("isemail", "cheesew@yahoo.com")#' label="Validator"></strong>
<br />
</layout:page>

