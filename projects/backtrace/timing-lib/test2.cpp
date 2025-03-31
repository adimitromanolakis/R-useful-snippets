
#include <stdio.h>
#include <stdlib.h>
#include <dlfcn.h>

typedef void (*bt_store_time_start_func)();
typedef void (*bt_store_time_end_func)();

static bt_store_time_start_func bt_store_time_start = NULL;
static bt_store_time_end_func bt_store_time_end = NULL;

static void *handle = NULL;


static inline void bt_resolve()
{
    if(handle == NULL) { handle = dlopen("libapo_timing.so", RTLD_NOW); }

    if(handle == NULL) {
        fprintf(stderr,"Error opening timing library.so\n");
        return;
    } else {

        bt_store_time_start = (bt_store_time_start_func)dlsym(handle, "bt_store_time_start"); 
        bt_store_time_end = (bt_store_time_end_func)dlsym(handle, "bt_store_time_end"); 
    }

}

#include <unistd.h>

void test2()
{
    bt_resolve();
    bt_store_time_end();
}