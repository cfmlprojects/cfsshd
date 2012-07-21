<cffunction name="sshd">
	<cfscript>
		var jm = createObject("WEB-INF.railo.customtags.cfsshd.cfc.sshd");
		var results = jm.runAction(arguments);
		return results;
	</cfscript>
</cffunction>