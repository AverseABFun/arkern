#![no_std]
#![no_main]
#![allow(dead_code)]
use core::{arch::asm, panic::PanicInfo, ptr::write_volatile};

#[no_mangle]
#[link_section = ".start"]
pub unsafe extern "C" fn _start() -> ! {
    letter_to_screen(b'A', VideoBufferColor::Red);
    halt()
}

enum VideoBufferColor {
    Black,
    Blue,
    Green,
    Cyan,
    Red,
    Purple,
    Brown,
    Gray,
    DarkGray,
    LightBlue,
    LightGreen,
    LightCyan,
    LightRed,
    LightPurple,
    Yellow,
    White,
}

#[inline(always)]
unsafe fn letter_to_screen(letter: u8, color: VideoBufferColor) {
    let mut ptr = 0xB8000 as *mut u8;
    write_volatile(ptr, letter);
    ptr = ptr.wrapping_add(1);
    write_volatile(ptr, color as u8);
}

fn halt() -> ! {
    unsafe { asm!("hlt") }
    loop {}
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    halt()
}
