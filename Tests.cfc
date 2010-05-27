<cfcomponent extends="mxunit.framework.TestCase">
  
  <cffunction name="basic">
    <cfset stache = createObject("component", "CFStache").init()/> 
    <cfset context = { thing = 'world'} />
    <cfset result = stache.render("Hello, {{thing}}!", context)/>
    <cfset assertEquals("Hello, World!", result) />
  </cffunction>      
  
  <cffunction name="two">
    <cfset stache = createObject("component", "CFStache").init()/> 
    <cfset context = { a = 'Jack', b = 'Jill'} />
    <cfset result = stache.render("Hello, {{a}} and {{b}}!", context)/>
    <cfset assertEquals("Hello, Jack and Jill!", result) />
  </cffunction>
</cfcomponent>