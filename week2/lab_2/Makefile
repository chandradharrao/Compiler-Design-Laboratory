LEX = lex
YACC = yacc
YFLAGS = -d
objects = lexer.o parse.o myprogram.objects
myprogram: $(objects)
lexer.o: lexer.l lexer.c
parse.o: parse.y
myprogram.o: myprogram.c 
clean: -rm *.o $(objects)