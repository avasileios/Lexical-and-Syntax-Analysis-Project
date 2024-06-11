all: compiler

syntax.tab.c syntax.tab.h: syntax.y
	bison -v -d syntax.y

lex.yy.c: compiler.l syntax.tab.h
	flex compiler.l

compiler: lex.yy.c syntax.tab.c syntax.tab.h
	gcc syntax.tab.c lex.yy.c -lm extra/hashtbl.c


hashtbl.o: extra/hashtbl.c extra/hashtbl.h
	gcc extra/hashtbl.o -c extra/hashtbl.c

clean:
	rm a.out syntax.tab.c syntax.tab.h lex.yy.c
	rm syntax.output
