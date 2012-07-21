import java.security.PublicKey;

import org.apache.sshd.server.PublickeyAuthenticator;
import org.apache.sshd.server.session.ServerSession;

/**
 * bugus public key auth
 */
public class BogusPublickeyAuthenticator implements PublickeyAuthenticator {

    public boolean authenticate(String username, PublicKey key, ServerSession session) {
        return true;
    }
}