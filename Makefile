objects = main
l_objects = ./src/clang.l
h_objects = ./head/Token.h
o_objects = ./build/Token.o
t_objects = ./test/demo.c

lex = flex

b: ./src/$(objects).cpp
	@-mkdir build
	@$(CXX) ./src/$(objects).cpp -o ./build/$(objects).o
	@./build/$(objects).o

lb: $(l_objects)
	@-mkdir build
	@$(lex) $<
	@$(CC) ./lex.yy.c -o $(o_objects)

# unitTest
ut: lb
	@$(o_objects) < $(t_objects)

clean:
	@echo cleaning
	@-rm -r ./build ./lex.yy.c ./*.txt
clear:
	@echo cleaning
	@-rm -r ./build ./lex.yy.c ./*.txt