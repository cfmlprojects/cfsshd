<cfcomponent displayname="TestCfsshd"  extends="mxunit.framework.TestCase">

	<cfimport taglib="/cfsshd/tag/cfsshd" prefix="sh" />

	<cffunction name="setUp" returntype="void" access="public">
	</cffunction>

	<cffunction name="tearDown" returntype="void" access="public">
		<sh:sshd action="stop"
			port="2022"/>
	</cffunction>

	<cffunction name="testStart">
		<sh:sshd action="start"
			port="2022"/>
		<cfset debug(sshd) />
	</cffunction>

	<cffunction name="testShell">
		<sh:sshd action="start"
			port="2022"/>
		<cftry>
			<sh:sshd action="shell"
				host="localhost"
				username="test"
				password="test"
				userinput="ls"
				port="2022"/>
				<cfset debug(sshd) />
		<cfcatch>
			<sh:sshd action="stop"
				port="2022"/>
			<cfrethrow />
		</cfcatch>
		</cftry>
		<sh:sshd action="stop"
			port="2022"/>

		<cfset debug(sshd) />
	</cffunction>

	<cffunction name="testExec">
		<sh:sshd action="start"
			port="2022"/>
		<cftry>
			<sh:sshd action="exec"
				host="localhost"
				username="test"
				password="test"
				userinput="ls"
				port="2022"/>
				<cfset debug(sshd) />
		<cfcatch>
			<sh:sshd action="stop"
				port="2022"/>
			<cfrethrow />
		</cfcatch>
		</cftry>
		<sh:sshd action="stop"
			port="2022"/>

		<cfset debug(sshd) />
	</cffunction>

	<cffunction name="testAuthenticator">
		<sh:sshd action="destroy" />
		<sh:sshd action="start"
			port="2022" authenticator="tests.cfsshd.ThereCanBeOnlyOneAuth"	/>
		<cftry>
			<cftry>
				<sh:sshd action="shell"
					host="localhost"
					username="souldnot"
					password="work"
					userinput="ls"
					port="2022"/>
				<cfset fail("the auth should have failed!") />
			<cfcatch>
			</cfcatch>
			</cftry>
			<sh:sshd action="shell"
				host="localhost"
				username="Christopher"
				password="Lambert"
				userinput="ls"
				port="2022"/>
				<cfset debug(sshd) />
		<cfcatch>
			<sh:sshd action="stop"
				port="2022"/>
			<cfrethrow />
		</cfcatch>
		</cftry>
		<sh:sshd action="stop"
			port="2022"/>
		<cfset debug(sshd) />
		<sh:sshd action="destroy" />
	</cffunction>

	<cffunction name="testStop">
		<sh:sshd action="stop"
			port="2022"/>
		<cfset debug(sshd) />
	</cffunction>

</cfcomponent>
