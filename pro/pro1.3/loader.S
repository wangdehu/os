%include "loader.inc"
section loader vstart=LOADER_BASE_ADDR

mov si,text_string
print_string:			
	mov ah,0eh

.repeat:
	lodsb		
	cmp al, 0
	je .done		
	int 10h			
	jmp .repeat

.done:
	ret

.data:
	text_string db 'Test String',0

jmp $               