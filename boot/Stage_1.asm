[org 0x7C00]


start:
    cli

    xor ax, ax
    mov ds, ax
    mov es, ax
    mov ss, ax

    mov sp, 0x7C00

    sti
    mov [BOOT_DRIVE], dl
    ; -------------------------
    ; Load Stage 2 from disk
    ; -------------------------

    mov bx, 0x8000

    
    mov ch, 0
    mov cl, 2
    mov dh, 0
    mov dl, [BOOT_DRIVE]

    mov ah, 0x02
    mov al, 4

    
    int 0x13
    jc disk_error

    jmp 0x0000:0x8000

disk_error:
    hlt
    jmp disk_error

BOOT_DRIVE db 0


times 510 - ($ - $$) db 0
dw 0xAA55



