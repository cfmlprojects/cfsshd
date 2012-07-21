import org.apache.sshd.server.Command;
import org.apache.sshd.server.CommandFactory;
import org.apache.sshd.server.command.ScpCommandFactory;
import org.apache.sshd.server.shell.ProcessShellFactory;

/**
 * simple wrapper for processshellfactory
 *
 * @author denny valliant
 */
public class ShellScpCommandFactory extends ScpCommandFactory {

    public Command createCommand(String command) {
    	//System.out.println("Running command: " + command); 
        return new ProcessShellFactory(command.split(" ")).create();
    }

}