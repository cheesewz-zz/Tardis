<cfsetting enablecfoutputonly="yes">

<cfparam name="attributes.dsObj">

<!--- Put together the component with the method call and run --->
<cfset str = attributes.dsObj & ".getErrorData()">
<cfset errordata = Evaluate(str)>

<!--- If there is any error data, output it --->
<!--- Modify this as you like with styles or formatting --->
<cfloop index="i" from="1" to="#ArrayLen(errordata)#">
	<cfoutput><p class="normal">#errordata[i].ERRORDATETIME# #errordata[i].ERRORDETAIL#</p><br/></cfoutput>	
</cfloop>

<cfsetting enablecfoutputonly="no">