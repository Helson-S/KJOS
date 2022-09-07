.PHONY: all clean

CC := gcc
OBJS := sample.o linked customed_hdr reload_phdr reverse_phdr multi-belonging alike default

all: $(OBJS)

sample.o: %.o: %.c
	$(CC) -c -o $@ $<

linked: sample.o
	ld -T ./no_fillexp_default_hdr.lds -o $@ $<

customed_hdr: sample.o
	ld -T ./customed_hdr.lds -o $@ $<

reload_phdr: sample.o
	ld -T ./reLoad_phdr.lds -o $@ $<

reverse_phdr: sample.o
	ld -T ./reverse_phdr.lds -o $@ $<

multi-belonging: sample.o
	ld -T ./multi-belonging.lds -o $@ $<

alike : sample.o
	ld -T ./alike.lds -o $@ $<

different_type_phdr : sample.o
	ld -T ./different_type_phdr.lds -o $@ $<

default : sample.o
	ld -T ./default.lds -o $@ $<

clean:
	rm ./sample.o
	rm ./linked