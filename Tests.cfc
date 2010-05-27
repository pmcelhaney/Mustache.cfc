<cfcomponent extends="mxunit.framework.TestCase">
  
  <cffunction name="basic">
    <cfset stache = createObject("component", "CFStache").init()/> 
    <cfset context = { thing = 'world'} />
    <cfset result = stache.render("Hello, {{thing}}!", context)/>
    <cfset assertEquals("Hello, World!", result) />
  </cffunction>
</cfcomponent>