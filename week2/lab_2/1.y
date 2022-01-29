%{
    #include<stdio.h>
    void yyerror(char *);
    int yylex();    
%}

%option yylineno

%token INT
%token CHAR
%token FLOAT
%token DOUBLE

%token WHILE
%token FOR
%token DO
%token IF
%token ELSE

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

%%
program :   HEADER
        |   mainf program
        |   declr SCOL program
        |   assgn SCOL program
        |
        ;

declr   :   type listvar
        ;

type    :   INT
        |   CHAR
        |   FLOAT
        |   DOUBLE

listvar :   listvar COMMA ID
        |   ID
        ;

assgn   :   ID ASSI expr
        ;

expr    :   expr relop e
        |   e
        ;

relop   :   LESS
        |   LESSEREQ
        |   GREATER
        |   GREATEREQ
        |   EQCOMP
        |   NOTEQ
        ;

e       :   e ADD t
        |   e SUB t
        |   t
        ;

t       :   t MUL f
        |   t DIV f
        |   f
        ;

f       :   OBRKT expr CBRCS
        |   ID
        |   NUMBER
        ;

mainf   :   type MAIN OBRKT empty_listvar CBRKT OBRCS stmnt CBRCS
        ;

empty_listvar   :   listvar
                |
                ;

stmnt   :   single stmnt
        |   multiline stmnt
        |
        ;

single  :   declr SCOL
        |   assgn SCOL
        |   IF OBRKT cond CBRKT stmnt
        |   IF OBRKT cond CBRKT stmnt ELSE stmnt
        |   while
        ;

multiline   :   OBRCS stmnt CBRCS
            ;

cond    :   expr
        |   assgn
        ;

while   :   WHILE OBRKT cond CBRKT whilecontent
        ;

whilecontent    :   single
                |   OBRCS stmnt CBRCS
                |
                ;
%%

void yyerror(char* s){
    fprintf(stderr,"line %d:\t%s\n",yylineno,s);
}

int main(){
    yyparse();
    return 0;
}
