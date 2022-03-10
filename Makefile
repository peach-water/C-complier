objects = ./src/main.cpp
l_objects = ./src/Token.l
h_objects = ./head/Token.h

lex = flex

b: $(objects)
	@-mkdir build
	@$(CXX) $(objects) -o ./build/main
	@./build/main

lb: $(l_objects)
	@-mkdir build
	@$(lex) $<
	@$(CC) ./lex.yy.c -o ./build/Token
	@./build/Token < ./test/a.cpp


clean:
	@echo cleaning
	@-rm -r ./build ./lex.yy.c ./analysis.a
clear:
	@echo cleaning
	@-rm -r ./build ./lex.yy.c ./analysis.a