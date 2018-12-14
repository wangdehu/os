SRC:=boot.asm
BIN:=boot.com 

.PHONY : run

run : $(BIN)
	sudo mount -o loop os.img /mnt/floppy/
	sudo cp $(BIN) /mnt/floppy/ -v
	sudo umount /mnt/floppy/
boot.com : boot.asm
	nasm $< -o $@
clean:
	-rm -f boot.com