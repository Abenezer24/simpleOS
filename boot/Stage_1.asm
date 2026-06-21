[org 0x7C00]

start:
    cli

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov sp, 0x7C00

    sti

    ; -------------------------
    ; Load Stage 2 from disk
    ; -------------------------

    mov ah, 0x02
    mov al, 4
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [BOOT_DRIVE]

    mov bx, 0x8000
    mov es, 0x0000 

    int 0x13
    jc disk_error

    jmp 0x0000:0x8000

disk_error:
    hlt
    jmp disk_error

BOOT_DRIVE db 0


times 510 - ($ - $$) db 0
dw 0xAA55
