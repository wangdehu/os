## 简介

- 代码任务:
    - 完成bootloader，在里面可以输出指定的字符串
- 代码要求：
    1. 在实模式下
    2. 使用intel格式的汇编
    3. 针对intel-i386
- 更高级要求：
    - 参考int 10h相关资料，完成更多种的显示方式

- 代码结构说明：
两个文件bootloader.s 与 boot2.s，为两个引导文件.执行`make run` 启动第一个引导，执行`make run source="boot2.s"`
运行结束后使用`make clean`清除
---

代码知识点分析：
1. bits16 是伪指令，由nasm来处理。意思为下面的代码为16位的。这样mov等指令的默认操作长度就被指定。
2. org 0x7c00也是伪指令，会使程序中要访问的数据的地加上偏移量.
3. BaseOfStack equ 0x7c00 不过是个常量
4.int 10h的意思为调用10h的中断，中断内容是提前写好的，这里写好的中断来自于BIOS,10h的中断是关于屏幕输出的。
5. mov指令为数据传送指令，可以理解为赋值
6. call与ret为转移指令，可以修改CS：IP的值，利用了栈。一般组合用于子程序的调用
7. jmp是无条件跳转指令 ，je是相等则跳转。依赖于程序状态字寄存器。cmp指令是做了sub运算但是不保存值
8.db 的意思是databyte，相对应的还有dw，dd。dw意思是word一个字。dd是doubleword双字。
在.data段里申请了一个字符串，每个字符是一个db大小，最后还有一个0用来方便判断末尾。
9.  times的意思是重复，\$ 表示当前指令的地址，\$\$表示程序的起始地址。`times 510-($-$$) db 0`的效果是把这一行到510字节的位置填充为0
10. 最后一句dw 0xAA55的作用即加上主引导记录的签名
11.lodsb是用于目的地址的内容读到源地址，即目标地址为:ES:DI,源地址为DS:SI。然后使用后si，di会自动++、--，根据df标志位来确定
12.程序开始首先是为ds，ss赋值为cs的值。mov指令不能直接将一个寄存器的值传送到另一个寄存器。sp制定了栈的大小。将text_string的位置传送了si。call切换状态到pritn_string
`mov ah,0eh`参考参考资料第二条。然后反复执行.repeat段，每次输出一个字符。直到输出到text_string末尾的0，然后跳转到done段，接着ret。会回到之前的位置。

---
参考资料：
1. [超级mini的bootloader](http://haiyangxu.github.io/posts/2014/2014-05-21-write_a_mini_OS.html)
2. [汇编-INT 10H功能](https://www.cnblogs.com/magic-cube/archive/2011/10/19/2217676.html)


---

寄存器介绍

CS:IP
DS:SI 
ES:DI
SS:SP


