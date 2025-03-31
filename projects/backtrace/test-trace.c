#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

typedef void (*backtrace_tester_func)();
backtrace_tester_func backtrace_tester_ptr = NULL;
void *handle = NULL;

//extern "C" { void backtrace_tester(); }

void func1()
{
    //if(handle == NULL) { handle = dlopen("libapotrace.so", RTLD_NOW); }
    //printf("handle=%llx\n",(long long unsigned int)handle);
    
    //backtrace_tester_ptr = (backtrace_tester_func *)dlsym(handle, "backtrace_tester"); 

    backtrace_tester_ptr = (backtrace_tester_func)dlsym(NULL, "backtrace_tester"); 
    // printf("backtrace_tester_ptr=%llx\n", (long long unsigned int)backtrace_tester_ptr);

    backtrace_tester_ptr();

}

void func2()
{

func1();

}

int main()
{
    func2();

    //backtrace_tester();

	return 0;
}

