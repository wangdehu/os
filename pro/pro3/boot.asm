
bits 16
extern choose

global _start	
global print_string

[section .data]
data_string db "this is string",0
num1st		dd	3
num2nd		dd	3

[section .text]

_start:

	mov ax,cs
    mov ds,ax
    mov ss,ax
    mov esp,0x7c00
		
	call choose	

	jmp $
	nop	
	nop

print_string:
	
	mov  DWORD ecx,[esp+2]
	mov  DWORD esi,[esp+4]

	; mov cx,3
	; mov si,data_string		
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
	loop .repeat

.done:
	ret