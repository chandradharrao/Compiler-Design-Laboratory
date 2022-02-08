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
%token NUMBER PUREINT
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

%token OR AND

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

%token ARROPEN ARRCLOSE

%start program

%nonassoc ELSE
%left GREATER LESS GREATEREQ LESSEREQ NOTEQ
%left ADD SUB
%left MUL DIV
%right ASSI
%expect 102

%%
program :   HEADER program
		|   mainf program
		|   declr SCOL program
		|	arrDeclr SCOL program
		|	assgn SCOL program
		|   /*empty*/   
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
		|	arrDeclr SCOL
		|   assgn SCOL
		|	expr SCOL
		|   IF OBRKT cond CBRKT stmnt
		|   IF OBRKT cond CBRKT stmnt ELSE stmnt
		|   iterators
		;

assgn   :   ID ASSI expr
		|	arrID ASSI expr /*Array assignment*/
		;

multiline   :   OBRCS stmnt CBRCS
			;

cond    :   expr
		|   assgn
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

/*Array decleration*/
arrID	:	ID ARROPEN arrIndx ARRCLOSE arrInit
		;

arrIndx	:	PUREINT
		|	expr
		|	/*Empty*/
		;

arrDeclr	:	type  arrList
			|	type arrList arrInit
			;

arrInit	:	ASSI OBRCS arrContent CBRCS
		|	ASSI SLITERAL
		|	ASSI CLITERAL
		|	/*Empty*/
		;

arrList	:	arrList COMMA arrID 
		|	arrID
		;

arrContent	:	number
			|	number COMMA arrContent
			| 	CLITERAL COMMA arrContent
			;

/*
Arithmetic expression
Relational expressions
Conditional/ternary expressions,(todo)
Relational Expressions,
Logical Expressions,
Binary Expressions
Unary Expression

Precedence: Highest ---to---> lowest

conditional expr
||
&&
|
&
== , !=
< , > , <= , >=
+ , -
* / %
+ , - , ++ , -- !
() , []
*/
expr    :	expr OROR relAndExpr
		|	relAndExpr
		;

relAndExpr	:	relAndExpr ANDAND bitOrExpr
			|	bitOrExpr
			;

bitOrExpr	:	bitOrExpr OR bitAndExpr
			|	bitAndExpr
			;

bitAndExpr	:	bitAndExpr AND equality
			|	equality
			;

equality	:	equality eqop relExpr
			|	relExpr
			;

eqop		:	EQCOMP
			|	NOTEQ
			;

relExpr		:	arithExpr relop arithExpr
			|	arithExpr
			;

relop   :   LESS
		|   LESSEREQ
		|   GREATER
		|   GREATEREQ
		;

arithExpr	:	arithExpr ADD muldivExpr
			|	arithExpr SUB muldivExpr
			|	muldivExpr
			;

muldivExpr	:	muldivExpr MUL unaryExpr
			|	muldivExpr DIV unaryExpr
			|	muldivExpr MOD unaryExpr
			|	unaryExpr
			;

unaryExpr	:	ADD unaryExpr
			|	SUB unaryExpr
			|	NOT unaryExpr
			|	INC var
			|	DEC var
			|	var INC
			|	var DEC
			|	term
			;

var	:	ID
	|	arrID /*using arr[i] in various kinds if expressions*/
	;

term	:	var
		|	iconst //immutable constant - non variable expressions
		;

number	:	NUMBER
		|	PUREINT
		;

iconst	:	OBRKT expr CBRKT
		| 	number
		| 	CLITERAL
		|	SLITERAL
		;

iterators	:	whileL
			|	dowhile
			|	for
			;

for	:	FOR OBRKT forDeclr SCOL expr SCOL expr CBRKT stmnt 
	;

forDeclr	:	declr
			|	arrDeclr
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
