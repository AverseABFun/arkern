; NASM assembly
bits 16
org  0x7C00

cli
xor  ax,  ax
mov  ds,  ax
lgdt [gdt.desc]

mov  eax, cr0
or   eax, 1
mov  cr0, eax
jmp  08h:clear_pipe

gdt:
    .null: dq 0
    .code:
        dw 0FFFFh
        dw 0
        db 0
        db 10011010b
        db 11001111b
        db 0
    .data:
        dw 0FFFFh
        dw 0
        db 0
        db 10010010b
        db 11001111b
        db 0
.end:
.desc:
   dw .end - gdt - 1
   dd gdt

bits 32

clear_pipe:
mov  ax,         0x10
mov  ds,         ax
mov  es,         ax
mov  fs,         ax
mov  gs,         ax
mov  ss,         ax

mov  ah,         'P'
mov  [0x0B8000], ah
mov  ah,         1Bh
mov  [0x0B8001], ah

hang:
    jmp hang

times 510 - ($-$$) db 0
dw 0xAA55

rust_begin:
    