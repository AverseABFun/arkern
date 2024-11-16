#![no_std]
#![no_main]

use core::{arch::asm, panic::PanicInfo};

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    unsafe { asm!("hlt") }
    loop {}
}

#[no_mangle]
pub extern "C" fn _start() -> ! {
    loop {}
}
