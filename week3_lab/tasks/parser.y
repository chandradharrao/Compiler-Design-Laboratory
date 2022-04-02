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
	symbol* declare_variable(char* varname);

	char* temp; //to store string version of integer
	char* temp2;;

	void intToString(int num);
	void floatToString(float num);

	int incrScope();
	int decrScope();

	//if we are processing a decleration statement
	int isDecl = 0;
%}

%token T_INT T_CHAR T_DOUBLE T_WHILE  T_INC T_DEC   T_OROR T_ANDAND T_EQCOMP T_NOTEQUAL T_GREATEREQ T_LESSEREQ T_LEFTSHIFT T_RIGHTSHIFT T_//printLN T_STRING  T_FLOAT T_BOOLEAN T_IF T_ELSE T_STRLITERAL T_DO T_INCLUDE T_HEADER T_MAIN T_ID T_NUM

%start START

%union{
	int dtype;
	int ival;
	float fval;
	char* varname;
	char* number;
	char* cval;
	int remVar; //remove variable from sym tab;e
}

%%
START 	: PROG { 
		display_symbol_table();
		//printf("Valid syntax\n"); 
		YYACCEPT; 

		//destructor
		free(temp);
		free(temp2);
		free(currDatatype);
		free(currLineNumber);
	}	
    	;	
	  
PROG 	:  	MAIN PROG				
		|	DECLR ';' PROG 				
		| 	ASSGN ';' PROG 			
		| 					
		;
	 
DECLR 	: 
{
	//printf("New variable decleration!\n");
}
TYPE LISTVAR 
{
	//printf("Finished Variable decleration!\n");
	isDecl=0;
}
		;	


LISTVAR : LISTVAR ',' VAR 
	  	| VAR
	  	;

VAR		: T_ID '=' EXPR 	{
		if($3.remVar!=1){
			//printf("%s\n","Assignment while decleration!");
			if(isDecl){
				//printf("Declaring var %s...\n",$1.varname);
				symbol* node = declare_variable($1.varname);

				if(!node){
					yyerror("[ERROR]:Variable already declared!");
				}
				else{
					//printf("Declared: %s\n",node->name);
					//if running datattype is int
					if(*currDatatype==2){
						temp = (char*)malloc(sizeof(char)*100);
						intToString($3.ival);
						node->val = temp;
					}
					//if running datatype is float
					else if(*currDatatype==3 || *currDatatype==4){
						temp = (char*)malloc(sizeof(char)*100);
						floatToString($3.fval);
						node->val = temp;
					}
					//if running datatype is char
					else{
						node->val = $3.cval;
					}
				}
			}
		}
}
     	| T_ID 		{
			if($1.remVar!=1){
				//printf("%s\n","[DEBUG]:Reduction of T_ID to V");
			 	//if we are declaring variables like int x;
				if(isDecl){
					symbol* node = declare_variable($1.varname);
					if(node==NULL){
						yyerror("[ERROR]:Variable already declared!");
					}
					else{
						//printf("Declared: %s\n",node->name);
					}	
				}
				else{
					//if we are using to terminate expressions like E+E
					//search if the variable is declerared already
					symbol* node = check_symbol_table($$.varname,currScope);
					if(node==NULL){
						yyerror("[ERROR]:Variable not declared!");
					}
				}
			}
		}	 

//assign type here to be returned to the declaration grammar
TYPE 	: T_INT {isDecl=1;typTrack(2);}
		| T_FLOAT {isDecl=1;typTrack(3);}
		| T_DOUBLE {isDecl=1;typTrack(4);}
		| T_CHAR {isDecl=1;typTrack(1);}
		;
    
/* Grammar for assignment */   
ASSGN 	: T_ID '=' EXPR 	{
	if($3.remVar!=1){
		//printf("%s\n","Assignment of val to var");
		//check if declared in the symbol table
		//printf("Checking for %s,%d\n",$1.varname,currScope);
		symbol* variable = check_symbol_table($1.varname,currScope);
		if(!variable){
			yyerror("[ERROR]:Variable not declared!");
		}else{
			if(*currDatatype==2){
				//printf("To assign val: %d to %s\n",$3.ival,$1.varname);
				//weird error if i dont do this...
				temp2 = (char*)malloc(sizeof(char)*100);
				strcpy(temp2,$1.varname);
				$1.ival = $3.ival;
				temp = (char*)malloc(sizeof(char)*100);
				intToString($3.ival);
				//printf("Converted from int to string %s\n",temp);
				
				int res = insert_value_to_name(temp2,temp,currScope);
				if(res){
					//printf("Assigned val in sym table\n");
				}else{
					//printf("Var undeclared!\n");
				}
			}
			else if(*currDatatype==3 || *currDatatype==4){
				temp2 = (char*)malloc(sizeof(char)*100);
				strcpy(temp2,$1.varname);
				$1.fval = $3.fval;
				temp = (char*)malloc(sizeof(char)*100);
				floatToString($3.fval);
				insert_value_to_name(temp2,temp,currScope);
			}
			else{
				//character
				insert_value_to_name($1.varname,$3.cval,currScope);
			}
		}
	}
	$$.remVar = $1.remVar;
}
		;

EXPR 	: EXPR REL_OP E
       	| E {
			   	if($1.remVar!=1){
					if(*currDatatype==2){
					   	$$.ival = $1.ival;
						//printf("Reduction of E to Expr: %d\n",$$.ival);
					}
					else if(*currDatatype==3 || *currDatatype==4){
						$$.fval = $1.fval;
					}
					else{
						//character type
						$$.cval = $1.cval;
					}
				}
			   	$$.remVar = $1.remVar;
		   }
       	;
	   
E 	: E '+' T{
	//printf("Currdatatype: %d\n",*currDatatype);
	//printf("Addition expression called!\n");

	if(*currDatatype==1 || $1.remVar==1 || $3.remVar==1){
			yyerror("[ERROR}:Cannot do div for string!");
			$$.remVar = 1;
	}
	else if(*currDatatype==2){
		int sum =0;
		//printf("Args %d,%d\n",$1.ival,$3.ival);
		sum = $1.ival+$3.ival;
		//printf("The Sum obtained from expression is %d\n",sum);
		$$.ival = sum;
	}
}
    | E '-' T {
		if(*currDatatype==1 || $1.remVar==1 || $3.remVar==1){
			yyerror("[ERROR}:Cannot do div for string!");
			$$.remVar = 1;
		}
		else if(*currDatatype==2){
			$$.ival= $1.ival-$3.ival;
		}
		else if(*currDatatype==3 || *currDatatype==4){
			$$.fval= $1.fval-$3.fval;
		}
		else if(*currDatatype==1){
			yyerror("[ERROR]:cannot do subtratcion with string!");
		}
		$$.remVar = 1;
	}
    | T {
		//printf("Reduction of T to E\n");
		if($1.remVar!=1){
			if(*currDatatype==2){
				$$.ival = $1.ival;
			}
			else if(*currDatatype==3 || *currDatatype==4){
				$$.fval = $1.fval;
			}
			else if(*currDatatype==1){
				$$.cval = $1.cval;
			}
		}
		$$.remVar = $1.remVar;
	}
    ;
	
	
T 	: T '*' F {
	if(*currDatatype==1 || $1.remVar==1 || $3.remVar==1){
			yyerror("[ERROR}:Cannot do div for string!");
			$$.remVar = 1;
	}
	else if(*currDatatype==2){
		$$.ival = (int)$1.ival*(int)$3.ival;
	}
	else if(*currDatatype==3 || *currDatatype==4){
		$$.fval = (float)$1.fval*(float)$3.fval;
	}
	$$.remVar = 1;
}
    | T '/' F {
		if(*currDatatype==1 || $1.remVar==1 || $3.remVar==1){
			yyerror("[ERROR}:Cannot do div for string!");
			$$.remVar = 1;
		}
		else{
			//lower grammar rules will take care to supply $1 and $3 with ivals and not fvals.
			if(*currDatatype==2){
				$$.ival = (int)$1.ival/(int)$3.ival;
			}
			//lower grammar rules will supply $1 and $3 with fvals and not ivals
			else if(*currDatatype==3 || *currDatatype==4){
				$$.fval = (float)$1.fval/(float)$3.fval;
			}
		}
	}
    | F {
		//printf("Reduction of F to T\n");
		if($1.remVar!=1){
			if(*currDatatype==2){
				$$.ival = $1.ival;
			}
			else if(*currDatatype==3 || *currDatatype==4){
				$$.fval = $1.fval;
			}
			else if(*currDatatype==1){
				strcpy($$.cval,$1.cval);
			}
		}
		$$.remVar = $1.remVar;
	}
    ;

F 	: '(' EXPR ')'{
	$$ = $2;
}
    | T_ID {
		//printf("T_ID of var %s called\n",$1.varname);
		symbol* variable = check_symbol_table($1.varname,currScope);
		if(variable && variable->val){
			//printf("%s\n","found Entry!!");
			//printf("%s.val=%s\n",variable->name,variable->val);
			//running ie context datatype==int
			if(*currDatatype==2){
				//if variable is float convert to int
				if(variable->type==3 || variable->type==4){
					//printf("Float to int :(\n");
					$$.ival = (int)atof(variable->val);
				}
				//if variable is int,copy it
				else if(variable->type==2){
					//printf("Int to int :)\n");
					$$.ival = atoi(variable->val);
				}
				//if var is string,error
				else if(variable->type==1){
					yyerror("[ERROR]:Cannot assign string to int!");
					$$.remVar = 1;
				}
				//printf("T_ID reduction to F=%d\n",$$.ival);
			}
			//running datatype is float
			else if(*currDatatype==3 || || *currDatatype==4){
				//if variable type is int,typecast
				if(variable->type==2){
					$$.fval = (float)atoi(variable->val);
				}else if(variable->type==3 || variable->type==4){
					$$.fval = atof(variable->val);
				}else if(variable->type==1){
					yyerror("[ERROR]:Cannot assign string to float!");
					$$.remVar = 1;
				}
			}
		}
	}
    | T_NUM {
		if(*currDatatype==2){
			//printf("Integer Constant: %d\n",atoi($1.number));
			$$.ival = atoi($1.number);
		}
		else if(*currDatatype==3 || *currDatatype==4){
			$$.fval = atof($1.number);
		}
		//printf("Reduction of T_NUM to F\n");
	}
    | T_STRLITERAL {
		//printf("String literal!\n");
		if(*currDatatype==2){
				yyerror("[ERROR:] type mismatch! Cant assign string to int type");
				//remove decleration from symbol table
				$$.remVar = 1;
			}
		else if(*currDatatype==3 || *currDatatype==4){
				yyerror("[ERROR:] type mismatch! Cant assign string to float type");
				$$.remVar = 1;
			}
	}
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
	//printf("\033[0;31m");
	//printf("%s at %d \n",s,yylineno);
	//printf("\033[0m");
}


int main(int argc, char* argv[])
{
	////printf("Running Parser!\n");
	init_table();
	////printf("Table assigned too!\n");
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
	////printf("Finished creating dtype!\n");
}

//track the line number of variable decleration
void lineTrack(int lno){
	if(currLineNumber==NULL){
		currLineNumber = malloc(sizeof(int));
	}
	*currLineNumber = lno;
	////printf("Finished asigning lineno!\n");
}

//function to insert variable decleration with type and line number into symbol table
symbol* declare_variable(char* varname){
	////printf("Processing to make sym table entry...\n");
	lineTrack(yylineno);
	symbol* res = insert_into_table(varname,size_of(*currDatatype),*currDatatype,*currLineNumber,currScope);
	if(res==NULL){
		yyerror("[ERROR] Variable already declared!");
		return NULL;
	}
	else{
		//printf("%s\n","Declared var!");
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

void floatToString(float num){
	sprintf(temp,"%f",num);
}