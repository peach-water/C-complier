// mcc

int main() {
    int a, b;
    float c, d;

    c = 2;
    d = c * 2;
    a = sum(c, d);
    b = sum(d, a);

    printf("c = %d d = %d", c, d);

    return 0;
}

int sum(int a, float b){
    int c, d;
    return a + b;
}