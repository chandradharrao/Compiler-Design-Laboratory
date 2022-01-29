letter [a-zA-Z]
digit [0-9]
identifier {letter}({letter}|{digit})*
number [+-]?{digit}{digit}*(\.{digit}+)?
space [\n\t ]+

%%
int return 44;
main{space}*\(\) return 1;
^\"[^"\\]*(\\.[^"\\]*)*\"$ return 2;
\#include({space}*)(\"[a-zA-Z][a-zA-Z0-9]+[\.][a-zA-Z]+\"|\<[a-zA-Z][a-zA-Z0-9]+[\.][a-zA-Z]+\>) return 3;
\((({identifier}([,]{identifier})*)?)\) return 4;
\((({number}([,]{number})*)?)\) return 4;
{letter} return 69;
{space} ;
%%

int yywrap(){
    return 1;
}

int main(){
    int scan;
    scan = yylex();
    while(scan){
        printf("%d\n",scan);
        scan = yylex();
    }
    return 0;
}