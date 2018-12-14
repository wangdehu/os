src:=boot.asm
bin:=boot.com

.PHONY : run clean

everything : $(bin)
	sudo mount -o loop os.img /mnt/floppy/
	sudo cp $(bin) /mnt/floppy/ -v
	sudo umount /mnt/floppy/

$(bin) : $(src)
	nasm  $< -o $@

clean:
	-rm -f boot.com