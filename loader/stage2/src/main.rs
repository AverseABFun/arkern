#![no_std]
#![no_main]
#![feature(start)]

use core::{arch::asm, panic::PanicInfo};

#[no_mangle]
pub extern "C" fn rust_main() -> ! {
    // Your Rust code here
    loop {}
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    unsafe { asm!("hlt") }
    loop {}
}

#[start]
fn _start() -> ! {
    rust_main()
}
