; loader
; -----------------------------------------------

%include "boot.inc"

SECTION LOADER vstart=LOADER_BASE_ADDR
    jmp loader_start
    ; GDT table
GDT_BASE:
    dd 0x00000000
    dd 0x00000000
CODE_DESC:
    dd 0x0000ffff
    dd DESC_HIGH4_CODE
DATA_STACK_DESC:
    dd 0x0000ffff
    dd DESC_HIGH4_DATA
VIDEO_DESC:
    dd 0x80000008
    dd DESC_HIGH4_VIDEO

    GDT_SIZE equ $ - GDT_BASE
    GDT_LIMIT equ GDT_SIZE - 1

    times 60 dq 0

GDT_PTR:
    dw GDT_LIMIT
    dd GDT_BASE

SELECTOR_CODE equ (1 << 3) + TI_GDT + RPL0
SELECTOR_DATA equ (2 << 3) + TI_GDT + RPL0
SELECTOR_VIDEO equ (3 << 3) + TI_GDT + RPL0

readMode_message:
    db 'system entered real mode.'
    align 4, db 0

loader_start:
    ; use video memory 
    ; gs register has long been set to 0xb8000
    mov byte [gs:0x140], 'l'
    mov byte [gs:0x141], 0x41

    mov byte [gs:0x142], 'o'
    mov byte [gs:0x143], 0x41

    mov byte [gs:0x144], 'a'
    mov byte [gs:0x145], 0x41

    mov byte [gs:0x146], 'd'
    mov byte [gs:0x147], 0x41

    mov byte [gs:0x148], 'e'
    mov byte [gs:0x149], 0x41
    
    mov byte [gs:0x14a], 'r'
    mov byte [gs:0x14b], 0x41

    ; ------------------- OPEN A20 ----------------------
    in al, 0x92
    or al, 0000_0010b
    out 0x92, al

    ; --------------------- Load gdt ---------------------
    lgdt [GDT_PTR]

    ; ---------------------- Enable PE in cr0 --------------------
    mov eax, cr0
    or eax, 0000_0001b
    mov cr0, eax
    jmp SELECTOR_CODE:p_mode_start

[bits 32]
p_mode_start:
    mov ax, SELECTOR_DATA
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov ax, SELECTOR_VIDEO
    mov gs, ax

    mov byte [gs:0x1e0], 'p'
    mov byte [gs:0x1e1], 0x41

    mov byte [gs:0x1e2], '_'
    mov byte [gs:0x1e3], 0x41

    mov byte [gs:0x1e4], 'm'
    mov byte [gs:0x1e5], 0x41

    mov byte [gs:0x1e6], 'o'
    mov byte [gs:0x1e7], 0x41

    mov byte [gs:0x1e8], 'd'
    mov byte [gs:0x1e9], 0x41

    mov byte [gs:0x1ea], 'e'
    mov byte [gs:0x1eb], 0x41

    jmp $