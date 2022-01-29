%{
    #include<stdio.h>
    #include "y.tab.h"
    void yyerror(char *s);

    #define INT 1
    #define CHAR 2
    #define FLOAT 3
    #define DOUBLE 4

    #define WHILE 5
    #define FOR 6
    #define DO 7
    #define IF 8
    #define ELSE 9

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

%option yylineno

letter [a-zA-Z]
digit [0-9]
alphanumeric [a-zA-Z0-9]
identifier {letter}({letter}|{digit})*
number [+-]?{digit}{digit}*(\.{digit}+)?
space [\n\t ]+

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

main{space}*\(\) {ECHO; return MAIN;}
{identifier} {ECHO; return ID;}
{number} {ECHO; return NUMBER;}
\"[^"\\]*(\\.[^"\\]*)*\" {ECHO; return SLITERAL;}
\#include({space}*)(\"{letter}{alphanumeric}+[\.]{letter}+\"|\<{letter}{alphanumeric}+[\.]{alphanumeric}+\>) {ECHO; return HEADER;}

{identifier}\[{digit}*\] {ECHO; return ARR;}
\((({identifier}([,]{identifier})*)?)\) {ECHO; return FUNC;}
\((({number}([,]{number})*)?)\) {ECHO; return FUNC;}

"==" {ECHO; return EQCOMP;}
">=" {ECHO; return GREATEREQ;}
"<=" {ECHO; return LESSEREQ;}
"!=" {ECHO; return NOTEQ;}
"++" {ECHO; return INC;}
"--" {ECHO; return DEC;}
"||" {ECHO; return OROR;}
"&&" {ECHO; return ANDAND;}
"!" {ECHO; return NOT; }
"-" {ECHO; return SUB;}
"+" {ECHO; return ADD;}
"*" {ECHO; return MUL;}
"/" {ECHO; return DIV;}

"(" {ECHO; return OBRKT;}
")" {ECHO; return CBRKT;}
"{" {ECHO; return OBRCS;}
"}" {ECHO; return CBRCS;}

"," {ECHO; return COMMA;}
";" {ECHO; return SCOL;}
"=" {ECHO; return ASSI;}
">" {ECHO; return GREATER;}
"<" {ECHO; return LESS;}

{space} /*do nothing for new line or white space*/;
%%

// int yywrap(){
//     return 1;
// }

// int main(){
//     int scan;
//     scan = yylex();
//     while(scan){
//         printf("token\t%d\n",scan);
//         scan = yylex();
//     }
//     return 0;
// }