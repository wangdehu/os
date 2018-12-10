#######################
# Makefile for foobar #
#######################

# Programs, flags, etc.
ASM		= nasm
CC		= gcc
LD		= ld
ASMFLAGS	= -f elf
CFLAGS		= -c -m32 -O3
LDFLAGS		=  -m  elf_i386 -nostdlib -N -e _start -Ttext 0x7C00 

# This Program
BIN		= foobar
OBJS		= foo.o bar.o

# All Phony Targets
.PHONY : everything final image clean realclean disasm all buildimg
run: os.img
	qemu-system-i386 -no-reboot -no-shutdown -parallel stdio -hda os.img -serial null

os.img: everything	
	objcopy -S -O binary foobar foobar.1
	./sign foobar.1  foobar.2
	dd if=foobar.2 of=os.img conv=notrunc
# Default starting position
everything : $(BIN)

all : realclean everything

final : all clean

clean :
	rm -f $(OBJS) os.img $(BIN) foobar.2 foobar foobar.1

realclean :
	rm -f $(OBJS) $(BIN)

$(BIN) : $(OBJS)
	$(LD) $(LDFLAGS) -o $(BIN) $(OBJS)

foo.o : foo.s
	$(ASM) $(ASMFLAGS) -o $@ $<

bar.o: bar.c
	$(CC) $(CFLAGS) -o $@ $<
debug: os.img
	qemu-system-i386 -S -s  -parallel stdio  -drive file=os.img,format=raw & 
	sleep 2
	gnome-terminal -e "gdb -q -tui -x gdbfile"