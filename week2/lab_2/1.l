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
%}

letter [a-zA-Z]
digit [0-9]
alphanumeric [a-zA-Z0-9]

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

{letter}({letter}|{digit})* return ID;
[+-]?{digit}{digit}*(\.{digit}+)? return NUMBER;
^\"[^"\\]*(\\.[^"\\]*)*\"$ return SLITERAL;
\#include(\"{letter}{alphanumeric}+[\.]{letter}+\"|\<{letter}{alphanumeric}+[\.]{letter}+\>) return HEADER;
%%