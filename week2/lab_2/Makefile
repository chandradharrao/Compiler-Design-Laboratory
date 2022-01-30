# -*- Makefile -*-

#target: dependencies
	#action
	
#directly perform the 4 stages of compilation on the .c files to create an executable called "a.out".
#Along with that,link the lexer and yacc library that contain the function definations to the signatures used.
a.out: lex.yy.c y.tab.c
	gcc y.tab.c lex.yy.c -o a.out -ll -ly

#to create lex.yy.c, we need y.tab.h and lexer.l
lex.yy.c: y.tab.h lexer.l
	lex lexer.l
	
#to get y.tab.h,we need parser.y
y.tab.h: parser.y
	yacc -d parser.y

#to get y.tab.c, we need parser.y
y.tab.c: parser.y
	yacc -d parser.y

clean:
	rm -f compiler y.tab.h y.tab.c lex.yy.c a.out compiler

