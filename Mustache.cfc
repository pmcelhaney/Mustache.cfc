<cfcomponent>

  <cffunction name="init" output="false">
    <cfset variables.context = {} />
    <cfreturn this />
  </cffunction>
  
  <cffunction name="render" output="false">
    <cfargument name="template"/>
    <cfargument name="context" />
    <cfset template = renderSections(template, context) />
    <cfreturn renderTags(template, context)/>
  </cffunction>
  
  <cffunction name="renderSections" access="private" output="false">
    <cfargument name="template" />
    <cfargument name="context" />
    <cfset var tag = ""/>
    <cfset var tagName = ""/>                    
    <cfset var type = "" />
    <cfset var inner = "" />
    <cfset var matches = arrayNew(1) />
    <cfloop condition = "true" >
      <cfset matches = ReFindNoCaseValues(template, "\{\{(##|\^)\s*(\w+)\s*}}(.*?)\{\{/\s*\2\s*\}\}")>
      <cfif arrayLen(matches) eq 0>
        <cfbreak>
      </cfif>
      <cfset tag = matches[1] />
      <cfset type = matches[2] />
      <cfset tagName = matches[3] />
      <cfset inner = matches[4] />
      <cfset template = replace(template, tag, renderSection(tagName, type, inner, context))/>
    </cfloop>
    <cfreturn template/>
  </cffunction>                                                             
  
  <cffunction name="renderSection" access="private" output="false">
    <cfargument name="tagName"/>
    <cfargument name="type"/>
    <cfargument name="inner"/>
    <cfargument name="context"/>
    <cfset var ctx = get(tagName, context) /> 
    <cfif isStruct(ctx)>
      <cfreturn render(inner, ctx)>
    <cfelseif isQuery(ctx)>
      <cfreturn renderQuerySection(inner, ctx) />
    <cfelseif isArray(ctx)>                                                                                                         
      <cfreturn renderArraySection(inner, ctx) />
    <cfelseif isFunction(context[tagName])>
      <cfreturn evaluate("context.#tagName#(inner)") />
    <cfelseif ctx xor type eq "^">
      <cfreturn inner />
    <cfelse>
      <cfreturn "" />
    </cfif>
  </cffunction> 
  
  <cffunction name="renderQuerySection" access="private" output="false">
    <cfargument name="template"/>
    <cfargument name="context"/>
    <cfset var result = "" />
    <cfloop query="context">
      <cfset result &= render(template, context) /> <!--- TODO: should probably use StringBuilder for performance --->
    </cfloop>
    <cfreturn result/>
  </cffunction>  
  
  <cffunction name="renderArraySection" access="private" output="false">
    <cfargument name="template"/>
    <cfargument name="context"/>
    <cfset var result = "" /> 
    <cfset var item = "" />
    <cfloop array="#context#" index="item">
      <cfset result &= render(template, item) /> <!--- TODO: should probably use StringBuilder for performance --->
    </cfloop>
    <cfreturn result/>
  </cffunction>
  
  
  <cffunction name="renderTags" access="private" output="false">
    <cfargument name="template"/>
    <cfargument name="context" />
    <cfset var tag = ""/>
    <cfset var tagName = ""/>     
    <cfset var matches = arrayNew(1) />
    <cfloop condition = "true" >    
      <cfset matches = ReFindNoCaseValues(template, "\{\{(!|\{|&)?\s*(\w+)\s*\}?\}\}") />   
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
  
  <cffunction name="renderTag" access="private" output="false">
    <cfargument name="type" />
    <cfargument name="tagName" />
    <cfargument name="context" />
    <cfif type eq "!">
      <cfreturn "" />
    <cfelseif type eq "{" or type eq "&">
      <cfreturn get(tagName, context) />
    <cfelse>
      <cfreturn htmlEditFormat(get(tagName, context)) />
    </cfif> 
  </cffunction>
  
  <cffunction name="get" access="private" output="false">
    <cfargument name="key" />
    <cfargument name="context"/>
    <cfif isStruct(context) && structKeyExists(context, key) >
      <cfif isFunction(context[key])> 
        <cfreturn evaluate("context.#key#('')")>
      <cfelse>
        <cfreturn context[key]/>
      </cfif>
    <cfelseif isQuery(context)>
      <cfreturn context[key][context.currentrow] />
    <cfelse>
      <cfreturn "" />
    </cfif>
  </cffunction>
  
  <cffunction name="ReFindNoCaseValues" access="private" output="false">
    <cfargument name="text"/>
    <cfargument name="re"/>
    <cfset var results = arrayNew(1) />
    <!--- TODO: Pass in the compiled pattern instead of recompiling every call. --->
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
  
  <!--- TODO: Find a good way to determine whether an object is a function --->
  <cffunction name="isFunction" access="private" output="false">
    <cfargument name="object" />
    <cfreturn not (isSimpleValue(object) or isStruct(object) or isQuery(object) or isArray(object)) />
  </cffunction>
  
</cfcomponent>