# 开发操作系统漫游


## 目录
- [环境准备](#环境准备)
    1. [linux系统](#linux操作系统)
    2. [gcc/g++](#gcc/g++)
    3. [qemu](#qemu)
    4. [nasm](#nasm)
- [前置知识](#前置知识)
    1. [浅谈](#浅谈)
    2. [linux下常用的命令](#linux下常用的命令)
    3. [gcc编译过程中发生了什么？](#gcc编译过程中发生了什么?)
    4. [关于汇编](#关于汇编)
    5. [make与Makefile](#make与Makefile)
    6. [gdb调试技能](#gdb调试技能)
- [从机器启动到操作系统的启动](#从机器启动到操作系统的启动)
    1. 浅谈硬件
    2. bios与分区
    3. bootloader的加载
    4. 内核的加载


## 环境准备

### linux操作系统

linux操作系统对于CS是绕不过去的一环，非常推荐大家使用，甚至是作为主力系统使用！
如果不会安装linux系统，那正好是一个动手学习的机会。在使用linux的过程中，或许会让你留下痛苦的回忆，但它们都会化为财富。
以下的示例全部使用ubuntu16.04为例。

### gcc/g++

gcc(**GNU Compiler Collection**) 是gnu开发的编程语言编译器，现在可以处理多种编程语言。我们需要它来完成对C语言以及部分汇编的编译工作。
ubuntu16.04是自带gcc的，版本为5.4.0
使用以下命令查看版本：
```shell
gcc --version
```

### qemu
qemu是一个开源仿真器，用于模拟一台计算机，可以用来运行我们编写的操作系统
使用以下命令进行安装：
```shell
sudo apt-get install qemu
```

### nasm
nasm为一种汇编器，用来编译汇编代码
我们可能不一定会用到它，详情见前置知识中关于汇编的部分

## 前置知识

### 浅谈
操作系统可能是CS里最具有挑战性的一门课程了，在这门课程真的写一个操作系统还是非常困难的，但总是写一些东西总还是可以的。写这个东西一是为了在总结中进步，二是以后说不定也可以给别人做参考。
。。。
### linux下常用的命令
我们对操作系统的控制的方式有两种，一种是常用的GUI式的（图形化界面），另外一种是CLI（命令行）。一般我们将输入命令的地方称作shell，Terminal，终端，命令提示符。
无论是在windows下，或者linux，乃至OS X都是有命令行的，不过在具体的命令下有些差别的。这里只介绍最常用的/必须要用到的命令。


```shell
ls      展示当前目录下的文件与目录
ls -a   展示所有文件（包括隐藏文件/文件夹)
ls -l   展示更详细的信息
```
```shell
cp  复制文件命令
mv  移动文件命令
rm  删除文件命令
cat 输出文件内容到终端
```
```shell
cd    切换目录命令
locate
find  查找文件命令
```
```shell
dd   用指定大小的块拷贝一个文件，并在拷贝的同时进行指定的转换。
```

具体的参数与使用方式，可以自行探索/在网上搜索

其他最常见linux与windows的不同处： 

linux的权限问题
linux下的路径与windows是有区别的
linux安装软件的方式（在ubuntu下试用apt-get）


### gcc的编译过程中发生了什么

gcc的编译

使用以下代码作为示例.命名为hello.c
```c
//"hello.c"
#include<stdio.h>
int main(){
    printf("hello world"); //注释
    return 0;
}
```

打开终端，将位置切换至hello.c所在的文件夹。
使用以下命令
```shell
gcc hello.c
```
在这个文件夹下会生成a.out文件
终端内执行
```shell
./a.out
```
即可看到hello world的输出。

a.out为没有指定输出结果文件名时候的默认名，使用-o 可以指定文件名。以下命令可以看到生成了hello.out文件
```shell
gcc hello.c -o hello.out
```
---


gcc的编译过程整体上分为 预处理，编译，汇编，链接。

图片！

我们在调用gcc的时候，实际上是一步步完成，然后再删除了中间结果。

预处理的过程是除去注释以及展开宏。
头文件的复制就是在展开宏中完成的。

以下两个命令都会将预处理的结果输出到终端上。
```shell
gcc  -E hello.c 
cpp hello.c
```
使用-o 参数指定输出文件名
```shell
gcc -E hello.c -o hello.i
```

---

编译的过程是将预处理好的文件编译为汇编文件。
使用以下命令都会生成一个hello.s的文件

```
gcc -S hello.i
as hello.i
```

---

汇编的过程是将汇编转化为二进制文件，不过此时的二进制文件还没有办法运行。参考后面多个文件连编的内容。
执行以下命令，会生成一个hello.o文件。又叫做可重定位文件。

```shell
gcc -c hello.s
```
---

链接之后就会生成可执行文件

```shell
gcc hello.o
```


----

使用-save-temps 参数可以保留中间的各种结果
```shell 
gcc -save-temps helloworld.c
```





part 2
```c
#include<stdio.h>
int main(){
    int a=3,b=4;
    printf("%d",add(a,b));
    return 0;
}
```
```c
int add(int a,int b){
    return a+b;
}
```

```shell
gcc main.c t1.c
```
```shell
gcc -c main.c
gcc -c t1.c
gcc main.o t1.o -o add.out
```


as,ld,cpp


链接
elf头与链接的过程
静态链接与动态链接


### 关于汇编
汇编已经非常底层，毕竟对于我们来说，又不会自己造硬件。所以汇编已经是我们写的最底层的代码了。
关于汇编，随便说几个名字，或许你就会感觉很乱。
arm64,i386,arm,intel ,amd,AT&T,x86,x86_64,IA-64,MIPS,RISC;
当然上述的东西有些对代码的完成并不影响，但对这些基本概念还是要有认识的。

CPU指令集，
。。。。

intel与AT&T

### make与Makefile
想一想gcc编译c语言代码的过程，针对小型项目，手动逐步编译倒也没有问题。但整个工程的架构逐渐变得复杂，数不清的源文件，又放在不同的目录中。就不能每次手动编译了。所以需要一个自动化编译的东西，这个东西就是make。

make的核心分为两个部分，即依赖关系与命令。
何为依赖关系，

makefile还支持变量的使用来简化书写。。。


makefile支持一些隐含规则。。。

伪目标的使用。。。


关于make，更多的规则可以自己在网上学习。
提供一份 跟我一起写makefile


### gdb调试技能


gdb是一个调试工具，比起很多ide提供的功能有些简陋。但是它小巧玲珑让人爱不释手。


。。。。





### 从机器启动到操作系统的启动

整个的启动过程大致可以分为以下几个阶段：
1. 上电后，机器进行初始化
2. 启动bios，选择启动设备
3. 在启动设备的相关位置加载 bootloader
4. bootloader加载内核

我们所需要关注的是后两个阶段。


#### 浅谈硬件

RAM，ROM。。。


#### bios与分区


扇区，分区，GPT，uefi等。。。。


#### bootloader的加载

0x7c00h,实模式与保护模式，GDT表


Boot扇区在第0扇区，大小为512个Bytes。BIOS在识别Boot扇区时回去识别第511和512个Byte是不是0x55和0xaa，如果是这两个值就认定Boot扇区是有效的。所以这里需要讲最后两个Bytes填充为制定的Signature。
times伪指令用来填充0，至于填充多少个0，由当前地址来决定。$ - $$表示当前地址与当前首地址的差值。\$位当前地址，\$\$为块的首地址。用510 - (\$ - \$\$)就能得到需要填充的bytes数，填充完成后下一个byte就是第511个byte了。然后用dw 0xaa55来写入签名。由于用的是Little-endian，所以高地位必须对应，0x55 0xaa就是0xaa55了。



#### 内核的加载