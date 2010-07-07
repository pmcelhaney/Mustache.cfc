<cfcomponent output="false" extends="mxunit.framework.TestSuite">      
  <cfset addAll("tests.RenderTests")>
  <cfset addAll("tests.WinnerTest") />
</cfcomponent>