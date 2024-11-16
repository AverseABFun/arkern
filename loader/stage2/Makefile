all: stage2

debug: stage2

.PHONY: all debug clean

clean:
	rm -f stage2
	cargo clean

stage2:
	cargo build
	objcopy -O binary --only-section=.text target/x86_64-arkern/debug/stage2 stage2