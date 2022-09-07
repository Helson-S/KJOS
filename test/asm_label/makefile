.PHONY: all

CC := nasm
CFLAGS := -f elf -o

all: test_asm.o

test_asm.o : %.o : %.asm
	$(CC) $(CFLAGS) $@ $<