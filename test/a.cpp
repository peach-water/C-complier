#include <iostream>
#include <fstream>

int main()
{
    std::ifstream fp;
    fp.open("../test/a.cpp");
    char str[100] = {0};

    while (!fp.eof())
    {
        fp.read(str,1);
        std::cout << str;
    }
    return 0;
}