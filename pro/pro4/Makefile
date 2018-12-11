run: os.img
	qemu-system-i386 -no-reboot -no-shutdown -parallel stdio -hda os.img -serial null

main.o: main.c
	gcc -m32 -O0 main.c -c -o main.o

boot.o:bootloader.s
	nasm -f elf bootloader.s -o boot.o -O0
boot:boot.o main.o
	ld -m  elf_i386 -nostdlib -N -e _start -Ttext 0x7C00  -o boot boot.o main.o
os.img: boot
	objcopy -S -O binary boot boot.1
	./sign boot.1  boot.2
	dd if=boot.2 of=os.img conv=notrunc
clean:
	-rm  -f boot.o boot boot.1 boot.2 os.img
debug: os.img
	qemu-system-i386 -S -s  -parallel stdio  -drive file=os.img,format=raw & 
	sleep 2
	gnome-terminal -e "gdb -q -tui -x gdbfile"