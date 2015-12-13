<cffunction name="sshd">
	<cfscript>
		var jm = createObject("WEB-INF.lucee.customtags.cfsshd.cfc.sshd");
		var results = jm.runAction(arguments);
		return results;
	</cfscript>
</cffunction>