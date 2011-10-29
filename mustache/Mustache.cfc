<!---
Mustache.cfc
https://github.com/pmcelhaney/Mustache.cfc

The MIT License

Copyright (c) 2009 Chris Wanstrath (Ruby)
Copyright (c) 2010 Patrick McElhaney (ColdFusion)

Permission is hereby granted, free of charge, to any person obtaining
a copy of this software and associated documentation files (the
"Software"), to deal in the Software without restriction, including
without limitation the rights to use, copy, modify, merge, publish,
distribute, sublicense, and/or sell copies of the Software, and to
permit persons to whom the Software is furnished to do so, subject to
the following conditions:

The above copyright notice and this permission notice shall be
included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND,
EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF
MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND
NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE
LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION
OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION
WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
--->

<cfcomponent>

	<!---
	reference for string building
	http://www.aliaspooryorik.com/blog/index.cfm/e/posts.details/post/string-concatenation-performance-test-128
	 --->

	<cfset variables.SectionRegEx = CreateObject("java","java.util.regex.Pattern").compile("\{\{(##|\^)\s*(\w+)\s*}}(.*?)\{\{/\s*\2\s*\}\}", 32)>
	<cfset variables.TagRegEx = CreateObject("java","java.util.regex.Pattern").compile("\{\{(!|\{|&|\>)?\s*(\w+).*?\}?\}\}", 32) />

  <cffunction name="init" output="false">
    <cfreturn this />
  </cffunction>

  <cffunction name="render" output="false">
    <cfargument name="template" default="#readMustacheFile(ListLast(getMetaData(this).name, '.'))#"/>
    <cfargument name="context" default="#this#"/>
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
      <cfset matches = ReFindNoCaseValues(template, variables.SectionRegEx)>
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
		<cfset var ctx = get(arguments.tagName, context) />
		<cfif isStruct(ctx) and !StructIsEmpty(ctx)>
			<cfreturn render(arguments.inner, ctx) />
		<cfelseif isQuery(ctx) AND ctx.recordCount>
			<cfreturn renderQuerySection(arguments.inner, ctx) />
		<cfelseif isArray(ctx) and !ArrayIsEmpty(ctx)>
			<cfreturn renderArraySection(arguments.inner, ctx) />
		<cfelseif structKeyExists(arguments.context, arguments.tagName) and isCustomFunction(arguments.context[arguments.tagName])>
			<cfreturn evaluate("context.#tagName#(inner)") />
		</cfif>
		<cfif convertToBoolean(ctx) xor arguments.type eq "^">
			<cfreturn inner />
		</cfif>
		<cfreturn "" />
	</cffunction>

	<cffunction name="convertToBoolean">
		<cfargument name="value"/>
		<cfif isBoolean(value)>
			<cfreturn value />
		</cfif>
		<cfif IsSimpleValue(value)>
			<cfreturn value neq "" />
		</cfif>
		<cfreturn false>
	</cffunction>

  <cffunction name="renderQuerySection" access="private" output="false">
    <cfargument name="template"/>
    <cfargument name="context"/>
    <cfset var result = [] />
    <cfloop query="context">
      <cfset ArrayAppend(result, render(template, context)) />
    </cfloop>
    <cfreturn ArrayToList(result, "") />
  </cffunction>

  <cffunction name="renderArraySection" access="private" output="false">
    <cfargument name="template"/>
    <cfargument name="context"/>
    <cfset var result = [] />
    <cfset var item = "" />
    <cfloop array="#context#" index="item">
      <cfset ArrayAppend(result, render(template, item)) />
    </cfloop>
    <cfreturn ArrayToList(result, "") />
  </cffunction>


  <cffunction name="renderTags" access="private" output="false">
    <cfargument name="template"/>
    <cfargument name="context" />
    <cfset var tag = ""/>
    <cfset var tagName = ""/>
    <cfset var matches = arrayNew(1) />
    <cfloop condition = "true" >
      <cfset matches = ReFindNoCaseValues(template, variables.TagRegEx) />
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
    <cfelseif type eq ">">
      <cfreturn render(readMustacheFile(tagName), context) />
    <cfelse>
      <cfreturn htmlEditFormat(get(tagName, context)) />
    </cfif>
  </cffunction>

  <cffunction name="readMustacheFile" access="private" output="false">
    <cfargument name="filename" />
    <cfset var template="" />
    <cffile action="read" file="#getDirectoryFromPath(getMetaData(this).path)##filename#.mustache" variable="template"/>
    <cfreturn trim(template)/>
  </cffunction>

  <cffunction name="get" access="private" output="false">
    <cfargument name="key" />
    <cfargument name="context"/>
    <cfif isStruct(context) && structKeyExists(context, key) >
      <cfif isCustomFunction(context[key])>
        <cfreturn evaluate("context.#key#('')")>
      <cfelse>
        <cfreturn context[key]/>
      </cfif>
    <cfelseif isQuery(context)>
			<cfif listContainsNoCase(context.columnList, key)>
      	<cfreturn context[key][context.currentrow] />
    	<cfelse>
				<cfreturn "" />
	    </cfif>
		<cfelse>
      <cfreturn "" />
    </cfif>
  </cffunction>

  <cffunction name="ReFindNoCaseValues" access="private" output="false">
    <cfargument name="text"/>
    <cfargument name="re"/>
    <cfset var results = arrayNew(1) />
    <cfset var matcher = arguments.re.matcher(arguments.text)/>
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