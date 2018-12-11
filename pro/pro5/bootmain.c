
#include <inc/x86.h>
#include <inc/elf.h>

//扇区的大小为512
#define SECTSIZE 512
//将内核加载到内存的起始地址
#define kernel_start 0x10000

//该函数的作用是读取一个节的内容，也就是读取一个扇区的内容
void readsect(void *, uint32_t);
//函数的作用是读取一个程序段
void readseg(uint32_t, uint32_t, uint32_t);

void bootmain(void)
{
    struct proghdr *ph, *eph;
    struct elfhdr *elf = 0x10000;

    //将硬盘上从第一个扇区开始的4096个字节读到内存中地址为0x10000处
    readseg((uint32_t)elf, SECTSIZE * 8, 0);

    //检查这是否是一个合法的ELF文件
    if (elf->e_magic != ELF_MAGIC)
        goto bad;

    //找到第一程序头表项的起始地址
    ph = (struct proghdr *)((uint8_t *)elf + elf->e_phoff);
    //程序头表的结束位置
    eph = ph + elf->e_phnum;

    //将内核加载进入内存
    for (; ph < eph; ph++)
        //p_pa就是该程序段应该加载到内存中的位置
        //读取一个程序段的数据到内存中
        readseg(ph->p_pa, ph->p_memsz, ph->p_offset);

    //开始执行内核
    ((void (*)(void))(elf->e_entry))();

bad:
    outw(0x8A00, 0x8A00);
    outw(0x8A00, 0x8E00);
    while (1)
        /* do nothing */;
}

//这个函数的作用是从ELF文件偏移为offset处，读取count个字节到内存地址为pa处
void readseg(uint32_t pa, uint32_t count, uint32_t offset)
{
    //段的结束地址
    uint32_t end_pa;

    //计算段的结束地址
    end_pa = pa + count;

    //将pa设置为512字节对齐的地方
    pa &= ~(SECTSIZE - 1);

    //将相对于ELF文件头的偏移量转换为扇区，ELF格式的内核文件存放在第一个扇区中
    offset = (offset / SECTSIZE) + 1;

    //开始读取该程序段的内容
    while (pa < end_pa)
    {
        //每次读取程序的一个节，即一个扇区
        //也就是将offset扇区中的内容，读到物理地址为pa的地方
        readsect((uint8_t *)pa, offset);
        //将pa的值增加512字节
        pa += SECTSIZE;
        //读取下一个扇区
        offset++;
    }
}

void waitdisk(void)
{
    // wait for disk reaady
    while ((inb(0x1F7) & 0xC0) != 0x40)
        /* do nothing */;
}

void readsect(void *dst, uint32_t offset)
{
    // wait for disk to be ready
    waitdisk();

    outb(0x1F2, 1); // count = 1
    outb(0x1F3, offset);
    outb(0x1F4, offset >> 8);
    outb(0x1F5, offset >> 16);
    outb(0x1F6, (offset >> 24) | 0xE0);
    outb(0x1F7, 0x20); // cmd 0x20 - read sectors

    // wait for disk to be ready
    waitdisk();

    // read a sector
    insl(0x1F0, dst, SECTSIZE / 4);
}