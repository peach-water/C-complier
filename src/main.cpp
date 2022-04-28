#include <iostream>
#include <fstream>
// #include "../head/Token.h"


int main()
{
    std::ifstream fp;
    fp.open("./test/demo.c");
    char buf[100];

    if(!fp.is_open()){
        std::cout << "file open error" << std::endl;
        return 0;
    }

    while (!fp.eof())
    {
        fp.getline(buf,sizeof(buf));

        std::cout << buf << std::endl;
    }
    std::cout << std::endl << std::endl;
    return 0;
}