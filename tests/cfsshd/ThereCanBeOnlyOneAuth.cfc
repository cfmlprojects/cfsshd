component {
	/**
	 * http://remark.overzealous.com/manual/usage.html
	 **/
	function init() {
		return this;
	}

	function authenticate(required username, required password, required sshsession) {
		if(username == "Christopher" && password == "Lambert") {
			return true;
		}
		return false;
	}

	function authenticatePublicKey(required username,required key,required sshsession) {
		return true;
	}

}