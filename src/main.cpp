#include <iostream>
#include <fstream>
#include "../head/Token.h"


int main()
{
    std::ifstream fp;
    fp.open("./test/a.cpp");
    char buf[100];

    while (!fp.eof())
    {
        fp.getline(buf,sizeof(buf));

        std::cout << buf << std::endl;
    }
    std::cout << std::endl << std::endl;
    return 0;
}