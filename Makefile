objects = main
l_objects = ./src/clang.l
h_objects = ./head/*.h
o_objects = ./build/Token.o
t_objects = ./test/demo.c
y_objexts = ./src/*.y

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
	@$(CC) ./build/*.c -o ./bin/$(BIN).bin
# 词法分析器生成
lb: $(l_objects) yb
	@$(lex) -o ./build/clang.c $(l_objects)
# 语法分析器生成
yb: $(y_objexts)
	@-mkdir build
	@$(bis) -vdty $(y_objexts) -o ./build/y.lab.c
# run
r: 
	@python3 quat.py > output.txt
#	@./bin/$(BIN).bin < ./test/equal.c > out.asm


# unitTest
ut: lb
	@$(o_objects) < $(t_objects) > ./out.asm

clean:
	@echo cleaning
	@-rm -r ./build ./bin ./*.asm
clear:
	@echo cleaning
	@-rm -r ./build ./bin ./*.asm

#＄＊　不包含扩展名的目标文件名称

#＄＜　第一个依赖文件的名称

#＄＠　目标文件的完整名称

#＄＾　所有不重复的目标依赖文件，以空格分开