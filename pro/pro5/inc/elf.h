#ifndef __LIBS_ELF_H__
#define __LIBS_ELF_H__

#include "defs.h"

#define ELF_MAGIC 0x464C457FU // "\x7FELF" in little endian

/* file header */
struct elfhdr
{
    uint32_t e_magic;  //4 字节，始终为 0x7felf 表名该文件是个 ELF 格式文件
    uint8_t e_elf[12]; // 12 字节，每字节对应意义如下：
                       //     0 : 1 = 32 位程序；2 = 64 位程序
                       //     1 : 数据编码方式，0 = 无效；1 = 小端模式；2 = 大端模式
                       //     2 : 只是版本，固定为 0x1
                       //     3 : 目标操作系统架构
                       //     4 : 目标操作系统版本
                       //     5 ~ 11 : 固定为 0

    uint16_t e_type; // 2 字节，表明该文件类型，意义如下：
                     //     0x0 : 未知目标文件格式
                     //     0x1 : 可重定位文件
                     //     0x2 : 可执行文件
                     //     0x3 : 共享目标文件
                     //     0x4 : 转储文件

    uint16_t e_machine;   // 2字节，计算机体系架构 3=x86, 4=68K.
    uint32_t e_version;   // 4 字节，表示文件的版本号 always 1
    uint32_t e_entry;     // 4 字节，该文件的入口地址，没有入口为0
    uint32_t e_phoff;     // 4 字节，表示该文件的“程序头部表”相对于文件的位置
    uint32_t e_shoff;     // 4 字节，表示该文件的“节区头部表”相对于文件的位置
    uint32_t e_flags;     // 4 字节，特定处理器标志 usually 0
    uint16_t e_ehsize;    // 2 字节，ELF文件头部的大小
    uint16_t e_phentsize; // 2 字节，表示程序头部表中一个入口的大小
    uint16_t e_phnum;     //  2 字节，表示程序头部表的入口个数
    uint16_t e_shentsize; // 2 字节，节区头部表入口大
    uint16_t e_shnum;     // 2 字节，节区头部表入口个数
    uint16_t e_shstrndx;  // 2 字节，表示字符表相关入口的节区头部表索引
};

/* program section header */
struct proghdr
{
    uint32_t p_type;   // loadable code or data, dynamic linking info,etc.
    uint32_t p_offset; // 在文件中的偏移
    uint32_t p_va;     // 虚拟地址 to map segment
    uint32_t p_pa;     // 物理地址, not used
    uint32_t p_filesz; // 4 字节， 段在文件中的长度
    uint32_t p_memsz;  // 4 字节， 段在内存中的长度
    uint32_t p_flags;  // 4 字节， 段标志
                       //         1 : 可执行
                       //         2 : 可写入
                       //         4 : 可读取
    uint32_t p_align;  // 4 字节， 段在文件及内存中如何对齐
};

// Values for Proghdr type
#define ELF_PROG_LOAD 1

// Flag bits for Proghdr flags
#define ELF_PROG_FLAG_EXEC 1
#define ELF_PROG_FLAG_WRITE 2
#define ELF_PROG_FLAG_READ 4

#endif /* !__LIBS_ELF_H__ */
