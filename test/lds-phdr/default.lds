ENTRY(main)

SECTIONS
{
    . = 0x085400;
    .text : {*(.text)}
    . = 0x091020;
    .rodata : {*(.rodata)}
    . = 0x120000;
    .eh_frame : {*(.eh_frame)}
    . = 0x130000;
    .note.gnu.property : {*(.note.gnu.property)}
    .data : {*(data)}
    .bss : {*(.bss)}
}