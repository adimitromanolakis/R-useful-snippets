default: libapotrace.so 

LIBS=-lbfd -ldw -lunwind -ldwarf
# -lelf -lbfd -ldw -g0
libapotrace.so: trace-library.cpp
	g++ -O3 -shared -o libapotrace.so -fPIC trace-library.cpp -I backward-cpp/ -I /usr/include/libdwarf/ $(LIBS) 


install: libapotrace.so
	sudo install libapotrace.so /usr/lib/x86_64-linux-gnu/libapotrace.so
	sudo chmod go+rx /usr/lib/x86_64-linux-gnu/libapotrace.so 



deps:
	 sudo apt-get install libdwarf-dev libdw-dev libunwind-dev libbfd-dev


test:	
	g++ -ggdb -o test-trace test-trace.c -Wl,-rpath -Wl,. 
	@echo 
	@echo
	@echo
	LD_PRELOAD=./libapotrace.so ./test-trace

