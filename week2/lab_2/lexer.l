%{
    #include<stdio.h>
    #include "y.tab.h"
    void yyerror(char *s);
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
\#include({space}*)(\"[a-zA-Z][a-zA-Z0-9]+[\.][a-zA-Z]+\"|\<[a-zA-Z][a-zA-Z0-9]+[\.][a-zA-Z]+\>) {ECHO; return HEADER;}

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