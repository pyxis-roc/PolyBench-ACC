SRCPATH ?= .
CC ?= nvcc
all:
	$(CC) -O3 -gencode arch=compute_61,code=sm_61 -gencode arch=compute_70,code=sm_70 ${CUFILES} -I${PATH_TO_UTILS} -o $(SRCPATH)/$(subst .exe,,${EXECUTABLE})
clean:
	rm -f *~ *.exe
