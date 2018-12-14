
source:= bootloader.s

os.img:os.bin
	dd if=os.bin of=os.img
os.bin:$(source) 
	nasm -f bin -o os.bin $(source)

.PHONY: run clean

run : os.img
	qemu-system-i386 -no-reboot -no-shutdown -drive file=os.img,format=raw
clean:
	-rm -f os.bin os.img
debug: os.img
	qemu-system-i386 -S -s  -parallel stdio  -drive file=os.img,format=raw & 
	sleep 2
	gnome-terminal -e "gdb -q -tui -x gdbfile"