objects = ./src/main.cpp
l_objects = ./src/Token.l
h_objects = ./head/Token.h

lex = flex

b: $(objects)
	@$(CXX) $(objects) -o main
	@./main

lb: $(l_objects)
	@$(lex) $<
	@$(CC) ./lex.yy.c -o Token
	@./Token < ./test/a.cpp


clean:
clear:
	@echo cleaning
	@-rm ./main ./Token ./src/lex.yy.c ./lex.yy.c