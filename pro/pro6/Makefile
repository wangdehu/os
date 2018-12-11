
source := bootloader.s
bin:= mbr.bin core.bin boot.bin
flags := -Wall -ggdb -m32 -O3  -nostdinc

os.img:$(bin)
	dd if=mbr.bin of=os.img conv=notrunc
	dd if=core.bin seek=1 of=os.img conv=notrunc
	dd if=boot.bin seek=50 of=os.img conv=notrunc
	dd if=data.txt seek=100 of=os.img conv=notrunc
mbr.bin: mbr.s
	nasm -f bin mbr.s -o mbr.bin
core.bin: core.s
	nasm -f bin core.s -o core.bin
boot.bin: boot.s
	nasm -f bin boot.s -o boot.bin

.PHONY: run clean debug

run : os.img
	qemu-system-i386 -no-reboot -no-shutdown -drive file=os.img,format=raw
clean:
	-rm -f  os.img $(bin)
debug: os.img
	qemu-system-i386 -S -s  -parallel stdio  -drive file=os.img,format=raw & 
	sleep 2
	gnome-terminal -e "gdb -q -tui"