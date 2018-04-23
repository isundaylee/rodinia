include ../Makefile.common

lud: lud.o common.o lud_omp.o
	$(CC) $(CC_FLAGS) -o lud lud.o lud_omp.o common.o

lud.o: lud.c
	$(CC) $(CC_FLAGS) -o lud.o -c lud.c

lud_omp.o: lud_omp.c
	$(CC) $(CC_FLAGS) -o lud_omp.o -c lud_omp.c

common.o: common.c
	$(CC) $(CC_FLAGS) -o common.o -c common.c

clean:
	rm -f lud *.o

.SUFFIXES: 
