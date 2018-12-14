1. 在实模式下，bios位我们提供了许多的中断。但在保护模式下，他会被我们的IDT替代，IDT叫做中断描述附表。
2. IDT中有许多中断描述附表，大致分为3类：fault，trap，abort。实际上可以说是
3. 中断是程序在执行过程中的强制性转移。有时候是处理硬件的请求，有时候是软件的中断。同时还有异常的情况。

向量号 |助记符| 说明 |类型| 错误号 |产生源
:---|:--|---|---|---|---|
0 |#DE |除出错| 故障| 无 |DIV或IDIV指令 
1|#DB| 调试| 故障/陷阱|无| 任何代码或数据引用，或是INT 1指令
2 |--|NMI中断|中断|无|非屏蔽外部中断
3|#BP|断点|陷阱|无|INT 3|指令
4|#OF|溢出|陷阱|无|INTO|指令
5|#BR|边界范围超出|故障|无|BOUND|指令
6|#UD|无效操作码（未定义操作码）|故障|无|UD2指令或保留的操作码。（Pentium Pro中加入的新指令）
7|#NM|设备不存在（无数学协处理器）|故障|无|浮点或WAIT/FWAIT指令|
8|#DF|双重错误|异常终止|有|任何可产生异常、NMI或INTR的指令
9|--|协处理器段超越（保留）|故障|无|浮点指令（386以后的CPU不产生该异常）
10|#TS|无效的任务状态段TSS|故障|有|任务交换或访问TSS
11|#NP|段不存在|故障|有|加载段寄存器或访问系统段
12|#SS|堆栈段错误|故障|有|堆栈操作和SS寄存器加载
13|#GP|一般保护错误|故障|有|任何内存引用和其他保护检查
14|#PF|页面错误|故障|有|任何内存引用
15|--|（Intel保留，请勿使用）|无
16|#MF|x87 FPU浮点错误（数学错误）|故障|无|x87 FPU浮点或WAIT/FWAIT指令
17|#AC|对起检查|故障|有|对内存中任何数据的引用
18|#MC|机器检查|异常终止|无|错误码（若有）和产生源与CPU类型有关（奔腾处理器引进）
19|#XF|SIMD浮点异常|故障|无|SSE和SSE2浮点指令（PIII处理器引进）
20-31|--|（Intel保留，请勿使用）
32-255|--|用户定义（非保留）中断|中断

 
4. 同时我们还需要相应的处理程序，每个中断通过他的号码通过IDT找到他的中断处理程序。

5. 8259A是两片一个可编程的中断控制器，我们需要向里面写专门的数据来使用他。
```asm

; Init8259A ---------------------------------------------------------------------------------------------
Init8259A:
	mov	al, 011h
	out	020h, al	; 主8259, ICW1.
	call	io_delay

	out	0A0h, al	; 从8259, ICW1.
	call	io_delay

	mov	al, 020h	; IRQ0 对应中断向量 0x20
	out	021h, al	; 主8259, ICW2.
	call	io_delay

	mov	al, 028h	; IRQ8 对应中断向量 0x28
	out	0A1h, al	; 从8259, ICW2.
	call	io_delay

	mov	al, 004h	; IR2 对应从8259
	out	021h, al	; 主8259, ICW3.
	call	io_delay

	mov	al, 002h	; 对应主8259的 IR2
	out	0A1h, al	; 从8259, ICW3.
	call	io_delay

	mov	al, 001h
	out	021h, al	; 主8259, ICW4.
	call	io_delay

	out	0A1h, al	; 从8259, ICW4.
	call	io_delay

	;mov	al, 11111111b	; 屏蔽主8259所有中断
	mov	al, 11111110b	; 仅仅开启定时器中断
	out	021h, al	; 主8259, OCW1.
	call	io_delay

	mov	al, 11111111b	; 屏蔽从8259所有中断
	out	0A1h, al	; 从8259, OCW1.
	call	io_delay

	ret
; Init8259A -------
```

6.建立IDT使用了%rep预处理指令，快速完成中断设置
```asm
; 门                        目标选择子,            偏移, DCount, 属性
%rep 32
		Gate	SelectorCode32, SpuriousHandler,      0, DA_386IGate
%endrep
.020h:		Gate	SelectorCode32,    ClockHandler,      0, DA_386IGate
%rep 95
		Gate	SelectorCode32, SpuriousHandler,      0, DA_386IGate
%endrep
.080h:		Gate	SelectorCode32,  UserIntHandler,      0, DA_386IGate

IdtLen		equ	$ - LABEL_IDT
IdtPtr		dw	IdtLen - 1	; 段界限
		dd	0		; 基地址
; END of [SECTION .idt]
```asm


这个中断的处理是在右上角打印红色的！
```asm
_SpuriousHandler:
SpuriousHandler	equ	_SpuriousHandler - $$
	mov	ah, 0Ch				; 0000: 黑底    1100: 红字
	mov	al, '!'
	mov	[gs:((80 * 0 + 75) * 2)], ax	; 屏幕第 0 行, 第 75 列。
	jmp	$
	iretd
```
这个中断内容是（0,75）的值+1
_ClockHandler:
ClockHandler	equ	_ClockHandler - $$
	inc	byte [gs:((80 * 0 + 70) * 2)]	; 屏幕第 0 行, 第 70 列。
	mov	al, 20h
	out	20h, al				; 发送 EOI
	iretd

7. 在16位下我们关掉了中断，然后可以使用sti打开中断


8.程序运行后，我们将看到右上角不停的变化