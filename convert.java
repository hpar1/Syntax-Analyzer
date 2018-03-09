import java.util.*;
import java.io.*;

public class convert{

  public static void main(String[] args) throws Exception{

    String s;
    // We need to provide file path as the parameter:
    // double backquote is to avoid compiler interpret words
    // like \test as \t (ie. as a escape sequence)
    File file = new File("test2.txt");

    BufferedReader br = new BufferedReader(new FileReader(file));

    String st;
    boolean error = false;
    String res = "";
    while (( s = br.readLine()) != null){
      char[] c = (s).toCharArray();
      int i = 0;
      if(c[i] == '[' &&  c[i + 1] == 'r' && c[i + 2] == 'e'){
        int j = 0;
        while(c[i+j] != ']'){
          //System.out.println(c[i+j] + " added" );
          res += c[i+j];
          j++;
        }
        res += "]";
      }
      else if(c[i] == '#'){
        if(c[i + 1] == ' ' && c[i + 2] == 'S' ){
          //System.out.println("Shift added" );
          res += "[shift]\n";
        }
        else if(c[i + 1] == ' ' && c[i + 2] == 'E' ){
          res += "[reject]\n";
          error = true;
          break;
        }
      }
      else {
        int j = 0;
        while(c[i+j] != ' ' ){
          //System.out.println(c[i+j] + " added" );
          res += c[i+j];
          j++;
        }
      }
    }
    if(!error){
      res += "[accept]\n";
    }
    System.out.print(res + "\n");
  }
}
