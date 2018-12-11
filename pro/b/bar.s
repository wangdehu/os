	.file	"bar.c"
	.text
	.globl	choose
	.type	choose, @function
choose:
.LFB0:
	.cfi_startproc
	pushl	%ebp
	.cfi_def_cfa_offset 8
	.cfi_offset 5, -8
	movl	%esp, %ebp
	.cfi_def_cfa_register 5
	subl	$8, %esp
	addl	$1, 8(%ebp)
	addl	$1, 12(%ebp)
	movl	8(%ebp), %eax
	cmpl	12(%ebp), %eax
	jne	.L3
	call	print_string
.L3:
	nop
	leave
	.cfi_restore 5
	.cfi_def_cfa 4, 4
	ret
	.cfi_endproc
.LFE0:
	.size	choose, .-choose
	.ident	"GCC: (Ubuntu 5.4.0-6ubuntu1~16.04.10) 5.4.0 20160609"
	.section	.note.GNU-stack,"",@progbits
