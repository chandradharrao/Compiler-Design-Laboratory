#!/bin/bash

rm -f out.txt output1.txt lex.yy.c y.tab. sym.tab.o a.out
yacc -d parser.y

lex lexer.l
gcc -g y.tab.c lex.yy.c sym_tab.c -ll
# valgrind --leak-check=yes ./a.out<sample_input1.c   
./a.out<sample_input0.c
./a.out<sample_input1.c
./a.out<sample_input2.c
./a.out<sample_input3.c

# valgrind --leak-check=yes ./a.out<sample_input1.c