
<cfset valObj = CreateObject("component","tardis.validation.validation").init(application.configdirectory,application.globals.validationconfigfile)>

<cfset testStruct = StructNew()>
<cfset structInsert(testStruct, "vargroup1_first", "astring")>
<cfset structInsert(testStruct, "vargroup99_second", "2222")>

<cfset result = valObj.validateInputData(testStruct)>

<cfoutput>#result#</cfoutput>

<cfimport prefix="layout" taglib="/tardis_sampleapp/system/cfpagelets"> 
<layout:error dsObj="application.dsObj">
<cfset application.dsObj.flushErrorData()>
<!--- <cfdump var="#valObj.getInstance()#"> --->