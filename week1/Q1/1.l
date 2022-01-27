%%
int|float|char printf("keyword\n");
[a-zA-Z]([a-zA-Z0-9])* printf("Identifier\n");
[' '|\t|\n] ;
;|, printf("punctuation\n");
%%

int yywrap(){
    return 1;
}

int main(){
    yylex(); //convert the RE into corresponding c code
    return 0;
}