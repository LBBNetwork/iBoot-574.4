OUTPUT_FORMAT("elf32-littlearm")

/* Base is at 0. */
__base = 0x84000000;
/* iBoot start. */
__iboot_base = 0x400;

MEMORY {
	ram : org = 0x84000000, l = 16M
}

ENTRY(_start)

SECTIONS {
	.reset : {
		*(.reset)
		. = ALIGN(0x4);
	} >ram

	.srom_title 0x84000200 :{
		*(.srom_title)
		. = ALIGN(0x4);
	} >ram

	.srom_build 0x84000240 :{
		*(.srom_build)
		. = ALIGN(0x4);
	} >ram

	.srom_revision 0x84000280 :{
		*(.srom_revision)
		. = ALIGN(0x4);
	} >ram

	.srom_revision_offset 0x84000300 :{
		*(.srom_revision_offset)
		. = ALIGN(0x40);
	} >ram

	. = __base + __iboot_base;	
	.text :{
		*(.text)
		*(.text.*)
		. = ALIGN(0x4);
	} >ram

	.glue_7 :{
		*(.glue_7)
		. = ALIGN(0x4);
	} >ram

	.rodata : {
		*(.rodata)
		*(.rodata.*)
	} >ram
	
	. = ALIGN(32);
	.data : {
		*(.data)
		*(.data.*)
		*(.sdata)
		*(.sdata.*)
	} >ram

	. = ALIGN(32);
	__bss_start = .;
	.bss : {
		*(.sbss)
		*(.sbss.*)
		*(COMMON)
		*(.bss)
		*(.bss.*)
	} >ram

	. = ALIGN(64);
	.stack : {
		__stack_top = .;
		. += 0x10000;
		__stack_bottom = .;
	}  >ram

	__free_memory = .;
}

