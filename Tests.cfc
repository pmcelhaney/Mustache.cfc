<cfcomponent extends="mxunit.framework.TestCase">
                  
  <cffunction name="setup">
    <cfset stache = createObject("component", "CFStache").init()/>
    
  </cffunction>
  
  <cffunction name="basic">
    <cfset context = { thing = 'world'} />
    <cfset result = stache.render("Hello, {{thing}}!", context)/>
    <cfset assertEquals("Hello, World!", result) />
  </cffunction>      
  
  <cffunction name="less_basic">
    <cfset context = { beverage = 'soda', person = 'Bob' } />
    <cfset result = stache.render("It's a nice day for {{beverage}}, right {{person}}?", context)/>
    <cfset assertEquals("It's a nice day for soda, right Bob?", result) />
  </cffunction>        
  
  <cffunction name="even_less_basic"> 
     <cfset context = { name = 'Jon', thing = 'racecar'} />
     <cfset result = stache.render("I think {{name}} wants a {{thing}}, right {{name}}?", context)/>
     <cfset assertEquals("I think Jon wants a racecar, right Jon?", result) />
  </cffunction>
  
</cfcomponent>