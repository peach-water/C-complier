// mcc

//#include "mcc.h"

int main() {
    int i ;
    float k;
    i = 0;
    while (i < 10) {
        i = i + 1;
        if (i == 3 || i == 5){
            continue;
        }
        else if (i == 8){
            break;
        }
        else{
            i = 4;
        }
        print("%d! = %d", i, factor(i));
    }
    return 0;
}

int factor(int n){
    if (n < 2){
        return 1;
    }
    return n * factor(n - 1);
}