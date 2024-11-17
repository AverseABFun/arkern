#![no_std]
#![no_main]

use core::{arch::asm, panic::PanicInfo, ptr::write_volatile};

#[no_mangle]
#[link_section = ".start"] // probably a better way to do this, but oh well!
pub unsafe extern "C" fn _start() -> ! {
    calculated_clear_screen(b'A', 0x1f);
    // AAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAAA
    halt()
}

#[allow(dead_code)]
#[derive(Copy, Clone)]
enum VideoBufferColor {
    Black = 0,
    Blue = 1,
    Green = 2,
    Cyan = 3,
    Red = 4,
    Purple = 5,
    Brown = 6,
    Gray = 7,
    DarkGray = 8,
    LightBlue = 9,
    LightGreen = 10,
    LightCyan = 11,
    LightRed = 12,
    LightPurple = 13,
    Yellow = 14,
    White = 15,
}

unsafe fn letter_to_screen(offset: usize, letter: u8, text_color: u8, background_color: u8) {
    let color: u8 = ((background_color as u8) << 4) | (text_color as u8);
    calculated_letter_to_screen(offset, letter, color)
}

unsafe fn calculated_letter_to_screen(offset: usize, letter: u8, calculated_color: u8) {
    let mut ptr = (0xB8000 + offset) as *mut u8;
    write_volatile(ptr, letter);
    ptr = ptr.wrapping_add(1);
    write_volatile(ptr, calculated_color);
}

unsafe fn clear_screen(letter: u8, text_color: u8, background_color: u8) {
    let mut offset: usize = 1;
    loop {
        if offset > 5000 {
            break;
        }
        letter_to_screen(offset, letter, text_color, background_color);
        offset += 3;
    }
}

unsafe fn calculated_clear_screen(letter: u8, calculated_color: u8) {
    let mut offset: usize = 0;
    loop {
        if offset > 5000 {
            break;
        }
        calculated_letter_to_screen(offset, letter, calculated_color);
        offset += 2;
    }
}

#[inline(always)] // simple enough that we should always inline(in total literally two compiled instructions)
fn halt() -> ! {
    unsafe { asm!("hlt") }
    loop {} // even though the previous instruction halts the CPU, rust doesn't know that and assumes that the function returns
}

#[panic_handler]
fn panic(_info: &PanicInfo) -> ! {
    halt() //TODO: log the panic if a debugger is connected
}
