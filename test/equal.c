// mcc

//#include "mcc.h"

int main()
{
    int i;
    i = 0;
    while (i >= -10)
    {
        i = i + 1;
        if (i >= 6 || i == 5)
        {
            break;
        }
        else
        {
            continue;
        }
    }
    
    i = factor(i);
    while (1){}
    return 0;
}

int factor(int n)
{
    if (n <= 1){
        return 1;
    }else{
        return n * factor(n-1);
    }
}