
// g++ -O3 -shared -o libapotrace.so -fPIC  -rdynamic trace.cpp  -ldl -I backward-cpp/ -I /usr/include/libdwarf/ -lelf -lbfd -ldw -g0


#include <iostream>
#include <sys/time.h>

//#define BACKWARD_HAS_DW 1
//#define BACKWARD_HAS_DWARF 1


#define BACKWARD_HAS_BFD 1


// faster but no line number as of now
//#define BACKWARD_HAS_UNWIND 1

#include "backward.hpp"


inline void backtrace_wrap_cpp1() {
    using namespace backward;
    
    StackTrace st; 
    st.load_here(34);

    //printf("Stack size = %d\n",sizeof(st));
    //return;

    Printer p;
    p.snippet = false;
    //p.object = true;
    p.color_mode = ColorMode::always;
    p.address = false;
    p.print(st, stderr);
}

inline void backtrace_wrap_cpp2()
{

    using namespace backward;
    StackTrace st; st.load_here(20);


    TraceResolver tr; 
    tr.load_stacktrace(st);



    for (size_t i = 1; i < st.size(); ++i) {
        ResolvedTrace trace = tr.resolve(st[i]);

        fprintf(stderr, " %2d] >>> %s --->>>>> %s:%d\n",
        (int)i,
        trace.object_filename.c_str(),
        trace.object_function.c_str(),
        trace.source.line 
        );
        if(0) std::cout << "#" << i
            << " " << trace.object_filename
        //	<< "::: " << trace.object_function
            << "\t\t[" << trace.source.function << " line:" << trace.source.line << "]"
        << std::endl;
    }

}


extern "C" { void backtrace_tester(); }


void backtrace_tester()
{
    struct timeval start, end;
    gettimeofday(&start, NULL);

    //if(getenv("TRACETYPE")) { 
        backtrace_wrap_cpp2(); 
    //} else {
        //backtrace_wrap_cpp1();
    //}

    gettimeofday(&end, NULL);

    long long elapsed = (end.tv_sec - start.tv_sec) * 1000000LL + (end.tv_usec - start.tv_usec);
    fprintf(stderr, "Time taken for backtrace: %lld usec\n", (long long unsigned int)elapsed );   
}
