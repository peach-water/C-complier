
// here is test file
int main()
{
    int a ;
    float b ;
    a = 5;
    b  = 0.1;
    while (a < 10)
    {
        a = a + 1;
        if (b > 10000000 && a < 10 || b > a)
        {
            printf("%s",a);
            // scanf("%d",b);
            break;
        }else{
            break;
        }
    }
    return 0;
}