all: stage2

debug: stage2

.PHONY: all debug clean stage2

clean:
	rm -f stage2
	cargo clean

stage2: src/* i686-arkern.json .cargo/* Cargo.toml rust-toolchain.toml ld.lld # lots of files that cargo depends on, oh well
	cargo build # build it
	rm -f stage2 # clean out the junk
	cp target/i686-arkern/debug/arkern-kernel-core kernel # copy this long path