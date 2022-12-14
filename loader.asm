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

    ; line 4
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



    jmp page_start
    ; ----------- some function about page mapping ---------------------

setup_page:
    ; x64 invoke convention
    mov edi, PDE_pos
    mov esi, 0
    mov ecx, 0x3000 ; 4096*3 = 0x3000
.clear_page_area:
    mov byte [edi + esi], 0
    inc esi
    loop .clear_page_area

    ; syscall convention
    ; create PDE
    mov eax, PDE_pos
    mov ebx, PDE_pos + 0x1000
    or ebx, PG_P | PG_RW_W | PG_US_U
    mov [eax], ebx
    mov [eax + 0xc00], ebx
    sub ebx, 0x1000
    mov [eax + 0xffc], ebx

    ; create PTE, syscall convention
    mov eax, PDE_pos + 0x1000
    mov ebx, 0 | PG_P | PG_RW_W | PG_US_U
    mov edx, 0
    mov ecx, 256
.PTE_In_Low_1M:
    mov [eax + edx*4], ebx
    add ebx, 4096
    inc edx
    loop .PTE_In_Low_1M

    ; Create PDE from 769 to 1022
    mov eax, PDE_pos
    add eax, 4 * 769
    mov ebx, PDE_pos
    add ebx, 0x2000
    or ebx, PG_P | PG_RW_W | PG_US_U
    mov edx, 0
    mov ecx, 254
.PDE_From769_To1022:
    mov [eax + edx*4], ebx
    add ebx, 0x1000
    inc edx
    loop .PDE_From769_To1022

    ret

page_start:
    call setup_page
    sgdt [GDT_PTR]

    ; modify VIDEO Descriptor. Adjust it's virtual address to PDE 768
    mov eax, GDT_PTR
    add eax, 0x2
    mov ebx, [eax + 3 * 8 + 4]
    or ebx, 0xc0000000 ; 0xc0000000 = 768 >> 2 << 24
    mov [eax + 3*8 + 4], ebx

    ; modify GDT_PTR
    mov eax, GDT_PTR
    add eax, 0x2
    mov ebx, [eax]
    or ebx, 0xc0000000 ; 0xc0000000 = 768 << 22
    mov [eax], ebx

    ; set cr3
    mov eax, PDE_pos
    mov cr3, eax
    
    ; Enable paging
    mov eax, cr0
    or eax, 0x80000000 ; 0x80000000 = 0x1 << 31
    mov cr0, eax

    ; reload GDT
    lgdt [GDT_PTR]

    ; Test for paging
    ; line 5
    mov byte [gs:0x280], 'P'
    mov byte [gs:0x281], 0x41

    mov byte [gs:0x282], 'A'
    mov byte [gs:0x283], 0x41

    mov byte [gs:0x284], 'G'
    mov byte [gs:0x285], 0x41

    mov byte [gs:0x286], 'E'
    mov byte [gs:0x287], 0x41

    jmp $