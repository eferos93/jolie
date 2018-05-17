package joliex.wsdl;

/*
 * To change this template, choose Tools | Templates
 * and open the template in the editor.
 */
import java.io.IOException;
import java.util.logging.Level;
import java.util.logging.Logger;
import jolie.CommandLineException;
import jolie.lang.parse.ParserException;
import jolie.lang.parse.ast.Program;
import jolie.lang.parse.util.ParsingUtils;
import jolie.lang.parse.util.ProgramInspector;

/**
 *
 * @author Francesco Bullini and Claudio Guidi
 */
public class Jolie2Wsdl {

    public static void main(String[] args) {
        try {
            Jolie2WsdlCommandLineParser cmdParser = Jolie2WsdlCommandLineParser.create(args, Jolie2Wsdl.class.getClassLoader());
           // args = cmdParser.arguments();

            Program program = ParsingUtils.parseProgram(
                    cmdParser.commandLineOptions().programStream(),
                    cmdParser.commandLineOptions().programFilepath().toURI(), cmdParser.commandLineOptions().charset(),
                    cmdParser.commandLineOptions().includePaths(),cmdParser.commandLineOptions().jolieClassLoader(), cmdParser.commandLineOptions().definedConstants());

            //Program program = parser.parse();
            ProgramInspector inspector = ParsingUtils.createInspector(program);

            WSDLDocCreator document = new WSDLDocCreator(inspector, program.context().source());
            String outfile = cmdParser.getOutputFile();
            String tns = cmdParser.getNamespace();
            String portName = cmdParser.getPortName();
            String address = cmdParser.getAddress();
            document.ConvertDocument(outfile, tns, portName, address );
        } catch (CommandLineException ex) {
            Logger.getLogger(Jolie2Wsdl.class.getName()).log(Level.SEVERE, null, ex);
        } catch (IOException e) {
            e.printStackTrace();
        } catch (ParserException e) {
            System.out.println(e.getMessage());
        } catch (Exception e) {
            e.printStackTrace();
        }
    }
}
