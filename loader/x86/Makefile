.PHONY: bios clean bios-emulate bios-all

clean:
	rm -f loader
	$(MAKE) -C bios clean
	$(MAKE) -C stage2 clean

bios:
	rm -f loader
	$(MAKE) -C bios stage1.bin
	$(MAKE) -C stage2 stage2
	cp bios/stage1.bin loader
	cat stage2/stage2 >> loader

bios-emulate:
	bochs -f bochsrc.txt -q -rc bios/auto-continue.txt

bios-all: bios bios-emulate