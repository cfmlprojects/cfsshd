component {
	/**
	 * http://remark.overzealous.com/manual/usage.html
	 **/
	function init() {
		return this;
	}

	function getSshServer(){
		lock scope="server" timeout="3" {
			return server.sshd;
		}
	}

	function getSshClient(){
		// TODO: locking or removing tie to a scope alltogether
		if(!structKeyExists(server,"sshclient")) {
			server.sshclient = classLoader.create("org.apache.sshd.SshClient").setUpDefaultClient();
		}
		return server.sshclient;
	}

  	classLoader = new LibraryLoader(getDirectoryFromPath(getMetaData(this).path) & "lib/").init();
	jThread = createObject("java","java.lang.Thread");
	jFile = classLoader.create("java.io.File");
	ByteArrayInputStream = classLoader.create("java.io.ByteArrayInputStream");
	ByteArrayOutputStream = classLoader.create("java.io.ByteArrayOutputStream");
	ClientChannel = classLoader.create("org.apache.sshd.ClientChannel");

	SshServer = classLoader.create("org.apache.sshd.SshServer");
	SshConstants = classLoader.create("org.apache.sshd.common.SshConstants");
	IoSession = classLoader.create("org.apache.mina.core.session.IoSession");
	SessionFactory = classLoader.create("org.apache.sshd.client.SessionFactory");
	ClientSessionImpl = classLoader.create("org.apache.sshd.client.session.ClientSessionImpl");
	FileKeyPairProvider = classLoader.create("org.apache.sshd.common.keyprovider.FileKeyPairProvider");
	SimpleGeneratorHostKeyProvider = classLoader.create("org.apache.sshd.server.keyprovider.SimpleGeneratorHostKeyProvider");
	PEMGeneratorHostKeyProvider = classLoader.create("org.apache.sshd.server.keyprovider.PEMGeneratorHostKeyProvider");
	AbstractSession = classLoader.create("org.apache.sshd.common.session.AbstractSession");
	ScpCommandFactory = classLoader.create("org.apache.sshd.server.command.ScpCommandFactory");
	ShellScpCommandFactory = classLoader.create("ShellScpCommandFactory");
	UserAuthNone = classLoader.create("org.apache.sshd.server.auth.UserAuthNone");
	SftpSubsystem = classLoader.create("org.apache.sshd.server.sftp.SftpSubsystem$Factory");
	BogusPasswordAuthenticator = classLoader.create("BogusAuth");
	EchoShellFactory = classLoader.create("EchoShellFactory");
	jRailoAuth = classLoader.create("RailoAuthenticator");
	WrappedFileSystemFactory = classLoader.create("WrappedFileSystemFactory");
//		PAMPasswordAuthenticator = classLoader.create("org.apache.sshd.server.pam.PAMPasswordAuthenticator");
	ProcessShellFactory = classLoader.create("org.apache.sshd.server.shell.ProcessShellFactory");
	JaasPasswordAuthenticator = classLoader.create("org.apache.sshd.server.jaas.JaasPasswordAuthenticator");
	ClientSession = classLoader.create("org.apache.sshd.ClientSession");
	ScpCommandFactory = classLoader.create("org.apache.sshd.server.command.ScpCommandFactory");
		//jThread.currentThread().setContextClassLoader(classLoader.GETLOADER().getURLClassLoader());
		//request.debug(start.getClass());
//var logdata = logAppender();


	function start(port=2022, authTimeout=1000, maxAuthRequests=10,authenticator="DummyAuthenticator") {
		security = createObject("java","java.security.Security");
		var system = classLoader.create("java.lang.System");
		//jThread.currentThread().setContextClassLoader(classLoader.GETLOADER().getURLClassLoader());

		//jThread.currentThread().setContextClassLoader(classLoader.GETLOADER().getURLClassLoader().getSystemClassloader());
//		security.removeProvider("BC");
//		bouncyCastle = classLoader.create("org.bouncycastle.jce.provider.BouncyCastleProvider");
//		security.addProvider(bouncyCastle.init());

//		secutil = classLoader.create("org.apache.sshd.common.util.SecurityUtils");
//		secutil.setRegisterBouncyCastle(true);
//		secutil.setSecurityProvider("BC");
//		secutil.getSecurityProvider();
		if(!structKeyExists(server,"sshd")) {
			server.sshd = classLoader.create("org.apache.sshd.SshServer").setUpDefaultServer();
	        //var FileKeyPairProvider = classLoader.create("org.apache.sshd.common.keyprovider.FileKeyPairProvider");
	        //sshd.setKeyPairProvider(FileKeyPairProvider.init(["hostkey.pem"]));
	 		var provider = PEMGeneratorHostKeyProvider.init();
	        provider.setAlgorithm("DSA");
	        provider.setKeySize(1024);
	        provider.setPath("hostkey.pem");
	        server.sshd.setKeyPairProvider(provider);
			// total hack to use CFC for authentication
	        jRailoAuth = jRailoAuth.init();
		        jRailoAuth.setAuthComponent(createObject(authenticator).init(),getPageContext());
	        server.sshd.setPasswordAuthenticator(jRailoAuth);
	        server.sshd.setPublicKeyAuthenticator(jRailoAuth);
	        server.sshd.setFileSystemFactory(WrappedFileSystemFactory.init());
		}
		sshd = server.sshd;
		sshd.setSubsystemFactories([SftpSubsystem.init()]);
		//sshd.setShellFactory(EchoShellFactory.init());
		sshd.setShellFactory(ProcessShellFactory.init(["/bin/sh", "-i", "-l"]));
		sshd.setCommandFactory(ShellScpCommandFactory.init());
		//sshd.setCommandFactory(ScpCommandFactory.init());
        sshd.getProperties().put(SshServer.AUTH_TIMEOUT, authTimeout);
		sshd.getProperties().put(SshServer.MAX_AUTH_REQUESTS, maxAuthRequests);
        sshd.setPort(port);
        //sshd.setPasswordAuthenticator(BogusPasswordAuthenticator.init());
        //sshd.setPasswordAuthenticator(JaasPasswordAuthenticator.init());
        //sshd.setPasswordAuthenticator(PAMPasswordAuthenticator.init());
        //sshd.setUserAuthFactories([UserAuthNone.init()]);

/*

			var pool = classLoader.create("javassist.ClassPool").init(true);

			var CtMethod = classLoader.create("javassist.CtMethod");
			pool.appendPathList(classloader.getClassloaderJars());
			var ch = pool.makeClass("den.BogusPasswordAuth");
			var m = CtMethod.make( 'public boolean authenticate(String username, String password, org.apache.sshd.server.session.ServerSession session) {return username != null && username.equals(password);}', ch);
			ch.addMethod(m);
			ci = pool.get("org.apache.sshd.server.PasswordAuthenticator");
			ch.addInterface(ci);
			h = ch.toClass(classLoader.GETLOADER().getURLClassLoader());
			BogusPasswordAuth = h.newInstance();
        	server.sshd.setPasswordAuthenticator(BogusPasswordAuth);


*/
			sshd.start();
/*
//  TESTS
	       	server.sshd = sshd;


			var sshclient = getSshClient();
	        sshclient.start();
	        var s  = sshclient.connect("localhost", port).await().getSession();
	        var nbTrials = 0;
	        var res = 0;
	        while ((bitAnd(res,ClientSession.CLOSED)) == 0) {
	            nbTrials++;
	            s.authPassword("smx", "buggy");
	            res = s.waitFor(bitOr(ClientSession.CLOSED,ClientSession.WAIT_AUTH), 5000);
	            if (res == ClientSession.TIMEOUT) {
	                throw("timed out");
	            }
	        }
	        sshclient.stop();
	        request.debug(nbTrials);

//========================

		var PipedInputStream = classLoader.create("java.io.PipedInputStream");
		var PipedOutputStream = classLoader.create("java.io.PipedOutputStream");
		var TeePipedOutputStream = classLoader.create("TeePipedOutputStream");
		var StringBuilder = classLoader.create("java.lang.StringBuilder");

        sshclient.start();

        clientsh = sshclient.connect("localhost", port).await().getSession();
        clientsh.authPassword("smx", "smx").await().isSuccess();
        	system.out.println("Trying shell...");
        var channel = clientsh.createChannel(ClientChannel.CHANNEL_SHELL);
        	system.out.println("Created chanell");

        var sent = ByteArrayOutputStream.init();
        var pipedIn = TeePipedOutputStream.init(sent);
        channel.setIn(PipedInputStream.init(pipedIn));
        var out = ByteArrayOutputStream.init();
        var err = ByteArrayOutputStream.init();
        channel.setOut(out);
        channel.setErr(err);
        	system.out.println("opening...");
        channel.open();
        	system.out.println("opened");

        pipedIn.write("ls#chr(10)#".getBytes());
        	system.out.println("Sending command...");
        pipedIn.flush();

        sb = StringBuilder.init();
        for (i = 0; i < 1000; i++) {
            sb.append("0123456789");
        }
        sb.append(chr(10));
        pipedIn.write(sb.toString().getBytes());

       	system.out.println("Sending exit...");
       	system.out.println("exit" & chr(10));
        pipedIn.write("exit#chr(10)#".getBytes());
        pipedIn.flush();
       	system.out.println("wait for close...");

        channel.waitFor(ClientChannel.CLOSED, 0);

        channel.close(false);
       	system.out.println("closed");
        sshclient.stop();

//        assertArrayEquals(sent.toByteArray(), out.toByteArray());
		request.debug(sent.toString());
		request.debug(out.toString());

*/
		return true;
	}

	function stop() {
		try{
			var sshd = getSshServer();
			sshd.stop();
			return true;
		} catch (any e) {
			//e.printStackTrace();
			return false;
		}
	}

	function shell(required username, required password, required host, numeric port=22, required string userinput)  {
		var system = classLoader.create("java.lang.System");
		var sshclient = getSshClient();
		sshclient.start();
		try {
	        clientsh = sshclient.connect("localhost", port).await().getSession();
	        clientsh.authPassword(username, password);
            var res = clientsh.waitFor(bitOr(ClientSession.CLOSED,ClientSession.WAIT_AUTH), 5000);
            if (res == bitOr(ClientSession.TIMEOUT,ClientSession.WAIT_AUTH)) {
                throw("timed out");
            }
            if(res == bitOr(ClientSession.CLOSED,ClientSession.CLOSED)) {
            	throw("session is closed");
            }
            if(val(res) != 9) {
            	throw("incorrect username or password or public key");
            }
	       	//system.out.println("Trying shell...");
	        var channel = clientsh.createChannel(ClientChannel.CHANNEL_SHELL);
	        //system.out.println("Created chanell");
	        var out = ByteArrayOutputStream.init();
	        var err = ByteArrayOutputStream.init();
	        channel.setIn(ByteArrayInputStream.init(userinput.getBytes()));
	        channel.setOut(out);
	        channel.setErr(err);
	        //system.out.println("opening...");
	        channel.open();
	        //system.out.println("opened");
	        channel.waitFor(ClientChannel.CLOSED, 0);
	        channel.close(false);
	       	//system.out.println("closed");
		} catch (Any e) {
        	sshclient.stop();
        	throw(e);
		}
        sshclient.stop();
        out.close();
        err.close();
        var errText = (isNull(err.toString())) ? "" : err.toString();
        var outText = (isNull(out.toString())) ? "" : out.toString();
        return outText;
	}

	function exec(required username, required password, required host, numeric port=22, required string userinput)  {
		var system = classLoader.create("java.lang.System");
		var sshclient = getSshClient();
		sshclient.start();
		try {
	        clientsh = sshclient.connect("localhost", port).await().getSession();
	        clientsh.authPassword(username, password);
            var res = clientsh.waitFor(bitOr(ClientSession.CLOSED,ClientSession.WAIT_AUTH), 5000);
            if (res == bitOr(ClientSession.TIMEOUT,ClientSession.WAIT_AUTH)) {
                throw("timed out");
            }
            if(res == bitOr(ClientSession.CLOSED,ClientSession.CLOSED)) {
            	throw("session is closed");
            }
            if(val(res) != 9) {
            	throw("incorrect username or password or public key");
            }
	       	//system.out.println("Trying shell...");
	        //system.out.println("Created chanell");
	        var out = ByteArrayOutputStream.init();
	        var err = ByteArrayOutputStream.init();
	        userinput &= chr(10);
	        var channel = clientsh.createExecChannel("ls");
            var baos = ByteArrayOutputStream.init();
            var w = classLoader.create("java.io.OutputStreamWriter").init(baos);
            w.append("ls");
            w.append("\n");
            w.close();
            channel.setIn(ByteArrayInputStream.init(baos.toByteArray()));

	        channel.setOut(out);
	        channel.setErr(err);
	        system.out.println("opening...");
	        channel.open();
	        system.out.println("opened");
	        channel.waitFor(ClientChannel.CLOSED, 0);
	        channel.close(false);
	       	system.out.println("closed");
		} catch (Any e) {
        	sshclient.stop();
        	throw(e);
		}
        sshclient.stop();
        out.close();
        err.close();
        var errText = (isNull(err.toString())) ? "" : err.toString();
        var outText = (isNull(out.toString())) ? "" : out.toString();
        return outText;
	}

	function destroy() {
		stop();
		server.sshd = javacast("null","");
		structDelete(server,"sshd");
		return true;
	}

	function logSlf4jAppender() {
		var Logger = classLoader.create("org.slf4j.Logger");
		var LoggerFactory = classLoader.create("org.slf4j.LoggerFactory");
		var rootlogger = LoggerFactory.getLogger(Logger.ROOT_LOGGER_NAME);
		request.debug(rootlogger);
		request.debug(loggerfactory);
	}

	function logAppender() {
		var WriterAppender = createObject("java","org.apache.log4j.WriterAppender");
		var PatternLayout = createObject("java","org.apache.log4j.PatternLayout");
		var Level = createObject("java","org.apache.log4j.Level");
		var Logger = createObject("java","org.apache.log4j.Logger");
		var PATTERN = "%d [%p|%c|%C{1}] %m%n";
		var layout = PatternLayout.init(PATTERN);
		var outstream = createObject("java","java.io.ByteArrayOutputStream");

		console = WriterAppender.init(layout,outstream); //create appender
		//configure the appender
		console.setThreshold(Level.INFO);
		console.activateOptions();
		//add appender to any Logger (here is root)
		Logger.getRootLogger().addAppender(console);
		return outstream;
	}

}