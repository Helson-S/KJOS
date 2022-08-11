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

    ; use video memory. 0xc1 flash.
    mov byte [gs:0x00], 'H'
    mov byte [gs:0x01], 0x41

    mov byte [gs:0x02], 'e'
    mov byte [gs:0x03], 0x41

    mov byte [gs:0x04], 'l'
    mov byte [gs:0x05], 0x41

    mov byte [gs:0x06], 'l'
    mov byte [gs:0x07], 0x41

    mov byte [gs:0x08], 'o'
    mov byte [gs:0x09], 0x41

    mov eax, LOADER_START_SECTOR
    mov ebx, LOADER_BASE_ADDR
    mov ecx, 0x1                    ; sector count

    call diskloader_to_addr
    jmp LOADER_BASE_ADDR


diskloader_to_addr:
    mov edi, eax
    mov esi, ecx

    ; set Features register, 0x1f1
    ; mov dx, 0x1f1
    ; mov ax, 0x0
    ; out dx, ax

    ; set sector count
    mov eax, esi
    mov dx, 0x1f2
    out dx, al

    ; set LBA28
    mov eax, edi

    mov dx, 0x1f3
    out dx, al

    mov dx, 0x1f4
    shr eax, 8
    out dx, al

    mov dx, 0x1f5
    shr eax, 8
    out dx, al

    ; set device register
    mov dx, 0x1f6
    shr eax, 8
    and al, 0xf
    or al, 0xe0
    out dx, al 

    mov dx, 0x1f7
    mov ax, 0x20
    out dx, al

.if_ready:
    mov dx, 0x1f7
    in al, dx
    and al, 0x88
    cmp al, 0x8
    jnz .if_ready

    ; calculate how many times to read.
    mov ax, 256
    mov dx, si
    mul dx
    mov cx, ax

    mov dx, 0x1f0
.loop_read:
    in ax, dx
    mov word [bx], ax
    add bx, 2
    loop .loop_read

    ret


    ; define padding data
    padding_data times $$ + 510 - $ db 0
    dw 0xaa55