#!/bin/bash

yacc -d parser.y
lex lexer.l
gcc -g y.tab.c lex.yy.c sym_tab.c -ll
# valgrind --leak-check=yes ./a.out<sample_input1.c   
./a.out<sample_input1.c
