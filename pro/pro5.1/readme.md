1. 整个代码的结构为boot文件夹作为引导，内核在kernel文件夹下，include 是公有的c头文件。lib里是辅助函数
2. 用4个语句完成了切换堆栈和更换gdt的任务，其中gdt_ptr和cstart分别是一个全局变量和全局函数，定义在start.c中
```asm
mov	esp, StackTop	; 堆栈在 bss 段中

	sgdt	[gdt_ptr]	; cstart() 中将会用到 gdt_ptr
	call	cstart		; 在此函数中改变了gdt_ptr，让它指向新的GDT
	lgdt	[gdt_ptr]	; 使用新的GDT

```
3. cstart()做了一次输出，这个函数的位置在lib下。然后把位于loader中的原GDT全部赋值给新的GDT（换了基地址和界限）。使用了memcpy函数，凡在了string.asm中。还有一些结构体在include目录下。

```c
PUBLIC void cstart()
{
	disp_str("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
		 "-----\"cstart\" begins-----\n");

	/* 将 LOADER 中的 GDT 复制到新的 GDT 中 */
	memcpy(&gdt,				  /* New GDT */
	       (void*)(*((u32*)(&gdt_ptr[2]))),   /* Base  of Old GDT */
	       *((u16*)(&gdt_ptr[0])) + 1	  /* Limit of Old GDT */
		);
	/* gdt_ptr[6] 共 6 个字节：0~15:Limit  16~47:Base。用作 sgdt/lgdt 的参数。*/
	u16* p_gdt_limit = (u16*)(&gdt_ptr[0]);
	u32* p_gdt_base  = (u32*)(&gdt_ptr[2]);
	*p_gdt_limit = GDT_SIZE * sizeof(DESCRIPTOR) - 1;
	*p_gdt_base  = (u32)&gdt;

	disp_str("-----\"cstart\" ends-----\n");
}

```