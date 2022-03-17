# C-complier
编译原理编译器实验

# 目前进度
* 完成词法分析器，测试正确的词法输出 -2022.3.17

# 编译方法

**重要**：需要flex工具

下面的命令生成词法分析器
```shell
$ make lb
```

使用下面的命令，运行单元测试，并给出词法分析结果
```shell
$ make ut
```


使用如下命令来清理编译结果
```shell
$ make clean || make clear
```

