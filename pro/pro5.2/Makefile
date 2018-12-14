ASM		= nasm
CC		= gcc
LD		= ld 

ASMTOBINFLAGS	= -I boot/include/
ASMTOELFFALGS	= -I include/ -f elf
CFLAGS		= -I include/ -c -fno-builtin -m32 -fno-stack-protector
LDFLAGS		= -m elf_i386 -Ttext 0x30400 

asmToObj = kernel/kernel.asm lib/kliba.asm lib/string.asm
asmTobin = boot/boot.asm boot/loader.asm 

include = include/type.h include/const.h include/protect.h include/proto.h include/global.h


OBJS  = kernel/kernel.o kernel/start.o lib/kliba.o \
				lib/string.o lib/klib.o kernel/i8259.o \
				kernel/global.o kernel/protect.o 

BINS = boot/kernel.bin boot/boot.bin boot/loader.bin

.PHONY :clean buildimage 

buildimage : $(BINS)
	dd if=boot/boot.bin of=a.img bs=512 count=1 conv=notrunc
	sudo mount -o loop a.img /mnt/floppy/
	sudo cp -fv boot/loader.bin /mnt/floppy/
	sudo cp -fv boot/kernel.bin /mnt/floppy
	sudo umount /mnt/floppy


clean :
	-rm -f $(OBJS) $(BINS) 


# We assume that "a.img" exists in current folder

boot/boot.bin : boot/boot.asm boot/include/load.inc boot/include/fat12hdr.inc
	$(ASM) $(ASMTOBINFLAGS) -o $@ $<

boot/loader.bin : boot/loader.asm boot/include/load.inc \
			boot/include/fat12hdr.inc boot/include/pm.inc
	$(ASM) $(ASMTOBINFLAGS) -o $@ $<


boot/kernel.bin: $(OBJS)
	$(LD) $(LDFLAGS) -o $@ $(OBJS)

kernel/kernel.o : kernel/kernel.asm
	$(ASM) $(ASMTOELFFALGS) -o $@ $<

kernel/start.o : kernel/start.c include/type.h include/const.h include/protect.h
	$(CC) $(CFLAGS) -o $@ $<

lib/kliba.o : lib/kliba.asm
	$(ASM) $(ASMTOELFFALGS) -o $@ $<

lib/string.o : lib/string.asm
	$(ASM) $(ASMTOELFFALGS) -o $@ $<

lib/klib.o : lib/klib.c $(include)
	$(CC) $(CFLAGS) -o $@ $<
kernel/i8259.o :kernel/i8259.c $(include)
	$(CC) $(CFLAGS) -o $@ $<
 
kernel/global.o :kernel/global.c   $(include)
	$(CC) $(CFLAGS) -o $@ $<

kernel/protect.o :kernel/protect.c $(include)
	$(CC) $(CFLAGS) -o $@ $<
