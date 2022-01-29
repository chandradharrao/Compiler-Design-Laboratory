space [\n\t ]+

%%
\/\/({space}*)(.*) ;
\/\*({space}*)(.*)({space}*)\*\/ ;
%%

int yywrap(){
    return 1;
}

int main(){
    //write lex program to identify comments in a c program and remove them
    printf("Enter file name:\n");
    char name[20];
    scanf("%s",name);
    yyin = fopen(name,"r");
    yyout = fopen("out.c","w");
    yylex();
    return 0;
}