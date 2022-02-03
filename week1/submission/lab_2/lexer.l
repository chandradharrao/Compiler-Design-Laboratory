%{
    #include<stdio.h>
    #include "y.tab.h"
    // #define DEBUG
    #ifdef DEBUG
    #define DISP printf("[detected @ %d: %s]\n",yylineno,yytext)
    #else
    #define DISP do {} while(0)
    #endif
    void yyerror(char *s);
%}

%option yylineno

letter [a-zA-Z]
digit [0-9]
alphanumeric [a-zA-Z0-9]
identifier ({letter}|_)({letter}|{digit}|_)*
number [+-]?{digit}{digit}*(\.{digit}+)?
space [\n\t ]+

%%
\/\/({space}*)(.*) ;
"/*"([^*]|\*+[^*/])*\*+"/" ;

int {DISP; return INT;}
char {DISP; return CHAR;}
float {DISP; return FLOAT;}
double {DISP; return DOUBLE;}
while {DISP; return WHILE;}
for {DISP; return FOR;}
do {DISP; return DO;}
if {DISP; return IF;}
else {DISP; return ELSE;}

main {DISP; return MAIN;}
{identifier} {DISP; return ID;}
{number} {DISP; return NUMBER;}
\#include({space}*)(\"{letter}{alphanumeric}+[\.]{letter}+\"|\<{letter}{alphanumeric}+[\.]{letter}+\>) {DISP; return HEADER;}

\"[^"\\]*(\\.[^"\\]*)*\" {DISP; return SLITERAL;}
\'[^"\\]*(\\.[^"\\]*)*\' {DISP; return CLITERAL;}


"==" {DISP; return EQCOMP;}
">=" {DISP; return GREATEREQ;}
"<=" {DISP; return LESSEREQ;}
"!=" {DISP; return NOTEQ;}
"++" {DISP; return INC;}
"--" {DISP; return DEC;}
"||" {DISP; return OROR;}
"&&" {DISP; return ANDAND;}
"!" {DISP; return NOT; }
"-" {DISP; return SUB;}
"+" {DISP; return ADD;}
"*" {DISP; return MUL;}
"/" {DISP; return DIV;}

"(" {DISP; return OBRKT;}
")" {DISP; return CBRKT;}
"{" {DISP; return OBRCS;}
"}" {DISP; return CBRCS;}

"," {DISP; return COMMA;}
";" {DISP; return SCOL;}
"=" {DISP; return ASSI;}
">" {DISP; return GREATER;}
"<" {DISP; return LESS;}

{space} /*do nothing*/;
%%

int yywrap(){
    return 1;
}























/*
int main(){
    int scan;
    scan = yylex();
    while(scan){
        printf("token\t%d\n",scan);
        scan = yylex();
    }
    return 0;
}
*/