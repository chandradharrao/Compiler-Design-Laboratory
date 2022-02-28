#include <stdio.h>
#include "sym_tab.h"

int main(){
    //using static table* t available
    t = init_table();
    printf("Table created!\n");
    display_symbol_table();
    printf("Doing future operations!\n");
    
    /*
    scope 1 : global scope
    type 1: int
    type 2: char
    */
    char a[2] = {'a'};
    int res = insert_into_table(a,4,1,1,1);
    if(res) printf("insert of '%s' success\n",a);else printf("insert of '%s' not success\n",a);
    res = insert_into_table(a,4,1,2,2);
    if(res) printf("insert of '%s' success\n",a);else printf("insert of '%s' not success\n",a);
    char b[2] = {'c'};
    insert_into_table(b,1,2,4,1);
    if(res) printf("insert of '%s' success\n",b);else printf("insert of '%s' not success\n",b);

    display_symbol_table();

    res = check_symbol_table(a,1);
    if(res) printf("%s","Found a\n");else printf("%s","Not found a\n");
    res = check_symbol_table(b,1);
    if(res) printf("%s","Found c\n");else printf("%s","Not found c\n");

    char value[2] = {'6'};
    insert_value_to_name(a,value);
    char value1[2] = {'7'};
    insert_value_to_name(b,value1);

    display_symbol_table();

    return 0;
}