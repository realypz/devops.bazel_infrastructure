#include <stdio.h>

int main()
{
#ifdef __cplusplus
    printf("Hello, World! in C++ \n");
#else
    printf("Hello, World! in C \n");
#endif
    return 0;
}
