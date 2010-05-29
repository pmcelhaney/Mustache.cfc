<cfcomponent extends="mxunit.framework.TestCase">
                  
  <cffunction name="setup">
    <cfset stache = createObject("component", "Mustache").init()/>
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
  
  <cffunction name="falseSectionsAreShownIfInverted">
    <cfset template = "Ready {{^set}}set {{/set}}go!" />
    <cfset context =  { set = false }  />     
    <cfset expected = "Ready set go!" />
  </cffunction>       
   
   <cffunction name="trueSectionsAreHiddenIfInverted">
    <cfset template = "Ready {{^set}}set {{/set}}go!" />
    <cfset context =  { set = true }  />     
    <cfset expected = "Ready go!" />
  </cffunction>
  
  <cffunction name="structAsSection">
    <cfset context = {
      contact = { name = 'Jenny', phone = '867-5309'}
    } />
    <cfset template = "{{##contact}}({{name}}'s number is {{phone}}){{/contact}}">
    <cfset expected = "(Jenny's number is 867-5309)" />
  </cffunction>     
  
  <cffunction name="queryAsSection">
    <cfset contacts = queryNew("name,phone")/>
    <cfset queryAddRow(contacts)>
    <cfset querySetCell(contacts, "name", "Jenny") />
    <cfset querySetCell(contacts, "phone", "867-5309") />            
    <cfset queryAddRow(contacts)>
    <cfset querySetCell(contacts, "name", "Tom") />
    <cfset querySetCell(contacts, "phone", "555-1234") />
    <cfset context = {contacts = contacts} />
    <cfset template = "{{##contacts}}({{name}}'s number is {{phone}}){{/contacts}}">
    <cfset expected = "(Jenny's number is 867-5309)(Tom's number is 555-1234)" />
  </cffunction>   
                      
  <cffunction name="escape">
    <cfset template = "Hello, {{thing}}!" />
    <cfset context = { thing = '<b>world</b>'} />   
    <cfset expected = "Hello, &lt;b&gt;world&lt;/b&gt;!" />
  </cffunction>

  <cffunction name="dontEscape">
    <cfset template = "Hello, {{{thing}}}!" />
    <cfset context = { thing = '<b>world</b>'} />   
    <cfset expected = "Hello, <b>world</b>!" />
  </cffunction>                                      
                 
  <cffunction name="dontEscapeWithAmpersand">
    <cfset template = "Hello, {{&thing}}!" />
    <cfset context = { thing = '<b>world</b>'} />   
    <cfset expected = "Hello, <b>world</b>!" />
  </cffunction>      
  
  <cffunction name="ignoreWhitespace">
    <cfset template = "Hello, {{   thing   }}!" />
    <cfset context = { thing = 'world'} />   
    <cfset expected = "Hello, world!" />
  </cffunction>   
  
  
  <cffunction name="ignoreWhitespaceInSection">
    <cfset template = "Ready {{##  set  }}set {{/  set  }}go!" />
    <cfset context =  { set = true }  />     
    <cfset expected = "Ready set go!" />
  </cffunction> 

  <cffunction name="callAFunction">
  	<cfset context = createObject("component", "Person")/>   
		<cfset context.firstname = "Chris" />
		<cfset context.lastname = "Wanstrath" />       
	  <cfset template = "Mustache was created by {{fullname}}." /> 
		<cfset expected = "Mustache was created by Chris Wanstrath." />
  </cffunction>
  
  <cffunction name="filter">        
  	<cfset context = createObject("component", "Filter")/>       
	  <cfset template = "Hello, {{##bold}}world{{/bold}}." /> 
		<cfset expected = "Hello, <b>world</b>." />
  </cffunction>
  
  
</cfcomponent>