#include <iostream>
#include <fstream>

int main()
{
    std::ifstream fp;
    fp.open("../test/a.cpp");
    char buf;

    while (true)
    {
        fp.read(&buf,sizeof(buf));
        if(fp.eof())break;

        
        std::cout << buf;
    }
    std::cout << std::endl;
    return 0;
}