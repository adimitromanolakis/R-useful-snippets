#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

typedef void (*malloc_enable_trace_functype)(int value);
malloc_enable_trace_functype malloc_enable_trace_func = NULL;
void *handle = NULL;


static inline void malloc_enable_trace(int value)
{
    if(0) if(handle == NULL) { 
        handle = dlopen("libmalloc.so", RTLD_NOW);
        if(handle == NULL) {  fprintf(stderr,"Cannot load libmalloc.so\n"); }
    }

    //backtrace_tester_ptr = (backtrace_tester_func *)dlsym(handle, "backtrace_tester"); 
    malloc_enable_trace_func = (malloc_enable_trace_functype)dlsym(NULL, "malloc_enable_trace"); 

    if(malloc_enable_trace_func == NULL) {
        fprintf(stderr,"Cannot resolve malloc_enable_trace_func\n");
    }
    // printf("backtrace_tester_ptr=%llx\n", (long long unsigned int)backtrace_tester_ptr);

    malloc_enable_trace_func(value);
}