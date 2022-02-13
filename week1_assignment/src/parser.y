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
%expect 130

%%
program :   HEADER program
		|   mainf program
		|   declr SCOL program
		|	arrDeclr SCOL program
		|	assgn SCOL program
		|   /*empty*/   
		;

/*main function (not compulsory for a program) */
mainf   :   type MAIN OBRKT empty_listvar CBRKT OBRCS stmnt CBRCS
		;

/*parameter for main function*/
empty_listvar   :   listvar
				|   /*empty*/
				;

/*Stmnts can be single or multiline ones*/
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
		|	SCOL /*only semi colons allowed*/
		;

multiline   :   OBRCS stmnt CBRCS
			;

cond    :   expr
		|   assgn
		;

/*Can be array assignment or variable assignment only*/
assgn   :   ID ASSI expr
		|	arrID ASSI expr /*Array assignment*/
		;

/*Non array variable Decleration*/
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
		|	listvar COMMA arrID arrInit
		|	arrID arrInit
		;

/*Array decleration*/
arrID	:	ID ARROPEN arrIndx ARRCLOSE
		;

arrIndx	:	PUREINT
		|	expr
		|	assgn
		|	/*Empty*/
		;

arrDeclr	:	type  listvar
			|	type listvar arrInit
			;

arrInit	:	ASSI OBRCS arrContent CBRCS
		|	ASSI SLITERAL
		|	ASSI CLITERAL
		|	/*Empty*/
		;

/* arrList	:	arrList COMMA arrID arrInit
		|	arrID arrInit
		; */

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

/*Non terminal*/		
term	:	var
		|	iconst //immutable constant - non variable expressions
		;

/*Variables are mutables : Identifiers and array[indx] */
var	:	ID
	|	arrID /*using arr[i] in various kinds if expressions*/
	;

/*Number can be an INTEGER or non integer*/
number	:	NUMBER
		|	PUREINT
		;

/* constants*/
iconst	:	OBRKT expr CBRKT
		| 	number
		| 	CLITERAL
		|	SLITERAL
		;

/*iteratos like while,do while and for loop*/
iterators	:	whileL
			|	dowhile
			|	for
			;

/* For loop*/
for	:	FOR OBRKT forDeclr SCOL expr SCOL expr CBRKT stmnt 
	;

/*the decleration can be an array initialization or a variable intiialization or nothing*/
forDeclr	:	declr
			|	arrDeclr
			;

whileL   :   WHILE OBRKT cond CBRKT whilecontent
	 	 ;

dowhile	:	DO whilecontent WHILE OBRKT cond CBRKT SCOL
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
