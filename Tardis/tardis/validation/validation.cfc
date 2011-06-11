<cfcomponent displayname="validation" hint="Component to perform validation methods" extends="tardis.base.base">	
	<cffunction name="init" access="public" output="false" returntype="tardis.validation.validation" displayname="init" hint="Method to initialize and return the instance" description="Methods parses XML configuration file, sets instance variable values and returns component instance.">
		<cfargument name="configdirectory" required="yes" />
		<cfargument name="configfilename" required="yes" />		
				
		<cfset this.config(arguments.configdirectory,arguments.configfilename)>		
		
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="doValidation" access="public" output="false" returntype="boolean" displayname="doValidation" hint="Perform validation method and return true/false" description="Method to perform validation against regex signature defined in component instance.">
		<cfargument name="validator" type="string" required="yes" />
		<cfargument name="strinput" type="string" required="yes" />			
		
		<cfset var thisresult = false>
		<cfset var thisregex = "">
		
		<cftry>
			<cfset thisregex = "instance.config.validators" & "." & arguments.validator>
			<cfset thisregex = Evaluate(thisregex)>
			
			<cfif Len(Trim(arguments.strinput))>
				<cfif REFindNoCase(thisregex,Trim(arguments.strinput))>		
					<cfset thisresult = true>
				<cfelse>
					<cfset thisresult = false>
				</cfif>	
			</cfif>			

			<cfcatch>
				<!--- If there was an error, leave the validation as a fail and throw exception --->
				<cfset var thisresult = false>
				<cfthrow type="tardis.validation.doValidation" message="#cfcatch.message#" detail="#cfcatch.detail#">				
			</cfcatch>
		</cftry>
		
		<cfreturn thisresult />
	</cffunction>	
	
	<cffunction name="lookupDataValidation" access="public" output="false" returntype="struct" displayname="lookupDataValidation" hint="Lookup validation criteria for field and return as a struct." description="Method to lookup the declared validation criteria for a field.">
		<cfargument name="field" type="string" required="yes" />			
		
		<cfset var thisresult = StructNew()>
		<cfset var thistempstr = "">
		
		<cftry>
			<cfset thistempstr = "instance.config.datavalidation" & "." & arguments.field>
			<cfset thisresult = Evaluate(thistempstr)>

			<cfcatch>
				<!--- If there is no validator defined for fieldname, return an empty struct. If strict validation is true, exception for missing validators is delegated to validateInputData--->
				<cfset var thisresult = StructNew()>
			</cfcatch>
		</cftry>
		
		<cfreturn thisresult />
	</cffunction>	
	
	<cffunction name="lookupWildcardDataValidation" access="public" output="false" returntype="struct" displayname="lookupWildcardDataValidation" hint="Lookup validation criteria for wildcard fields and return as a struct." description="Method to lookup the declared validation criteria for a wildcard field.">
		<cfargument name="field" type="string" required="yes" />			
		
		<cfset var thisresult = StructNew()>
		<cfset var thiskeylist = "">
		<cfset var thistempstr = "">
		<cfset var thistempstr2 = "">
		<cfset var i  = "">
		
		<cftry>
			<cfset thistempstr = "instance.config.wildcarddatavalidation">			
			<cfset thistempstr2 = Evaluate(thistempstr)>
			<cfset thiskeylist = StructKeyList(thistempstr2)>
			
			<cfloop index="i" from="1" to="#ListLen(thiskeylist)#">
				<cfif arguments.field CONTAINS ListGetAt(thiskeylist,i)>
					<cfset thistempstr = "instance.config.wildcarddatavalidation." & ListGetAt(thiskeylist,i) >
					<cfset thisresult = Evaluate(thistempstr)>
				</cfif>
			</cfloop>

			<cfcatch>
				<!--- If there is no validator defined for fieldname, return an empty struct. If strict validation is true, exception for missing validators is delegated to validateInputData--->
				<cfset var thisresult = StructNew()>
			</cfcatch>
		</cftry> 
		
		<cfreturn thisresult />
	</cffunction>
	
	<cffunction name="validateInputData" access="public" output="false" returntype="boolean" displayname="validateInputData" hint="Takes a structure and validates the members against validation rules.">
		<cfargument name="datastruct" type="struct" required="yes" />	
		<cfargument name="dsObjName" type="string" required="yes" default="application.dsObj"/> <!--- />--->
		
		<cfset var thisresult = "true">
		<cfset var thisvalidationstruct = "">
		<cfset var i = "">
		<cfset var errmsg = "">
		<cfset var tempstring = "">
	
		<cftry>
			<cfloop collection="#arguments.datastruct#" item="i">
				<cfset thisvalidationstruct = this.lookupDataValidation(i)>
				
				<cfif StructIsEmpty(thisvalidationstruct) AND instance.config.wildcardvalidation.enabled>
					<cfset thisvalidationstruct = this.lookupWildcardDataValidation(i)>
				</cfif>
				
				<!--- If there is a validation definition in the config file do the validation --->
				<cfif NOT(StructIsEmpty(thisvalidationstruct))>
				
					<!--- Validation of MAX and MIN length --->
					<cfif IsDefined("thisvalidationstruct.maxlength") AND Len(thisvalidationstruct.maxlength)>						
						<cfif Len(arguments.datastruct[i]) GT thisvalidationstruct.maxlength>
							<cfset thisresult = false>
							<cfset errmsg = "Validation Error: Variable " & i & " failed maxlength criteria.">			
							<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
							<cfset Evaluate(tempstring)>
						</cfif>
					</cfif>
					
					<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength)>						
						<cfif thisvalidationstruct.minlength GT Len(arguments.datastruct[i])>
							<cfset thisresult = false>
							<cfset errmsg = "Validation Error: Variable " & i & " failed minlength criteria.">			
							<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
							<cfset Evaluate(tempstring)>
						</cfif>
					</cfif>
					<!--- END Validation of MAX and MIN length --->
					
					<!--- Validation of MAX and MIN  value --->
					<cfif IsDefined("thisvalidationstruct.maxvalue") AND Len(thisvalidationstruct.maxvalue)>						
						<cfif arguments.datastruct[i] GT thisvalidationstruct.maxvalue>
							<cfset thisresult = false>
							<cfset errmsg = "Validation Error: Variable " & i & " failed maxvalue criteria.">			
							<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
							<cfset Evaluate(tempstring)>
						</cfif>
					</cfif>
					
					<cfif IsDefined("thisvalidationstruct.minvalue") AND Len(thisvalidationstruct.minvalue)>						
						<cfif thisvalidationstruct.minvalue GT arguments.datastruct[i]>
							<cfset thisresult = false>
							<cfset errmsg = "Validation Error: Variable " & i & " failed minvalue criteria.">			
							<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
							<cfset Evaluate(tempstring)>
						</cfif>
					</cfif>
					<!--- END Validation of MAX and MIN value --->
					
					<cfif IsDefined("thisvalidationstruct.validatetype") AND Len(thisvalidationstruct.validatetype)>						
						<cfswitch expression="#thisvalidationstruct.validatetype#">
							<cfcase value="builtin">
							
								<cfif IsDefined("thisvalidationstruct.validate") AND Len(thisvalidationstruct.validate)>						
									<cfswitch expression="#thisvalidationstruct.validate#">
										<cfcase value="binary">
											<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength) AND thisvalidationstruct.minlength GT 0>	
												<cfif NOT(IsBinary(arguments.datastruct[i]))>
													<cfset thisresult = false>
													<cfset errmsg = "Validation Error: Variable " & i & " failed binary criteria.">			
													<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
													<cfset Evaluate(tempstring)>
												</cfif>
											</cfif>
										</cfcase>
										<cfcase value="xml">
											<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength) AND thisvalidationstruct.minlength GT 0>	
												<cfif NOT(IsXml(arguments.datastruct[i]))>
													<cfset thisresult = false>
													<cfset errmsg = "Validation Error: Variable " & i & " failed xml criteria.">			
													<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
													<cfset Evaluate(tempstring)>
												</cfif>
											</cfif>
										</cfcase>
										<cfcase value="alphanumeric">
											<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength) AND thisvalidationstruct.minlength GT 0>	
												<cfif isNumeric(arguments.datastruct[i])>
													<cfset thisresult = false>
													<cfset errmsg = "Validation Error: Variable " & i & " failed alpahnumeric criteria.">			
													<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
													<cfset Evaluate(tempstring)>
												</cfif>
											</cfif>
										</cfcase>
										<cfcase value="string">
											<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength) AND thisvalidationstruct.minlength GT 0>	
												<cfif NOT(isSimpleValue(arguments.datastruct[i]))>
													<cfset thisresult = false>
													<cfset errmsg = "Validation Error: Variable " & i & "failed string criteria.">			
													<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
													<cfset Evaluate(tempstring)>
												</cfif>	
											</cfif>	
										</cfcase>
										<cfcase value="numeric">
											<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength) AND thisvalidationstruct.minlength GT 0>	
												<cfif NOT(isNumeric(arguments.datastruct[i]))>
													<cfset thisresult = false>
													<cfset errmsg = "Validation Error: Variable " & i & "failed numeric criteria.">			
													<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
													<cfset Evaluate(tempstring)>
												</cfif>	
											</cfif>									
										</cfcase>
										<cfcase value="integer">
											<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength) AND thisvalidationstruct.minlength GT 0>	
												<cfif NOT(isNumeric(arguments.datastruct[i]))>
													<cfset thisresult = false>
													<cfset errmsg = "Validation Error: Variable " & i & " failed integer criteria.">			
													<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
													<cfset Evaluate(tempstring)>
												</cfif>												
												
												<cfif find(".",arguments.datastruct[i]) GT 0>
													<cfset thisresult = false>
													<cfset errmsg = "Validation Error: Variable " & i & " failed integer criteria.">			
													<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
													<cfset Evaluate(tempstring)>
												</cfif>	
											</cfif>									
										</cfcase>
										<cfcase value="float">
											<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength) AND thisvalidationstruct.minlength GT 0>	
												<cfif NOT(isNumeric(arguments.datastruct[i]))>
													<cfset thisresult = false>
													<cfset errmsg = "Validation Error: Variable " & i & " failed float criteria.">			
													<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
													<cfset Evaluate(tempstring)>
												</cfif>
												
												<cfif find(".",arguments.datastruct[i]) EQ 0>
													<cfset thisresult = false>
													<cfset errmsg = "Validation Error: Variable " & i & " failed float criteria.">			
													<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
													<cfset Evaluate(tempstring)>
												</cfif>
											</cfif>
										</cfcase>
										<cfcase value="boolean">
											<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength) AND thisvalidationstruct.minlength GT 0>	
												<cfif NOT(isBoolean(arguments.datastruct[i]))>
													<cfset thisresult = false>
													<cfset errmsg = "Validation Error: Variable " & i & " failed boolean criteria.">			
													<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
													<cfset Evaluate(tempstring)>
												</cfif>
											</cfif>
										</cfcase>
										<cfcase value="date">
											<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength) AND thisvalidationstruct.minlength GT 0>	
												<cfif NOT(isDate(arguments.datastruct[i]))>
													<cfset thisresult = false>
													<cfset errmsg = "Validation Error: Variable " & i & " failed date criteria.">			
													<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
													<cfset Evaluate(tempstring)>
												</cfif>
											</cfif>
										</cfcase>
									</cfswitch>
								</cfif>
							</cfcase>
							
							<cfcase value="regex">
								<cfif IsDefined("thisvalidationstruct.validatemethod") AND Len(thisvalidationstruct.validatemethod)>
									<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength) AND thisvalidationstruct.minlength GT 0>	
										<cfif NOT(this.doValidation(thisvalidationstruct.validatemethod, arguments.datastruct[i]))>
											<cfset thisresult = false>
											<cfset errmsg = "Validation Error: Variable " & i & " failed " & thisvalidationstruct.validatemethod& " criteria.">			
											<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
											<cfset Evaluate(tempstring)>
										</cfif>	
									</cfif>							
								</cfif>
							</cfcase>
							
							<cfcase value="userdefined">
								<cfif IsDefined("thisvalidationstruct.validatemethod") AND Len(thisvalidationstruct.validatemethod)>
									<cfif IsDefined("thisvalidationstruct.minlength") AND Len(thisvalidationstruct.minlength) AND thisvalidationstruct.minlength GT 0>	
										<cfset tempstring = "this." & thisvalidationstruct.validatemethod & "(" & arguments.datastruct[i] & ")">
										<cfset tempresult = Evaluate(tempstring)>
										
										<cfif NOT(tempresult)>
											<cfset thisresult = false>
											<cfset errmsg = "Validation Error: Variable " & i & " failed " & thisvalidationstruct.validatemethod& " criteria.">			
											<cfset tempstring = arguments.dsObjName & ".setErrorData('" & errmsg & "')">
											<cfset Evaluate(tempstring)>
										</cfif>	
									</cfif>															
								</cfif>
							</cfcase>
						</cfswitch>
					</cfif>
				<cfelse>
					<!--- If strict validation is true, throw an exception for the missing validator --->
					<cfif instance.config.strictvalidation.enabled>
						<cfthrow type="tardis.validation.validateInputDataException" message="Strict Mode Validation Exception" detail="Undefined validator for variable - (#i#).">	
					</cfif>
				</cfif>
			</cfloop>				
		
			<cfcatch>
				<cfthrow type="tardis.validation.validateInputDataException" message="#cfcatch.message#" detail="#cfcatch.detail#">	
			</cfcatch>
		</cftry>
		
		<cfreturn thisresult />
	</cffunction>
	<cffunction name="processInputData" access="public" output="false" returntype="struct" displayname="processInputData" hint="Takes a structure and processes each member against HTML and script rules.">
		<cfargument name="datastruct" type="struct" required="yes" />	
		
		<cfset var thisresult = StructNew()>
		<cfset var thisvalidationstruct = "">
		<cfset var i = "">
		<cfset var thevalue = "">
		<cfset var allowedtags = "">
		
		<cftry>
			<cfloop collection="#arguments.datastruct#" item="i">
				<cfset thisvalidationstruct = this.lookupDataValidation(i)>
				
				<cfif StructIsEmpty(thisvalidationstruct) AND instance.config.wildcardvalidation.enabled>
					<cfset thisvalidationstruct = this.lookupWildcardDataValidation(i)>
				</cfif>	
				
				<!--- If there is a validation definition in the config file do the validation --->
				<cfif NOT(StructIsEmpty(thisvalidationstruct))>
					<cfset thevalue = datastruct[i]>

					<cfif IsDefined("thisvalidationstruct.allowedtags")>
						<cfset allowedtags = thisvalidationstruct.allowedtags>
					</cfif>					
			
					<cfif IsDefined("thisvalidationstruct.allowhtml")>
						<cfif thisvalidationstruct.allowhtml>
							<cfset thevalue = this.stripTags("allow",allowedtags,thevalue)>	
						<cfelse>	
							<cfset thevalue = this.stripTags("allow","",thevalue)>	
						</cfif>						
					</cfif>	
					
					<cfif IsDefined("thisvalidationstruct.scriptsafe") AND thisvalidationstruct.scriptsafe>
						<cfset thevalue = this.safetext(URLDecode(thevalue))>	
					</cfif>	
					
					<cfif IsDefined("thisvalidationstruct.sqlsafe") AND thisvalidationstruct.sqlsafe>
						<cfif IsDefined("instance.config.params.sqlexcludedfields") AND NOT(ListFindNoCase(instance.config.params.sqlexcludedfields, i))>	
							<cfset thevalue = this.safeSQLtext(URLDecode(thevalue),1)>		
						</cfif>
					</cfif>						
					
					<cfif IsDefined("thisvalidationstruct.htmleditvalue") AND thisvalidationstruct.htmleditvalue>
						<cfset thevalue = HTMLEditFormat(thevalue)>	
					</cfif>	
					
					<cfif IsDefined("thisvalidationstruct.trimvalue") AND thisvalidationstruct.trimvalue>
						<cfset thevalue = Trim(thevalue)>		
					</cfif>	
					
					<cfset temp = StructInsert(thisresult, i, theValue)>	
				<cfelse>
					<!--- If there is no validation for this variable, apply strictest methods against it. --->		
					<cfset thevalue = datastruct[i]>		
					
					<!--- Never touch a request token or you will likely break it. --->
					<cfif CompareNoCase(i,"REQUESTTOKEN") NEQ 0>
						<cfset thevalue = this.safetext(URLDecode(thevalue))>		
	
						<cfif IsDefined("instance.config.params.sqlexcludedfields") AND NOT(ListFindNoCase(instance.config.params.sqlexcludedfields, i))>	
							<cfset thevalue = this.safeSQLtext(URLDecode(thevalue),1)>		
						</cfif>
	
						<cfset thevalue = this.stripTags("allow","",thevalue)>					
						<cfset thevalue = HTMLEditFormat(thevalue)>		
						<cfset thevalue = Trim(thevalue)>	
					</cfif>	
								
					<cfset temp = StructInsert(thisresult, i, thevalue)>		
				</cfif>	
			</cfloop>		
		
			<cfcatch>
				<cfthrow type="tardis.validation.processInputData" message="#cfcatch.message#" detail="#cfcatch.detail#">	
			</cfcatch>
		</cftry>
		
		<cfreturn thisresult />
	</cffunction>
	<cffunction name="safeText" access="public" output="false" returntype="string" displayname="safeText" hint="Takes an input string and applies safe text rules to it.">
		<cfargument name="inputstring" required="yes" type="string" />

		<cfset var mode = instance.config.params.mode>
		<cfset var badTags = instance.config.params.badtags>
		<cfset var badEvents = instance.config.params.badevents>
		<cfset var stripperRE = "">
		<cfset var theText = arguments.inputstring>	
		<cfset var obracket = find("<",theText)>		
		<cfset var badTag = "">
		<cfset var nextStart = "">		
		<cfset stripperRE = "</?(" & ListChangeDelims(badTags,"|") & ")[^>]*>">
		<cfset theText = replaceList(theText,chr(8216) & "," & chr(8217) & "," & chr(8220) & "," & chr(8221) & "," & chr(8212) & "," & chr(8213) & "," & chr(8230),"',',"","",--,--,...")>
	
		<cfif mode is "escape">
			<cfscript>
				while(obracket){
					//find the next instance of one of the bad tags
					badTag = REFindNoCase(stripperRE,theText,obracket,1);
					//if a bad tag is found, escape it
					if(badTag.pos[1]){
						theText = Replace(theText,Mid(TheText,badtag.pos[1],badtag.len[1]),HTMLEditFormat(Mid(TheText,badtag.pos[1],badtag.len[1])),"ALL");
						nextStart = badTag.pos[1] + badTag.len[1];
					}
					//if no bad tag is found, move on
					else{
						nextStart = obracket + 1;
					}
					//find the next open bracket
					obracket = find("<",theText,nextStart);
				}
			</cfscript>
		<cfelse>
			<cfset theText = REReplaceNoCase(TheText,StripperRE,"invalid","ALL")>
		</cfif>

		<cfset theText = REReplaceNoCase(theText,(ListChangeDelims(badEvents,"|")),"invalid","ALL")>

		<cfreturn theText />	
	</cffunction>
	<cffunction name="safeSQLText" access="public" output="false" returntype="string" displayname="safeSQLText" hint="Takes an input sting and applies SQL safe rules to it.">
		<cfargument name="inputstring" required="yes" type="string" />
		
		<cfset var str = arguments.inputstring>
		<cfset var i = 0>
		<cfset var patternlist = instance.config.params.sqlpatterns>
	
		<cfloop index="i" list="#patternlist#">
			<cfset str = ReplaceNoCase(str,i,instance.config.params.stringreplacement,"all")>
		</cfloop>
		
		<cfreturn str/> 	
	</cffunction>
	
	<cffunction name="stripTags" access="public" output="false" returntype="string" displayname="stripTags" hint="Takes an input string, with allowed html tags, and removes all tags except for the allowed tags.">
		<cfargument name="stripmode" required="yes" type="string" />
		<cfargument name="mytags" required="yes" type="string" />
		<cfargument name="mystring" required="yes" type="string" />
		
		<cfset var spanquotes = "([^"">]*""[^""]*"")*">
		<cfset var spanstart = "[[:space:]]*/?[[:space:]]*">
		<cfset var endstring = "[^>$]*?(>|$)">
		<cfset var x = 1>
		<cfset var currenttag = structNew()>
		<cfset var subex = "">
		<cfset var findonly = false>
		<cfset var cfversion = iif(structKeyExists(GetFunctionList(),"getPageContext"), 6, 5)>
		<cfset var backref = "\\1">
		<cfset var rexlimit = len(mystring)>

		<cfscript>	
		if (arraylen(arguments) gt 3) { findonly = arguments[4]; }
		if (cfversion gt 5) { backref = "\#backref#"; } // fix backreference for mx and later cf versions
		else { rexlimit = 19000; } // limit regular expression searches to 19000 characters to support CF 5 regex character limit
	
		if (len(trim(mystring))) {
			// initialize defaults for examining this string
			currenttag.pos = ListToArray("0");
			currenttag.len = ListToArray("0");
	
			mytags = ArrayToList(ListToArray(mytags)); // remove any empty items in the list
			if (len(trim(mytags))) {
				// turn the comma delimited list of tags with * as a wildcard into a regular expression
				mytags = REReplace(mytags,"[[:space:]]","","ALL");
				mytags = REReplace(mytags,"([[:punct:]])",backref,"ALL");
				mytags = Replace(mytags,"\*","[^$>[:space:]]*","ALL");
				mytags = Replace(mytags,"\,","[$>[:space:]]|","ALL");
				mytags = "#mytags#[$>[:space:]]";
			} else { mytags = "$"; } // set the tag list to end of string to evaluate the "allow nothing" condition
	
			// loop over the string
			for (x = 1; x gt 0 and x lt len(mystring); x = x + currenttag.pos[1] + currenttag.len[1] -1)
			{ 
				// find the next tag within rexlimit characters of the starting point
				currenttag = REFind("<#spanquotes##endstring#",mid(mystring,x,rexlimit),1,true); 
				if (currenttag.pos[1])
				{ 
					// if a tag was found, compare it to the regular expression
					subex = mid(mystring,x + currenttag.pos[1] -1,currenttag.len[1]); 
					if (stripmode is "allow" XOR REFindNoCase("^<#spanstart#(#mytags#)",subex,1,false) eq 1)
					{
						if (findonly) { return subex; } // return invalid tag as an error message
						else { // remove the invalid tag from the string
							myString = RemoveChars(myString,x + currenttag.pos[1] -1,currenttag.len[1]);
							currenttag.len[1] = 0; // set the length of the tag string found to zero because it was removed
						}
					}
				}
				// no tag was found within rexlimit characters
				// move to the next block of rexlimit characters -- CF 5 regex limitation
				else { currenttag.pos[1] = rexlimit; }
			}
		}
		if (findonly) { return ""; } // return an empty string indicating no invalid tags found
		else { return mystring; } // return the new string discluding any invalid tags
		</cfscript>	
	</cffunction>
</cfcomponent>