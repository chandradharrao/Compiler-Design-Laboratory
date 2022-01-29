%{
    int yylineno;    
%}

%token INT
%token CHAR
%token FLOAT
%token DOUBLE

%token WHILE
%token FOR
%token DO
%token IF
%token ELSE

%token INCLUDE 
%token MAIN 

%token ID 
%token NUMBER 
%token SLITERAL 
%token HEADER 

%token EQCOMP 
%token GREATEREQ 
%token LESSEREQ 
%token NOTEQ 
%token INC 
%token DEC
%token SUB 
%token ADD 
%token MUL 
%token DIV 

%token OROR 
%token ANDAND 
%token NOT 

%token OBRKT 
%token CBRKT 
%token OBRCS 
%token CBRCS 

%token ARR 

%token SCOL 
%token COMMA 

%token FUNC 

%token ASSI 
%token LESS 
%token GREATER 

%start program

program :   HEADER
        |   