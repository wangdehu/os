
bits 16
extern choose	

[section .data]	; 数据在此

num1st		dd	3
num2nd		dd	3

[section .text]	; 代码在此

global _start	
global print_string	

_start:


	mov ax,cs
    mov ds,ax
    mov ss,ax
    mov esp,0x7c00

	push	dword [num2nd]	
	push	dword [num1st]	
	call choose	
	
	


	jmp $
	nop
	nop

print_string:
	mov ah,00h
	mov al,04h
	int 10h
	mov ah,0Eh			
	mov bh,00h
	mov bl,02h
	ret


