[org 0x8000]
[BITS 16]

start:

; ------------------------------------
; Ask user for name (REAL MODE)
; ------------------------------------

mov si, prompt
call print_string

mov di, username
call read_string

; ------------------------------------
; Switch to Protected Mode
; ------------------------------------

cli
xor ax, ax
mov ds, ax
lgdt [gdt_descriptor]

mov eax, cr0
or eax, 1
mov cr0, eax

jmp CODE_SEG:init_pm

; ====================================
; 32-bit Protected Mode
; ====================================

[BITS 32]

init_pm:

mov ax, DATA_SEG
mov ds, ax
mov es, ax
mov fs, ax
mov gs, ax
mov ss, ax

mov esp, 0x90000

call clear_screen

mov esi, welcome
call print_pm_string

mov esi, username
call print_pm_string

hang:
    hlt
    jmp hang

; ====================================
; VGA PRINT ROUTINES
; ====================================

VIDEO_MEMORY equ 0xB8000

cursor_pos dd 0

print_pm_string:

.next:
    lodsb
    cmp al, 0
    je .done

    mov ebx, VIDEO_MEMORY
    add ebx, [cursor_pos]

    mov [ebx], al
    mov byte [ebx+1], 0x0F

    add dword [cursor_pos], 2

    jmp .next

.done:
    ret

clear_screen:

    mov edi, VIDEO_MEMORY
    mov ecx, 80*25

.clear:

    mov byte [edi], ' '
    mov byte [edi+1], 0x07

    add edi, 2
    loop .clear

    mov dword [cursor_pos], 0
    ret

; ====================================
; REAL MODE ROUTINES
; ====================================

[BITS 16]

print_string:

.next:
    lodsb
    cmp al, 0
    je .done

    mov ah, 0x0E
    int 0x10

    jmp .next

.done:
    ret

read_string:

.loop:

    xor ah, ah
    int 0x16

    cmp al, 13
    je .done

    stosb

    mov ah, 0x0E
    int 0x10

    jmp .loop

.done:
    mov al, 0
    stosb
    ret

; ====================================
; DATA
; ====================================

prompt db "Enter your name: ",0
welcome db "Welcome ",0

username times 32 db 0

; ====================================
; GDT
; ====================================

gdt_start:

gdt_null:
    dq 0

gdt_code:
    dw 0xFFFF
    dw 0
    db 0
    db 10011010b
    db 11001111b
    db 0

gdt_data:
    dw 0xFFFF
    dw 0
    db 0
    db 10010010b
    db 11001111b
    db 0

gdt_end:

gdt_descriptor:
    dw gdt_end - gdt_start - 1
    dd gdt_start

CODE_SEG equ gdt_code - gdt_start
DATA_SEG equ gdt_data - gdt_start