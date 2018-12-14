[section .text]	; 代码在此

global _start	; 导出 _start

_start:	
	mov	ah, 0Fh				
	mov	al, '!'
	mov	[gs:((80 * 1 + 39) * 2)], ax	;
	jmp	$
