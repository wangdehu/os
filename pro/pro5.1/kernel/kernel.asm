


SELECTOR_KERNEL_CS	equ	8

; 导入函数
extern	cstart

; 导入全局变量
extern	gdt_ptr


[SECTION .bss]
StackSpace		resb	2 * 1024
StackTop:		; 栈顶

[section .text]	; 代码在此

global _start	; 导出 _start

_start:

	; 把 esp 从 LOADER 挪到 KERNEL
	mov	esp, StackTop	; 堆栈在 bss 段中

	sgdt	[gdt_ptr]	; cstart() 中将会用到 gdt_ptr
	call	cstart		; 在此函数中改变了gdt_ptr，让它指向新的GDT
	lgdt	[gdt_ptr]	; 使用新的GDT

	;lidt	[idt_ptr]

	jmp	SELECTOR_KERNEL_CS:csinit
csinit:		

	push	0
	popfd	; Pop top of stack into EFLAGS

	hlt
