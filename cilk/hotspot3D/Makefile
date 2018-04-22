CC ?= clang
CCFLAGS ?= -g -O3 -ftapir=cilk

CCFLAGS += -frhino -mllvm -polly
# CCFLAGS += -frhino

OUTPUT = *.out

3D: 3D.c
	$(CC) -o 3D $(CCFLAGS) 3D.c -lm

clean:
	rm -f 3D $(OUTPUT)
