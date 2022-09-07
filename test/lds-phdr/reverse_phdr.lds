ENTRY(main)

PHDRS
{
    rodata PT_LOAD FILEHDR PHDRS;
    text PT_LOAD; 
}

SECTIONS
{
    . = 0x085400;
    .text : {*(.text)} : text
    . = 0x091020;
    .rodata : {*(.rodata)} :rodata
    . = 0x120000;
    .eh_frame : {*(.eh_frame)} : text
    .data : {*(data)}
    .bss : {*(.bss)}
}