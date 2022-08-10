; Main boot record
; -----------------------------------------------

section MBR vstart=0x7c00
    mov ax, cs
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov sp, ax

; Set video mode
    mov ax, 0x1
    int 0x10

; Select a page and set
;---------------------------------------------------
    mov ax, 0x0500
    int 0x10

; Clear screen by uprolling the screen
    mov ax, 0x0600
    mov bx, 0x0
    mov cx, 0x0
    mov dx, 0x184f
    int 0x10

; Set cursor in page zero
    mov ax, 0x0200
    xor bx, bx
    mov dx, 0x0100
    int 0x10

; Write string
    mov ax, 0x1300      ; mode 1
    mov bx, 0x0041      ; Blue background, Red foreground, 0x14. Red background, Blue foreground, 0x41.
    mov ecx, 0xc         ; length of string. 12 = 0xc
    mov dx, 0x0510      ; (row, column)
    mov bp, message
    int 0x10
    jmp $

; data stored
    message db "Sx, 2021 NB"
    times 510 - ($ - $$) db 0
    dw 0xaa55

