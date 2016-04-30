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

    pmm_init();                 // init physical memory management

    vmm_init();                 // init virtual memory management
    sched_init();
    proc_init();                // init process table

    ide_init();
    fs_init();

    // debug-for-Translate
	kprintf("%s line %d: before intr_enable\n", __func__, __LINE__);
    intr_enable();              // enable irq interrupt
    //*(int*)(0x00124) = 0x432;
    //asm volatile("divu $1, $1, $1");
    // debug-for-Translate
	kprintf("%s line %d: before cpu_idle\n", __func__, __LINE__);
    cpu_idle();
}
