%{
	#include "sym_tab.h"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	void typTrack(int type);
	void lineTrack(int lno);

	void yyerror(char* s); // error handling function
	int yylex(); // declare the function performing lexical analysis
	extern int yylineno; // track the line number

	/*No need to use stack to track current line number and datatype of variable since in the LMD of tree expansion,after parsing the grammar for first variable,it goes to the second variable.*/

	//current data type while parsing
	int* currDatatype=NULL;
	//current line number of variable decleration during parsing
	int* currLineNumber=NULL;
	//manage curr scope
	int currScope = 1;
	//get sizeof datatype
	int size_of(int type);

	//function to declare variable
	int declare_variable();

	char temp[100]; //to store string version of integer

	void intToString(int num);
%}

%token T_INT T_CHAR T_DOUBLE T_WHILE  T_INC T_DEC   T_OROR T_ANDAND T_EQCOMP T_NOTEQUAL T_GREATEREQ T_LESSEREQ T_LEFTSHIFT T_RIGHTSHIFT T_PRINTLN T_STRING  T_FLOAT T_BOOLEAN T_IF T_ELSE T_STRLITERAL T_DO T_INCLUDE T_HEADER T_MAIN T_ID T_NUM

%start START

%union{
	char* txt;
	int ival;
	float fval;
	double dval;
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

VAR		: T_ID '=' EXPR 	{}
     	| T_ID 		{declare_variable();}	 

//assign type here to be returned to the declaration grammar
TYPE 	: T_INT {typTrack(1);/*printf("Assigned INT\n")*/;}
		| T_FLOAT {typTrack(3);/*printf("Assigned FLOAT\n")*/;}
		| T_DOUBLE {typTrack(4);/*printf("Assigned DOUBLE\n")*/;}
		| T_CHAR {typTrack(2);/*printf("Assigned CHAR\n")*/;}
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
	//printf("Running Parser!\n");
	init_table();
	//printf("Table assigned too!\n");
	yyparse();
	/* display final symbol table*/
	return 0;
}

//assign the data type of variable decleration
void typTrack(int type){
	if(currDatatype==NULL){
		currDatatype = malloc(sizeof(int));
	}
	*currDatatype = type;
	//printf("Finished creating dtype!\n");
}

//track the line number of variable decleration
void lineTrack(int lno){
	if(currLineNumber==NULL){
		currLineNumber = malloc(sizeof(int));
	}
	*currLineNumber = lno;
	//printf("Finished asigning lineno!\n");
}

//function to insert variable decleration with type and line number into symbol table
int declare_variable(){
	//printf("Processing to make sym table entry...\n");
	lineTrack(yylineno);
	int res = insert_into_table(yylval.txt,size_of(*currDatatype),*currDatatype,*currLineNumber,currScope);
	if(!res)yyerror("[ERROR] Variable already declared!");else //printf("Successfully inserted var<%s>!\n",yylval.txt);	
	return res;
}

//function to return size of datatype
int size_of(int type){
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
	return size;		
}

void intToString(int num){
		sprintf(temp,"%d",num);
}