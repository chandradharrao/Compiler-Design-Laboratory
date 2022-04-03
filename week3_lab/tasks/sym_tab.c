#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sym_tab.h"

//made extern in header file.
table* t = NULL;

int strEq(char* a,char* b){
    return(strcmp(a,b)==0);
}

void init_table()	{
    //printf("Allocating table...\n");
    t = (table*)malloc(sizeof(table));
    t->head = NULL;
    t->tail = NULL;
    //printf("table allocated!Now returning...\n");
}

int remove_from_table(char* name,int scope){
    symbol* prev = NULL;
    symbol* curr = t->head;

    while(curr){
        if(strEq(curr->name,name) && curr->scope==scope){
            if(!prev){
                t->head = curr->next;
            }
            else{
                prev->next = curr->next;
            }
            return 1;
        }
        prev = curr;
        curr = curr->next;
    }
    return 0;
}

symbol* init_symbol(char* name, int size, int type, int lineno, int scope){
    symbol* new = (symbol*)malloc(sizeof(symbol));
    new->name = name;
    new->size = size;
    new->type = type;
    new->line = lineno;
    new->next = NULL;
    new->scope = scope;
    new->val = (char*)malloc(100);
    return new;
}

//resNode-> return pointer to the symbol table
symbol* doesExist(symbol* node){
    //printf("Checking for existence of (%s,%d)\n",node->name,node->scope);
    symbol* curr = t->head;

    while(curr!=NULL){
        if(strEq(node->name,curr->name) && node->scope==curr->scope){
            // printf("%s\n","found!");
            return curr;
        }else{
            curr=curr->next;
        }
    }
    return NULL;
}

symbol* insert_into_table(char* name, int size, int type, int lineno, int scope){
    symbol* new = init_symbol(name,size,type,lineno,scope);
    if(t->head==NULL){
        //table doesnt exists
        t->head = new;
        t->tail = new;
    }
    else{//table is not null

        //search if symbol already exists
        if(check_symbol_table(new->name,new->scope)){
            return NULL; //error
        }
        t->tail->next = new;
        t->tail = t->tail->next;
    }
    return new;
}

symbol* check_symbol_table(char* name,int scope){
    //check if the variable exists in current scope or in outer global scopes
    for(int i = scope;i>=1;i--){
        printf("Checking for %s in scop:%d\n",name,i);
        symbol* node = init_symbol(name,0,0,0,i);
        symbol* resNode = doesExist(node);
        if(resNode!=NULL){
            printf("%s\n","found!");
            printf("%s\n",resNode->name);
            return resNode;
        }
    }
    return NULL;
}

int insert_value_to_name(char* name,char* value,int scope){
    //only if declared before,we can insert into
    symbol* curr = t->head;
    while(curr!=NULL){
        if(strEq(curr->name,name) && curr->scope==scope){
            strcpy(curr->val,value);
            // curr->val = value;
            return 1;
        }
        curr=curr->next;
    }
    return 0; //not declared variabe hence error
}

void display_symbol_table(){
    //printf("Called disp_sym_table()\n");
    symbol* curr = t->head;
    printf("+=====+=====+=====+=====+=====+=====+\n");
    printf("|Name |Size |Type |Value|Line |Scope|\n");
    printf("+=====+=====+=====+=====+=====+=====+\n");
    while(curr!=NULL){
        printf("|%-5.5s|%5d|%5d|%-5.5s|%5d|%5d|\n",curr->name,curr->size,curr->type,curr->val,curr->line,curr->scope);
        curr = curr->next;
    }
    printf("+=====+=====+=====+=====+=====+=====+\n");
}
