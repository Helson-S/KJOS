SECTION test
label_one:
    db 'hello'
    var1 dd 0x11223344

    mov eax, label_one
    mov ebx, var1
    mov ecx, var2
    mov edx, [var3]
    mov edi, [label_one]

SECTION .data
    var2 dd 0xdeadbeaf
    var3 dd 0xdeadbeaf