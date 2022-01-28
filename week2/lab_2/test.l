%%
main\(\) printf("MAIN()");
^\"[^"\\]*(\\.[^"\\]*)*\"$ printf("sliteral");
^\<[^<]+\>$ printf("header file");
\#include(\"[a-zA-Z][a-zA-Z0-9]+[\.][a-zA-Z]+\"|\<[a-zA-Z][a-zA-Z0-9]+[\.][a-zA-Z]+\>) printf("header");
%%

int yywrap(){
    return 1;
}

int main(){
    yylex();
    return 0;
}