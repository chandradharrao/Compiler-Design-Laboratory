%{
	#include "quad_generation.c"
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

	//queue to store labels created in "if" stmnts
	char* labels_q[1000];	
	int rear=0;
	int top = 0;

	//function to generate intermediate codes for "if" and "label"
	void int_code_label();
	void int_code_if();
%}

%token T_INT T_CHAR T_DOUBLE T_WHILE  T_INC T_DEC   T_OROR T_ANDAND T_EQCOMP T_NOTEQUAL T_GREATEREQ T_LESSEREQ T_LEFTSHIFT T_RIGHTSHIFT T_PRINTLN T_STRING  T_FLOAT T_BOOLEAN T_IF T_ELSE T_STRLITERAL T_DO T_INCLUDE T_HEADER T_MAIN T_ID T_NUM

%start START

%nonassoc T_IFX
%nonassoc T_ELSE

%%
START : PROG { /*printf("Valid syntax\n");*/ YYACCEPT; }	
        ;	
	  								
PROG	: ASSGN ';' PROG 		
		|	
		| {/*printf("Stmnt prog chosen\n");*/} STMT {/*printf("Done with stmnt\n"); */} PROG {/*printf("Done with Stmnt prog choosen!\n");*/}					
		; 
    
/* Grammar for assignment */   
ASSGN 	: T_ID '=' EXPR 	{
		$$ = strdup($1);
		char* op = strdup("=");
		char* op1 = strdup(" ");
		quad_code_gen($$,$3,op,op1);
	}
	;

EXPR 	: EXPR REL_OP E {
		printf("A condition!\n");
		$$ = new_temp();
		char* op = strdup($2);
		printf("Recieved Operator: %s\n",op);
		printf("Gen quad code!!\n");
		quad_code_gen($1,$3,op,$$);
}
	| E {
		$$ = strdup($1);
		}
    ;
	   
/* Expression Grammar */	   
E 	: E '+' T { 
		$$= new_temp();
		char* op = strdup("+");
		quad_code_gen($$,$1,op,$3);	
	}
    | E '-' T 	{ 
		$$ = new_temp();
		char* op = strdup("-");
		quad_code_gen($$,$1,op,$3);	
	}
    | T {
		$$ = strdup($1);
	}
    ;
	
	
T 	: T '*' F { 
		$$ = new_temp();
		char* op = strdup("*");
		quad_code_gen($$,$1,op,$3);	
	}
    | T '/' F { 
		$$ = new_temp();
		char* op = strdup("/");
		quad_code_gen($$,$1,op,$3);		
	}
    | F { $$ = strdup($1);}
    ;

F 	: '(' EXPR ')' {
		$$ = strdup($2);
	}
    | T_ID 	{
		$$ = strdup($1);	
		printf("Transferred %s...\n",$$);	
	}
    | T_NUM {
    	$$ = strdup($1);
		printf("Transferred %s...\n",$$);	
	}
    ;

REL_OP 	:'<' {$$ = strdup($1);}
		| '>' {/*printf("Assigned >\n");*/$$ = strdup(">");}
		| T_EQCOMP {$$ = strdup($1);}
		| T_NOTEQUAL {$$ = strdup($1);}
		;	

STMT 	: 	{/*printf("Blockless stmnt\n");*/} STMT_NO_BLOCK {int_code_label();}
		| 	{/*printf("Gear for block stmnt\n");*/} BLOCK STMT
		|	{/*printf("Empty stmnt exe!\n");*/}
		;

STMT_AFTER_IF	:	{/*printf("Stmnt after if\n");*/{int_code_label();}} STMT 
			;

EL	:	T_ELSE STMT_AFTER_IF ;
	|
	;

STMT_NO_BLOCK 	: ASSGN ';'{/*printf("Done with stmnt no block assi clause\n");*/}

				| 	{/*printf("Entering if else clause??wtf??\n");*/} 
					T_IF '(' COND ')' 
					{int_code_if(strdup($4));}
					{int_code_label();}
					STMT 
					{int_code_label();}
					EL;
       
//increment and decrement at particular points in the grammar to implement scope tracking
BLOCK : '{' {/*printf("\nBlock stmnt exe!\n");*/} STMT '}' {printf("Block stmnt done!\n");};

COND 	: EXPR {/*printf("Cond done sir!\n");*/}
    	;

%%

/* error handling function */
void yyerror(char* s)
{
	printf("Error :%s at %d \n",s,yylineno);
}

void int_code_label(){
	if(top<rear){
		//printf("Generating int. code for label...\n");
		char* l1 = labels_q[top++];
		//printf("Retrieved %s\n",l1);
		quad_code_gen(strdup(" "),strdup(" "),strdup("Label"),strdup(l1));
	}else{
		//printf("First if statement yet to be declared...\n");
	}
}

void int_code_if(char* dollar4){
	//printf("If statement matched!\n");
	char* l1 = strdup(new_label());
	char* l2 = strdup(new_label());

	quad_code_gen(strdup(dollar4),strdup(" "),strdup("if"),strdup(l1));
	quad_code_gen(strdup(" "),strdup(" "),strdup("goto"),strdup(l2));

	labels_q[rear++]=strdup(l1);
	//printf("Inserted %s\n",labels_q[rear-1]);
	labels_q[rear++]=strdup(l2);
	//printf("Inserted %s\n",labels_q[rear-1]);
}


/* main function - calls the yyparse() function which will in turn drive yylex() as well */
int main(int argc, char* argv[])
{
	icg_quad_file = fopen("icg_quad.txt","w");
	yyparse();
	fclose(icg_quad_file);
	return 0;
}
