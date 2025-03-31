// g++ -O3 -shared -o libapotrace.so -fPIC  -rdynamic trace.cpp  -ldl -I backward-cpp/ -I /usr/include/libdwarf/ -lelf -lbfd -ldw -g0


#include <iostream>
#include <sys/time.h>
#include <stdint.h>
#include <cpuid.h>

// Function to check if TSC is invariant
bool is_tsc_invariant() {
    unsigned int eax, ebx, ecx, edx;
    __get_cpuid(0x80000007, &eax, &ebx, &ecx, &edx);
    return edx & (1 << 8); // Bit 8 of EDX indicates invariant TSC
}

// Function to print CPUID information
void print_cpuid() {
    unsigned int eax, ebx, ecx, edx;
    char vendor[13];

    __get_cpuid(0, &eax, (unsigned int *)vendor, 
                (unsigned int *)(vendor + 8), 
                (unsigned int *)(vendor + 4));
    vendor[12] = '\0';

    std::cout << "CPUID Information:" << std::endl;
    std::cout << "Vendor: " << vendor << std::endl;

    __get_cpuid(1, &eax, &ebx, &ecx, &edx);
    std::cout << "Family: " << ((eax >> 8) & 0xf) << std::endl;
    std::cout << "Model: " << ((eax >> 4) & 0xf) << std::endl;
    std::cout << "Stepping: " << (eax & 0xf) << std::endl;

    // Check for AVX support
    bool avx_supported = ecx & (1 << 28);
    std::cout << "AVX support: " << (avx_supported ? "Yes" : "No") << std::endl;

    // Check for AVX2 support
    __get_cpuid(7, &eax, &ebx, &ecx, &edx);
    bool avx2_supported = ebx & (1 << 5);
    std::cout << "AVX2 support: " << (avx2_supported ? "Yes" : "No") << std::endl;


    std::cout << "TSC Invariant: " << (is_tsc_invariant() ? "Yes" : "No") << std::endl;
}

extern "C" { 
    void bt_store_time_start(); 
    uint64_t bt_store_time_end(); 
    void bt_print_cpuid();
}

// Use rdtsc for higher resolution timing
static inline uint64_t rdtsc() {
    unsigned int lo, hi;
    __asm__ __volatile__("rdtsc" : "=a"(lo), "=d"(hi));
    return ((uint64_t)hi << 32) | lo;
}

uint64_t start_time;
uint64_t end_time;

struct timeval time0, time1;


void bt_print_cpuid()
{
    print_cpuid();
}

void bt_store_time_start()
{

    start_time = rdtsc();

    gettimeofday(&time0, NULL);
}

uint64_t bt_store_time_end()
{
    end_time = rdtsc();
    uint64_t elapsed = end_time - start_time;

    gettimeofday(&time1, NULL);

    int64_t ns_diff = (time1.tv_sec - time0.tv_sec) * 1000000000LL + (time1.tv_usec - time0.tv_usec) * 1000;

    double diff = (double)  ((int)(340000000 - (int64_t)elapsed)) / (1e-6*3.4e9);

    elapsed = elapsed / 3400;

    elapsed = ns_diff/1000;
    diff = ((int64_t)elapsed - 100000.0);

    if(1) fprintf(stdout, "Time taken for backtrace: %llu cycles  diff = %f us cycles = %d\n", elapsed,
    diff, (int)(340000000 - elapsed)
    );

    return elapsed;
}
