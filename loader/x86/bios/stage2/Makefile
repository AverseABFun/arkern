all: stage2

debug: stage2

.PHONY: all debug clean stage2

clean:
	rm -f stage2
	cargo clean

stage2: src/* x86_64-arkern.json .cargo/* Cargo.toml rust-toolchain.toml ld.lld # lots of files that cargo depends on, oh well
	cargo build # build it
	rm -f stage2 # clean out the junk
	cp target/x86_64-arkern/debug/stage2 stage2 # copy this long path