#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>
#include <iostream>
#include <signal.h>
#include <time.h>
#include <unistd.h>
#include <string.h>
#include <map>
#include <chrono>
#include <thread>


typedef void (*bt_store_time_start_func)();
typedef uint64_t (*bt_store_time_end_func)();


static bt_store_time_start_func bt_store_time_start = NULL;
static bt_store_time_end_func bt_store_time_end = NULL;
static void *bt_handle = NULL;

static inline void bt_resolve() {
    if (bt_handle == NULL) {
        bt_handle = dlopen("libapo_timing.so", RTLD_NOW);
    }

    if (bt_handle == NULL) {
        fprintf(stderr, "Error opening timing library.so\n");
        return;
    } else {
        bt_store_time_start = (bt_store_time_start_func)dlsym(bt_handle, "bt_store_time_start");
        bt_store_time_end = (bt_store_time_end_func)dlsym(bt_handle, "bt_store_time_end");
    }
}

#include <unistd.h>

extern void test2();


int measurements[1000];
int nmeasurements = 0;


void test1() {

    bt_store_time_start();

    int time = 25000;

    usleep(time);
    //std::this_thread::sleep_for(std::chrono::milliseconds(100));
    //    test2();
    uint64_t diff = bt_store_time_end();

    double timing_err = ((int64_t)diff - time);

    printf("diff = %f\n", (double) timing_err );

    usleep((int) ((drand48()*20)*1000) );

    measurements[nmeasurements++] = timing_err;
}



#include <algorithm>
#include <math.h>

void measurement_stats()
{

    // Compute min, max , avf of measurements
    int min = measurements[0];
    int max = measurements[0];

    double avg = 0;
    for (int i = 0; i < nmeasurements; i++) {
        if (measurements[i] < min) {
            min = measurements[i];
        }
        if (measurements[i] > max) {
            max = measurements[i];
        }
        avg += fabs(measurements[i]);
    }
    avg /= nmeasurements;
    printf("Min: %d, Max: %d, Avg: %f\n", min, max, avg);

    // Compute q95%

    int q95_index = (int)(0.95 * nmeasurements);
    
    // Sort the measurements
    std::sort(measurements, measurements + nmeasurements);

    // Get the q95% value
    int q95 = measurements[q95_index];
    printf("Q95: %d\n", q95);



}


int main1() {
    bt_resolve();

    for(int i=0 ; i < 100 ; i++) {
        test1();
    }
    measurement_stats();

    return 0;
}

// Global map to associate timer IDs with messages
std::map<timer_t, const char*> timer_messages;



timer_t timerid2;
timer_t timerid1;



// Signal handler for both timers
void timer_handler(int signum, siginfo_t *info, void *ucontext) {
    if (signum == SIGALRM) {

        
        timer_t *timerid = (timer_t *)info->si_value.sival_ptr;

        //std::cerr << (timerid == &timerid1) << " " << (timerid == &timerid2) << "\n";

        if(timerid == &timerid1) {
            bt_store_time_start();
        }

        if(timerid == &timerid2) {
            int64_t time = 30000;
            int64_t diff = (int64_t)bt_store_time_end();

            double timing_err = ((int64_t)diff - time);

            printf("diff = %f\n", (double) timing_err );

            measurements[nmeasurements++] = timing_err;
        }


    }
}


int main() {
    main1();

    bt_resolve();

    const int timer_clock_type = CLOCK_MONOTONIC;

    // Set up signal handler
    struct sigaction sa;
    memset(&sa, 0, sizeof(sa));
    sa.sa_sigaction = timer_handler;
    sa.sa_flags = SA_SIGINFO; // Important: Use SA_SIGINFO to get the timer ID
    sigaction(SIGALRM, &sa, NULL);

    // Set up timer 1 (100ms)

    struct sigevent sev1;
    struct itimerspec its1;
    struct sigevent sev2;
    struct itimerspec its2;


    memset(&sev1, 0, sizeof(sev1));
    sev1.sigev_notify = SIGEV_SIGNAL;
    sev1.sigev_signo = SIGALRM;
    sev1.sigev_value.sival_ptr = &timerid1; // Pass the timer ID to the handler

    if (timer_create(timer_clock_type, &sev1, &timerid1) == -1) {
        perror("timer_create");
        return 1;
    }

    // Store the timer ID and message
    timer_messages[timerid1] = "timer1 fired";

    its1.it_value.tv_sec = 0;
    its1.it_value.tv_nsec = 10 * 1000000; // ms
    its1.it_interval.tv_sec = 0;
    its1.it_interval.tv_nsec = 0; // Non-repeating timer



    // Set up timer 2
    

    memset(&sev2, 0, sizeof(sev2));
    sev2.sigev_notify = SIGEV_SIGNAL;
    sev2.sigev_signo = SIGALRM;
    sev2.sigev_value.sival_ptr = &timerid2; // Pass the timer ID to the handler

    if (timer_create(timer_clock_type, &sev2, &timerid2) == -1) {
        perror("timer_create");
        return 1;
    }

    // Store the timer ID and message
    timer_messages[timerid2] = "timer2 fired";

    its2.it_value.tv_sec = 0;
    its2.it_value.tv_nsec = (10+30) * 1000000; // 110ms
    its2.it_interval.tv_sec = 0;
    its2.it_interval.tv_nsec = 0; // Non-repeating timer



    for(int nrep = 0; nrep <100 ;nrep++) {

        if (timer_settime(timerid1, 0, &its1, NULL) == -1) {
            perror("timer_settime");
            return 1;
        }


        if (timer_settime(timerid2, 0, &its2, NULL) == -1) {
            perror("timer_settime");
            return 1;
        }





        // Keep the program running to receive signals

        pause(); // Wait for a signal
        pause(); // Wait for a signal
        usleep(2000);

        //printf("nmeasurements=%d\n", nmeasurements);

    }

    measurement_stats();

    // Clean up timers (optional, but good practice)
    timer_delete(timerid1);
    timer_delete(timerid2);

    return 0;
}
