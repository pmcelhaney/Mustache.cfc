<cfcomponent extends="mxunit.framework.TestCase">
  <cffunction name="canonincalExample">
    <cfset winner = createObject("component", "Winner").init()/>
    <cfset winner.name = "Patrick" />
    <cfset winner.value = 10000 />
    <cfset winner.taxed_value = 10000 - 10000 * 0.4/>
    <cfset winner.in_ca = true />
    <!--- TODO: Technically, there shouldn't be newlines after "$10000!" and "taxes." (going by the ctemplate spec) --->
    <cfset expected = "Hello Patrick
You have just won $10000!

Well, $6000, after taxes.
" />
    <cfset assertEquals(expected, winner.render()) />
  </cffunction>

</cfcomponent>