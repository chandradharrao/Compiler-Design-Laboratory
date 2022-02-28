#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include "sym_tab.h"

table* init_table()	{
   t = (table*)malloc(sizeof(table));
   t->head = NULL;
   t->tail = NULL;
   return t;
}

symbol* init_symbol(char* name, int size, int type, int lineno, int scope){
    symbol* new = (symbol*)malloc(sizeof(symbol));
    new->name = name;
    new->size = size;
    new->type = type;
    new->line = lineno;
    new->next = NULL;
    new->scope = scope;
    return new;
}

int doesExist(symbol* node){
    printf("Checking for existence of (%s,%d)\n",node->name,node->scope);
    symbol* curr = t->head;

    while(curr!=NULL){
        if(node->name==curr->name && node->scope==curr->scope){
            return 1;
        }else{
            curr=curr->next;
        }
    }
    return 0;
}

int insert_into_table(char* name, int size, int type, int lineno, int scope){
    symbol* new = init_symbol(name,size,type,lineno,scope);
    if(t->head==NULL){
        //table doesnt exists
        t->head = new;
        t->tail = new;
    }else{
        //table is not null,search if symbol already exists
        if(doesExist(new)){
            return 0; //error
        }
        t->tail->next = new;
        t->tail = t->tail->next;
    }
}

int check_symbol_table(char* name,int scope){
    symbol* node = init_symbol(name,0,0,0,scope);
    return doesExist(node);
}

int insert_value_to_name(char* name,char* value){
    //only if declared before,we can insert into
    symbol* curr = t->head;
    while(curr!=NULL){
        if(curr->name == name){
            curr->val = value;
            return 1;
        }
        curr=curr->next;
    }
    return 0; //not declared variabe hence error
}

void display_symbol_table(){
    printf("Called disp_sym_table()\n");
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
