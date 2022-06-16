objects = main
l_objects = ./src/clang.l
t_objects = equal
y_objexts = ./src/gramma.y

lex = flex
bis = bison
# 编译得到的文件名字
BIN = mcc

# https://blog.csdn.net/zqixiao_09/article/details/50388695

# b: ./src/$(objects).cpp
# 	@-mkdir build
# 	@$(CXX) ./src/$(objects).cpp -o ./build/$(objects).o
# 	@./build/$(objects).o

# build简写
b: lb yb
	@-mkdir bin
	@$(CC) *.c -o ./bin/$(BIN).bin
	@-rm ./y.* ./clang.c
# 词法分析器生成
lb: $(l_objects) yb
	@$(lex) -o clang.c $(l_objects)
# 语法分析器生成
yb: $(y_objexts)
	@$(bis) -vdty $(y_objexts) -d
# run
r: b
	@./bin/$(BIN).bin ./test/$(t_objects).c

# unitTest
ut: b
	@./bin/$(BIN).bin ./test/$(t_objects).c 
	@nasm -f elf32 -P"./src/macro.inc" -P"./test/$(t_objects).inc" -o $(t_objects).o ./test/$(t_objects).asm
	@ld -m elf_i386 -o $(t_objects) $(t_objects).o

clean:
	@echo cleaning
	@-rm -r ./bin ./test/*.asm ./test/*.inc ./y.* ./clang.c
	@-rm $(t_objects) $(t_objects).o
clear:
	@echo cleaning
	@-rm -r ./bin ./*.asm ./y.* ./clang.c
	@-rm $(t_objects) $(t_objects).o

#＄＊　不包含扩展名的目标文件名称

#＄＜　第一个依赖文件的名称

#＄＠　目标文件的完整名称

#＄＾　所有不重复的目标依赖文件，以空格分开