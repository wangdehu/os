#config
ASM		= nasm
CC		= gcc
LD		= ld
ASMFLAGS	= -f elf -O0 
CFLAGS		= -c -m32 -O0
LDFLAGS		=  -m  elf_i386 -nostdlib -N -e _start -Ttext 0x7C00 


#source

obj:= t1.o boot.o



run: os.img
	qemu-system-i386 -no-reboot -no-shutdown -parallel stdio -hda os.img -serial null

os.img: boot	
	objcopy -S -O binary boot boot.tmp1
	./sign boot.tmp1 boot.tmp2
	dd if=boot.tmp2  of=os.img conv=notrunc




boot : $(obj)
	$(LD) $(LDFLAGS) -o  $@ $(obj)

boot.o : boot.asm
	$(ASM) $(ASMFLAGS) -o $@ $<

t1.o : t1.c
	$(CC) $(CFLAGS) -o $@ $<

.PHONY: debug clean run

debug: os.img
	qemu-system-i386 -S -s  -parallel stdio  -drive file=os.img,format=raw & 
	sleep 2
	gnome-terminal -e "gdb -q -tui -x gdbfile"
clean :
	-rm -f os.img boot.o boot.tmp1 boot.tmp2 