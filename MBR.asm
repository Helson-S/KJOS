; Main boot record
; -----------------------------------------------

%include "./boot.inc"

SECTION MBR vstart=0x7c00
    mov ax, cs
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov sp, 0x7c00
    mov ax, 0xb800
    mov gs, ax

    ; set video mode
    mov ax, 0x3
    int 0x10

    ; set displaying page 
    mov ax, 0x0500
    int 0x10

    ; uproll screen
    mov ax, 0x0600
    mov bx, 0x0
    mov cx, 0x0
    mov dx, 0x184f
    int 0x10

    ; set cursor
    mov ax, 0x0200
    xor bx, bx
    xor dx, dx
    int 0x10

    ; write string 
    mov ax, 0x1300
    mov bp, message
    mov cx, 21
    mov dx, 0x0510      ; (row, column)
    mov bx, 0x0041
    int 0x10
    jmp $


    ; data
    message db 'Hello OS, I am helson'
    pad_data times $$+510-$ db 0
    dw 0xaa55