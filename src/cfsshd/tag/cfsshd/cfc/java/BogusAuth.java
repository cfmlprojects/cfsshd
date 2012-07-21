import org.apache.sshd.server.PasswordAuthenticator;
import org.apache.sshd.server.session.ServerSession;


/**
 * bogus password auth returns true if username == password
 *
 * 
 */
public class BogusAuth implements PasswordAuthenticator {

    public boolean authenticate(String username, String password, ServerSession session) {
        return username != null && username.equals(password);
    }
}