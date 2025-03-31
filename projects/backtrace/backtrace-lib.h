#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

typedef void (*backtrace_tester_func)();
backtrace_tester_func backtrace_tester_ptr = NULL;
void *handle = NULL;


static inline void backtrace_lib_call()
{
    if(handle == NULL) { handle = dlopen("libapotrace.so", RTLD_NOW); }

    if(handle == NULL) {
        fprintf(stderr,"Error opening libapotrace.so\n");
        return;
    }
    backtrace_tester_ptr = (backtrace_tester_func)dlsym(handle, "backtrace_tester"); 
    // printf("backtrace_tester_ptr=%llx\n", (long long unsigned int)backtrace_tester_ptr);
    if(backtrace_tester_ptr == NULL) {
        fprintf(stderr,"Error resolving backtrace_tester\n");
        return;
    }
    backtrace_tester_ptr();
}