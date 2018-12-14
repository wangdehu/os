
bin:= mbr.bin loader.bin


os.img: $(bin)
	dd if=mbr.bin of=os.img conv=notrunc
	dd if=loader.bin seek=1 of=os.img conv=notrunc
mbr.bin: mbr.S loader.inc
	nasm -f bin mbr.S -o mbr.bin
loader.bin: loader.S loader.inc
	nasm -f bin loader.S -o loader.bin

.PHONY: clean run debug

run:os.img 
	qemu-system-i386 -no-reboot -no-shutdown -parallel stdio -hda os.img -serial null
clean:
	-rm -f os.img $(bin)
debug: os.img
	qemu-system-i386 -S -s  -parallel stdio  -drive file=os.img,format=raw & 
	sleep 2
	gnome-terminal -e "gdb -q -tui -x gdbfile"