<cfparam name="attributes.scope" type="string" default="APPLICATION">
<cfparam name="attributes.filename" type="string">
<cfparam name="attributes.varname" type="string" default="globals">
<cfparam name="attributes.bRefresh" default="FALSE">
<cfparam name="attributes.bCopyToRequest" default="FALSE">
<cfparam name="attributes.configDirectory" default="#GetDirectoryFromPath(ExpandPath('*.*'))#">

<cfif attributes.bRefresh>
	<cftry>
		<cflock timeout="10" throwontimeout="Yes" type="EXCLUSIVE" scope="#attributes.scope#">
			<cfset temp = StructDelete(Evaluate(attributes.scope),"globals")>
			<cfset temp = StructDelete(Evaluate(attributes.scope),"bIsAppInitialized")>
		</cflock>
		<cfcatch type="Lock">Timeout waiting for exclusive lock access.<br>Unable to initialize variables.<cfabort></cfcatch>
		<cfcatch type="Any"><cfdump var="#cfcatch#">General Error.<br>Unable to initialize variables.<cfabort></cfcatch>
	</cftry>
</cfif>

<cftry>
	<cflock timeout="10" throwontimeout="Yes" type="EXCLUSIVE" scope="#attributes.scope#">
		<cfif NOT(IsDefined("#attributes.scope#.bIsAppInitialized")) or attributes.bRefresh>
			<cfset temp = StructInsert(Evaluate(attributes.scope), "bIsAppInitialized", FALSe)>
			<cfset bIsAppInitialized = FALSE>
		<cfelse>	
			<cfset thisvar = attributes.scope & ".bIsAppInitialized">
			<cfset bIsAppInitialized = Evaluate(thisvar)>
		</cfif>
	</cflock>	
	<cfcatch type="Lock">Timeout waiting for exclusive lock access.<br>Unable to initialize variables.<cfabort></cfcatch>
	<cfcatch type="Any">General Error.<br>Unable to initialize variables.<cfabort></cfcatch>
</cftry>

<cfif NOT(bIsAppInitialized)>
	<cftry>
		<cffile action="READ" file="#attributes.configDirectory##attributes.filename#" variable="thisFile">		
		<cfcatch type="Any">Unable to read XML Configuration File.<br>Unable to initialize variables.<cfabort></cfcatch>
	</cftry>
	
	<cfif Len(thisFile)>		
		<cfif NOT(IsWDDX(thisFile))>
			<cftry>
				<cfset globals = StructNew()>
				<cfset thisXML = XmlParse(thisFile)>				
				<cfloop index="i" from="1" to="#ArrayLen(thisXML.globals.XmlChildren)#">
					<cfset thisvar = "thisXML.globals.XmlChildren[" & i & "].XmlName">
					<cfset thisvalue = "thisXML.globals.XmlChildren[" & i & "].XmlText">				
					<cfset temp = StructInsert(globals, Evaluate(thisvar), Evaluate(thisvalue), TRUE)>
				</cfloop>
				<cfcatch type="Any">Unable to parse XML Configuration File.<br>Unable to initialize variables.<cfabort></cfcatch>
			</cftry>	
		<cfelse>
			<cftry>
				<cfwddx 
					action="WDDX2CFML" 
					input="#thisFile#" 
					output="globals">
				<cfcatch type="Any">Unable to deserialze WDDX Configuration File.<br>Unable to initialize variables.<cfabort></cfcatch>
			</cftry>	
		</cfif>			
		<cftry>
			<cflock timeout="10" throwontimeout="Yes" type="EXCLUSIVE" scope="#attributes.scope#">
				<cfset temp = StructInsert(Evaluate(attributes.scope), attributes.varname, Duplicate(globals), TRUE)>
				<cfset temp = StructUpdate(Evaluate(attributes.scope), "bIsAppInitialized", "TRUE")>
			</cflock>			
	  		<cfcatch type="Lock">Timeout waiting for exclusive lock access.<br>Unable to initialize variables.<cfabort></cfcatch>
			<cfcatch type="Any">General Error.<br>Unable to initialize variables.<cfabort></cfcatch>
		</cftry>
	</cfif>	
<cfelse>
	<cfif attributes.bCopyToRequest>

	<cftry>
		<cflock timeout="10" throwontimeout="Yes" type="EXCLUSIVE" scope="#attributes.scope#">
			<cfset thisvar = attributes.scope & "." & attributes.varname>
			<cfset temp = StructInsert(request, attributes.scope, Duplicate(Evaluate(thisvar)), TRUE)>
		</cflock>			
 		<cfcatch type="Lock">Timeout waiting for exclusive lock access.<br>Unable to initialize variables.<cfabort></cfcatch>
		<cfcatch type="Any">General Error.<br>Unable to initialize variables.<cfabort></cfcatch>
	</cftry>
	</cfif>
</cfif>