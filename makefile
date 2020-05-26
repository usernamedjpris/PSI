all: comp
	./comp < cible.c
	echo "\n\n"
	cat cible.c
	echo "\n\n"
	cat asm.txt

comp: y.tab.o lex.yy.o
	gcc -Wall y.tab.o lex.yy.o -o comp

y.tab.c: source.y
	yacc --verbose --debug -v -d source.y

lex.yy.c: source.l
	lex source.l
