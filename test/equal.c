// mcc

//#include "mcc.h"

int main() {
    int i ;
    i = 0;
    while (i < 10) {
        i = i + 1;
        if (i == 3 || i == 5){
            continue;
        }
        else{
            i = 4;
        }

    }
    factor(i);
    return 0;
}

int factor(int n){
    if (n < 2){
        return 1;
    }
    return n * factor(n - 1);
}