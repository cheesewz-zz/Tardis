<cfcomponent extends="tardis.validation.validation">
	<!--- This is an example of an application specific extension of the validation cfc --->
	<!--- You would do this for app specific validation method that cannot be implemented as a regex --->
	<cffunction name="isABA" access="public" returntype="boolean">
		<cfargument name="strABA" type="string" required="yes">
		
		<cfset var iCheckDigit = 0>
		<cfset var ErrMsg = "">
		<cfset var digitMult = ArrayNew(1)>
		<cfset var result = false>
		<cfset digitMult[1] = 3>
		<cfset digitMult[2] = 7>
		<cfset digitMult[3] = 1>
		<cfset digitMult[4] = 3>
		<cfset digitMult[5] = 7>
		<cfset digitMult[6] = 1>
		<cfset digitMult[7] = 3>
		<cfset digitMult[8] = 7>
		
		<cftry>
			<cfif (Len(arguments.strABA) NEQ 9)>
				<cfset result = false>
			</cfif>
				
			<cfif (NOT(IsNumeric(arguments.strABA)))>
				<cfset result = false>
			</cfif>
				
			<cfscript>
			for (x = 1; x LTE Len(Trim(arguments.strABA)); x = x + 1){
					
				digit = Mid(arguments.strABA, x, 1);
					
				if (x LTE 8){
					iCheckDigit = iCheckDigit + (digitMult[x] * digit);
				}	
			}
			</cfscript>
				
			<cfset iCheckDigit = (10 - (iCheckDigit Mod 10)) Mod 10>
				
			<cfif (iCheckDigit NEQ digit)>
				<cfset result = false>
			</cfif>
				
			<cfset result = true>
			
			<cfcatch>
				<cfset result = false>
			</cfcatch>
		</cftry>
		
		<cfreturn result>
	</cffunction>	
</cfcomponent>