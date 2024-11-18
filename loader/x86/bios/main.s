; NASM assembly
bits        16
org         0x7C00

mov         [loaded_drive], dl

call        reset_disk

jmp         main

bprintchar:                    ;Assume that AL has the character in it and BH has the page in it; does not modify general purpose registers
	pusha

	mov ah, 0Eh ;Operation
	mov bl, 00h ;Color in graphics mode, not in the current text mode
	mov cx, 01h ;Number of repetitions

	int 10h

	popa
	ret

bprint: ;Assume that string starting pointer is in register SI; does not modify general purpose registers
	pusha

	bp_next_char:
		mov  al, [si]
		inc  si
		or   al, al
		jz   bp_end
		mov  bh, 00h
		call bprintchar
		jmp  bp_next_char
	bp_end:
		popa
		ret

reset_disk: ;does not modify general purpose registers
	pusha

		mov ah, 00h            ;command
		mov dl, [loaded_drive] ;disk

		int 13h

	popa
	ret

load_sectors:
    xor ax, ax    ; make sure ds is set to 0
    mov ds, ax
    cld
    ; start putting in values:
    mov ah, 2h    ; int13h function 2
    mov al, 64    ; we want to read 64 sectors
    mov ch, 0     ; from cylinder number 0
    mov cl, 2     ; the sector number 2 - second sector (starts from 1, not 0)
    mov dh, 0     ; head number 0
    xor bx, bx
    mov es, bx    ; es should be 0
    mov bx, 7e00h ; 512bytes from origin address 7c00h
    int 13h
    ret


error:
    inc  byte [iterations]
    call reset_disk

    mov al, [iterations]
    cmp al, 3            ; Only retry 3 times
    jge error3           ; Jump to error3 after 3 retries

    jmp main_load ; Retry loading if under 3 attempts

error3:

    mov  si, FAILURE_MSG
    call bprint

    mov ah, 01h ; Wait for a keypress
err3loop:
    int 16h
    jz  err3loop

    jmp err3exit


err3exit:
	jmp 0xFFFF:0 ;restart vector

main:
	mov  si, LOADING
	call bprint

	main_load:

	call load_sectors

	jc error

	mov  si, LOADOK
	call bprint

	jmp 7e00h ; Jump to loaded code

LOADING      db "Loading...", 0Ah, 0Dh, 0
FAILURE_MSG  db "ERROR: Press any key to reboot.", 0Ah, 0Dh, 0
LOADOK       db "Load ok", 0Ah, 0Dh, 0

loaded_drive db 0
iterations   db 0

times 510 - ($-$$) db 0
dw 0xAA55

end:

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
mov  ax, 0x10
mov  ds, ax
mov  es, ax
mov  fs, ax
mov  gs, ax
mov  ss, ax

rust_begin:
    