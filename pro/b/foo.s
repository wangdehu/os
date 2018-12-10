
bits 16
extern choose	


[section .text]	; 代码在此

global _start	; 我们必须导出 _start 这个入口，以便让链接器识别。
global print_string	; 导出这个函数为了让 bar.c 使用

_start:


	mov ax,cs
    mov ds,ax
    mov ss,ax
    mov esp,0x7c00

	call choose	
	mov ax,1	
	call print_string
	jmp $

print_string:
	mov ah,00h
	mov al,04h
	int 10h
	mov ah, 0Eh			
	mov bh,00h
	mov bl,02h
	rent


