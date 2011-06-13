<cfcomponent displayname="frontcontroller" hint="Application frontcontroller component" extends="tardis.base.base">	
	<cffunction name="init" access="public" output="false" returntype="tardis.controller.frontcontroller" displayname="init" hint="Method to initialize and return component instance" description="Methods parses XML configuration file, sets instance variable values and returns component instance.">
		<cfargument name="configdirectory" required="yes" />
		<cfargument name="configfilename" required="yes" />			

		<cfset this.config(arguments.configdirectory,arguments.configfilename)>			
		
		<cfreturn this/>
	</cffunction>
	
	<cffunction name="validateGesture" access="public" output="false" displayName="validateGesture" returntype="boolean">
		<cfargument name="gesture" type="string" required="true" />
		
		<cfset var retValue = false>
		
		<cfset retValue = StructKeyExists(instance.config,arguments.gesture)>		
		
		<cfreturn retValue />		
	</cffunction>
		
	<cffunction name="validateAction" access="public" output="false" displayName="validateAction" returntype="boolean">
		<cfargument name="remotemethod" type="string" required="true" />
		<cfargument name="gesture" type="string" required="true" />
		
		<cfset var retValue = false>
		
		<cfset retValue = StructKeyExists(instance.config[arguments.remotemethod],arguments.gesture)>	
		
		<cfreturn retValue />		
	</cffunction>
	
	<cffunction name="doGesture" access="public" output="false" displayname="doGesture" hint="Perform gesture for the view" description="This method performs the gesture requested by the user by invoking the appropriate manager and methods.">
		<cfargument name="remotemethod" type="string" required="true" />
		
		<cfset var thiscomponentpath = Evaluate(this.getMethodComponentPath(arguments.remotemethod))>
			
		<cfinvoke component="#thiscomponentpath#" method="#arguments.remotemethod#">
			<cfinvokeargument name="remotemethod" value="#arguments.remotemethod#"/>
		</cfinvoke>	
		
		<cfreturn />
	</cffunction>	
	<cffunction name="dispatchView" access="public" output="false" displayname="dispatchView" hint="Dispatch view for the view, controller or model" description="This method dispatches the view requested by the user.">
		<cfargument name="remotemethod" type="string" required="true" />
		<cfargument name="gesture" type="string" required="true" />
		
		<cflock name="dispatchView" timeout="5">
			<cfset var tempstring = "">
			
			<cfset tempstring = "instance.config." & arguments.remotemethod & "." & arguments.gesture>
	
			<cfset getPageContext().forward(Evaluate(tempstring))>
		</cflock>		

		<cfreturn />
	</cffunction>	
	<cffunction name="dispatchViewMP" access="public" output="false" displayname="dispatchViewMP" hint="Dispatch view for the view, controller or model on multipart forms" description="This method dispatches the view requested by the user.">
		<cfargument name="remotemethod" type="string" required="true" />
		<cfargument name="gesture" type="string" required="true" />
		<cfargument name="requesttoken" type="string" required="false" />
		
		<cfset var tempstring = "">
		
		<cfset tempstring = "instance.config." & arguments.remotemethod & "." & arguments.gesture>
		
		<cfif IsDefined("arguments.requesttoken") AND Len(arguments.requesttoken)>
			<cflocation url="#Evaluate(tempstring)#&requesttoken=#arguments.requesttoken#" addtoken="no">
		<cfelse>
			<cflocation url="#Evaluate(tempstring)#" addtoken="no">
		</cfif>	

		<cfreturn />
	</cffunction>	
	<cffunction name="getMethodComponentPath" access="public" output="false" returntype="string" displayname="getMethodComponentPath" hint="Return the manager cfc instance location for requested gesture" description="This method returns the variable instance name for the requested manager cfc.">
		<cfargument name="thismethod" type="string" required="true" />

		<cfset var thispath = "">
		
		<cfset thispath = "instance.config." & arguments.thismethod & ".cfcinstance">
		<cfset thispath = Evaluate(thispath)>
				
		<cfreturn thispath />
	</cffunction>
</cfcomponent>