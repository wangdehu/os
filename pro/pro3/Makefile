
source := bootloader.s
flags := -Wall -ggdb -m32 -O3  -nostdinc

os.img:os.bin
	dd if=os.bin of=os.img
os.bin:bootloader.s 
	gcc $(flags) -c bootloader.S -o ./os.bin

.PHONY: run clean

run : os.img
	qemu-system-i386 -no-reboot -no-shutdown -drive file=os.img,format=raw
clean:
	-rm -f os.bin os.img