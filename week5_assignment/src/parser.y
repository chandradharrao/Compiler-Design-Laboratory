%{
	#include "sym_tab.c"
	#include <stdio.h>
	#include <stdlib.h>
	#include <string.h>
	#define YYSTYPE char*
	void yyerror(char* s); 											// error handling function
	int yylex(); 													// declare the function performing lexical analysis
	extern int yylineno; 											// track the line number

	FILE* icg_quad_file;

	//temperoray variable name which is incremented everytime
	int temp_no = 1;

	//label name integer
	int label_no = 1;

%}

%token T_INT T_CHAR T_DOUBLE T_WHILE  T_INC T_DEC   T_OROR T_ANDAND T_EQCOMP T_NOTEQUAL T_GREATEREQ T_LESSEREQ T_LEFTSHIFT T_RIGHTSHIFT T_PRINTLN T_STRING  T_FLOAT T_BOOLEAN T_IF T_ELSE T_STRLITERAL T_DO T_INCLUDE T_HEADER T_MAIN T_ID T_NUM

%start START

%union{
	char* temp;
	char* label;
}


%nonassoc T_IFX
%nonassoc T_ELSE

%%
START : PROG { printf("Valid syntax\n"); YYACCEPT; }	
        ;	
	  
PROG :  MAIN PROG				
	|DECLR ';' PROG 				
	| ASSGN ';' PROG 			
	| 					
	;
	 

DECLR : TYPE LISTVAR 
	;	


LISTVAR : LISTVAR ',' VAR 
	  | VAR
	  ;

VAR: T_ID '=' EXPR 	{
				/*
				    check if symbol is in the table
				    if it is then error for redeclared variable
				    else make entry and insert into table
				    insert value coming from EXPR
				    revert variables to default values:value,type
                   		 */
			}
     | T_ID 		{
				/*
                   			finished in lab 2
                    		*/
			}	 

//assign type here to be returned to the declaration grammar
TYPE : T_INT 
       | T_FLOAT 
       | T_DOUBLE 
       | T_CHAR 
       ;
    
/* Grammar for assignment */   
ASSGN : T_ID '=' EXPR 	{
			/*
               			 Check if variable is declared in the table
               			 insert value
            		*/
			}
	;

EXPR : EXPR REL_OP E {
	$$ 
}
       | E 	//store value using value variable declared before
       ;
	   
/* Expression Grammar */	   
E : E '+' T 	{ 
		$$.temp = new_temp();
		char* op = strdup("+");
		quad_code_gen($$.temp,$1.temp,op,$3.temp);	
	}
    | E '-' T 	{ 
		$$.temp = new_temp();
		char* op = strdup("-");
		quad_code_gen($$.temp,$1.temp,op,$3.temp);	
	}
    | T {
		$$.temp = strdup($1);
	}
    ;
	
	
T : T '*' F 	{ 
		$$.temp = new_temp();
		char* op = strdup("*");
		quad_code_gen($$.temp,$1.temp,op,$3.temp);	
	}
    | T '/' F 	{ 
		$$.temp = new_temp();
		char* op = strdup("/");
		quad_code_gen($$.temp,$1.temp,op,$3.temp);		
	}
    | F //copy value from F to grammar rule T
    ;

F : '(' EXPR ')' {
	$$.text = strdup($2);
	}
    | T_ID 	{
	$$.text = strdup($1);		
	}
    | T_NUM {
    		$$.text = strdup($1);
	}
    ;

REL_OP :   T_LESSEREQ {$$.text = strdup($1);}
	   | T_GREATEREQ {$$.text = strdup($1);}
	   | '<' {$$.text = strdup($1);}
	   | '>' {$$.text = strdup($1);}
	   | T_EQCOMP {$$.text = strdup($1);}
	   | T_NOTEQUAL {$$.text = strdup($1);}
	   ;	


/* Grammar for main function */
//increment and decrement at particular points in the grammar to implement scope tracking
MAIN : TYPE T_MAIN '(' EMPTY_LISTVAR ')' '{' STMT '}';

EMPTY_LISTVAR : LISTVAR
		|	
		;

STMT : STMT_NO_BLOCK STMT
       | BLOCK STMT
       |
       ;


STMT_NO_BLOCK : DECLR ';'
       | ASSGN ';'
       | T_IF '(' COND ')' {$3 = labelgen();} STMT %prec T_IFX	/* if loop*/
       | T_IF '(' COND ')' STMT T_ELSE STMT	/* if else loop */ 
       ;
       
//increment and decrement at particular points in the grammar to implement scope tracking
BLOCK : '{' STMT '}';

COND : EXPR {
	quad_code_gen(strdup("if"),$1);
}
    | ASSGN
       ;


%%

/* error handling function */
void yyerror(char* s)
{
	printf("Error :%s at %d \n",s,yylineno);
}


/* main function - calls the yyparse() function which will in turn drive yylex() as well */
int main(int argc, char* argv[])
{
	icg_quad_file = fopen("icg_quad.txt","w");
	yyparse();
	fclose(icg_quad_file);
	return 0;
}
