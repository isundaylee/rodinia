# C compiler
CC ?= clang
CC_FLAGS ?= -g -O3 -ftapir=cilk

CC_FLAGS += -frhino -mllvm -polly

all: hotspot

hotspot: hotspot.cpp Makefile
	$(CC) $(CC_FLAGS) hotspot.cpp -o hotspot

clean:
	rm -f hotspot hotspot.preopt.ll

################################################################################
# Investigative targets
################################################################################

hotspot.preopt.ll: hotspot.cpp
	clang -emit-llvm -S -O3 hotspot.cpp -o hotspot.preopt.ll
	opt -polly-canonicalize -S hotspot.preopt.ll -o hotspot.preopt.ll

polly-detect: hotspot.preopt.ll
	opt -polly-detect hotspot.preopt.ll -analyze -polly-process-unprofitable
