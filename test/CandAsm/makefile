.PHONY: all

CC := gcc
CFLAGS := -g -c -m32 -o

all: cobj.o

cobj.o : %.o : %.c
	$(CC) $(CFLAGS) $@ $<