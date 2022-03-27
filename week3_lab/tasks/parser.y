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

	// enum types{
	// 	char=1,
	// 	int=2,
	// 	float=3,
	// 	double=4
	// };

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
	symbol* declare_variable();

	char temp[100]; //to store string version of integer

	void intToString(int num);

	int incrScope();
	int decrScope();

	//if we are processing a decleration statement
	int isDecl = 0;
%}

%token T_INT T_CHAR T_DOUBLE T_WHILE  T_INC T_DEC   T_OROR T_ANDAND T_EQCOMP T_NOTEQUAL T_GREATEREQ T_LESSEREQ T_LEFTSHIFT T_RIGHTSHIFT T_PRINTLN T_STRING  T_FLOAT T_BOOLEAN T_IF T_ELSE T_STRLITERAL T_DO T_INCLUDE T_HEADER T_MAIN T_ID T_NUM

%start START

%union{
	char* txt;
	struct symbol* node;
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
		printf("%s\n","Assignment while decleration!");
}
     	| T_ID 		{
			 printf("%s\n","[DEBUG]:Reduction of T_ID to V");
			 //if we are decleration
			 if(isDecl){
				symbol* node = declare_variable();
				if(node==NULL){
					yyerror("[ERROR]:Variable already declared!");
					exit(0);
				}
				$$.node = node;
				printf("Declared: %s\n",$$.node->name);
			 }
			else{
				//if we are using to terminate expressions like E+E
				//search if the variable is declerared already
				$$.node = check_symbol_table($$.txt,currScope);
				if($$.node==NULL){
					yyerror("[ERROR]:Variable not declared!");
					exit(0);
				}
			}
		}	 

//assign type here to be returned to the declaration grammar
TYPE 	: T_INT {isDecl = 1;typTrack(1);/*printf("Assigned INT\n")*/;}
		| T_FLOAT {typTrack(3);/*printf("Assigned FLOAT\n")*/;}
		| T_DOUBLE {typTrack(4);/*printf("Assigned DOUBLE\n")*/;}
		| T_CHAR {typTrack(2);/*printf("Assigned CHAR\n")*/;}
		;
    
/* Grammar for assignment */   
ASSGN 	: T_ID '=' EXPR 	{
	printf("%s\n","Assignment of val to var");
	//check if declared in the symbol table
	printf("Checking for %s,%d\n",$1.txt,currScope);
	$1.node = check_symbol_table($1.txt,currScope);
	if($1.node==NULL){
		yyerror("[ERROR]:Variable not declared!");
		exit(0);
	}else{
		printf("To assign val: %s to %s\n",$3.txt,$1.node->name);
		insert_value_to_name($1.node->name,$3.txt,currScope);
	}
}
		;

EXPR 	: EXPR REL_OP E
       	| E {
			   	$$.txt = (char*)malloc(100);
			   	strcpy($$.txt,$1.txt);
				printf("Reduction of E to Expr: %s\n",$$.txt);
		   }
       	;
	   
E 	: E '+' T
    | E '-' T
    | T {
		$$.txt = (char*)malloc(100);
		strcpy($$.txt,$1.txt);
		printf("Reduction of T to E: %s\n",$$.txt);
	}
    ;
	
	
T 	: T '*' F
    | T '/' F
    | F {
		$$.txt = (char*)malloc(100);
		strcpy($$.txt,$1.txt);
		printf("Reduction of F to T: %s\n",$$.txt);
	}
    ;

F 	: '(' EXPR ')'
    | T_ID {
	}
    | T_NUM {
		$$.txt = (char*)malloc(100);
		strcpy($$.txt,$1.txt);
		printf("Reduction of T_NUM to F: %s\n",$$.txt);
	}
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
MAIN : TYPE T_MAIN '(' EMPTY_LISTVAR ')' '{' {currScope = incrScope();}

					STMT 
					
					'}'{currScope = decrScope();}

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

BLOCK 	: '{' 	{currScope = incrScope();}
			STMT 
			'}'{currScope=decrScope();}

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

int incrScope(){
	currScope+=1;
	return currScope;
}

int decrScope(){
	currScope-=1;
	if(currScope<=0){
		currScope = 1;
	}
	return currScope;
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
symbol* declare_variable(){
	//printf("Processing to make sym table entry...\n");
	lineTrack(yylineno);
	symbol* res = insert_into_table(yylval.txt,size_of(*currDatatype),*currDatatype,*currLineNumber,currScope);
	if(res==NULL){
		yyerror("[ERROR] Variable already declared!");
		return NULL;
	}
	else{
		printf("%s\n","Declared var!");
		return res;
	}
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