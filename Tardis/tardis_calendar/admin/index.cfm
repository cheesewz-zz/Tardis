<cfparam name="action" default="view.homepage">

<cftry>
	<!--- Actions should all be a . delimited value, if not set error and dispatch the homepage --->
	<cfif ListLen(action,".") NEQ 2>
		<cfset action = "view.homepage">
		<cfset application.dsObj.setErrorData("Error. Invalid action.")>
		<cfset application.logObj.doLog("Warning", "Error. Invalid action.")>	
	</cfif>
	
	<!--- Set the action and mapping values from the action parameter --->
	<cfset thisaction = ListGetAt(action,1,".")>
	<cfset thismapping = ListGetAt(action,2,".")>
	
	<cfcatch>
		<!--- Catch and errors and dispatch homepage --->
		<cfset thisaction = "view">
		<cfset thismapping = "homepage">
		<cfset application.dsObj.setErrorData("Error. Invalid action.")>
		<cfset application.logObj.doLog("Warning", cfcatch)>	
	</cfcatch>
</cftry>

<cfswitch expression="#thisaction#">
	<!--- Since the action is a view, use the dispatchView method--->
	<cfcase value="view">
		<cftry>
			<!--- Validate that a valid view has been requested or throw to error --->
			<cfif NOT(application.fcObj.validateAction("viewManager",thismapping))>
				<cfset errors = true>
				<cfset application.dsObj.setErrorData("Error. Invalid View.")>
				<cfset application.logObj.doLog("Warning", "Error. Invalid View.")>	
				<cfset application.fcObj.dispatchView("viewManager","error")>
			</cfif>
			
			<!--- If view is using request tokens, verify the request token --->
			<cfif application.secObj.isUsingRequestTokens("url") AND application.secObj.isViewUsingRequestTokens(thismapping)>
				<cfif NOT(IsDefined("url.requesttoken"))>
					<cfset url.requesttoken = "NOT ISSUED">
				</cfif>
				
				<cfset tokenvalid = application.secObj.validateRequestToken(url.requesttoken)>				
				
				<cfif NOT(tokenvalid)>
					<cfset errors = true>
					<cfset application.dsObj.setErrorData("Error. Invalid Request Token.")>
					<cfset application.logObj.doLog("Warning", "Error. Invalid Request Token.")>	
					<cfset application.fcObj.dispatchView("viewManager","error")>
				</cfif>
			<cfelse>
				<cfset application.secObj.purgeRequestTokens()>
			</cfif>
			
			<!--- Validate user access to view and dispatch view --->
			<cfif application.secObj.userHasAccess("viewManager",thismapping)>
				<!--- Process encrypted/unencrypted values and return for validation --->
				<cfset urldata = application.secObj.processFields(url)>	
				
				<!--- Process fields for sql,xss,html,trim and htmleditformat prior to validation --->
				<cfset urldata = application.valObj.processInputData(urldata)>	
			
				<!--- Validate input from the url scope to make sure variables comply with rules --->
				<cfif NOT(application.valObj.validateInputData(urldata))>
					<cfset application.dsObj.setErrorData("Error. Invalid Data.")>
					<cfset application.fcObj.dispatchView("viewManager","error")>
				</cfif>			
			
				<cfset application.dsObj.setMethodData(urldata)>
				<cfset application.fcObj.dispatchView("viewManager",thismapping)>
			<!--- User doesn't have access, set an error and dispatch error view --->
			<cfelse>
				<cfset application.dsObj.setErrorData("Error. Unauthorized User.")>
				<cfset application.logObj.doLog("Error", "Unauthorized User attempting to access View.")>	
				<cfset application.fcObj.dispatchView("viewManager","error")>
			</cfif>	
			
			<cfcatch type="any">	
				<!--- Catch invalid view errors and dispatch error page --->
				<cfif LCase(cfcatch.message)  CONTAINS "is undefined">
					<cfset application.dsObj.setErrorData("Error. Undefined View.")>
					<cfset application.logObj.doLog("Warning", cfcatch)>	
					<cfset application.fcObj.dispatchView("viewManager","error")>
				<cfelse>
					<cfset application.dsObj.setErrorData("Error. Unspecified Error. Please view the error logs.")>
					<cfset application.logObj.doLog("Warning", cfcatch)>	
					<cfset application.fcObj.dispatchView("viewManager","error")>
				</cfif>
			</cfcatch>
		</cftry>	
	</cfcase>
	<!--- Since the action is a form, use the doGesture method --->
	<cfcase value="form">		
		<cftry>
			<!--- Required form variables, throw if not passed --->
			<cfparam name="form.remotemethod">
			<cfparam name="form.componentmethod">
			<cfset errors = false>
			
			<!--- Validate that a valid view has been requested or throw to error --->
			<cfif NOT(application.fcObj.validateGesture(form.remotemethod))>
				<cfset errors = true>
				<cfset application.dsObj.setErrorData("Error. Invalid Gesture.")>
				<cfset application.logObj.doLog("Warning", "Error. Invalid Gesture.")>	
				<cfset application.fcObj.dispatchView("viewManager","error")>
			</cfif>
			
			<!--- If form is using request tokens, verify the request token --->
			<cfif application.secObj.isUsingRequestTokens("form")>
				<cfif NOT(IsDefined("form.requesttoken"))>
					<cfset form.requesttoken = "NOT ISSUED">
				</cfif>
				
				<cfset tokenvalid = application.secObj.validateRequestToken(form.requesttoken)>				
				
				<cfif NOT(tokenvalid)>
					<cfset errors = true>
					<cfset application.dsObj.setErrorData("Error. Invalid Request Token.")>
					<cfset application.logObj.doLog("Warning", "Error. Invalid Request Token.")>	
					<cfset application.fcObj.dispatchView("viewManager","error")>
				</cfif>
			</cfif>
			
			<!--- Process encrypted/unencrypted values and return for validation --->
			<cfset formdata = application.secObj.processFields(form)>		
			
			<!--- Process fields for sql,xss,html,trim and htmleditformat prior to validation --->
			<cfset formdata = application.valObj.processInputData(formdata)>		
			
			<!--- Validate input from the form scope to make sure variables comply with rules --->
			<cfif NOT(application.valObj.validateInputData(formdata))>
				<cfset errors = true>
				<cfset application.logObj.doLog("Warning", "Error. Invalid Data.")>	
				<cfset application.fcObj.dispatchView("viewManager","error")>
			</cfif>
			
			<cfcatch type="any">	
				<!--- Handle error and dispatch error view --->
				<cfif LCase(cfcatch.message) CONTAINS "componentmethod">
					<cfset application.dsObj.setErrorData("Error. Undefined Component Method.")>
					<cfset application.logObj.doLog("Warning", cfcatch)>	
					<cfset application.fcObj.dispatchView("viewManager","error")>
				<cfelseif LCase(cfcatch.message) CONTAINS "remotemethod">
					<cfset application.dsObj.setErrorData("Error. Undefined Remote Method.")>
					<cfset application.logObj.doLog("Warning", cfcatch)>	
					<cfset application.fcObj.dispatchView("viewManager","error")>
				<cfelse>
					<cfset application.dsObj.setErrorData("Error. Unspecified Error. Please view the error logs.")>
					<cfset application.logObj.doLog("Warning", cfcatch)>	
					<cfset application.fcObj.dispatchView("viewManager","error")>
				</cfif>
			</cfcatch>
		</cftry>		
		
		<!--- If the form contains attachment(s), run the filehandling script --->		
		<cfif IsDefined("CGI.CONTENT_TYPE") AND CGI.CONTENT_TYPE CONTAINS "multipart/form-data" AND NOT(errors)>
			<cfinclude template="/tardis/cflibs/_fileHandler.cfm">
		</cfif>		
		
		<cftry>
			<!--- Validate user access to gesture and doGesture --->
			<cfif application.secObj.userHasAccess(form.remotemethod,form.componentmethod) AND NOT(errors)>
				<cfset application.dsObj.setMethodData(formdata)>
				<cfset application.fcObj.doGesture(form.remotemethod)>
				<cfset status = application.dsObj.getServiceMessage()>		
				
				<cfif application.secObj.isUsingRequestTokens("url")>		
					<cfset requesttoken = URLEncodedFormat(application.secObj.issueRequestToken())>				
					<cfset application.fcObj.dispatchViewMP(form.remotemethod,status,requesttoken)>	
				<cfelse>		
					<cfset application.fcObj.dispatchViewMP(form.remotemethod,status)>	
				</cfif>	
			<!--- User doesn't have access to gesture, set an error and dispatch error view --->
			<cfelse>
				<cfset application.dsObj.setErrorData("Error. Unauthorized Method.")>
				<cfset application.logObj.doLog("Warning", "Error. Unauthorized Method Call.")>	
				<cfset application.fcObj.dispatchView("viewManager","error")>
			</cfif>	
			
			<cfcatch type="any">
				<!--- Handle error and dispatch error view --->	
				<cfif LCase(cfcatch.message) CONTAINS "is undefined">
					<cfset application.dsObj.setErrorData("Error. Undefined Component Method.")>
					<cfset application.logObj.doLog("Warning", cfcatch)>	
					<cfset application.fcObj.dispatchView("viewManager","error")>
				</cfif>
			</cfcatch>
		</cftry>
	</cfcase>
</cfswitch>