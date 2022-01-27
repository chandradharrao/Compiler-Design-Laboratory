%{
    #include<stdio.h>
    int count = 0;
%}

%%
([a-zA-Z0-9_]+) count++;
. ;
\n printf("The number of words is %d\n",count);
%%

int yywrap(){
    return 1;
}

int main(){
    //Write a lex program to count the number of words in a statement

    yylex();
    return 0;
}