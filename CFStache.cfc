<cfcomponent> 
  <cffunction name="init">
    <cfreturn this />
    
  </cffunction>
   
  <cffunction name="render">
    <cfargument name="template"/>
    <cfargument name="context" />
    <cfset matches =reFindNoCaseValues("{{(\w+)}}", template) />
    <cfset tag = matches[1]/>
    <cfset tagName = matches[2] />
    <cfreturn replace(template, tag, context[tagName]) />
  </cffunction>                                               


  <cffunction name="reFindNoCaseValues"> 
    <cfargument name="re" /> 
    <cfargument name="s"/> 
    <cfargument name="start" default="1" />
    <cfset var matches = reFindNoCase(re, s, 1, true) />
    <cfset var i = 0 /> 
    <cfset var result = arrayNew(1) />  
    <cfloop index="i" from="1" to="#arrayLen(matches.pos)#">
      <cfset arrayAppend(result, mid(s, matches.pos[i], matches.len[i])) />
    </cfloop>   
    <cfreturn result />                                                                
  </cffunction>
</cfcomponent>