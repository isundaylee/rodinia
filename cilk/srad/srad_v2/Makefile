# C compiler
CC ?= clang
CC_FLAGS ?= -g -O3 -ftapir=cilk -lm -ldl

CC_FLAGS += -frhino -mllvm -polly

bfs:
	$(CC) $(CC_FLAGS) srad.cpp -o srad

clean:
	rm -f srad
