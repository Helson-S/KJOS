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
	dd if=loader.bin of=MBR.img bs=512 count=1 seek=2 conv=notrunc
	cp MBR.img ./EmuEnv

clean: $(OBJS)
	rm $<
	rm MBR.lst MBR.map MBR.img
	rm ./EmuEnv/MBR.img
