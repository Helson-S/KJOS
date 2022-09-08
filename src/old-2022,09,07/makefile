# Build binary for OS

.PHONY: all clean

CC := nasm
CFLAGS := -f bin -o
OBJS := boot loader

all: $(OBJS)

boot: MBR.asm
	$(CC) $(CFLAGS) MBR.bin $< 
	dd if=MBR.bin of=MBR.img bs=512 count=1 conv=notrunc

loader: loader.asm
	$(CC) $(CFLAGS) loader.bin $<
	dd if=loader.bin of=MBR.img bs=512 count=16 seek=2 conv=notrunc,sync
	cp MBR.img ./EmuEnv

clean: $(OBJS)
	rm MBR.bin
	rm loader.bin
	rm MBR.img
	rm ./EmuEnv/MBR.img
