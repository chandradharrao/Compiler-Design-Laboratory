%{
    #include <stdio.h>

    #define INT 1
    #define CHAR 2
    #define FLOAT 3
    #define DOUBLE 4

    #define WHILE 5
    #define FOR 6
    #define DO 7
    #define IF 8
    #define ELSE 9

    #define INCLUDE 10
    #define MAIN 11
    
    #define ID 12
    #define NUMBER 13
    #define SLITERAL 14
    #define HEADER 15

    #define EQCOMP 16
    #define GREATEREQ 17
    #define LESSEREQ 18
    #define NOTEQ 19
    #define INC 20
    #define DEC 21
    #define SUB 22
    #define ADD 23
    #define MUL 24
    #define DIV 25

    #define OROR 26
    #define ANDAND 27
    #define NOT 28

    #define OBRKT 29
    #define CBRKT 30
    #define OBRCS 31
    #define CBRCS 32

    #define ARR 34

    #define SCOL 35
    #define COMMA 36

    #define FUNC 37

    #define ASSI 38
    #define LESS 39
    #define GREATER 40
%}

letter [a-zA-Z]
digit [0-9]
alphanumeric [a-zA-Z0-9]
identifier {letter}({letter}|{digit})*
number [+-]?{digit}{digit}*(\.{digit}+)?

%%
int return INT;
char return CHAR;
float return FLOAT;
double return DOUBLE;
while return WHILE;
for return FOR;
do return DO;
if return IF;
else return ELSE;
main return MAIN;

{identifier} return ID;
{number} return NUMBER;
\"[^"\\]*(\\.[^"\\]*)*\" return SLITERAL;
\#include(\"{letter}{alphanumeric}+[\.]{letter}+\"|\<{letter}{alphanumeric}+[\.]{letter}+\>) return HEADER;

{identifier}\[{digit}*\] return ARR;
\((({identifier}([,]{identifier})*)?)\) return FUNC;
\((({number}([,]{number})*)?)\) return FUNC;

"==" return EQCOMP;
">=" return GREATEREQ;
"<=" return LESSEREQ;
"!=" return NOTEQ;
"++" return INC;
"--" return DEC;
"||" return OROR;
"&&" return ANDAND;
"!" return NOT; 
"-" return SUB;
"+" return ADD;
"*" return MUL;
"/" return DIV;

"(" return OBRKT;
")" return CBRKT;
"{" return OBRCS;
"}" return CBRCS;

"," return COMMA;
";" return SCOL;
"=" return ASSI;
">" return GREATER;
"<" return LESS;
%%

int yywrap(){
    return 1;
}

int main(){
    int scan;
    scan = yylex();
    while(scan){
        printf("\ntoken\t%d",scan);
        scan = yylex();
    }
    return 0;
}