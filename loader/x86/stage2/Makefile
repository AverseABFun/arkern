all: stage2

debug: stage2

.PHONY: all debug clean stage2

clean:
	rm -f stage2
	cargo clean

stage2: src/* x86_64-arkern.json .cargo/* Cargo.toml rust-toolchain.toml
	cargo build
	rm -f stage2
	cp /home/averse/arkern/loader/x86/stage2/target/x86_64-arkern/debug/stage2 stage2