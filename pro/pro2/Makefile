
source:= bootloader.s

os.img:os.bin
	dd if=os.bin of=os.img
os.bin:bootloader.s 
	nasm -f bin -o os.bin $(source)

.PHONY: run clean

run : os.img
	qemu-system-i386 -no-reboot -no-shutdown -drive file=os.img,format=raw
clean:
	-rm -f os.bin os.img