#include <stdarg.h>

int print(char *str, int len){
    // x86_64
    // __asm__(
    //     "movq $1, %rax\n\t"
    //     "movq $1, %rid\n\t"
    //     "movq -8(%rbp), %rsi\n\t"
    //     "movl -12(%rbp), %edx\n\t"
    //     "syscall\n\t"
    // );
    
    // x86_32
    __asm__(
        "mov $4, %eax\n\t"
        "mov $1, %ebx\n\t"
        "mov 8(%ebp), %ecx\n\t"
        "mov 12(%ebp), %edx\n\t"
        "int $0x80\n\t"
    );
    return len;
}

// typedef char *va_list;
// #define _INTSIZEOF(n) ((sizeof(n) + sizeof(int) - 1) & ~(sizeof(int) - 1))
// #define va_start(ap, v) (ap = (va_list)&v + _INTSIZEOF(v))
// #define va_arg(ap, type) (*(type *)((ap += _INTSIZEOF(type)) - _INTSIZEOF(type)))
// #define va_end(ap) (ap = (va_list)0)

void swap(char a, char b)
{
    char temp = a;
    a = b;
    b = temp;
}

int itos(char *numStr, int num, int mod)
{
    // 只能转换2~26进制的整数
    if (mod < 2 || mod > 26 || num < 0)
    {
        return 0;
    }

    int length, temp;

    // 进制转换
    length = 0;
    while (num)
    {
        temp = num % mod;
        num /= mod;
        numStr[length] = temp > 9 ? temp - 10 + 'A' : temp + '0';
        ++length;
    }

    // 特别处理num=0的情况
    if (!length)
    {
        numStr[0] = '0';
        ++length;
    }

    // 将字符串倒转，使得numStr[0]保存的是num的高位数字
    for (int i = 0, j = length - 1; i < j; ++i, --j)
    {
        swap(numStr[i], numStr[j]);
    }

    numStr[length] = 0;
    return length;
}

int printf_add_to_buffer(char *buffer, char c, int *idx, const int BUF_LEN)
{
    int counter = 0;

    buffer[*idx] = c;
    (*idx)++;

    if (*idx == BUF_LEN)
    {
        buffer[*idx] = '\0';
        counter = print(buffer, *idx);
        *idx = 0;
    }

    return counter;
}

extern int printf(const char *const fmt, ...)
{
    const int BUF_LEN = 32;
    int temp = 0;

    char buffer[BUF_LEN + 1];
    char number[33];

    int idx, counter;
    va_list ap;

    va_start(ap, fmt);
    idx = 0;
    counter = 0;

    for (int i = 0; fmt[i]; ++i)
    {
        if (fmt[i] != '%')
        {
            counter += printf_add_to_buffer(buffer, fmt[i], &idx, BUF_LEN);
        }
        else
        {
            i++;
            if (fmt[i] == '\0')
            {
                break;
            }

            switch (fmt[i])
            {
            case '%':
                counter += printf_add_to_buffer(buffer, fmt[i], &idx, BUF_LEN);
                break;

            case 'c':
                counter += printf_add_to_buffer(buffer, va_arg(ap, int), &idx, BUF_LEN);
                break;

            // case 's':
            //     buffer[idx] = '\0';
            //     counter += print(buffer, idx);

            //     counter += print(va_arg(ap, const char *));
            //     idx = 0;
            //     break;

            case 'd':
            case 'x':

                temp = va_arg(ap, int);

                if (temp < 0 && fmt[i] == 'd')
                {
                    counter += printf_add_to_buffer(buffer, '-', &idx, BUF_LEN);
                    temp = -temp;
                }

                temp = itos(number, temp, (fmt[i] == 'd' ? 10 : 16));

                for (int j = temp - 1; j >= 0; --j)
                {
                    counter += printf_add_to_buffer(buffer, number[j], &idx, BUF_LEN);
                }
                break;
            }
        }
    }

    buffer[idx] = '\0';
    counter += print(buffer, idx);

    return counter;
}

// int main()
// {
//     int n = 1234;

//     printf("Hello %d times %c world\n", n, 'c');
//     return 0;
// }