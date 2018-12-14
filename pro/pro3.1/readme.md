## 简介
- 代码任务:
    - 完成分页功能
- 代码要求：
    1. 实模式下,利用中断查看内存
    2. 在保护模式下,完成分页功能
- 项目结构说明：汇编的头文件lib.inc,os.inc, 汇编代码boot.asm.使用了freedos来代替引导

代码知识点分析:
1. 分段机制也提供了保护机制，而引入分页的目的是为了实现虚拟存储器
2. 使用两级页面，第一级是大小4KB的页目录表，共1024个表项，每项是第二级的一个页表；第二级每个页表，1024项，每项对应一个物理页面。
3. 分页机制的开关在cr0寄存器的最高位，称为PG位，为1则分页机制打开。同时cr3需要指向页目录表。
```asm
; 启动分页机制 --------------------------------------------------------------
SetupPaging:
	; 根据内存大小计算应初始化多少PDE以及多少页表
	xor	edx, edx
	mov	eax, [dwMemSize]
	mov	ebx, 400000h	; 400000h = 4M = 4096 * 1024, 一个页表对应的内存大小
	div	ebx
	mov	ecx, eax	; 此时 ecx 为页表的个数，也即 PDE 应该的个数
	test	edx, edx
	jz	.no_remainder
	inc	ecx		; 如果余数不为 0 就需增加一个页表
.no_remainder:
	push	ecx		; 暂存页表个数

	; 所有线性地址对应相等的物理地址. 

	; 首先初始化页目录
	mov	ax, SelectorPageDir	; 此段首地址为 PageDirBase
	mov	es, ax
	xor	edi, edi
	xor	eax, eax
	mov	eax, PageTblBase | PG_P  | PG_USU | PG_RWW
.1:
	stosd
	add	eax, 4096		; 为了简化, 所有页表在内存中是连续的.
	loop	.1

	; 再初始化所有页表
	mov	ax, SelectorPageTbl	; 此段首地址为 PageTblBase
	mov	es, ax
	pop	eax			; 页表个数
	mov	ebx, 1024		; 每个页表 1024 个 PTE
	mul	ebx
	mov	ecx, eax		; PTE个数 = 页表个数 * 1024
	xor	edi, edi
	xor	eax, eax
	mov	eax, PG_P  | PG_USU | PG_RWW
.2:
	stosd
	add	eax, 4096		; 每一页指向 4K 的空间
	loop	.2

	mov	eax, PageDirBase
	mov	cr3, eax
	mov	eax, cr0
	or	eax, 80000000h
	mov	cr0, eax
	jmp	short .3
.3:
	nop

	ret
; 分页机制完毕 

```

其中有两个宏，PageDirBase与PageTblBase指向页目录表和页表在内存中的位置。

4. 这个project使用了freedos来代替引导程序

5. 程序可以通过15h中断来获取内存的大小，同时可以得到一些对对不同内存段的描述
```asm
	; 得到内存数
	mov	ebx, 0
	mov	di, _MemChkBuf
.loop:
	mov	eax, 0E820h
	mov	ecx, 20
	mov	edx, 0534D4150h
	int	15h
	jc	LABEL_MEM_CHK_FAIL
	add	di, 20
	inc	dword [_dwMCRNumber]
	cmp	ebx, 0
	jne	.loop
	jmp	LABEL_MEM_CHK_OK
LABEL_MEM_CHK_FAIL:
	mov	dword [_dwMCRNumber], 0
LABEL_MEM_CHK_OK



```
6.lib.inc 里位几个功能函数，单独抽出来方便阅读

7.程序最终输出结果是我们得到的内存信息，分为5个字段,基地址的2个32位，长度界限的2个32位，还有这段地址的地址类型

参考资料:

orangeS 一个操作系统的实现 第3章

需要研究的问题:
1. 只是在参考资料下,尝试完成了分页.但是体会并不深
2. 尝试研究分页带来的巨大好处