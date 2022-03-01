%{
	#include "sym_tab.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	/*
		declare variables to help you keep track or store properties
		scope can be default value for this lab(implementation in the next lab)
	*/
	void varDeclr(int type,int line);
	void yyerror(char* s); // error handling function
	int yylex(); // declare the function performing lexical analysis
	extern int yylineno; // track the line number

	//current data type while parsing
	int* currDatatype=NULL;
	//current line number of variable decleration during parsing
	int* currLineNumber=NULL;
	//manage curr scope
	int currScope = 1;
%}

%token T_INT T_CHAR T_DOUBLE T_WHILE  T_INC T_DEC   T_OROR T_ANDAND T_EQCOMP T_NOTEQUAL T_GREATEREQ T_LESSEREQ T_LEFTSHIFT T_RIGHTSHIFT T_PRINTLN T_STRING  T_FLOAT T_BOOLEAN T_IF T_ELSE T_STRLITERAL T_DO T_INCLUDE T_HEADER T_MAIN T_ID T_NUM

%start START

%union{
	char* txt;
	int ival;
}

%%
START 	: PROG { display_symbol_table();printf("Valid syntax\n"); YYACCEPT; }	
    	;	
	  
PROG 	:  	MAIN PROG				
		|	DECLR ';' PROG 				
		| 	ASSGN ';' PROG 			
		| 					
		;
	 
DECLR 	: TYPE LISTVAR 
		;	


LISTVAR : LISTVAR ',' VAR 
	  	| VAR
	  	;

VAR		: T_ID '=' EXPR 	{
	

}
     	| T_ID 		{		
				printf("Processing to make sym table entry...\n");
				int size = 0;
				switch(*currDatatype){
					case 1:
						size = 4;
						break;
					case 2:
						size = 1;
						break;
					case 3:
						size = 8;
						break;
					case 4:
						size=16;
						break;
					default:
						size = 4;
						break;
				}
				int res = insert_into_table(yylval.txt,size,*currDatatype,*currLineNumber,currScope);
				if(!res)yyerror("[ERROR] Variable already declared!");else printf("Successfully inserted var<%s>!\n",yylval.txt);	
			}	 

//assign type here to be returned to the declaration grammar
TYPE 	: T_INT {varDeclr(1,yylineno);printf("Assigned INT\n");}
		| T_FLOAT {varDeclr(3,yylineno);printf("Assigned FLOAT\n");}
		| T_DOUBLE {varDeclr(4,yylineno);printf("Assigned DOUBLE\n");}
		| T_CHAR {varDeclr(2,yylineno);printf("Assigned CHAR\n");}
		;
    
/* Grammar for assignment */   
ASSGN 	: T_ID '=' EXPR 	{}
		;

EXPR 	: EXPR REL_OP E
       	| E 
       	;
	   
E 	: E '+' T
    | E '-' T
    | T 
    ;
	
	
T 	: T '*' F
    | T '/' F
    | F
    ;

F 	: '(' EXPR ')'
    | T_ID
    | T_NUM 
    | T_STRLITERAL 
    ;

REL_OP :   T_LESSEREQ
	   | T_GREATEREQ
	   | '<' 
	   | '>' 
	   | T_EQCOMP
	   | T_NOTEQUAL
	   ;	


/* Grammar for main function */
MAIN : TYPE T_MAIN '(' EMPTY_LISTVAR ')' '{' STMT '}';

EMPTY_LISTVAR 	: LISTVAR
				|	
				;

STMT 	: STMT_NO_BLOCK STMT
       	| BLOCK STMT 
       	|
       	;


STMT_NO_BLOCK 	: DECLR ';'
       			| ASSGN ';' 
       			;

BLOCK 	: '{' STMT '}';

COND : EXPR 
       | ASSGN
       ;
%%


/* error handling function */
void yyerror(char* s)
{
	printf("Error :%s at %d \n",s,yylineno);
}


int main(int argc, char* argv[])
{
	printf("Running Parser!\n");
	init_table();
	printf("Table assigned too!\n");
	yyparse();
	/* display final symbol table*/
	return 0;
}

//assign the line number of variable decleration and its type
void varDeclr(int type,int lno){
	if(currDatatype==NULL || currLineNumber==NULL){
		currDatatype = malloc(sizeof(int));
		currLineNumber = malloc(sizeof(int));
	}
	*currDatatype = type;
	*currLineNumber = lno;
	printf("Finished creating dtype!\n");
}
