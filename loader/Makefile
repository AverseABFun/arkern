.PHONY: bios

clean:
	rm -f loader

bios:
	$(MAKE) -C bios stage1.bin
	$(MAKE) -C stage2 stage2
	cp bios/stage1.bin loader
	cat stage2/stage2 >> loader