%{
    #include<stdio.h>
    #include<stdlib.h>

    int yydebug=1;

    int yylex();  
    void yyerror(char *);  
%}

%name parse
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

%nonassoc LOWER_THAN_ELSE
%nonassoc ELSE
%left GREATER LESS GREATEREQ LESSEREQ NOTEQ
%left ADD SUB
%left MUL DIV
%expect 32

%%
program :   HEADER program
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
        ;

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

f       :   OBRKT expr CBRKT
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
        |   IF OBRKT cond CBRKT stmnt LOWER_THAN_ELSE
        |   IF OBRKT cond CBRKT stmnt ELSE stmnt
        |   whileL
        ;

multiline   :   OBRCS stmnt CBRCS
            ;

cond    :   expr
        |   assgn
        ;

whileL   :   WHILE OBRKT cond CBRKT whilecontent
        ;

whilecontent    :   single
                |   OBRCS stmnt CBRCS
                |
                ;
%%

void yyerror(char* s){
        extern int yylineno;
    fprintf(stderr,"[ERROR at line: %d]: %s\n",yylineno,s);
}

int main()
{
if(!yyparse())
	printf("Parsing Successful\n");
else
	printf("Unsuccessful\n");
return 0;
}
