<cfcomponent extends="mxunit.framework.TestCase">
                  
  <cffunction name="setup">
    <cfset stache = createObject("component", "CFStache").init()/>
    
  </cffunction>
  
  <cffunction name="basic">     
    <cfset template = "Hello, {{thing}}!" />
    <cfset context = { thing = 'world'} />
    <cfset result = stache.render(template, context)/>
    <cfset assertEquals("Hello, World!", result) />
  </cffunction>      
  
  <cffunction name="less_basic">   
    <cfset template = "It's a nice day for {{beverage}}, right {{person}}?" />
    <cfset context = { beverage = 'soda', person = 'Bob' } />
    <cfset result = stache.render(template, context)/>
    <cfset assertEquals("It's a nice day for soda, right Bob?", result) />
  </cffunction>        
  
  <cffunction name="even_less_basic">      
     <cfset template = "I think {{name}} wants a {{thing}}, right {{name}}?">
     <cfset context = { name = 'Jon', thing = 'racecar'} />
     <cfset result = stache.render(template, context)/>
     <cfset assertEquals("I think Jon wants a racecar, right Jon?", result) />
  </cffunction>         
  
  <cffunction name="ignores_misses">      
     <cfset template = "I think {{name}} wants a {{thing}}, right {{name}}?">
     <cfset context = { name = 'Jon'} />
     <cfset result = stache.render(template, context)/>
     <cfset assertEquals("I think Jon wants a , right Jon?", result) />
  </cffunction>           
  
  <cffunction name="test_render_zero">
    <cfset template = "My value is {{value}}." /> 
    <cfset context = { value = 0 } />  
    <cfset result = stache.render(template, context)/>
    <cfset assertEquals("My value is 0.", result) />
  </cffunction>
                      

  
</cfcomponent>