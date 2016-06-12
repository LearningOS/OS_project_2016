#include "naive_mips.h"
#include "uglylogging.h"
#include <fcntl.h>
#include <assert.h>
#include <string.h>
#include <unistd.h>
#include <termios.h>

static void disable_data_wp(int num);
static void set_data_wp(int num, struct code_hw_watchpoint* wp);
static void disable_code_bp(int num);
static void set_code_bp(int num, mips_addr_t addr);
static void run();
static void step();
static void read_all_regs(reg* regs);
static void read_cpu_reg(int num, reg* regs);
static void read_cp0_reg(int num, reg* regs);
static void write_cpu_reg(int num, int value, reg* regs);
static void read_pc_reg(reg* regs);
static void read_hilo_reg(reg* regs);
static void connect();
static void reset();
static int is_stop();
static void halt();
static void read_mem32(mips_addr_t addr, uint32_t size);
static void write_mem32(mips_addr_t addr, uint32_t size, char *data);


naive_mips_t NaiveMIPS = {
    .disable_data_wp = disable_data_wp,
    .set_data_wp = set_data_wp,
    .disable_code_bp = disable_code_bp,
    .set_code_bp = set_code_bp,
    .run = run,
    .step = step,
    .read_all_regs = read_all_regs,
    .read_cpu_reg = read_cpu_reg,
    .read_cp0_reg = read_cp0_reg,
    .write_cpu_reg = write_cpu_reg,
    .read_pc_reg = read_pc_reg,
    .read_hilo_reg = read_hilo_reg,
    .connect = connect,
    .reset = reset,
    .read_mem32 = read_mem32,
    .write_mem32 = write_mem32,
    .is_stop = is_stop,
    .halt = halt
};

static void debugger_cmd(uint8_t* cmd, uint32_t size)
{
    tcflush(NaiveMIPS.fd,TCIFLUSH);

    for (int i = 0; i < size; ++i)
    {
        int ret = write(NaiveMIPS.fd, cmd+i, 1);
        tcdrain(NaiveMIPS.fd);
    }

    int count = 0;
    for (;count < 4;)
    {
        int len = read(NaiveMIPS.fd, NaiveMIPS.result+count, 4-count);
        if(len < 0){
            continue;
        }
        count += len;
    }

    // printf("cmd=0x%x :", cmd[0]);
    // for(int i=1;i<5;++i)
    //     printf("%02x",cmd[i]);
    // printf(" ");
    // for(int i=5;i<9;++i)
    //     printf("%02x",cmd[i]);
    // printf("\n");
    // DLOG("Reading %d bytes \t", count);
    // assert(count==4);
    // printf("%08x\n", htonl(NaiveMIPS.result_i));
}

static void disable_data_wp(int num)
{
    DLOG("naive_mips.c: %s\n", __func__);
}
static void set_data_wp(int num, struct code_hw_watchpoint* wp)
{
    DLOG("naive_mips.c: %s\n", __func__);
}
static void disable_code_bp(int num)
{
    DLOG("naive_mips.c: %s\n", __func__);
}
static void set_code_bp(int num, mips_addr_t addr)
{
    uint8_t cmd[9] = {0x85};
    DLOG("naive_mips.c: %s\t", __func__);
    memcpy(cmd+1, &addr, 4);
    debugger_cmd(cmd, 9);
}
static void run()
{
    DLOG("naive_mips.c: %s\t", __func__);
    uint8_t cmd[9] = {0x2};
    debugger_cmd(cmd, 9);
}
static void step()
{
    DLOG("naive_mips.c: %s\t", __func__);
    uint8_t cmd[9] = {0xd};
    debugger_cmd(cmd, 9);
}
static void read_all_regs(reg* regs)
{
    DLOG("naive_mips.c: %s\t", __func__);
    for (int i = 0; i < 32; ++i)
    {
        read_cpu_reg(i, regs);
    }
    read_cp0_reg(8,regs);
    read_cp0_reg(12,regs);
    read_cp0_reg(13,regs);
    read_hilo_reg(regs);
    read_hilo_reg(regs);
    read_pc_reg(regs);
}
static void read_cp0_reg(int num, reg* regs)
{
    uint8_t cmd[9] = {0x87};
    DLOG("naive_mips.c: %s\t", __func__);
    memcpy(cmd+1, &num, 4);
    debugger_cmd(cmd, 9);
    if(num==12)regs->status=NaiveMIPS.result_i;
    else if(num==13)regs->cause=NaiveMIPS.result_i;
    else if(num==8)regs->badvaddr=NaiveMIPS.result_i;
    else{
        // empty   
    }
}
static void read_cpu_reg(int num, reg* regs)
{
    uint8_t cmd[9] = {0x86};
    DLOG("naive_mips.c: %s\t", __func__);
    memcpy(cmd+1, &num, 4);
    debugger_cmd(cmd, 9);
    regs->r[num] = NaiveMIPS.result_i;
}
static void write_cpu_reg(int num, int value, reg* regs)
{
    uint8_t cmd[9] = {0x46};
    DLOG("naive_mips.c: %s\t", __func__);
    memcpy(cmd+1, &num, 4);
    memcpy(cmd+5, &value, 4);
    debugger_cmd(cmd, 9);
    regs->r[num] = value;
}
static void read_pc_reg(reg* regs)
{
    DLOG("naive_mips.c: %s\t", __func__);
    uint8_t cmd[9] = {0xa};
    debugger_cmd(cmd, 9);
    regs->pc = NaiveMIPS.result_i;
}
static void read_hilo_reg(reg* regs)
{
    DLOG("naive_mips.c: %s\t", __func__);
    uint8_t cmd[9] = {0x8};
    debugger_cmd(cmd, 9);
    regs->hi = NaiveMIPS.result_i;
    DLOG("naive_mips.c: %s\t", __func__);
    cmd[0] = 0x9;
    debugger_cmd(cmd, 9);
    regs->lo = NaiveMIPS.result_i;
}
static void connect()
{
    DLOG("naive_mips.c: %s\n", __func__);
    struct termios options;
    // int fd = open("/dev/cu.usbserial-FTHK1N4K", O_RDWR | O_NOCTTY | O_NDELAY);
    int fd = open("/dev/tty.usbserial", O_RDWR | O_NOCTTY | O_NDELAY);
    if(fd < 0)
        return;
    usleep(200000);
    // fcntl(fd, F_SETFL, FNDELAY);
    tcgetattr(fd, &options);
    cfsetispeed(&options, B115200);
    cfsetospeed(&options, B115200);
    options.c_cflag |= (CLOCAL | CREAD);
    options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
    tcsetattr(fd, TCSANOW, &options);
    usleep(200000);
    NaiveMIPS.fd = fd;
    DLOG("serial fd: %d\n", fd);
    uint8_t cmd[9] = {0x0};
    debugger_cmd(cmd, 9);
    debugger_cmd(cmd, 9);
    tcflush(fd,TCIOFLUSH);
}
static void reset()
{
    DLOG("naive_mips.c: %s\t", __func__);
    uint8_t cmd[9] = {0xb};
    debugger_cmd(cmd, 9);
}
static int is_stop(){
    DLOG("naive_mips.c: %s\t", __func__);
    int count=0;
    int signal=0;
    for(;count<1;)
    {
        int len=read(NaiveMIPS.fd,&signal,1);
        if(len<0){
            continue;
        }
        count+=len;
    }
    signal=signal & 0xff;
    printf("0x%02x\n", signal);
    return signal==0xd5?1:0;
    // sleep(5);
    // return 1;
}
static void halt()
{
    DLOG("naive_mips.c: %s\t", __func__);
    uint8_t cmd[9] = {0x1};
    debugger_cmd(cmd, 9);
}

static void read_mem32(mips_addr_t addr, uint32_t size)
{
    DLOG("naive_mips.c: %s\t", __func__);
    // assert((addr & 3) == 0);
    // assert((size & 3) == 0);
    uint8_t cmd[9] = {0x8c};
    for (int i = 0; i < size; i+=4)
    {
        memcpy(cmd+1, &addr, 4);
        debugger_cmd(cmd, 9);
        memcpy(NaiveMIPS.q_buf+i, NaiveMIPS.result, 4);
        addr+=4;
    }
}

static void write_mem32(mips_addr_t addr, uint32_t size, char *data){
    DLOG("naive_mips.c: %s\t", __func__);
    // assert((addr & 3) == 0);
    // assert((size & 3) == 0);
    uint8_t cmd[9] = {0x4c};
    for (int i = 0; i < size; i+=4)
    {
        memcpy(cmd+1, &addr, 4);
        char a[9];
        strncpy(a,data+i*2,8);
        int value=ntohl(strtoul(a,NULL,16));
        memcpy(cmd+5,&value,4);
        debugger_cmd(cmd, 9);
        addr+=4;
    }

}
