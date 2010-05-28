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
    <cfset var matches = arrayNew(1)  /> 

    <cfloop condition = "true" >    
      <cfset matches = ReFindNoCaseValues(template, "\{\{(##)(\w+)}}(.*?)\{\{/\2\}\}")>
      <cfif arrayLen(matches) eq 0>
        <cfbreak>
      </cfif>
      <cfset tag = matches[1]/>   
      <cfset type = matches[2] />
      <cfset tagName = matches[3] />   
      <cfset inner = matches[4] />
      <cfset template = replace(template, tag, renderSection(tagName, inner, context))/>
    </cfloop>
    <cfreturn template/>   
  </cffunction>                                                             
  
  <cffunction name="renderSection">      
    <cfargument name="tagName"/>
    <cfargument name="inner"/>           
    <cfargument name="context" />
    <cfset var ctx = get(tagName, context) /> 
    <cfset var result = "" />
    <cfif isStruct(ctx)>
      <cfreturn render(inner, ctx)>  
    <cfelseif isQuery(ctx)>         
      <cfloop query="ctx">
        <cfset result &= render(inner, ctx) /> <!--- should probably use StringBuilder for performance --->
      </cfloop>
      <cfreturn result/>
    <cfelseif ctx>
      <cfreturn inner />
    <cfelse>
      <cfreturn "" />
    </cfif>
  </cffunction>          
                         
  <cffunction name="renderTags">
    <cfargument name="template"/>
    <cfargument name="context" />
    <cfset var tag = ""/>
    <cfset var tagName = ""/>     
    <cfset var matches = arrayNew(1) />
    
    <cfloop condition = "true" >    
      <cfset matches = ReFindNoCaseValues(template, "\{\{(!|\{)?(\w+)\}?\}\}") />   
      <cfif arrayLen(matches) eq 0>
        <cfbreak>
      </cfif>
      <cfset tag = matches[1]/>   
      <cfset type = matches[2] />
      <cfset tagName = matches[3] />  
      <cfset template = replace(template, tag, renderTag(type, tagName, context))/>  
    </cfloop>
    <cfreturn template/>  
  </cffunction>
  
  <cffunction name="renderTag">    
    <cfargument name="type" /> 
    <cfargument name="tagName" /> 
    <cfargument name="context" />  
    <cfif type eq "!">
      <cfreturn "" />
    <cfelseif type eq "{"> 
      <cfreturn get(tagName, context) />
    <cfelse> 
      <cfreturn htmlEditFormat(get(tagName, context)) />
    </cfif>
  </cffunction>                      
                                                  
  <cffunction name="get">
    <cfargument name="key" />
    <cfargument name="context"/>
    <cfif isStruct(context) && structKeyExists(context, key) >
      <cfreturn context[key] />       
    <cfelseif isQuery(context)>
      <cfreturn context[key][context.currentrow] />
    <cfelse>
      <cfreturn "" />
    </cfif>
  </cffunction>
  
  <cffunction
  	name="ReFindNoCaseValues"
  	access="private"
  	output="false">
  	<cfargument name="text"/>
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