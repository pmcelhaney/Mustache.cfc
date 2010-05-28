<cfcomponent extends="mxunit.framework.TestCase">
                  
  <cffunction name="setup">
    <cfset stache = createObject("component", "CFStache").init()/>
  </cffunction>
                 
  
  <cffunction name="tearDown">
    <!--- <cfset debug(stache.reFindNoCaseValues("\{\{(!)?(\w+)\}\}", template))/>        --->
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
  
  <cffunction name="render_zero">
    <cfset template = "My value is {{value}}." /> 
    <cfset context = { value = 0 } />  
    <cfset expected = "My value is 0." />
  </cffunction>         
  
                    
  <cffunction name="comments">
    <cfset template = "What {{!the}} what?" /> 
    <cfset context = structNew() />
    <cfset context['!'] = "FAIL" />                   
    <cfset context['the'] = "FAIL" />  
    <cfset expected = "What  what?" />    
  </cffunction>
                      
  <cffunction name="falseSectionsAreHidden">
    <cfset template = "Ready {{##set}}set {{/set}}go!" />
    <cfset context =  { set = false }  />     
    <cfset expected = "Ready go!" />
  </cffunction>       
   
   <cffunction name="trueSectionsAreShown">
    <cfset template = "Ready {{##set}}set {{/set}}go!" />
    <cfset context =  { set = true }  />     
    <cfset expected = "Ready set go!" />
  </cffunction>    
  
  <cffunction name="structAsSection">
    <cfset context = {
      contact = { name = 'Jenny', phone = '867-5309'}
    } />
    <cfset template = "{{##contact}}({{name}}'s number is {{phone}}){{/contact}}">
    <cfset expected = "(Jenny's number is 867-5309)" />
     
    
  </cffunction>        
                      


                                        
                      
  <cffunction
  	name="REMatchGroups"
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

    <cfset matcher.Find()>       
  
    <cfset debug(matcher.matches()) />              
  
    <cfloop index="i" from="0" to="#matcher.groupCount()#">       
    
      <cfset arrayAppend(results, matcher.group(i)) />  
    </cfloop>  
                    
  	<cfreturn results />
  </cffunction>                    

  
</cfcomponent>