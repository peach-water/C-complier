#include <stdio.h>

int main()
{
    int a = 0;
    int b = 0;
    while (a < 10)
    {
        a = a + 1;
        if (b > 10000000)
        {
            break;
        }
    }
    return 0;
}