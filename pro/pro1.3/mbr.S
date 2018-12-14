%include "loader.inc"
SECTION MBR vstart=0x7c00
  
  mov ax,cs
  mov ds,ax
  mov es,ax
  mov ss,ax
  mov fs,ax
  mov sp,0x7c00
  mov ax,0xb800   ;显存
  mov gs,ax

;利用0x06号功能，上卷全部行，则可清屏。
; -----------------------------------------------------------
;INT 0x10   功能号:0x06	   功能描述:上卷窗口
;------------------------------------------------------
;输入：
;AH 功能号= 0x06
;AL = 上卷的行数(如果为0,表示全部)
;BH = 上卷行属性
;(CL,CH) = 窗口左上角的(X,Y)位置
;(DL,DH) = 窗口右下角的(X,Y)位置
  mov ax,0x600
  mov bx,0x700
  mov cx,0
  mov dx,0x184f   ;(80,25)
  int 0x10        ;10h 中断,06位上卷窗口

  mov byte [gs:0x00],'T'
  mov byte [gs:0x01],0xA4

  mov byte [gs:0x02],'e'
  mov byte [gs:0x03],0x13

  mov byte [gs:0x04],'s'
  mov byte [gs:0x05],0x52

  mov byte [gs:0x06],'t'
  mov byte [gs:0x07],0xB1

  mov byte [gs:0x08],' '
  mov byte [gs:0x09],0xCC

  mov byte [gs:0x0A],'S'
  mov byte [gs:0x0B],0x2B

  mov byte [gs:0x0C],'t'
  mov byte [gs:0x0D],0x6D

  mov byte [gs:0x0E],'r'
  mov byte [gs:0x0F],0x7E

  mov byte [gs:0x10],'i'
  mov byte [gs:0x11],0x49

  mov byte [gs:0x12],'n'
  mov byte [gs:0x13],0xE5

  mov byte [gs:0x14],'g'
  mov byte [gs:0x15],0x8A

  mov byte [gs:0x16],'!'
  mov byte [gs:0x17],0x96


  mov eax,LOADER_START_SECTOR
  mov bx,LOADER_BASE_ADDR
  mov cx,1
  call read_disk

  jmp LOADER_BASE_ADDR


;----------------
; eax=LBA扇区号
; bx=将数据写入的内存地址
; cx=待读入的扇区数
;
read_disk:  


  mov esi,eax   ;备份eax,cx
  mov di,cx

  mov dx,0x1f2
  mov al,cl
  out dx,al     ;读取的扇区数
  mov eax,esi   ;恢复ax

;lba地址7-0位写入0x1f3
  mov dx,0x1f3
  out dx,al

;lba地址15-8位写入0x1f4
  mov cl,8
  shr eax,cl
  mov dx,0x1f4
  out dx,al

;lba地址23-16位写入0x1f5
  shr eax,cl
  mov dx,0x1f5
  out dx,al

;写入device信息
  shr eax,cl
  and al,0x0f
  or al,0xe0
  mov dx,0x1f6
  out dx,al

;向0x1f7端口写读命令
  mov dx,0x1f7
  mov al,0x20  ;读
  out dx,al

;检测硬盘状态
not_ready:
  nop
  in al,dx
  and al,0x88
  cmp al,0x08
  jnz not_ready

;从0x1f0端口读数据
  mov ax,di
  mov dx,256
  mul dx
  mov cx,ax
  mov dx,0x1f0

go_on_read:
  in ax,dx
  mov [bx],ax
  add bx,2
  loop go_on_read
  ret

  times 510-($-$$) db 0
  db 0x55,0xaa