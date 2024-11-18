.PHONY: bios clean bios-emulate bios-all

clean:
	rm -f loader
	$(MAKE) -C bios clean

bios:
	rm -f loader
	$(MAKE) -C bios stage1.bin
	cp bios/stage1.bin loader

bios-emulate:
	bochs -f bochsrc.txt -q -rc bios/auto-continue.txt

bios-all: bios bios-emulate