1. BIOS Int 13H 调用是 BIOS 提供的磁盘基本输入输出中断调用, 它可以 
完成磁盘(包括硬盘和软盘)的复位, 读写, 校验, 定位, 诊断, 格式化等功能. 
它使用的就是 CHS 寻址方式
2. 磁盘根据chs,有三个参数磁头数(Heads), 柱面数 
(Cylinders), 扇区数(Sectors)
3. 我们总共使用int 13h的两种功能,一种是磁盘复位,一种是读取
复位:
```
    xor	ah, ah	
	xor	dl, dl	
	int	13h	
```
ah为0代表 磁盘复位,dh代表类型00是软盘
读取:
```
.GoOnReading:
	mov	ah, 2			    ; 读
	mov	al, byte [bp-2]		; 读 al 个扇区
	int	13h
	jc	.GoOnReading		; 如果读取错误 CF 会被置为 1, 这时就不停地读, 直到正确为止
```

参考如下:
AL＝扇区数|CH＝柱面|CL＝扇区|DH＝磁头|DL＝驱动器类型,00H~7FH：软盘；80H~0FFH：硬盘|ES:BX＝缓冲区的地址
4. 在boot中寻找loader.bin,在loader中找kernel.bin. 然后都加载后者.
这一切都是为了突破512字节的限制

5. 在找到想要找的文件后的起始扇区号，我们需要用这个扇区号来做两件事情：一件是把起始扇区装入内存，另一件则是通过它找到FAT中的项，从而找到Loader占用的其余所有扇区。

6. 我读fat12,软盘等还是有很大的知识漏洞,待填坑.




参考资料:
[bios int 13h](http://www.only2fire.com/archives/87.html)