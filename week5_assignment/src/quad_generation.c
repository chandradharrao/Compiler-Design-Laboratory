#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "quad_generation.h"

/*
a->first operand
b->second operand
op->operator
c->result storing operand
*/
void quad_code_gen(char* a, char* b, char* op, char* c)
{
	//use fprintf to output the quadruple code to icg_quad_file
	fprintf(icg_quad_file,"%s,%s, %s, %s\n",op,a,b,c);
}

char* new_temp()
{
		//returns a pointer to a new temporary variable 
		char* new_temp = (char*)malloc(sizeof(char)*100);
		sprintf(new_temp,"temp%d",temp_no);
		temp_no++;
		return new_temp;
}

char* new_label(){
	char* new_label = (char*)malloc(sizeof(char)*100);
	sprintf(new_label,"L%d",label_no);
	label_no++;
	return new_label;
}