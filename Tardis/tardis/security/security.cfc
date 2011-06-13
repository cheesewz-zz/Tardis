<cfcomponent displayname="security" hint="Component to perform security validation for views and methods" extends="tardis.base.base">	
	<cffunction name="init" access="public" output="false" returntype="tardis.security.security" description="Methods parses XML configuration file, sets instance variable values and returns component instance.">
		<cfargument name="configdirectory" required="yes" />
		<cfargument name="configfilename" required="yes" />				
		
		<cfset this.config(arguments.configdirectory,arguments.configfilename)>	
		
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="getMethodRoles" access="public" output="false" returntype="string" displayname="getMethodRoles" hint="Return valid roles for method" description="Method to return a list of valid roles for a given view or gesture.">
		<cfargument name="thismanager" type="string" required="true" />
		<cfargument name="thismethod" type="string" required="true" />

		<cfset var thispath = "">
		
		<cftry>
			<cfset thispath = "instance.config." & arguments.thismanager & "." & arguments.thismethod>
			<cfset thispath = Evaluate(thispath)>
			
			<cfcatch>
				<!--- This method has no defined roles, so return empty list --->
				<cfset thispath = "">				
			</cfcatch>
		</cftry>
				
		<cfreturn thispath />
	</cffunction>
	
	<cffunction name="userHasAccess" access="public" output="false" returntype="boolean" displayname="userHasAccess" hint="Verify that user has access to requested view/method" description="Method to verify that the current user has access to the given view or gesture.">
		<cfargument name="thismanager" type="string" required="true" />
		<cfargument name="thismethod" type="string" required="true" />
		
		<cfset var i = 0>
		<cfset var result = false>
		<cfset var methodrolelist = this.getMethodRoles(arguments.thismanager,arguments.thismethod)>
		
		<cftry>
			<!--- If there is a list of roles, loop over them to see if user is in one. --->
			<cfif ListLen(methodrolelist)>
				<cfloop index="i" list="#methodrolelist#">
					<cfif IsUserInRole(i)>
						<cfset result = true>
					</cfif>
				</cfloop>	
			<!--- If no role definitions existed this defaults to open access --->	
			<cfelse>
				<cfset result = true>
			</cfif>		
			
			<cfcatch>	
				<!--- Catch error related to using cflogin framework (ie - it isn't being used) and set access to true --->
				<cfset result = true>
			</cfcatch>
		</cftry>
				
		<cfreturn result />
	</cffunction>
	
	<cffunction name="setEncryptionAlgorithm" access="public" returntype="void" output="false" displayname="setEncryptionAlgorithm" hint="Method to set the encryption algorithm for the application.">	
		
		<cfset application.encryptionalgorithm = instance.config.encryptionAlgorithm.algorithm>
		
	</cffunction>
	
	<cffunction name="getEncryptionAlgorithm" access="public" returntype="string" output="false" displayname="getEncryptionAlgorithm" hint="Method to get the encryption algorithm used by the application.">	
		
		<cfreturn application.encryptionalgorithm />
		
	</cffunction>
	
	<cffunction name="generateKey" access="public" returntype="string" output="false" displayname="generateKey" hint="Method to generate a secret key which will be used by the encryption/decryption methods in the application.">	
		
		<cfset var strKey = "">
		<cfset strKey = generateSecretKey(this.getEncryptionAlgorithm())>
		
		<cfreturn strKey />
	</cffunction>
	
	<cffunction name="setSessionKey" access="public" returntype="void" output="false" displayname="setSessionKey" hint="Method to set the encryption key used by the session.">	
		
		<cfset session.encryptionkey = this.generateKey()>
		
	</cffunction>
	
	<cffunction name="getSessionKey" access="public" returntype="string" output="false" displayname="getSessionKey" hint="Method to get the encryption key used by the session.">	
		<cfset var strResult = "">
		
		<cfif IsDefined("session.encryptionkey")>
			<cfset strResult = session.encryptionkey>
		<cfelse> 
			<!--- This should really already be in the session, but just in case... set a default. --->
			<cfset strResult = this.setSessionKey()>
		</cfif>	
		
		<cfreturn strResult />
	</cffunction>	
	
	<cffunction name="encryptValue" access="public" returntype="string" output="false" displayname="encryptValue" hint="Method to encrypt values.">	
		<cfargument name="strValue" type="string" required="yes">
		<cfargument name="bWithDelimiter" type="string" required="no" default="false">
		<cfargument name="bWithURLEncoding" type="string" required="no" default="false">
		
		<cfset var strKey = this.getSessionKey()>		
		<cfset var today = Now()>
		<cfset var strSaltedValue = arguments.strValue & "|" & today & "|" & Reverse(strValue)>
		<cfset var strResult = "">
		
		<cfif NOT(IsDefined("instance.config.encryptionEncoding.encoding"))>
			<cfset instance.config.encryptionEncoding.encoding = "Hex">
		</cfif>
		
		<cfif arguments.bWithURLEncoding>
			<cfset strResult = URLEncodedFormat(encrypt(strSaltedValue,strKey,this.getEncryptionAlgorithm(),instance.config.encryptionEncoding.encoding))>
		<cfelse>
			<cfset strResult = encrypt(strSaltedValue,strKey,this.getEncryptionAlgorithm(),instance.config.encryptionEncoding.encoding)>
		</cfif>
		
		<cfif arguments.bWithDelimiter>
			<cfset strResult = this.getEncryptedDelimiter() & strResult>
		</cfif>
		
		<cfreturn strResult />
	</cffunction>
	
	<cffunction name="decryptValue" access="public" returntype="string" output="false" displayname="decryptValue" hint="Method to decrypt values.">	
		<cfargument name="strValue" type="string" required="yes">
		<cfset var strKey = this.getSessionKey()>
		<cfset var strResult = "">
		
		<cfif NOT(IsDefined("instance.config.encryptionEncoding.encoding"))>
			<cfset instance.config.encryptionEncoding.encoding = "Hex">
		</cfif>
		
		<cfset strResult = decrypt(arguments.strValue, strKey,this.getEncryptionAlgorithm(),instance.config.encryptionEncoding.encoding)>

		<cfset strResult = ListGetAt(strResult,1,"|")>
	
		<cfif strResult contains "\">
			<cfset strResult = ListLast(strResult,"\")>		
		</cfif>
		
		<cfreturn strResult />
	</cffunction>
	
	<cffunction name="checkReferer" access="public" returntype="boolean" output="false" displayname="checkReferer" hint="Method to compare the cgi http_referer to make sure that submitting form is from current domain.">
		<cfargument name="stCGI" type="struct" required="yes">
		
		<cfset var bResult = true>
		<cfset var refererlist = instance.config.referers.refererList>
		<cfset var thisreferer = "">
		<cfset var thisserver = "">
		
		<cftry>
			<!--- Check to see if stCGI.REFERER was passed, if not set one to none --->
			<cfif IsDefined("arguments.stCGI.HTTP_REFERER") and len(arguments.stCGI.HTTP_REFERER)>		
				<cfif LCase(arguments.stCGI.HTTP_REFERER) CONTAINS "https://">
					<cfset thisreferer = listgetat(replace(LCase(arguments.stCGI.HTTP_REFERER),'https://','','all'),1,'/')>
				<cfelse>
					<cfset thisreferer = listgetat(replace(LCase(arguments.stCGI.HTTP_REFERER),'http://','','all'),1,'/')>
				</cfif>
			<cfelseif IsDefined("arguments.stCGI.REMOTE_ADDR") and len(arguments.stCGI.REMOTE_ADDR)>	
				<cfset thisreferer = arguments.stCGI.REMOTE_ADDR>
			<cfelse>
				<cfset thisreferer = "none">
			</cfif>
			
			<!--- Grab the server name for referer comparison --->
			<cfset thisserver = arguments.stCGI.SERVER_NAME>
			<cfset thisserver = LCase(thisserver)>				

			<cfif Len(refererlist)>
				<!--- If referring page isn't from our server, return false --->
				<cfif thisreferer DOES NOT CONTAIN thisserver>
					<cfif NOT ListContainsNoCase(refererlist,thisreferer,',')>
						<cfset bResult = false>						
					</cfif>		
				</cfif>	
			<cfelse>
				<!--- If referring page isn't from our server, return false --->
				<cfif thisreferer DOES NOT CONTAIN thisserver>
					<cfset bResult = false>		
				</cfif>	
			</cfif>	
			
			<cfcatch type="Any">
				<!--- If any errors caught, return false --->
				<cfset bResult = false>
			</cfcatch>
		</cftry>

		<cfreturn bResult />
	</cffunction>	
	
	<cffunction name="generateEncryptedDelimiter" access="public" returntype="string" output="false" displayname="generateEncryptedDelimiter" hint="Method to create delimiter which will be used to identify encrypted fields from unencrypted fields.">		
		<cfset var strDelimiter = "">
		<cfset var characterLength = instance.config.encryptedDelimiterSettings.characterLength>
		<cfset var useNumbers = instance.config.encryptedDelimiterSettings.useNumbers>		
		<cfset var useUpperCaseLetters = instance.config.encryptedDelimiterSettings.useUpperCaseLetters>
		<cfset var useLowerCaseLetters = instance.config.encryptedDelimiterSettings.useLowerCaseLetters>
		<cfset var CharacterList="">
		<cfset var CharacterString="">
		<cfset var Numbers="48,49,50,51,52,53,54,55,56,57">
		<cfset var UppercaseLetters="65,66,67,68,69,70,71,72,73,74,75,76,77,78,79,80,81,82,83,84,85,86,87,88,89,90">
		<cfset var LowercaseLetters="97,98,99,100,101,102,103,104,105,106,107,108,109,110,111,112,113,114,115,116,117,118,119,120,121,122">
		
		<cfif Len(characterLength)>
			<cfset characterLength = characterLength>
		<cfelse>
			<cfset characterLength = 7>
		</cfif>
		
		<cfif Len(UseNumbers)>
			<cfset UseNumbers = UseNumbers>
		<cfelse>
			<cfset UseNumbers = false>
		</cfif>		
		
		<cfif Len(UseUppercaseLetters)>
			<cfset UseUppercaseLetters = UseUppercaseLetters>
		<cfelse>
			<cfset UseUppercaseLetters = false>
		</cfif>
		
		<cfif Len(UseLowercaseLetters)>
			<cfset UseLowercaseLetters = UseLowercaseLetters>
		<cfelse>
			<cfset UseLowercaseLetters = false>
		</cfif>
			
		<cfif NOT(useNumbers) AND NOT(useUpperCaseLetters) AND NOT(useLowerCaseLetters)>
			<cfset useLowerCaseLetters = true>
		</cfif>

		<cfif UseNumbers>
			<cfset CharacterList=ListAppend(CharacterList, Numbers, ",")>
		</cfif>
	
		<cfif UseUppercaseLetters>
			<cfset CharacterList=ListAppend(CharacterList, UppercaseLetters, ",")>
		</cfif>
	
		<cfif UseLowercaseLetters>
			<cfset CharacterList=ListAppend(CharacterList, LowercaseLetters, ",")>
		</cfif>
		
		<cfset TheLength = ListLen(CharacterList)>
		
		<cfloop index="CharacterPlaces" from="1" to="#characterLength#">
			<cfset GetPosition=RandRange(1,TheLength)>
			<cfset Character=ListGetAt(CharacterList, GetPosition, ",")>
			<cfset CharacterString=ListAppend(CharacterString, Chr(Character), ",")>
		</cfloop>
	
		<cfset strDelimiter = ListChangeDelims(CharacterString, "")>
		
		<cfreturn strDelimiter />
	</cffunction>
	
	<cffunction name="setEncryptedDelimiter" access="public" returntype="void" output="false" displayname="setEncryptedDelimiter" hint="Method to set the encrypted field delimiter for the session.">	
		
		<cfset session.encrypteddelimiter = this.generateEncryptedDelimiter()>
		
	</cffunction>
	
	<cffunction name="getEncryptedDelimiter" access="public" returntype="string" output="false" displayname="getEncryptedDelimiter" hint="Method to get the encrypted delimiter currently being used by the session.">	
		<cfset var strResult = "">
		
		<cfif IsDefined("session.encrypteddelimiter")>
			<cfset strResult = session.encrypteddelimiter>
		<cfelse>
			<!--- This should really already be in the session, but just in case... set a default. --->
			<cfset strResult = "tardis_">
		</cfif>	
		
		<cfreturn strResult />
	</cffunction>
	
	<cffunction name="stripEncryptedDelimiter" access="public" returntype="string" output="false" displayname="stripEncryptedDelimiter" hint="Method that strips the encrypted field delimiter from field.">	
		<cfargument name="strValue" type="string" required="yes">
		
		<cfset var strResult = "">
		<cfset var strDelimiter = this.getEncryptedDelimiter()>
		<cfset strResult = Replace(arguments.strValue,strDelimiter,"")>		

		<cfreturn strResult />
	</cffunction>	
	
	<cffunction name="processFields" access="public" output="false" returntype="struct" displayname="processFields" hint="Method accepts struct and processes fields to decrypt any fields that are encrypted.">
		<cfargument name="cfdata" type="struct" required="true" />
		<cfargument name="bWithURLDecoding" type="string" required="no" default="false">
		
		<!--- Get the session unique delimiter that we created when the session was established. --->
		<cfset var strDelimiter = this.getEncryptedDelimiter()>
		
		<cfset var i = "" >
		<cfset var thisfield = "" >	
		<cfset var thisvalue = "">	
		<cfset var returnStruct = StructNew()>
		
		<!--- Loop over the struct of variables and decrypt any that have been flagged with the encrypted delimiter. --->
		<cfloop collection="#arguments.cfdata#" item="i">		
			<cfset thisfield = "arguments.cfdata." & i >
			<cfset thisvalue = Evaluate(thisfield)>
			
			<cfif thisvalue CONTAINS strDelimiter>				
				<!--- If values come from the URL, and flag is set, urldecode first --->
				<cfif arguments.bWithURLDecoding>
					<cfset thisvalue = URLDecode(thisvalue)>
				</cfif>
				
				<!--- Remove the delimiter string and decrypt the value we actually want. --->
				<cfset thisvalue = this.stripEncryptedDelimiter(thisvalue)>
				<cfset thisvalue = this.decryptValue(thisvalue)>
			</cfif>
			
			<cfset StructInsert(returnStruct,i,thisvalue, TRUE)>			
		</cfloop>
		
		<cfreturn returnStruct />		
	</cffunction>	
	
	<cffunction name="isUsingRequestTokens" access="public" returntype="boolean" output="false" displayname="isUsingRequestTokens" hint="Method to determine if scope passed is using request tokens or not.">	
		<cfargument name="strScope" type="string" required="yes" default="form">
		
		<cfif arguments.strScope IS "form">
			<cfreturn instance.config.requestTokens.requireFormRequestTokens />	
		<cfelseif arguments.strScope IS "url">	
			<cfreturn instance.config.requestTokens.requireURLRequestTokens />	
		<cfelse>
			<cfreturn false />
		</cfif>
	</cffunction>
	
	<cffunction name="isViewUsingRequestTokens" access="public" returntype="boolean" output="false" displayname="isViewUsingRequestTokens" hint="Method that determines if view is using request tokens, or if it has been excluded.">	
		<cfargument name="strView" type="string" required="yes" default="error">
			
 		<cfif ListContainsNoCase(instance.config.requestTokens.URLRequestTokenExcludes, arguments.strView)>
			<cfreturn false />
		<cfelse>
			<cfreturn true />
		</cfif>
	</cffunction>
	
	<cffunction name="issueRequestToken" access="public" returntype="string" output="false" displayname="issueRequestToken" hint="Method issues a request token an registers issued token in request token cache.">	
		<!--- Create an encrypted UUID for a request token. --->
		<cfset var strRequestToken = CreateUUID()>
		
		<!--- Create the session struct to keep track of tokens --->
		<cfif NOT(IsDefined("session.requesttokens"))>
			<cfset session.requesttokens = StructNew()>
		</cfif>
		
		<!--- Insert the new token into the session token struct, duplicates are not allowed and will throw an error. --->
		<cfset StructInsert(session.requesttokens,strRequestToken,"","FALSE")>
			
		<cfreturn strRequestToken />		
	</cffunction>
	
	<cffunction name="validateRequestToken" access="public" returntype="boolean" output="false" displayname="validateRequestToken" hint="Method validates whether a request token is valid or not.">	
		<cfargument name="strValue" type="string" required="yes">
		<!--- All tokens are invalid until proven otherwise. --->
		<cfset var bValid = false>		
		
		<!--- If there isn't a session tokens struct, then this token isn't valid. --->
		<cfif NOT(IsDefined("session.requesttokens"))>
			<cfset session.requesttokens = StructNew()>
			<cfset bValid = false>
		</cfif>
		
		<!--- If the token isn't registered, then we didn't create it and it is invalid. --->
		<cfif NOT(StructKeyExists(session.requesttokens,arguments.strValue))>
			<cfset bValid = false>
			<cfset this.purgeRequestTokens()>	
		<cfelse>
			<!--- If the value of the struct key is empty, that means it hasn't been used and is valid. Set the value to used so it can't be used again. --->
			<cfif NOT(Len(session.requesttokens[arguments.strValue]))>
				<cfset bValid = true>
				<cfset this.purgeRequestTokens()>				
			<!--- Token has already been used and is thus invalid for using again. --->
			<cfelseif session.requesttokens[arguments.strValue] IS "USED">	
				<cfset bValid = false>
				<cfset this.purgeRequestTokens()>	
			</cfif>			
		</cfif>		
			
		<cfreturn bValid />		
	</cffunction>		
	
	<cffunction name="purgeRequestTokens" access="public" returntype="void" output="false" displayname="purgeRequestTokens" hint="Method purges the cache of request tokens.">			
		<cftry>
			<cfset structClear(session.requesttokens)>
			<cfcatch></cfcatch>
		</cftry>
	</cffunction>	
</cfcomponent>