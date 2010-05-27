<cfcomponent extends="mxunit.framework.TestCase">
                  
  <cffunction name="setup">
    <cfset stache = createObject("component", "CFStache").init()/>
    
  </cffunction>
                 
  
  <cffunction name="tearDown">
    <cfset assertEquals(expected, stache.render(template, context)) />
  </cffunction>
  
  <cffunction name="basic">     
    <cfset template = "Hello, {{thing}}!" />
    <cfset context = { thing = 'world'} />
    <cfset expected = "Hello, World!" />
  </cffunction>      
  
  <cffunction name="less_basic">   
    <cfset template = "It's a nice day for {{beverage}}, right {{person}}?" />
    <cfset context = { beverage = 'soda', person = 'Bob' } />
    <cfset expected = "It's a nice day for soda, right Bob?"/>
  </cffunction>        
  
  <cffunction name="even_less_basic">      
     <cfset template = "I think {{name}} wants a {{thing}}, right {{name}}?">
     <cfset context = { name = 'Jon', thing = 'racecar'} />
     <cfset expected = "I think Jon wants a racecar, right Jon?" />
  </cffunction>         
  
  <cffunction name="ignores_misses">      
     <cfset template = "I think {{name}} wants a {{thing}}, right {{name}}?">
     <cfset context = { name = 'Jon'} />
     <cfset expected = "I think Jon wants a , right Jon?" />
  </cffunction>           
  
  <cffunction name="test_render_zero">
    <cfset template = "My value is {{value}}." /> 
    <cfset context = { value = 0 } />  
    <cfset expected = "My value is 0." />
  </cffunction>
                      

  
</cfcomponent>