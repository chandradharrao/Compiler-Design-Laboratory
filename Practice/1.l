%{
    int yylineno=0;
%}
%%
^(.*)\n printf("%d\t%s",++yylineno,yytext);
%%
int main(int argc,char* argv[]){
    //program to read file and add print line numbers
    yyin = fopen(argv[1],"r");
    yylex();
    fclose(yyin);
}