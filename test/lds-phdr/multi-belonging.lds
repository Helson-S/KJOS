ENTRY(main)

PHDRS
{
    text PT_LOAD FILEHDR PHDRS;
    rodata PT_LOAD; 
}

SECTIONS
{
    . = 0x085400;
    .text : {*(.text)} : text
    . = 0x091020;
    .rodata : {*(.rodata)} : rodata : text
    . = 0x120000;
    .eh_frame : {*(.eh_frame)} : text 
    . = 0x130000;
    .note.gnu.property : {*(.note.gnu.property)} : rodata
    .data : {*(data)}
    .bss : {*(.bss)}
}