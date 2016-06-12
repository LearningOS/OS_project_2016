#include <defs.h>
#include <stdio.h>
#include <string.h>
#include <console.h>
#include <kdebug.h>
#include <picirq.h>
#include <trap.h>
#include <clock.h>
#include <intr.h>
#include <pmm.h>
#include <vmm.h>
#include <proc.h>
#include <thumips_tlb.h>
#include <sched.h>
#include <vga.h>
#include <flashswap.h>

void test_flash();

void setup_exception_vector()
{
  //for QEMU sim
  extern unsigned char __exception_vector, __exception_vector_end;
  memcpy((unsigned int*)0xBFC00000, &__exception_vector,
      &__exception_vector_end - &__exception_vector);
}

void __noreturn
kern_init(void) {
    //setup_exception_vector();
    // exit(1);
    // debug
    // cons_putc('c');
    tlb_invalidate_all();
    // cons_putc('b');

    // int a=3,b=2,c=1,i=0;
    // for(i=0;i<3;++i){
    //     c=i;
    //     a=c+b;
    // }

    pic_init();                 // init interrupt controller
    // cons_putc('c');
    cons_init();                // init the console
    // cons_putc('d');
    // vga_init();                 // vga_init
    clock_init();               // init clock interrupt

    check_initrd();

    const char *message = "(THU.CST) os is loading ...\n\n";
    kprintf(message);

    print_kerninfo();

#if 0
    kprintf("EX\n");
    __asm__ volatile("syscall");
    kprintf("EX RET\n");
#endif

    test_flash();

    int a=0,b=1,c=2,i=3;
    for(i=0;i<2;++i){
        c=i;
    }

    pmm_init();                 // init physical memory management

    vmm_init();                 // init virtual memory management
    sched_init();
    proc_init();                // init process table

    ide_init();
    // while (1);
    fs_init();

    // debug-for-Translate
	// kprintf("%s line %d: before intr_enable\n", __func__, __LINE__);
    swapper_init();
    intr_enable();              // enable irq interrupt
    //*(int*)(0x00124) = 0x432;
    //asm volatile("divu $1, $1, $1");
    // debug-for-Translate
	// kprintf("%s line %d: before cpu_idle\n", __func__, __LINE__);

    // debug
    // volatile uint16_t *addr = 0xBE000000;
    // *addr = 0x90;
    // uint16_t tmp = *addr;
    //
    // *addr = 0x20;
    // *addr = 0xD0;
    // do{
    //     *addr = 0x70;
    // }while(!(*addr&0x80));
    //
    // // uint16_t dst;
    // // memcpy(&dst, addr, sizeof(uint16_t));
    // kprintf("code: %x\n", tmp);
    // addr[0] = 0xFF;
    // *addr = 0xff;
    // for (int i = 0; i < 100; ++i) {
    //     int a = addr[i];
    //     kprintf("%d\n", a);
    // }
    // int iter;
    // for (iter = 0; iter < 10; ++ iter) {
    //     w_addr[iter] = 0xFF;
    //     // kprintf("%d: %x\n", iter, w_addr[iter]);
    // }
    // for (iter = 0; iter < 10; ++ iter) {
    //     kprintf("%d: %x\n", iter, r_addr[iter]);
    // }
    // kprintf("%x %x %x %x %x %x\n", *(r_addr ++), *(r_addr ++), *(r_addr ++), *(r_addr ++), *(r_addr ++), *(r_addr ++));
    // while (1);
    cpu_idle();
}
