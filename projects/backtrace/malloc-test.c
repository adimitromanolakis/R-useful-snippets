#include <stdio.h>

#include "malloc-call-trace.h"

int
main()
{

    malloc_enable_trace(1);

    int *p = malloc(100);

    free(p);

    malloc_enable_trace(1);

    int *z = malloc(120);
    int *z2 = malloc(1120);

    exit(1);



}