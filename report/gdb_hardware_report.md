#GDB远程调试接口暨硬件调研设计报告

##串口部分
####调研
	解决跨时钟域同步即可，已做过实验。
####设计
	使用合理的跨时钟域同步实现一个鲁棒的串口，具体会使用边沿同步和脉冲同步。可以考虑在超过115200的波特率下运行。
####参考书目
	跨时钟域信号同步方法6种 http://wenku.baidu.com/link?url=Y2wfOx_UI3IpNdMdGRUL47NOHRLkB5MCnT3E3Bizvay4FBzNLPiRWV6KDvWhJa4kcFuFOBuh1_kGqflX51bEHmFFeSNKeMYvf55IOZeniiK

##Flash部分
####调研
	直接查看计原实验教程。
####设计
	Flash和Ram类似，就是和CPU协调跑一个状态机。不同之处在于，在真正操作之前需要通过写入操作码选择操作模式；写入之前必须先擦除。
####参考书目
	《计算机硬件系统实验教程》
	datasheet

##DM9000AEP以太网芯片
####调研
	在调研前，先重新温习了一些基础的网络原理知识。然后找到的芯片的datasheet，通过阅读芯片Feature、内部布图、接口说明、时序等理解了如何将DM9000AEP与CPU对接。

	实际上，DM9000AEP很好的实现了物理层以及数据链路层的算法。为了控制芯片的运行，只需要往芯片中存在几十个寄存器写数据就可以了。具体来说，第一个写入操作必须是需要操作的寄存器8位地址，第二次可以选择访问或写入这个寄存器的值。

	读写地址和读写数据的时序是一样的。
####设计
	给CPU新增模块使其能往以太网芯片中读写数据，处理好读写逻辑，并修改MMU映射关系即可。

	由于datasheet完整阅读工作量过大，并且手写驱动需要对于以太网数据链路层的理解和较好的实现网络层协议的基础，和高层对接的关键是找到一个可以使用的DM9000AEP芯片驱动。
####参考书目
	DM9000AEP datasheet

##GDB调试部分
####调研
	这个部分的调研是难度最大的。首先通过一些讲解嵌入式系统远程调试 和 ucore实验指导书了解了gdb远程调试的基本概念。然后通过一些文章了解到了GDB远程调试接口——RSP的内容。通过了解gdb调试信息的编译过程，比如stabs格式等也加深了对于gdb的理解。还通过kgdb了解到linux中的调试stub。之后，就把工作重心放在GDB的线程级、进程级调试的学习上，需要相应的指令达到目标。通过查阅RSP的manual，可以知道这个功能可以通过RSP的扩展、异步调试包实现。

	简而言之，只要在硬件中提供一些相对简单的功能，比如读写寄存器，读写内存，设置硬断点等，并提供一个，就可以实现GDB的汇编级调试。同时，gdb可以直接加载host机上kernel得到符号表信息，这样应该是能实现源码级调试的。并且通过在操统的调试stub上支持对于进程、线程的操作，有望实现用户态代码调试。

####设计
	目标定位为实现GDB的汇编级调试。为了达成这个目标，首先需要支持GDB控制的读写寄存器，读写内存，设置硬断点等操作。其次需要有能和RSP协议交互的模块，这个模块一般来说放在操统中实现比较简单。但我们的目标是尽量不对操统进行修改就达到调试的目的，可选的方案有硬件解析，以及通过写入rom中的机器码指令完成RSP协议交互。选择后者，但具体细节有待考虑。

	之前也提到源码级调试和用户态代码调试，暂时认为源码级调试可能只需要加载host机上的符号表信息，而用户态代码调试较为复杂，需要在操统上进行一定的修改。这是可选项目。

	由于现在的理解只是初步的，需要在实践中慢慢地修正方案。
####参考书目
	ucore实验指导书gitbook qemu+gdb调试部分
	gdb debug 信息 stabs 格式 http://blog.csdn.net/killmice/article/details/38226983
	gdb调试多进程 http://www.cnblogs.com/zhenjing/archive/2011/06/01/gdb_fork.html
	Linux内核驱动开发之KGDB原理介绍及kgdboe方式配置 http://www.linuxidc.com/Linux/2013-06/86406.htm
	Howto: GDB Remote Serial Protocol
Writing a RSP Server http://www.embecosm.com/appnotes/ean4/embecosm-howto-rsp-server-ean4-issue-2.html