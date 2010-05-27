<cfcomponent> 
  <cffunction name="init">
    <cfreturn this />
    
  </cffunction>
   
  <cffunction name="render">
    <cfargument name="template"/>
    <cfargument name="context" />   
    <cfset var tag = ""/>
    <cfset var tagName = ""/> 
    <cfset var matches = reFindNoCaseValues("{{(\w+)}}", template) />
    <cfloop condition = "arraylen(matches) gt 0" >
      <cfset tag = matches[1]/>
      <cfset tagName = matches[2] />
      <cfset template = replace(template, tag, get(tagName, context))/>
      <cfset matches = reFindNoCaseValues("{{(\w+)}}", template) />    
    </cfloop>
    <cfreturn template/>
  </cffunction>                                               
                                                  
  <cffunction name="get">
    <cfargument name="key" />
    <cfargument name="context" />   
    <cfif structKeyExists(context, key) >
      <cfreturn context[key] /> 
    <cfelse>
      <cfreturn "" />
    </cfif>
  </cffunction>

  <cffunction name="reFindNoCaseValues" access="private"> 
    <cfargument name="re" /> 
    <cfargument name="s"/> 
    <cfargument name="start" default="1" />
    <cfset var matches = reFindNoCase(re, s, 1, true) />
    <cfset var i = 0 /> 
    <cfset var result = arrayNew(1) />  
    <cfloop index="i" from="1" to="#arrayLen(matches.pos)#">
      <cfif matches.pos[i] gt 0>
        <cfset arrayAppend(result, mid(s, matches.pos[i], matches.len[i])) />     
      </cfif>    
    </cfloop>   
    <cfreturn result />                                                                
  </cffunction>
</cfcomponent>