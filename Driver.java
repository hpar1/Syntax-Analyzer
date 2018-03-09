import java.io.FileReader;
//import java_cup.runtime.*;

public class Driver{
    public static void main(String[] args){
        try{
            parser p = new parser(new Lexer(new FileReader(args[0])));
            //parser p = new parser();
            //p.setScanner(new Lexer(new FileReader(args[0])));
            p.parse();
            //Object result = p.parse().value;
        }catch(Exception e){
            System.out.println("An error has occured!!!");
        }
    }
}
