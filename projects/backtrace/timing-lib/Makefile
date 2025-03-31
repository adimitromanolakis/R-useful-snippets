default: libapo_timing.so 

# -lelf -lbfd -ldw -g0
libapo_timing.so: timing-lib.cpp
	g++ -O3 -shared -o libapo_timing.so -fPIC timing-lib.cpp $(LIBS) 


install: libapo_timing.so
	sudo install libapo_timing.so /usr/lib/x86_64-linux-gnu/libapo_timing.so
	sudo chmod go+rx /usr/lib/x86_64-linux-gnu/libapo_timing.so




test: test.cpp
	g++ -ggdb -O2 test.cpp -o test -Wl,-rpath -Wl,. 
	@echo 
	@echo
	@echo
	./test

