; loader
; -----------------------------------------------

%include "boot.inc"

SECTION MBR vstart=0x7c00
    ; use video memory 
    ; gs register has long been set to 0xb800
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

    jmp $