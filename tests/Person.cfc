<cfcomponent>

 	<cfset this.firstname = "John" />
	<cfset this.lastname = "Smith" />

	<cffunction name="fullName" >
	  <cfreturn "#this.firstname# #this.lastname#" />
	</cffunction>
</cfcomponent>