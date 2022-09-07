ENTRY(main)

PHDRS
{
    text PT_LOAD FILEHDR PHDRS;
    rodata PT_LOAD;
}

SECTIONS
{
    . = 0x085400;
    .interp : {*(.interp)} : text : interp
    .text : {*(.text)} : text
    . = 0x091020;
    .rodata : {*(.rodata)} :rodata
    . = 0x120000;
    .eh_frame : {*(.eh_frame)} : text
    .data : {*(data)} : text
    .bss : {*(.bss)}
}