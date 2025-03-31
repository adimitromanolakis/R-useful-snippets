#include <execinfo.h>
#include <string.h>
#include <errno.h>
#include <unistd.h>
#include <stdlib.h>
#include <stacktrace>
#include <iostream>

void print_backtrace(void)
{
         std::cout << std::stacktrace::current() << '\n';

}


void foo()
{
    print_backtrace();
}

int main()
{
    foo();
    return 0;
}
