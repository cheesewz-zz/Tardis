<cfcomponent displayname="datastore" hint="Component for handling request and error data" extends="tardis.base.base">
	<cffunction name="getMethodData" access="public" output="false" returntype="struct" displayname="getMethodData" hint="Return data for the most recent method call" description="Method to return the data struct from the current method call.">		
		
		<cfif NOT(IsDefined("session.methoddata"))>
			<cfset session.methoddata = StructNew()>
		</cfif>
		
		<cfreturn session.methoddata />
	</cffunction>
	
	<cffunction name="setMethodData" access="public" output="false" displayname="setMethodData" hint="Set data for the current method call" description="Method to set the data struct from the current method call.">
		<cfargument name="cfdata" type="struct" required="true" />
		
		<cfset var i = "" >
		<cfset var thisfield = "" >	
		<cfset var thisvalue = "">			
		
		<!--- Since this is a new method call, flush error data from the last call --->
		<cfset this.flushErrorData()>
		<cfset this.flushMethodData()>

		<cfloop collection="#arguments.cfdata#" item="i">		
			<cfset thisfield = "arguments.cfdata." & i >
			<cfset thisvalue = Evaluate(thisfield)>	
			
			<cfif NOT(IsDefined("session.methoddata"))>
				<cfset session.methoddata = StructNew()>
			</cfif>
	
			<cfset StructInsert(session.methoddata,i,thisvalue, TRUE)>			
		</cfloop>
				
		<cfreturn />
	</cffunction>
	
	<cffunction name="flushMethodData" access="public" output="false" displayname="flushMethodData" hint="Flush method data from previous method call" description="Method to flush the data struct from the current method call.">
		<cfif NOT(IsDefined("session.methoddata"))>
			<cfset session.methoddata = StructNew()>
		</cfif>
		
		<cfset StructClear(session.methoddata)>
		<cfreturn />
	</cffunction>
	
	<cffunction name="getCallBackData" access="public" output="false" returntype="struct" displayname="getCallBackData" hint="Return data that was set in the callback" description="Method to return the data struct from the current callback.">		
		<cfif NOT(IsDefined("session.callbackdata"))>
			<cfset session.callbackdata = StructNew()>
		</cfif>
		
		<cfreturn session.callbackdata />
	</cffunction>
	
	<cffunction name="getCallBackField" access="public" output="false" returntype="any" displayname="getCallBackField" hint="Return data for field that was set in the callback"  description="Method to return the data struct field from the current callback.">		
		<cfargument name="fieldname" type="string" required="true">
		
		<cfset var returnvalue = "">
		
		<cftry>
			<cfif NOT(IsDefined("session.callbackdata"))>
				<cfset session.callbackdata = StructNew()>
			</cfif>
		
			<cfset returnvalue = session.callbackdata[arguments.fieldname]>
			<cfcatch>
				<!--- If there was an error just return the empty string --->
			</cfcatch>
		</cftry>
		
		<cfreturn returnvalue />
	</cffunction>
	
	<cffunction name="setCallBackData" access="public" output="false" displayname="setCallBackData" hint="Set data for the callback" description="Method to set the data struct from the current callback.">
		<cfargument name="fieldname" type="string" required="true">
		<cfargument name="fieldvalue" type="any" required="true">
		
		<cfif NOT(IsDefined("session.callbackdata"))>
			<cfset session.callbackdata = StructNew()>
		</cfif>
		
		<cfset StructInsert(session.callbackdata, arguments.fieldname, arguments.fieldvalue, TRUE)>
				
		<cfreturn />
	</cffunction>
	
	<cffunction name="flushCallBackData" access="public" output="false" displayname="flushCallBackData" hint="Flush data from the callback" description="Method to flush the data struct from the current callback.">
		<cfif NOT(IsDefined("session.callbackdata"))>
			<cfset session.callbackdata = StructNew()>
		</cfif>
		
		<cfset StructClear(session.callbackdata)>
		<cfreturn />
	</cffunction>
	
	<cffunction name="getErrorData" access="public" output="false" returntype="array" displayname="getErrorData" hint="Return error data from the method call" description="Method to return the data struct from the current error.">
		<cfif NOT(IsDefined("session.errordata"))>
			<cfset session.errordata = ArrayNew(1)>
		</cfif>
		
		<cfreturn session.errordata />
	</cffunction>
	
	<cffunction name="setErrorData" access="public" output="false" displayname="setErrorData" hint="Sets error data for the method call" description="Method to set the data struct from the current error.">
		<cfargument name="errordetail" type="string" required="true">		
		
		<cfset var thiserror = StructNew()>
		
		<cfif NOT(IsDefined("session.errordata"))>
			<cfset session.errordata = ArrayNew(1)>
		</cfif>
		
		<cfset thiserror.errordatetime = Now()>
		<cfset thiserror.errordetail = arguments.errordetail>		
		<cfset ArrayAppend(session.errordata, thiserror)>
				
		<cfreturn />		
	</cffunction>
	
	<cffunction name="flushErrorData" access="public" output="false" displayname="flushErrorData" hint="Flush error data for the method call" description="Method to flush the data struct from the current error.">
		<cfif NOT(IsDefined("session.errordata"))>
			<cfset session.errordata = ArrayNew(1)>
		</cfif>
		
		<cfset ArrayClear(session.errordata)>
		<cfreturn />
	</cffunction>

	<cffunction name="getServiceMessage" access="public" output="false" returntype="string" displayname="getServiceMessage" hint="Get service message for the method call" description="Method to get the service message for the current method call.">
		<cfreturn session.servicemessage />
	</cffunction>
	
	<cffunction name="setServiceMessage" access="public" output="false" displayname="setServiceMessage" hint="Sets service message for the method call"  description="Method to set the service message for the current method call.">
		<cfargument name="servicemessage" type="string" required="true">
		
		<cfset session.servicemessage = arguments.servicemessage>
		
		<cfreturn />
	</cffunction>
	
	<cffunction name="flushServiceMessage" access="public" output="false" displayname="flushServiceMessage" hint="Flush service message for the method call" description="Method to flush the service message for the current method call.">
	
		<cfset session.servicemessage = "">
		
		<cfreturn />
	</cffunction>	
</cfcomponent>