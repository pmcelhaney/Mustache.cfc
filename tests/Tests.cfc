<cfcomponent output="false" extends="mxunit.framework.TestSuite">
  <cfset addAll("tests.RenderTests")>
  <cfset addAll("tests.WinnerTest") />
<cfset addAll("tests.one.two.three.WinnerTest") />
</cfcomponent>