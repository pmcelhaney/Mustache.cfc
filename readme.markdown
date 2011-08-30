# Mustache.cfc

Chris Wanstrath's [Mustache](http://mustache.github.com/) templates for [ColdFusion](https://github.com/pmcelhaney/Mustache.cfc).

## Basic Usage                              

    <cfset template = "Hello, {{thing}}!">
    <cfset context = structNew()>
    <cfset context['thing'] = 'World'>

    <cfouptut>#mustache.render(template, context)#</cfouptut>


## Creating Views
                
Given a template named Winner.mustache:
    
    Hello {{name}}
    You have just won ${{value}}!
    {{#in_ca}}
    Well, ${{taxed_value}}, after taxes.
    {{/in_ca}}
                   

And a view named Winner.cfc:

    <cfcomponent extends="Mustache">
      <cffunction name="taxed_value">
        <cfreturn this.value * 0.6>
      </cffunction>
    </cfcomponent>
                                   
You can render the view like so:

    <cfset winner = createObject("component", "Winner")>
    <cfset winner.name = "Patrick">   
    <cfset winner.value = "1000">
    <cfset winner.in_ca = true>
    <cfoutput>#winner.render()#</cfoutput>
     
Result:
    
    Hello Patrick
    You have just won $1000!
    Well, $600, after taxes.           
   
   
   
                            
