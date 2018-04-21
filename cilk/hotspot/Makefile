# C compiler
CC = clang
CC_FLAGS = -g -O2

all: hotspot

hotspot: hotspot_openmp.cpp Makefile
	$(CC) $(CC_FLAGS) hotspot_openmp.cpp -o hotspot

clean:
	rm -f hotspot hotspot_offload
