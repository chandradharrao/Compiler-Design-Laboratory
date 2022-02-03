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
%token INC
%token DEC
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
%token MOD

%token SUB 
%token ADD 
%token MUL 
%token DIV 
%token NOT

%token OROR ANDAND

%token OBRKT 
%token CBRKT 
%token OBRCS 
%token CBRCS 

%token SCOL 
%token COMMA 

%token ASSI 
%token LESS 
%token GREATER 

%start program

%nonassoc ELSE
%left GREATER LESS GREATEREQ LESSEREQ NOTEQ
%left ADD SUB
%left MUL DIV
%right ASSI
%expect 66

%%
program :   HEADER program
	|   mainf program
	|   declr SCOL program
	|   assgn SCOL program
	|   unary_expr SCOL program
	|   /*empty*/   
	;

/*Decleration*/
declr   :   type listvar
	|   type listvar ASSI expr
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
	|   ID ASSI unary_expr
	;

/*
Arithmetic operators have more precedence than binary operators
NOT > AND > OR precedence in binary operators
*/

unary_expr      :       ADD e
		|       SUB e
		|       NOT e 
		;

/*Arithmetic expression
Relational expressions
Conditional/ternary expressions,(todo)
Relational Expressions,
Logical Expressions,
Unary Expression (todo properly)
*/
expr    :   expr relop e
	|   unary_expr relop e
	|   e
	;

relop   :   LESS
	|   LESSEREQ
	|   GREATER
	|   GREATEREQ
	|   EQCOMP
	|   NOTEQ
	;

e       :   e OROR k
	|   k
	;
	
k       :   k ANDAND u
	|   u
	;

u       :   e ADD t
	|   e SUB t
	|   t
	;

t       :   t MUL f
	|   t DIV f
	|   t MOD f
	|   f
	;

f       :   OBRKT expr CBRKT
	|   ID
	|   NUMBER
	|   CLITERAL       
	;  

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
	|   unary_expr SCOL
	|   IF OBRKT cond CBRKT stmnt
	|   IF OBRKT cond CBRKT stmnt ELSE stmnt
	|   whileL
	|   dowhile
	;

multiline   :   OBRCS stmnt CBRCS
	    ;

cond    :   expr
	|   assgn
	;

whileL   :   WHILE OBRKT cond CBRKT whilecontent
	 ;

dowhile	:	DO whilecontent WHILE OBRCS cond CBRCS SCOL
	;

whilecontent    :   single /*without using braces*/
		|   OBRCS stmnt CBRCS
		|   /*empty*/
		;
%%

void yyerror(char* s){
	extern int yylineno;
	extern char* yytext;
	fprintf(stderr,"Syntax Error for token %s at line %d\n",yytext,yylineno);
}

int main()
{
if(!yyparse()) printf("Valid\n");
return 0;
}
