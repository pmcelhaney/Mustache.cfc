<cfcomponent> 
  <cffunction name="init">    
    <cfset variables.context = {} />
    <cfreturn this />
    
  </cffunction>
   
  <cffunction name="render">
    <cfargument name="template"/>
    <cfargument name="context" />           
    <cfset template = renderSections(template, context) />  
    <cfreturn renderTags(template, context)/>
  </cffunction>                         
       
  <cffunction name="renderSections">
    <cfargument name="template" />
    <cfargument name="context" />
    <cfset var tag = ""/>
    <cfset var tagName = ""/>                    
    <cfset var type = "" />
    <cfset var inner = "" />
    <cfset var re = "\{\{(##)(\w+)}}(.*?)\{\{/\2\}\}" />       
    <cfset  matches = ReFindNoCaseValues(template, re) />  
    <cfset variables.context = arguments.context />   
    <cfloop condition = "arraylen(matches) eq 4" >
      <cfset tag = matches[1]/>   
      <cfset type = matches[2] />
      <cfset tagName = matches[3] />   
      <cfset inner = matches[4] />
      <cfset template = replace(template, tag, "")/>
      <cfset matches = ReFindNoCaseValues(template, re) />   

    </cfloop>
    <cfreturn template/>   
  </cffunction>
   
  <cffunction name="renderTags">
    <cfargument name="template"/>
    <cfargument name="context" />
    <cfset var tag = ""/>
    <cfset var tagName = ""/>     
    <cfset var re = "\{\{(!)?(\w+)\}\}" />                     
    <cfset var matches = ReFindNoCaseValues(template, re) />
      
    <cfset variables.context = arguments.context />
    <cfloop condition = "arraylen(matches) eq 3" >
      <cfset tag = matches[1]/>   
      <cfset type = matches[2] />
      <cfset tagName = matches[3] />  
      <cfset template = replace(template, tag, renderTag(type, tagName))/>  
      <cfset matches = ReFindNoCaseValues(template, re) />    
    </cfloop>
    <cfreturn template/>  
  </cffunction>
  
  <cffunction name="renderTag">    
    <cfargument name="type" /> 
    <cfargument name="tagName" />   
    <cfif type eq "!">
      <cfreturn "" />
    <cfelse>
      <cfreturn get(tagName) & type />
    </cfif>
  </cffunction>                      
                                                  
  <cffunction name="get">
    <cfargument name="key" />
    <cfif structKeyExists(context, key) >
      <cfreturn context[key] /> 
    <cfelse>
      <cfreturn "" />
    </cfif>
  </cffunction>
  
  <cffunction
  	name="ReFindNoCaseValues"
  	access="private"
  	returntype="array"
  	output="false"
  	hint="Returns the captrued groups for each pattern match.">
    <!--- Based on Ben Nadel's code http://bennadel.com/blog/1040-REMatchGroups-ColdFusion-User-Defined-Function.htm --->
  	<cfargument name="Text"/>
  	<cfargument name="re"/>
    <cfset var results = arrayNew(1) />           
    <cfset var pattern = CreateObject("java","java.util.regex.Pattern").compile(arguments.re) />
    <cfset var matcher = pattern.matcher(arguments.text)/>
    <cfset var i = 0 />
    <cfset var nextMatch = "" />                   

    <cfif matcher.Find()>          
      <cfloop index="i" from="0" to="#matcher.groupCount()#">     
        <cfset nextMatch = matcher.group(i) />
        <cfif isDefined('nextMatch')>
          <cfset arrayAppend(results, nextMatch) />
        <cfelse>
          <cfset arrayAppend(results, "") /> 
        </cfif>    
      </cfloop>  
    </cfif>
                    
  	<cfreturn results />
  </cffunction>
</cfcomponent>