#define _GNU_SOURCE


#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <execinfo.h>

//# -Wl,-init,<function name>



#include <iostream>
#include <sys/time.h>

#define BACKWARD_HAS_DW 1
//#define BACKWARD_HAS_BFD 1

//#define BACKWARD_HAS_DWARF 1
//#define BACKWARD_HAS_UNWIND 1
#include "backward-cpp/backward.hpp"


inline void backtrace_wrap_cpp1() {
    using namespace backward;
    
    StackTrace st; 
    st.load_here(14);

    //printf("Stack size = %d\n",sizeof(st));
    //return;

    Printer p;
    p.snippet = false;
    //p.object = true;
    p.color_mode = ColorMode::always;
    p.address = false;
    p.print(st, stderr);
}



extern void * apo_malloc(size_t size);
void apo_free(char *p);


static void init() __attribute__((constructor));

void * (*real_malloc)  (size_t) = NULL;
void   (*real_free)    (void *p) = NULL;
void * (*real_realloc) (void *ptr, size_t size) = NULL;



void init(void)
{
    fprintf(stderr, "init\n");

    real_malloc = (void *(*)(size_t)) dlsym(RTLD_NEXT, "malloc");

    if (NULL == real_malloc) {
        fprintf(stderr, "Error in `dlsym`: %s\n", dlerror());
    }    

    real_free = (void (*)(void *))dlsym(RTLD_NEXT, "free");
    // print_trace();
}

int trace_enable = 0;
int count = 0;

extern "C" { 
    void malloc_enable_trace(int enable);
    void *malloc(size_t size);
}


void malloc_enable_trace(int enable)
{
    trace_enable = enable;
    
    if(enable == 0) count = 0;

}


void *malloc(size_t size)
{
    count ++;
    if(trace_enable) {
        fprintf(stderr, "(%d) malloc %d\n", count,  (int) size);
    }

    if(count == 20) {
        trace_enable = 0;
        //backtrace_wrap_cpp1();
        trace_enable = 1;
    }

    if(1) if(real_malloc == NULL) {
      fprintf(stderr, "Malloc is null!!\n");
      real_malloc = ( void* (*)(size_t) ) dlsym(RTLD_NEXT, "malloc");
      return real_malloc(size);
    }
    return real_malloc(size);
}

