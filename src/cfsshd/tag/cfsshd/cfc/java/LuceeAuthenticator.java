import java.security.PublicKey;
import org.apache.sshd.server.PasswordAuthenticator;
import org.apache.sshd.server.PublickeyAuthenticator;
import org.apache.sshd.server.session.ServerSession;
import lucee.loader.engine.CFMLEngineFactory;
import lucee.loader.engine.CFMLEngine;
import lucee.runtime.Component;
import lucee.runtime.PageContext;

/**
 * Lucee Authenticator for calling a CFC that you stick in a persistent thread
 *
 * @author denny valliant
 */
public class LuceeAuthenticator implements PasswordAuthenticator, PublickeyAuthenticator {
	Component authComponent;
	PageContext pc;

    public boolean authenticate(String username, String password, ServerSession session) {
    	CFMLEngine	engine	= CFMLEngineFactory.getInstance();
    	try{
	    	return (Boolean) authComponent.call( pc, "authenticate", new Object[] { username, password, session } );
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
        return false;
    }

    public boolean authenticate(String username, PublicKey key, ServerSession session) {
    	CFMLEngine	engine	= CFMLEngineFactory.getInstance();
    	try{
	    	return (Boolean) authComponent.call( pc, "authenticatePublicKey", new Object[] { username, key, session } );
    	} catch (Exception e) {
    		e.printStackTrace();
    	}
    	return false;
    }


    public void setAuthComponent(Component component, PageContext threadContext) {
        authComponent = component;
        pc = threadContext;
    }
}