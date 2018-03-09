/*
* CS 411 Project 1
* Dr. Sang
* Hamza Parekh and Kunal RajPurohit
*/

import java.util.*;
import java_cup.runtime.*;

%%

%public
%class Lexer // This names the generated java class Lexer.java
%intwrap
%unicode // the set of chars the scanner will read
%cup // switches it to CUP compatibility mode in which type is set to Symbol, and an eof is defined
%line // current line # can be accessed with yyline
%column // current column accessed with yycolumn
// returns values as type of Symbol
//%type Symbol
// %eofval{
//     return -1; // handled by cup this time
// %eofval}
//%eofclose //close the input stream at end of file
%type Symbol
%eofclose

%{
    // anything in between these brackets is copied exactly to the generated class
    private Symbol symbol(int sym){
        return new Symbol(sym, yyline+1, yycolumn+1);
    }

//     // stores the token as enums so that they have a # associated with them
//   public enum token {
//     _boolean, _break, _class, _double,
//     _else, _extends, _for, _if,
//     _implements, _int, _interface, _newarray,
//     _println, _readln, _return, _string,
//     _void, _while, _plus, _minus,
//     _multiplication, _division, _mod, _less,
//     _lessequal, _greater, _greaterequal, _equal,
//     _notequal, _and, _or, _not,
//     _assignop, _semicolon, _comma, _period,
//     _leftparen, _rightparen, _leftbracket, _rightbracket,
//     _leftbrace, _rightbrace, _intconstant, _doubleconstant,
//     _stringconstant, _booleanconstant, _id
//   }

  public class trieStruct {
    public int [] trieSwitch = new int[52]; // representing A-Z a-z
    public ArrayList<Character> symbol = new ArrayList<Character>();
    public ArrayList<Integer> next = new ArrayList<Integer>();

    // constructor to initialize the switch array
    public trieStruct() {
        for (int i = 0; i < this.trieSwitch.length; i++) {
            this.trieSwitch[i] = -1;
        }
    }
  }

  public trieStruct s = new trieStruct();

  // Return array index of character
  public int switchIndex(char c) {
    int k = c;
    if(k >= 65 && k < 97){
      return k-65; // 65 represents A in ASCII
    }
    else{
      return k - 71; // = k - 97 + 26. 97 represents a in ASCII
    }
  }

  public void trie(String str) {
    int first = switchIndex(str.charAt(0));
    int ptr = s.trieSwitch[first]; // initially first letter in switch array

    // No value at the location of first char
    if (ptr == -1) {
        // point to the last entry in symbol table
        s.trieSwitch[first] = s.symbol.size();
        // add the rest of the characters to end of symbol table
        for (int i = 1; i < str.length(); i++) {
            s.symbol.add(str.charAt(i)); // add the rest of the chars
        }
        s.symbol.add('@'); // add delimiter
    }
    // there is a value at the first char location
    else {
        // 2nd character, 'i' is the symbol counter
        int i = 1;
        boolean exit = false;

        if(str.length() == 1) {
            return; // if string is of length 1 and already in table
        }

        while(!exit) {
            // if symbol index of point is the next char
            if (s.symbol.get(ptr) == str.charAt(i)) {
                // if at the end
                if(str.length() -1 <= i) {
                    exit = true;
                    break; // break out of while loop
                }
                i++;
                ptr++;
            }
            else if((s.next.size() > ptr) && (s.next.get(ptr) != -1)) {
                ptr = s.next.get(ptr);
            }
            else {
                while(s.next.size() <= ptr) {
                    //add entries to the trie table
                    s.next.add(-1);
                }

                // Set ptr to next available space in symbol array
                s.next.set(ptr,s.symbol.size());

                //add the rest of the chracters to the trie
                while(i < str.length()) { // end of string not yet reached
                    s.symbol.add(str.charAt(i++));
                }
                //end with the '@' symbol
                s.symbol.add('@');

                exit = true;
                break;
            }
        }
    }
  }
    // print the Switch array
    public void printSwitch(int head, int tail) {
        System.out.printf("%-10s", "switch:");
        int i = 0;
        for (head = head ;head < tail; ++head) {
            i = s.trieSwitch[head];
            if (i == -1) {
                System.out.print("$   ");
            }
            else {
                System.out.printf("%-3d ", i);
            }
        }
        System.out.println("\n");
    }
    
    // print the Symbol array
    public void printSymbol(int head, int tail) {
        System.out.printf("%-10s", "symbol:");
        for(int i = head; i < tail; ++i) {
            System.out.printf("%c   ", s.symbol.get(i));
        }
        System.out.println();
    }
    
    // print the Next array
    public void printNext(int head, int tail) {
        System.out.printf("%-10s", "next:");
        int v = 0;
        for (int i = head; i < tail; ++i) {
            v = s.next.get(i);
            if (v == -1) {
                System.out.print("$   ");
            }
            else {
                System.out.printf("%-3d ", v);
            }
        }
        System.out.println("\n");
    }

    private void equalizeNext() {
        if (s.symbol.size() > s.next.size()) {
            while (s.next.size() != s.symbol.size()) {
                s.next.add(-1);
            }
        }
    }
    // print out all of the arrays in a special format
    public void printTable() {
        String alpha = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
        System.out.printf("%-10s","");
        int head = 0;
        int i = 0;
        for (; i < 52; ++i) {
            if ((i+1)%20 == 0) {    // print the Switch array
                System.out.println();
                printSwitch(head,i);
                System.out.printf("%-10s","");
                head = i;
            }
            System.out.printf("%c   ", alpha.charAt(i));
        }
        System.out.println();   // print the Switch array
        printSwitch(head,i);
        equalizeNext();
        i = 0;
        head  = 0;
        System.out.printf("%-10s","");
        for (; i < s.symbol.size(); ++i) {
            if ((i+1)%20 == 0) {    
            // print the Symbol array
                System.out.println();
                printSymbol(head,i);
                printNext(head,i);
                System.out.printf("%-10s","");
                head = i;
            }
            System.out.printf("%-3d ", i);
        }       
        // print the Next array
        // print the Symbol array
        System.out.println();
        printSymbol(head,i);
        printNext(head,i);
    }

%}

LineTerminate = \r|\n|\r\n  
// print the Next array
InputChar = [^\r\n] // all characters that are not line feed or carriage return
WhiteSpace = [ \t]+ // all spaces and tabs

Comment = ({TraditionalComm} |{EOFComm})
TraditionalComm = "/*" [^*] ~"*/" | "/*" "*" "/"
EOFComm = "//" ({InputChar})* ({LineTerminate})?

BaseTen = [0-9] // any digit
BaseSixteen = [0-9a-fA-F]
Hex = "0x" ({BaseSixteen}+)|"0X"({BaseSixteen}+)
Integer = ({BaseTen}+ | {Hex}) // can be base 10 or hex

Double = ([0-9])+ (".") ([0-9])* ({Exponent})? 
Exponent = (E|e) ("+"|"-")? ([0-9])+

// print out all of the arrays in a special format

String = \"([^\"\n])*\"
// can contain anything except newline or double quote

ID = [a-zA-Z] ([a-zA-Z]|[0-9]|"_")*

NewLine = \n

%%
// print out all of the arrays in a special format

// output newline when a comment is seen
{Comment} {System.out.println();}

{NewLine} {System.out.print("\n");}
{LineTerminate} {System.out.print("\n");}
{WhiteSpace} { }

// IntegerConstant DoubleConstant and StringConstant
{Integer} {System.out.print("intconstant "); return symbol(sym._intconstant);}
{Double} {System.out.print("doubleconstant "); return symbol(sym._doubleconstant);}
{String} {System.out.print("stringconstant "); return symbol(sym._stringconstant);}

// keywords 

boolean {System.out.print(yytext()+" "); return symbol(sym._boolean);}
break {System.out.print(yytext()+" "); return symbol(sym._break);}
class {System.out.print(yytext()+" "); return symbol(sym._class);}
double {System.out.print(yytext()+" "); return symbol(sym._double);}
else {System.out.print(yytext()+" "); return symbol(sym._else);}
extends {System.out.print(yytext()+" "); return symbol(sym._extends);}
false {System.out.print("booleanconstant "); return symbol(sym._booleanconstant);}
for {System.out.print(yytext()+" "); return symbol(sym._for);}
if {System.out.print(yytext()+" "); return symbol(sym._if);}
implements {System.out.print(yytext()+" "); return symbol(sym._implements);}
int {System.out.print(yytext()+" "); return symbol(sym._int);}
interface {System.out.print(yytext()+" "); return symbol(sym._interface);}
newarray {System.out.print(yytext()+" "); return symbol(sym._newarray);}
println {System.out.print(yytext()+" "); return symbol(sym._println);}
readln {System.out.print(yytext()+" "); return symbol(sym._readln);}
return {System.out.print(yytext()+" "); return symbol(sym._return);}
string {System.out.print(yytext()+" "); return symbol(sym._string);}
true {System.out.print("booleanconstant "); return symbol(sym._booleanconstant);}
void {System.out.print(yytext()+" "); return symbol(sym._void);}
while {System.out.print(yytext()+" "); return symbol(sym._while);}

{ID} {System.out.print("id "); trie(yytext()); return symbol(sym._id);}

// operators and punctuation characters

"+" {System.out.print("plus "); return symbol(sym._plus);}
"-" {System.out.print("minus "); return symbol(sym._minus);}
"*" {System.out.print("multiplication "); return symbol(sym._multiplication);}
"/" {System.out.print("division "); return symbol(sym._division);}
"%" {System.out.print("mod "); return symbol(sym._mod);}
"<" {System.out.print("less "); return symbol(sym._less);}
"<=" {System.out.print("lessequal "); return symbol(sym._lessequal);}
">" {System.out.print("greater "); return symbol(sym._greater);}
">=" {System.out.print("greaterequal "); return symbol(sym._greaterequal);}
"==" {System.out.print("equal "); return symbol(sym._equal);}
"!=" {System.out.print("notequal "); return symbol(sym._notequal);}
"&&" {System.out.print("and "); return symbol(sym._and);}
"||" {System.out.print("or "); return symbol(sym._or);}
"!" {System.out.print("not "); return symbol(sym._not);}
"=" {System.out.print("assignop "); return symbol(sym._assignop);}
";" {System.out.print("semicolon "); return symbol(sym._semicolon);}
"," {System.out.print("comma "); return symbol(sym._comma);}
"." {System.out.print("period " ); return symbol(sym._period);}
"(" {System.out.print("leftparen "); return symbol(sym._leftparen);}
")" {System.out.print("rightparen "); return symbol(sym._rightparen);}
"[" {System.out.print("leftbracket "); return symbol(sym._leftbracket);}
"]" {System.out.print("rightbracket "); return symbol(sym._rightbracket);}
"{" {System.out.print("leftbrace "); return symbol(sym._leftbrace);}
"}" {System.out.print("rightbrace "); return symbol(sym._rightbrace);}

. {} // ignore everything else
<<EOF>> {return symbol(sym.EOF);}