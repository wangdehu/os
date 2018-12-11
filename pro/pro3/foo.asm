
bits 16
extern choose


[section .data]
data_string db "this is string",0

[section .text]

global _start	
global print_string


_start:

	mov ax,cs
    mov ds,ax
    mov ss,ax
    mov esp,0x7c00
	mov si,data_string

	call choose	

	jmp $
	nop	
	nop

print_string:			
	mov ah,00h
	mov al,04h
	int 10h
	mov ah, 0Eh			
	mov bh,00h
	mov bl,02h


.repeat:
	lodsb			
	cmp al, 0
	je .done		
	int 10h			
	jmp .repeat

.done:
	ret