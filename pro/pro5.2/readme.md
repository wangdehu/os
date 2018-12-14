1. 要设置中断需要做的两件事是设置8259A和建立IDT。不过很多工作都可以使用c语言来做了
2.使用一个初始化函数来设置8259A，与汇编的逻辑相同
```c
PUBLIC void	out_byte(u16 port, u8 value);
PUBLIC void init_8259A()
{
	/* Master 8259, ICW1. */
	out_byte(INT_M_CTL, 0x11);

	/* Slave  8259, ICW1. */
	out_byte(INT_S_CTL, 0x11);

	/* Master 8259, ICW2. 设置 '主8259' 的中断入口地址为 0x20. */
	out_byte(INT_M_CTLMASK, INT_VECTOR_IRQ0);

	/* Slave  8259, ICW2. 设置 '从8259' 的中断入口地址为 0x28 */
	out_byte(INT_S_CTLMASK, INT_VECTOR_IRQ8);

	/* Master 8259, ICW3. IR2 对应 '从8259'. */
	out_byte(INT_M_CTLMASK, 0x4);

	/* Slave  8259, ICW3. 对应 '主8259' 的 IR2. */
	out_byte(INT_S_CTLMASK, 0x2);

	/* Master 8259, ICW4. */
	out_byte(INT_M_CTLMASK, 0x1);

	/* Slave  8259, ICW4. */
	out_byte(INT_S_CTLMASK, 0x1);

	/* Master 8259, OCW1.  */
	out_byte(INT_M_CTLMASK, 0xFD);

	/* Slave  8259, OCW1.  */
	out_byte(INT_S_CTLMASK, 0xFF);
}
```

3. 修改端口的汇编代码，可以从c的函数来调用
```asm
out_byte:
	mov	edx, [esp + 4]		; port
	mov	al, [esp + 4 + 4]	; value
	out	dx, al
	nop	; 一点延迟
	nop
	ret
```


4. 初始化IDT的代码逻辑在start.c中，与gdt非常的相似。同时把包括gdt[],gdt_ptr[]，idt，idt_ptr[]这样的声明都放到了头文件中。

```c
PUBLIC void cstart()
{
	disp_str("\n\n\n\n\n\n\n\n\n\n\n\n\n\n\n"
			 "-----\"cstart\" begins-----\n");

	/* 将 LOADER 中的 GDT 复制到新的 GDT 中 */
	memcpy(&gdt,							  /* New GDT */
		   (void *)(*((u32 *)(&gdt_ptr[2]))), /* Base  of Old GDT */
		   *((u16 *)(&gdt_ptr[0])) + 1		  /* Limit of Old GDT */
	);
	/* gdt_ptr[6] 共 6 个字节：0~15:Limit  16~47:Base。用作 sgdt/lgdt 的参数。*/
	u16 *p_gdt_limit = (u16 *)(&gdt_ptr[0]);
	u32 *p_gdt_base = (u32 *)(&gdt_ptr[2]);
	*p_gdt_limit = GDT_SIZE * sizeof(DESCRIPTOR) - 1;
	*p_gdt_base = (u32)&gdt;

	/* idt_ptr[6] 共 6 个字节：0~15:Limit  16~47:Base。用作 sidt/lidt 的参数。*/
	u16 *p_idt_limit = (u16 *)(&idt_ptr[0]);
	u32 *p_idt_base = (u32 *)(&idt_ptr[2]);
	*p_idt_limit = IDT_SIZE * sizeof(GATE) - 1;
	*p_idt_base = (u32)&idt;

	init_prot();

	disp_str("-----\"cstart\" ends-----\n");
}

```