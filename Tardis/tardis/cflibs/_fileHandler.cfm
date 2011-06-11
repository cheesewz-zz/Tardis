<cfsetting enablecfoutputonly="yes">

<!--- Loop over the form members looking for files (match FILE_ criteria) --->
<cfloop index="i" list="#form.fieldnames#">				
	<cfset thisfield = "form." & i>
					
	<cfif thisfield CONTAINS "FILE_" AND Len(Trim(Evaluate(thisfield)))>
		<!--- Upload the file to the defined location for the application --->
		<cffile 
			action="UPLOAD" 
			filefield="#i#" 
			destination="#application.fileuploaddirectory#" 
			nameconflict="#application.globals.fileconflict#">
		<!--- Change the form field to the uploaded filename for later use in the Manager --->			
		<cfset temp = StructUpdate(form, i, file.ServerFile)>
		<cfset temp = StructUpdate(formdata, i, file.ServerFile)>
	<cfelseif thisfield CONTAINS "FILE_" AND NOT(Len(Trim(Evaluate(thisfield))))>
		<!--- File not uploaded, change form field to an error message --->
		<cfset temp = StructUpdate(form, i, "Zero length file field.")>
		<cfset temp = StructUpdate(formdata, i, "Zero length file field.")>
	</cfif>								
</cfloop>
	
<cfsetting enablecfoutputonly="no">