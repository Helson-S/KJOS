ENTRY(main)

PHDRS
{
    text PT_LOAD FILEHDR PHDRS;
}

SECTIONS
{
    . = 0x085400;
    .text : {*(.text)} : text
    . = 0x091020;
    .rodata : {*(.rodata)} :text
    .data : {*(data)}
    .bss : {*(.bss)}
}