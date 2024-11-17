all: stage1.bin emulate

debug: stage1.bin emulate-debug

.PHONY: all debug clean emulate emulate-debug

clean:
	rm -f stage1.bin

stage1.bin: main.s
	nasm main.s -f bin -o stage1.bin

emulate:
	bochs -f bochsrc.txt -q -rc auto-continue.txt

emulate-debug:
	bochs -f bochsrc.txt -q