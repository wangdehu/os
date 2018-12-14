bits 16
org 0x7c00
BaseOfStack equ 0x7c00

start:
    mov ax,cs
    mov ds,ax
    mov ss,ax
    mov sp,BaseOfStack
    
    mov si, text_string	
	call print_string	
	jmp $			    

print_string:			
	mov ah,00h
	mov al,04h
	int 10h				;切换到图形模式
	mov ah, 0Eh			
	mov bh,00h
	mov bl,02h
	


.repeat:
	lodsb			;传送一个字符
	cmp al, 0		
	je .done		;判断是否为0	
	int 10h			
	jmp .repeat

.done:
	ret

.data:
	text_string db 'Test String',0


	times 510-($-$$) db 0	;填充
	dw 0xAA55		        ;mbr签名