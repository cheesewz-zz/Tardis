<cfcomponent displayname="base" hint="Base component for all framework pieces.">
	<cffunction name="config" access="public" output="false" returntype="void" displayname="config" hint="Method to configure the instance" description="Methods parses XML configuration file and sets instance variable values.">
		<cfargument name="configdirectory" required="yes" />
		<cfargument name="configfilename" required="yes" />			
		
		<cfset var thisconfig = "">
		<cfset var thisbaseconfig = "">
		<cfset var thisnode = "">
		<cfset var temp = "">
		<cfset var thisrresult = "">
		<cfset var thisname = "">
		<cfset var thisvalue = "">
		<cfset var basexml = "">
		<cfset var pathstr = "">
		<cfset var thisparam = "">
		<cfset var thisparamvalue = "">	
		<cfset var thischildparam = "">											
		<cfset var thischildparamvalue = "">
		<cfset var thisparamchildren = "">	
		<cfset var thispathstr = "">
		<cfset var thischildparamchildren = "">
		<cfset var temparray = "">
		<cfset var thistempstruct = "">
		
		<cfset instance = StructNew()>
		<cfset instance.config = StructNew()>
		
		<cffile action="read" 
			file="#arguments.configdirectory##arguments.configfilename#" 
			variable="thisconfig">		
		
		<cfset thisbaseconfig = xmlParse(thisconfig)>	
		
		<cfset params = structNew()>		
		
		<cfloop index="i" from="1" to="#ArrayLen(thisbaseconfig.config.xmlchildren)#">
			<cfset thisparam = "thisbaseconfig.config.xmlChildren[" & i & "].xmlname">				
			<cfset thisnode = Evaluate(thisparam)>							
			
			<cfset StructInsert(params, thisnode, StructNew(), TRUE)>	
			
			<cfset thisresult = "thisbaseconfig.config['" & thisnode & "'].xmlchildren">	
		
			<cfloop index="k" from="1" to="#arrayLen(Evaluate(thisresult))#">			
				<cfset basexml = "thisbaseconfig.config['" & thisnode & "']">	
				<cfset pathstr = "thisbaseconfig.config." & thisnode>				
				<cfset thisparam = basexml & ".xmlchildren['" & k & "']." & "xmlname">							
				<cfset thisparamvalue = basexml & "." & Evaluate(thisparam) & ".xmltext">	
				<cfset thisparamchildren = basexml & "." & Evaluate(thisparam) & ".xmlchildren">
				
				<cfset temp = StructInsert(params[thisnode],Evaluate(thisparam),Evaluate(thisparamvalue),TRUE)>
				
				<cfif NOT(ArrayIsEmpty(Evaluate(thisparamchildren)))>
					<cfset thischildparam = basexml & ".xmlchildren['" & k & "']." & "xmlname">											
					<cfset thischildparamvalue = basexml & "." & Evaluate(thischildparam) & ".xmltext">	
					<cfset thispathstr = pathstr & "." & Evaluate(thischildparam)>
					<cfset thischildparamchildren = thispathstr & ".xmlchildren">
						
					<cfset thistempstruct = StructNew()>
					<cfset temparray = Duplicate(Evaluate(thisparamchildren))>
					
					<cfloop index="l" from="1" to="#arrayLen(temparray)#">
						<cfset thisname = temparray[l].xmlname>
						<cfset thisvalue = temparray[l].xmltext>
						<cfset temp = StructInsert(thistempstruct,thisname,thisvalue)>
					</cfloop>
					
					<cfset temp = StructInsert(params[thisnode],Evaluate(thisparam),Duplicate(thistempstruct),TRUE)>
				</cfif>		
			</cfloop>
		</cfloop>			
		
		<cfset instance.config = Duplicate(params)>	
		
		<cfreturn/>
	</cffunction>
	<cffunction name="getInstance" access="public" output="false" returntype="struct" displayname="getInstance" hint="Return the instance values" description="Method to return a structure of the instance variable values for debugging purposes.">
		<cfreturn instance />
	</cffunction>
</cfcomponent>