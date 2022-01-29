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
%token CLITERAL
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

%nonassoc ELSE
%left GREATER LESS GREATEREQ LESSEREQ NOTEQ
%left ADD SUB
%left MUL DIV
%right ASSI
%expect 41

%%
program :   HEADER program
        |   mainf program
        |   declr SCOL program
        |   assgn SCOL program
        |   /*empty*/   
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
        |   CLITERAL       
        ;   /*empty*/

mainf   :   type MAIN OBRKT empty_listvar CBRKT OBRCS stmnt CBRCS
        ;

empty_listvar   :   listvar
                |   /*empty*/
                ;

stmnt   :   single stmnt
        |   multiline stmnt
        |   /*empty*/
        ;

single  :   declr SCOL
        |   assgn SCOL
        |   IF OBRKT cond CBRKT stmnt
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
                |   /*empty*/
                ;
%%

void yyerror(char* s){
        extern int yylineno;
        extern char* yytext;
    fprintf(stderr,"Syntax Error %s at line %d\n",yytext,yylineno);
}

int main()
{
if(!yyparse())
	printf("Valid\n");
return 0;
}
