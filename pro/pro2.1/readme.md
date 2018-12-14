
## 简介

- 代码任务:
    - 使用nasm(汇编）与gcc（c语言）编译，完成带有参数传递的函数调用
- 代码要求：
    1. nasm与c联合编译
    2. nasm调用c代码函数
    3. c调用nasm函数，传递参数
    4. 实模式下
- 项目结构说明：一个boot.asm的汇编文件，一个t1.c文件，一个辅助程序sign.
---

代码知识点分析：
1. 如果是nasm的汇编文件与gcc的c文件联合编译为一个程序，那么nasm要和gcc联合编译过程为：nasm编译成elf格式的可重定位文件，gcc编译相应的c代码位elf格式的可重定位文件，然后使用ld命令进行链接。
2. 其中有些参数可能要指定。
```
gcc：
    - -m32 生成32位机器的汇编代码
    - -O0/O1/O2 优化等级
    - -g加入符号表，方便gdb调试

nasm：
    - -m elf_i386，这个与平台有关系
    - -O0/O1/O2 优化等级
```
3. 要使用gcc就必须对elf格式有所了解。elf格式分为4部分：elf头，程序头表，节，节头表。除了elf头其他都不是固定的。这里给出它的格式。
```cpp
#define EI_NIDENT 16
　　typedef struct{
　　unsigned char e_ident[EI_NIDENT];
　　Elf32_Half e_type;  //加一下
　　Elf32_Half e_machine;
　　Elf32_Word e_version;
　　Elf32_Addr e_entry;
　　Elf32_Off e_phoff;
　　Elf32_Off e_shoff;
　　Elf32_Word e_flags;
　　Elf32_Half e_ehsize;
　　Elf32_Half e_phentsize;
　　Elf32_Half e_phnum;
　　Elf32_Half e_shentsize;
　　Elf32_Half e_shnum;
　　Elf32_Half e_shstrndx;
　　}Elf32_Ehdr;
```

4. 参数的传递通过栈来进行，后面参数先入栈，由调用者清理堆栈.可以使用`gcc -S t1.c -masm=intel -O0`来查看t1的汇编文件.制定了优化等级与汇编格式

5. 主引导记录的签名写入方式变了,需要通过一定的辅助手段。但同时还有一个问题是elf格式导出的bin太大了,要比512字节大上不少,于是还要使用objcopy命令.它的作用也是将目标文件的一部分或者全部内容拷贝到另外一个目标文件中.加入 -S选项,可以去掉符号表来让文件变小.写入主引导记录签名使用了一个sign的程序.暂时不花篇章来介绍.

6. 在c语言中，函数定义可以在别的地方，但是必须有申明。汇编中通过extern来作为未定义的声明。汇编需要通过global来标注被引用的函数。

7. 链接需要指定程序入口-e _start,并且将初始地址重定向-Ttext 0x7C00.其实可以看出来这里和过去直接用nasm编为bin的不同了.

8. -nostdlib作用是不连接系统标准启动文件和标准库文件，只把指定的文件传递给连接器。这个选项常用于编译内核、bootloader等程序，它们不需要启动文件、标准库文件。

9. 下面就是c调用汇编时候的传参.长度好像和16位还是32位有关系.
```asm
mov  DWORD ecx,[esp+2]
mov  DWORD esi,[esp+4]
```
10. 连续连个nop,是因为调用了print_string后,就到了print_string上面的一行.这令我很费解.
---


参考资料:
1. [elf格式-百度百科](https://baike.baidu.com/item/ELF/7120560?fr=aladdin)
2. gcc常用参数


需要研究的东西:
1. 进一步研究参数的传递与堆栈.还有返回值是怎么传递的
2. c调用print_string的偏移