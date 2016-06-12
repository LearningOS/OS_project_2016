#ifndef NAIVE_MIPS_H
#define NAIVE_MIPS_H

#include <stdint.h>

#define DATA_WATCH_NUM 4
#define CODE_BREAK_NUM_MAX  3
#define STOP_MAGIC 0xd5
typedef uint32_t mips_addr_t;


enum watchfun { WATCHDISABLED = 0, WATCHREAD = 5, WATCHWRITE = 6, WATCHACCESS = 7 };

struct code_hw_watchpoint {
    mips_addr_t addr;
    enum watchfun fun;
};
struct code_hw_breakpoint {
    mips_addr_t addr;
    int          type;
};


typedef struct {
uint32_t r[32];
uint32_t hi;
uint32_t lo;
uint32_t pc;
uint32_t status;
uint32_t cause;
uint32_t badvaddr;
} reg;

typedef struct _naive_mips_t {
        int fd;
        unsigned char q_buf[4000000];
        union{
            unsigned char result[4];
            uint32_t result_i;
        };

        void (*disable_data_wp)(int num);
        void (*set_data_wp)(int num, struct code_hw_watchpoint* wp);
        void (*disable_code_bp)(int num);
        void (*set_code_bp)(int num, mips_addr_t addr);
        void (*run)();
        void (*step)();
        void (*read_all_regs)(reg* regs);
        void (*read_cpu_reg)(int num, reg* regs);
        void (*read_cp0_reg)(int num, reg* regs);
        void (*write_cpu_reg)(int num, int value, reg* regs);
        void (*read_pc_reg)(reg* regs);
        void (*read_hilo_reg)(reg* regs);
        void (*connect)();
        void (*reset)();
        int (*is_stop)();
        void (*halt)();
        void (*read_mem32)(mips_addr_t addr, uint32_t size);
        void (*write_mem32)(mips_addr_t addr, uint32_t size, char *data);
} naive_mips_t;



#endif
