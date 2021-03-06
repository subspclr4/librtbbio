CC = $(BB-KERNEL)/dl/gcc-linaro-4.9-2015.05-x86_64_arm-linux-gnueabihf/bin/arm-linux-gnueabihf-gcc

LIBCFLAGS = -Wall -I../rtgpio -I$(XENO_INSTALL)/include/cobalt 
LIBCFLAGS += -I$(XENO_INSTALL)/include -I$(BB-KERNEL)/KERNEL/drivers/xenomai/beaglebone -fPIC  

CFLAGS = -Wall -I../rtio -Ilib -I$(XENO_INSTALL)/include/cobalt -I$(BB-KERNEL)/KERNEL/drivers/xenomai/beaglebone
CFLAGS += -I$(XENO_INSTALL)/include -march=armv7-a -mfpu=vfp3 -D_GNU_SOURCE 
CFLAGS += -D_REENTRANT -D__COBALT__ -D__COBALT_WRAP_ -I$(XENO_INSTALL)/include/alchemy 

LFLAGS = -lalchemy -lcopperplate $(XENO_INSTALL)/lib/xenomai/bootstrap.o 
LFLAGS += -Wl,--wrap=main -Wl,--dynamic-list=$(XENO_INSTALL)/lib/dynlist.ld 
LFLAGS += -L$(XENO_INSTALL)/lib -lcobalt -lpthread -lrt 
LFLAGS += -lbbio  -march=armv7-a -mfpu=vfp3 -Llib  

lib: lib/libbbio.o
	$(CC) -o lib/libbbio.so lib/libbbio.o -shared

lib/libbbio.o:
	$(CC) -c -o lib/libbbio.o lib/libbbio.c $(LIBCFLAGS)

test: test/bbio_test.o
	$(CC) -o test/bbio_test test/bbio_test.o $(LFLAGS)
	
test/bbiotest.o: lib
	$(CC) -c -o test/bbio_test.o test/bbio_test.c $(CFLAGS)

.PHONY: clean

clean:
	rm -rf lib/*.o lib/*.so test/*.o test/test_bbio
