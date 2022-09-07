ENTRY(main)

SECTIONS
{
    . = 0x085400;
    .text : {*(.text)}
    . = 0x091020;
    .rodata : {*(.rodata)}
    .data : {*(data)}
    .bss : {*(.bss)}
}