objects = ./src/main.cpp
l_objects = ./src/clang.l
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
	@./build/Token < ./test/demo.c


clean:
	@echo cleaning
	@-rm -r ./build ./lex.yy.c ./*.txt
clear:
	@echo cleaning
	@-rm -r ./build ./lex.yy.c ./*.txt