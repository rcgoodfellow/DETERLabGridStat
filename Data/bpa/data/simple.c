#include<string.h>
#include<stdio.h>

int main(void) {
    char str[10];
    bzero(str, 10);

    sprintf(str, "hi %s", "47");
    puts(str);

    return 0;
}
