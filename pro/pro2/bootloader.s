bits 16
global start
start:
    mov ax,cs
    mov ss,ax
    mov sp,0x7c00
    
    ;计算GDT所在的逻辑段地址 
    mov ax,[cs:gdt_base+0x7c00]        ;低16位 
    mov dx,[cs:gdt_base+0x7c00+0x02]   ;高16位 
    mov bx,16        
    div bx            
    mov ds,ax                          ;令DS指向该段以进行操作
    mov bx,dx                          ;段内起始偏移地址 


    ;创建0#描述符，它是空描述符，这是处理器的要求
    mov dword [bx+0x00],0x00
    mov dword [bx+0x04],0x00  

    ;创建#1描述符，保护模式下的代码段描述符
    mov dword [bx+0x08],0x7c0001ff     
    mov dword [bx+0x0c],00000000_0100_0000_1_00_1_1000_00000000B     

    ;创建#2描述符，保护模式下的数据段描述符（文本模式下的显示缓冲区） 
    mov dword [bx+0x10],0x80007fff
    mov dword [bx+0x14],0x0040920b 
    ;00000000_0100_0000_1_00_1_001000001011B 
    
    ;创建#3描述符，保护模式下的堆栈段描述符
    mov dword [bx+0x18],0x00007a00
    mov dword [bx+0x1c],0x00409600 

    



    ;初始化描述符表寄存器GDTR
    mov word [cs: gdt_size+0x7c00],31  ;描述符表的界限（总字节数减一）   
                                    
    lgdt [cs: gdt_size+0x7c00]

    in al,0x92                          
    or al,00000010B
    out 0x92,al                        ;打开A20

    cli                                ;保护模式下中断机制尚未建立，应 
                                       ;禁止中断 
    mov eax,cr0
    or eax,1
    mov cr0,eax                        ;设置PE位

    
    jmp dword 0x0008:code32             ;重置cs,这个时候已经变成了段选择子了
                                        ;流水线被清空了
                                        
bits 32

code32:

        mov cx,0010h
        ;mov cx,00000000000_10_000B         ;加载数据段选择子(0x10)
        mov ds,cx
        mov byte [0x00],'A'
        mov byte [0x01],0xA4
        mov byte [0x02],'B'
        mov byte [0x03],0x13
        mov byte [0x04],'C'
        mov byte [0x05],0x52
        mov byte [0x06],'D'
        mov byte [0x07],0x8A
        mov byte [0x08],'E'
        mov byte [0x09],0x96
        mov byte [0x0a],'F'
        mov byte [0x0b],0x68
        mov byte [0x0c],'G'
        mov byte [0x0d],0x7E
        mov byte [0x0e],'H'
        mov byte [0x0f],0x49
 

;-------------------------------------------------------------------------------

    gdt_size         dw 0
    gdt_base         dd 0x00007e00     ;GDT的物理地址 
                        
    times 510-($-$$) db 0
    dw 0xAA55