/*
 * Copyright (C)  2011 Peter Zotov <whitequark@whitequark.org>
 * Use of this source code is governed by a BSD-style
 * license that can be found in the LICENSE file.
 */

#include <getopt.h>
#include <signal.h>
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <signal.h>
#include <unistd.h>
#include <sys/types.h>
#include <sys/time.h>
// #include <mach/mach.h>
// #include <mach/mach_time.h>
#ifdef __MINGW32__
#include "mingw.h"
#else
#include <sys/socket.h>
#include <netinet/in.h>
#include <arpa/inet.h>
#endif

#include "uglylogging.h"
#include "naive_mips.h"
#include "gdb-remote.h"
#include "gdb-server.h"

// typedef struct _st_state_t {
//     // things from command line, bleh
//     int stlink_version;
//     int logging_level;
//     int listen_port;
//     int persistent;
//     int reset;
// } st_state_t;

extern naive_mips_t NaiveMIPS;

static const char hex[] = "0123456789abcdef";
//
// static const char* const target_description_mips =
//     "<?xml version=\"1.0\"?>"
//     "<!DOCTYPE target SYSTEM \"gdb-target.dtd\">"
//     "<target version=\"1.0\">"
//     "   <architecture>mips</architecture>"
//     // "   <feature name=\"org.gnu.gdb.mips.cpu\">"
//     // "       <reg name=\"r0\" bitsize=\"32\" regnum=\"0\"/>"
//     // "       <reg name=\"r1\" bitsize=\"32\"/>"
//     // "       <reg name=\"r2\" bitsize=\"32\"/>"
//     // "       <reg name=\"r3\" bitsize=\"32\"/>"
//     // "       <reg name=\"r4\" bitsize=\"32\"/>"
//     // "       <reg name=\"r5\" bitsize=\"32\"/>"
//     // "       <reg name=\"r6\" bitsize=\"32\"/>"
//     // "       <reg name=\"r7\" bitsize=\"32\"/>"
//     // "       <reg name=\"r8\" bitsize=\"32\"/>"
//     // "       <reg name=\"r9\" bitsize=\"32\"/>"
//     // "       <reg name=\"r10\" bitsize=\"32\"/>"
//     // "       <reg name=\"r11\" bitsize=\"32\"/>"
//     // "       <reg name=\"r12\" bitsize=\"32\"/>"
//     // "       <reg name=\"r13\" bitsize=\"32\"/>"
//     // "       <reg name=\"r14\" bitsize=\"32\"/>"
//     // "       <reg name=\"r15\" bitsize=\"32\"/>"
//     // "       <reg name=\"r16\" bitsize=\"32\"/>"
//     // "       <reg name=\"r17\" bitsize=\"32\"/>"
//     // "       <reg name=\"r18\" bitsize=\"32\"/>"
//     // "       <reg name=\"r19\" bitsize=\"32\"/>"
//     // "       <reg name=\"r20\" bitsize=\"32\"/>"
//     // "       <reg name=\"r21\" bitsize=\"32\"/>"
//     // "       <reg name=\"r22\" bitsize=\"32\"/>"
//     // "       <reg name=\"r23\" bitsize=\"32\"/>"
//     // "       <reg name=\"r24\" bitsize=\"32\"/>"
//     // "       <reg name=\"r25\" bitsize=\"32\"/>"
//     // "       <reg name=\"r26\" bitsize=\"32\"/>"
//     // "       <reg name=\"r27\" bitsize=\"32\"/>"
//     // "       <reg name=\"r28\" bitsize=\"32\"/>"
//     // "       <reg name=\"r29\" bitsize=\"32\"/>"
//     // "       <reg name=\"r30\" bitsize=\"32\"/>"
//     // "       <reg name=\"r31\" bitsize=\"32\"/>"
//     // "       <reg name=\"lo\" bitsize=\"32\" regnum=\"33\"/>"
//     // "       <reg name=\"hi\" bitsize=\"32\" regnum=\"34\"/>"
//     // "       <reg name=\"pc\" bitsize=\"32\" regnum=\"37\" type=\"code_ptr\"/>"
//     // "   </feature>"
//     // "   <feature name=\"org.gnu.gdb.mips.cp0\">"
//     // "       <reg name=\"status\" bitsize=\"32\" regnum=\"32\"/>"
//     // "       <reg name=\"badvaddr\" bitsize=\"32\" regnum=\"35\"/>"
//     // "       <reg name=\"cause\" bitsize=\"32\" regnum=\"36\"/>"
//     // "   </feature>"
//     "</target>";
//
// static const char* const memory_map_template =
//     "<?xml version=\"1.0\"?>"
//     "<!DOCTYPE memory-map PUBLIC \"+//IDN gnu.org//DTD GDB Memory Map V1.0//EN\""
//     "     \"http://sourceware.org/gdb/gdb-memory-map.dtd\">"
//     "<memory-map>"
//     "  <memory type=\"ram\" start=\"0x00000000\" length=\"0x80000000\"/>"   // TLB mapped memory
//     "  <memory type=\"ram\" start=\"0x80000000\" length=\"0x400000\"/>"     // sram 4M
//     "  <memory type=\"rom\" start=\"0xb9000000\" length=\"0x800000\"/>"     // flash
//     "  <memory type=\"rom\" start=\"0xb0000000\" length=\"0x400\"/>"        // bootrom
//     "  <memory type=\"ram\" start=\"0xbfd00000\" length=\"0x02000000\"/>"   // peripheral regs
//     "</memory-map>";
//
// static const char* current_memory_map = NULL;
//
// int serve(naive_mips_t *sl, st_state_t *st);
//
// static void cleanup(int signal __attribute__((unused)))
// {
//
//
//     exit(1);
// }
//
// void main_server(){
//     ugly_init(UDEBUG);
//
//     st_state_t state;
//     memset(&state, 0, sizeof(state));
//     // set defaults...
//     state.stlink_version = 2;
//     state.logging_level = DEFAULT_LOGGING_LEVEL;
//     state.listen_port = DEFAULT_GDB_LISTEN_PORT;
//     state.reset = 1;    /* By default, reset board */
//
//
//     signal(SIGINT, &cleanup);
//     signal(SIGTERM, &cleanup);
//
//
//     current_memory_map = memory_map_template;
//
// #ifdef __MINGW32__
//     WSADATA wsadata;
//     if (WSAStartup(MAKEWORD(2, 2), &wsadata) != 0 ) {
//         goto winsock_error;
//     }
// #endif
//
//     NaiveMIPS.connect();
//
//     do {
//         if (serve(&NaiveMIPS, &state)) {
//             sleep (1); // don't go bezurk if serve returns with error
//         }
//
//         /* Continue */
//         // NaiveMIPS.run();
//     } while (state.persistent);
//
// #ifdef __MINGW32__
// winsock_error:
//     WSACleanup();
// #endif
// }
//
// void test_ram_server(){
//     int i;
//     // int start=4194304;
//     int start=0x80000000;
//     int count=10000;
//
//     static uint8_t data[5000000],reply[5000000];
//
//     struct timeval t0,t1,t2;
//
//     gettimeofday(&t0,NULL);
//     srand(t0.tv_usec);
//
//     for(i=0;i<2*count;++i)
//         data[i]='0'+rand()%10;
//     data[2*count]=0;
//
//     NaiveMIPS.connect();
//     gettimeofday(&t0,NULL);
//     NaiveMIPS.write_mem32(start,count,data);
//     gettimeofday(&t1,NULL);
//     fprintf(stderr,"write done\n");
//     NaiveMIPS.read_mem32(start,count);
//     gettimeofday(&t2,NULL);
//
//     for (unsigned int i = 0; i < count; i++) {
//         reply[i * 2 + 0] = hex[NaiveMIPS.q_buf[i] >> 4];
//         reply[i * 2 + 1] = hex[NaiveMIPS.q_buf[i] & 0xf];
//     }
//     reply[2*count]=0;
//
//     fprintf(stderr,"read done\n");
//
//     for(i=0;i<2*count;++i)
//     if(data[i]!=reply[i]){
//         printf("%d %c %c\n",i,data[i],reply[i]);
//         // break;
//     }
//
//     fprintf(stderr,"compare done\n");
//
//     fprintf(stderr,"write time=%.2lf\n",(double)(t1.tv_sec-t0.tv_sec)+(t1.tv_usec-t0.tv_usec)/1000000);
//     fprintf(stderr,"read time=%.2lf\n",(double)(t2.tv_sec-t1.tv_sec)+(t2.tv_usec-t1.tv_usec)/1000000);
//
//     // printf("%s\n",data);
//     // printf("%s\n",reply);
// }
//
// void test_flash_server(){
//     int i;
//     // int start=4194304;
//     int start=0xbe000000;
//     int count=600000;
//
//     static uint8_t data[5000000],reply[5000000];
//
//     struct timeval t0,t1,t2,t3;
//
//     gettimeofday(&t0,NULL);
//     srand(t0.tv_usec);
//
//     for(i=0;i<2*count;++i)
//         data[i]='0'+rand()%10;
//     data[2*count]='0';
//     data[2*count+1]='0';
//     data[2*count+2]='0';
//     data[2*count+3]='0';
//
//     NaiveMIPS.connect();
//
//     // fprintf(stderr,"X\n");
//     gettimeofday(&t3,NULL);
//
//     for(i=0;i<count/2;++i)
//     if((i*2)%131072==0){
//         NaiveMIPS.write_mem32(start+i*2,4,"20000000");
//         NaiveMIPS.write_mem32(start+i*2,4,"D0000000");
//         uint64_t t1,t2,tnsec,td;
//         t1=mach_absolute_time();
//         mach_timebase_info_data_t sTimebaseInfo;
//         for(;;){
//              t2=mach_absolute_time();
//              td=t2-t1;
//              mach_timebase_info(&sTimebaseInfo);
//              tnsec=td*sTimebaseInfo.numer/sTimebaseInfo.denom;
//              if(tnsec>100)break;
//          }
//         // usleep(2000000);
//         // for(;NaiveMIPS.read_mem32(start,4),((NaiveMIPS.q_buf[0] & (1<<7))==0););
//     }
//
//     gettimeofday(&t0,NULL);
//     for(i=0;i<count/2;++i){
//         NaiveMIPS.write_mem32(start+i*2,4,"40000000");
//         NaiveMIPS.write_mem32(start+i*2,4,data+i*4);
//         // usleep(1);
//         for(;NaiveMIPS.read_mem32(start,4),((NaiveMIPS.q_buf[0] & (1<<7))==0););
//     }
//     data[2*count]=0;
//     gettimeofday(&t1,NULL);
//
//
//     fprintf(stderr,"write done\n");
//
//     NaiveMIPS.write_mem32(start,4,"FF000000");
//     for(i=0;i<count/2;++i){
//         NaiveMIPS.read_mem32(start+i*2,4);
//         reply[i*4+0]=hex[NaiveMIPS.q_buf[0]>>4];
//         reply[i*4+1]=hex[NaiveMIPS.q_buf[0]&0xf];
//         reply[i*4+2]=hex[NaiveMIPS.q_buf[1]>>4];
//         reply[i*4+3]=hex[NaiveMIPS.q_buf[1]&0xf];
//     }
//
//     gettimeofday(&t2,NULL);
//     reply[2*count]=0;
//
//     fprintf(stderr,"read done\n");
//
//     for(i=0;i<2*count;++i)
//     if(data[i]!=reply[i]){
//         printf("%d %c %c\n",i,data[i],reply[i]);
//         // break;
//     }
//
//     fprintf(stderr,"compare done\n");
//
//     fprintf(stderr,"erase time=%.2lf\n",(double)(t0.tv_sec-t3.tv_sec)+(t0.tv_usec-t3.tv_usec)/1000000);
//     fprintf(stderr,"write time=%.2lf\n",(double)(t1.tv_sec-t0.tv_sec)+(t1.tv_usec-t0.tv_usec)/1000000);
//     fprintf(stderr,"read time=%.2lf\n",(double)(t2.tv_sec-t1.tv_sec)+(t2.tv_usec-t1.tv_usec)/1000000);
//
//     // printf("%s\n",data);
//     // printf("%s\n",reply);
// }

void write_os_to_ram(){
    int i;
    int start=0x80200000;
    int count;

    static uint8_t data[5000000],raw[2500000],reply[5000000];

    struct timeval t0,t1;

    FILE *fin=fopen("/home/donghy/OS_project_2016/ucore_OldDriver2/obj/ucore-kernel-initrd","r");
    count=fread(raw,1,5000000,fin);
    fprintf(stderr,"%d\n",count);
    fclose(fin);

    for(i=0;i<count;++i){
        data[i*2+0]=hex[raw[i]>>4];
        data[i*2+1]=hex[raw[i]&0xf];
    }
    data[2*count]=0;

    // for(i=0;i<2*count;++i)fprintf(stderr,"%c",data[i]);fprintf(stderr,"\n");

    NaiveMIPS.connect();
    fprintf(stderr, "%s\n", "hahahahhahahahhahahhahah");
    // gettimeofday(&t0,NULL);
    NaiveMIPS.write_mem32(start,count,data);
    fprintf(stderr, "%s\n", "hahahahhahahahhahahhahah");
    // gettimeofday(&t1,NULL);

    // NaiveMIPS.read_mem32(start,count);

    // for (unsigned int i = 0; i < count; i++) {
    //     reply[i * 2 + 0] = hex[NaiveMIPS.q_buf[i] >> 4];
    //     reply[i * 2 + 1] = hex[NaiveMIPS.q_buf[i] & 0xf];
    // }

    // for(i=0;i<2*count;++i)fprintf(stderr,"%c",reply[i]);fprintf(stderr,"\n");

    // fprintf(stderr,"total time=%.2lf\n",(double)(t1.tv_sec-t0.tv_sec)+(t1.tv_usec-t0.tv_usec)/1000000);
}

// void write_os_to_flash(){
//     int i;
//     int start=0xbe000000;
//     int count;
//
//     static uint8_t data[5000000],raw[2500000],reply[5000000];
//
//     struct timeval t0,t1,t3;
//
//     FILE *fin=fopen("/Users/apple/VirtualSpace/OldDriver_OS/ucore/ucore-thumips-master-gdb/obj/ucore-kernel-initrd","r");
//     count=fread(raw,1,5000000,fin);
//     fprintf(stderr,"%d\n",count);
//     fclose(fin);
//
//     count=131072;
//
//     for(i=0;i<count;++i){
//         data[i*2+0]=hex[raw[i]>>4];
//         data[i*2+1]=hex[raw[i]&0xf];
//     }
//     data[2*count]='0';
//     data[2*count+1]='0';
//     data[2*count+2]='0';
//     data[2*count+3]='0';
//
//     gettimeofday(&t0,NULL);
//     srand(t0.tv_usec);
//
//     NaiveMIPS.connect();
//
//     // fprintf(stderr,"X\n");
//     gettimeofday(&t3,NULL);
//
//     for(i=0;i<count/2;++i)
//     if((i*2)%131072==0){
//         NaiveMIPS.write_mem32(start+i*2,4,"20000000");
//         NaiveMIPS.write_mem32(start+i*2,4,"D0000000");
//         // usleep(2000000);
//         for(;NaiveMIPS.read_mem32(start,4),((NaiveMIPS.q_buf[0] & (1<<7))==0););
//     }
//
//     // fprintf(stderr,"Y\n");
//
//     gettimeofday(&t0,NULL);
//     for(i=0;i<count/2;++i){
//         NaiveMIPS.write_mem32(start+i*2,4,"40000000");
//         NaiveMIPS.write_mem32(start+i*2,4,data+i*4);
//         usleep(1);
//         // for(;NaiveMIPS.read_memm32(start,4),((NaiveMIPS.q_buf[0] & (1<<7))==0););
//     }
//     data[2*count]=0;
//     gettimeofday(&t1,NULL);
//
//     // for(i=0;i<2*count;++i)fprintf(stderr,"%c",data[i]);fprintf(stderr,"\n");
//
//     fprintf(stderr,"write done\n");
//
//     // NaiveMIPS.write_mem32(start,4,"FF000000");
//     // for(i=0;i<count/2;++i){
//     //     uint8_t a,b;
//     //     NaiveMIPS.read_mem32(start+i*2,4);
//     //     if(i%2==0)
//     //         a=NaiveMIPS.q_buf[0],b=NaiveMIPS.q_buf[1];
//     //     else
//     //         a=NaiveMIPS.q_buf[2],b=NaiveMIPS.q_buf[3];
//     //     reply[i*4+0]=hex[a>>4];
//     //     reply[i*4+1]=hex[a&0xf];
//     //     reply[i*4+2]=hex[b>>4];
//     //     reply[i*4+3]=hex[b&0xf];
//     // }
//     // reply[2*count]=0;
//
//     // for(i=0;i<2*count;++i)fprintf(stderr,"%c",reply[i]);fprintf(stderr,"\n");
//
//     fprintf(stderr,"erase time=%.2lf\n",(double)(t0.tv_sec-t3.tv_sec)+(t0.tv_usec-t3.tv_usec)/1000000);
//     fprintf(stderr,"write time=%.2lf\n",(double)(t1.tv_sec-t0.tv_sec)+(t1.tv_usec-t0.tv_usec)/1000000);
//
//     // printf("%s\n",data);
//     // printf("%s\n",reply);
// }
//
// void temp_server(){
//     int i;
//     int start=0xbe000000;
//     int count;
//
//     static uint8_t data[5000000],raw[2500000],reply[5000000];
//
//     struct timeval t0,t1,t3;
//
//     FILE *fin=fopen("/Users/apple/VirtualSpace/OldDriver_OS/ucore/ucore-thumips-master-gdb/obj/ucore-kernel-initrd","r");
//     count=fread(raw,1,5000000,fin);
//     fprintf(stderr,"%d\n",count);
//     fclose(fin);
//
//     count=0x20;
//     // for(i=0;i<2*count;++i)fprintf(stderr,"%c",data[i]);fprintf(stderr,"\n");
//
//     NaiveMIPS.connect();
//
//     // fprintf(stderr,"X\n");
//
//     NaiveMIPS.write_mem32(start,4,"FF000000");
//     for(i=0;i<count/2;++i){
//         uint8_t a,b;
//         NaiveMIPS.read_mem32(start+i*2,4);
//         if(i%2==0)
//             a=NaiveMIPS.q_buf[0],b=NaiveMIPS.q_buf[1];
//         else
//             a=NaiveMIPS.q_buf[2],b=NaiveMIPS.q_buf[3];
//         reply[i*4+0]=hex[a>>4];
//         reply[i*4+1]=hex[a&0xf];
//         reply[i*4+2]=hex[b>>4];
//         reply[i*4+3]=hex[b&0xf];
//     }
//     reply[2*count]=0;
//     // fprintf(stderr,"Y\n");
//
//     for(i=0;i<2*count;++i)fprintf(stderr,"%c",reply[i]);fprintf(stderr,"\n");
//
//     // fprintf(stderr,"erase time=%.2lf\n",(double)(t0.tv_sec-t3.tv_sec)+(t0.tv_usec-t3.tv_usec)/1000000);
//     // fprintf(stderr,"write time=%.2lf\n",(double)(t1.tv_sec-t0.tv_sec)+(t1.tv_usec-t0.tv_usec)/1000000);
//
//     // printf("%s\n",data);
//     // printf("%s\n",reply);
// }

int main(int argc, char** argv)
{
    // temp_server();
    // main_server();
    // test_ram_server();
    write_os_to_ram();
    // write_os_to_flash();
    // test_flash_server();
    return 0;
}

// struct code_hw_watchpoint data_watches[DATA_WATCH_NUM];
//
// static void init_data_watchpoints(naive_mips_t *sl)
// {
//     DLOG("init watchpoints\n");
//
//     // make sure all watchpoints are cleared
//     for (int i = 0; i < DATA_WATCH_NUM; i++) {
//         data_watches[i].fun = WATCHDISABLED;
//         sl->disable_data_wp(i);
//     }
// }
//
// static int add_data_watchpoint(naive_mips_t *sl, enum watchfun wf,
//                                mips_addr_t addr, unsigned int len)
// {
//     int i = 0;
//     uint32_t mask;
//
//     // computer mask
//     // find a free watchpoint
//     // configure
//
//     mask = -1;
//     i = len;
//     while (i) {
//         i >>= 1;
//         mask++;
//     }
//
//     if ((mask != (uint32_t) - 1) && (mask < 16)) {
//         for (i = 0; i < DATA_WATCH_NUM; i++) {
//             // is this an empty slot ?
//             if (data_watches[i].fun == WATCHDISABLED) {
//                 DLOG("insert watchpoint %d addr %x wf %u mask %u len %d\n", i, addr, wf, mask, len);
//
//                 data_watches[i].fun = wf;
//                 data_watches[i].addr = addr;
//                 data_watches[i].mask = mask;
//
//                 sl->set_data_wp(i, &data_watches[i]);
//                 return 0;
//             }
//         }
//     }
//
//     DLOG("failure: add watchpoints addr %x wf %u len %u\n", addr, wf, len);
//     return -1;
// }
//
// static int delete_data_watchpoint(naive_mips_t *sl, mips_addr_t addr)
// {
//     int i;
//
//     for (i = 0 ; i < DATA_WATCH_NUM; i++) {
//         if ((data_watches[i].addr == addr) && (data_watches[i].fun != WATCHDISABLED)) {
//             DLOG("delete watchpoint %d addr %x\n", i, addr);
//
//             data_watches[i].fun = WATCHDISABLED;
//             sl->disable_data_wp(i);
//
//             return 0;
//         }
//     }
//
//     DLOG("failure: delete watchpoint addr %x\n", addr);
//
//     return -1;
// }
//
// int code_break_num;
// int code_lit_num;
//
// struct code_hw_breakpoint code_breaks[CODE_BREAK_NUM_MAX];
//
// static void init_code_breakpoints(naive_mips_t *sl)
// {
//
//     code_break_num = CODE_BREAK_NUM_MAX;
//
//     ILOG("Found %i hw breakpoint registers\n", code_break_num);
//
//     for (int i = 0; i < code_break_num; i++) {
//         code_breaks[i].type = 0;
//         sl->disable_code_bp(i);
//     }
// }
//
// static int update_code_breakpoint(naive_mips_t *sl, mips_addr_t addr, int set)
// {
//
//     if (addr & 1) {
//         ELOG("update_code_breakpoint: unaligned address %08x\n", addr);
//         return -1;
//     }
//     int id = -1;
//     for (int i = 0; i < code_break_num; i++) {
//         if (addr == code_breaks[i].addr ||
//                 (set && code_breaks[i].type == 0)) {
//             id = i;
//             break;
//         }
//     }
//
//     if (id == -1) {
//         if (set) return -1; // Free slot not found
//         else    return 0;  // Breakpoint is already removed
//     }
//
//     struct code_hw_breakpoint* brk = &code_breaks[id];
//
//     brk->addr = addr;
//
//     if (set) brk->type = 1;
//     else    brk->type = 0;
//
//
//     if (brk->type == 0) {
//         DLOG("clearing hw break %d\n", id);
//
//         sl->disable_code_bp(id);
//     } else {
//         DLOG("setting hw break %d at %08x (%d)\n",
//              id, brk->addr, brk->type);
//         sl->set_code_bp(id, brk->addr);
//     }
//
//     return 0;
// }
//
//
// int serve(naive_mips_t *sl, st_state_t *st)
// {
//     int sock = socket(AF_INET, SOCK_STREAM, 0);
//     if (sock < 0) {
//         perror("socket");
//         return 1;
//     }
//
//     unsigned int val = 1;
//     setsockopt(sock, SOL_SOCKET, SO_REUSEADDR, (char *)&val, sizeof(val));
//
//     struct sockaddr_in serv_addr;
//     memset(&serv_addr, 0, sizeof(struct sockaddr_in));
//     serv_addr.sin_family = AF_INET;
//     serv_addr.sin_addr.s_addr = INADDR_ANY;
//     serv_addr.sin_port = htons(st->listen_port);
//
//     if (bind(sock, (struct sockaddr *) &serv_addr, sizeof(serv_addr)) < 0) {
//         perror("bind");
//         return 1;
//     }
//
//     if (listen(sock, 5) < 0) {
//         perror("listen");
//         return 1;
//     }
//
//     ILOG("Listening at *:%d...\n", st->listen_port);
//
//     int client = accept(sock, NULL, NULL);
//     //signal (SIGINT, SIG_DFL);
//     if (client < 0) {
//         perror("accept");
//         return 1;
//     }
//
//     close(sock);
//
//     sl->halt();
//     // sl->reset();
//     init_code_breakpoints(sl);
//     init_data_watchpoints(sl);
//
//     ILOG("GDB connected.\n");
//
//     /*
//      * To allow resetting the chip from GDB it is required to
//      * emulate attaching and detaching to target.
//      */
//     unsigned int attached = 1;
//
//     while (1) {
//         char* packet;
//
//         int status = gdb_recv_packet(client, &packet);
//         if (status < 0) {
//             ELOG("cannot recv: %d\n", status);
// #ifdef __MINGW32__
//             win32_close_socket(sock);
// #endif
//             return 1;
//         }
//
//         DLOG("recv: %s\n", packet);
//
//         char* reply = NULL;
//         reg regp;
//
//         switch (packet[0]) {
//         case 'q': {
//             if (packet[1] == 'P' || packet[1] == 'C' || packet[1] == 'L') {
//                 reply = strdup("");
//                 break;
//             }
//
//             char *separator = strstr(packet, ":"), *params = "";
//             if (separator == NULL) {
//                 separator = packet + strlen(packet);
//             } else {
//                 params = separator + 1;
//             }
//
//             unsigned queryNameLength = (separator - &packet[1]);
//             char* queryName = calloc(queryNameLength + 1, 1);
//             strncpy(queryName, &packet[1], queryNameLength);
//
//             DLOG("query: %s;%s\n", queryName, params);
//
//             if (!strcmp(queryName, "Supported")) {
//                 // reply = strdup("PacketSize=3fff;qXfer:memory-map:read+;qXfer:features:read+");
//                 reply = strdup("PacketSize=1000"); // JFLFY2255
//             } else if (!strcmp(queryName, "Xfer")) {
//                 char *type, *op, *__s_addr, *s_length;
//                 char *tok = params;
//                 char *annex __attribute__((unused));
//
//                 type     = strsep(&tok, ":");
//                 op       = strsep(&tok, ":");
//                 annex    = strsep(&tok, ":");
//                 __s_addr   = strsep(&tok, ",");
//                 s_length = tok;
//
//                 unsigned addr = strtoul(__s_addr, NULL, 16),
//                          length = strtoul(s_length, NULL, 16);
//
//                 DLOG("Xfer: type:%s;op:%s;annex:%s;addr:%d;length:%d\n",
//                      type, op, annex, addr, length);
//
//                 const char* data = NULL;
//
//                 if (!strcmp(type, "memory-map") && !strcmp(op, "read"))
//                     data = current_memory_map;
//
//                 if (!strcmp(type, "features") && !strcmp(op, "read"))
//                     data = target_description_mips;
//
//                 if (data) {
//                     unsigned data_length = strlen(data);
//                     if (addr + length > data_length)
//                         length = data_length - addr;
//
//                     if (length == 0) {
//                         reply = strdup("l");
//                     } else {
//                         reply = calloc(length + 2, 1);
//                         reply[0] = 'm';
//                         strncpy(&reply[1], data, length);
//                     }
//                 }
//             } else if (!strncmp(queryName, "Rcmd,", 4)) {
//                 // Rcmd uses the wrong separator
//                 char *separator = strstr(packet, ","), *params = "";
//                 if (separator == NULL) {
//                     separator = packet + strlen(packet);
//                 } else {
//                     params = separator + 1;
//                 }
//
//
//                 if (!strncmp(params, "726573756d65", 12)) { // resume
//                     DLOG("Rcmd: resume\n");
//                     sl->run();
//
//                     reply = strdup("OK");
//                 } else if (!strncmp(params, "68616c74", 8)) { //halt
//                     reply = strdup("OK");
//
//                     sl->halt();
//
//                     DLOG("Rcmd: halt\n");
//                 } else if (!strncmp(params, "6a7461675f7265736574", 20)) { //jtag_reset
//                     reply = strdup("OK");
//
//                     // stlink_jtag_reset(sl, 0);
//                     // stlink_jtag_reset(sl, 1);
//                     sl->halt();
//
//                     DLOG("Rcmd: jtag_reset\n");
//                 } else if (!strncmp(params, "7265736574", 10)) { //reset
//                     reply = strdup("OK");
//
//                     sl->halt();
//                     sl->reset();
//                     init_code_breakpoints(sl);
//                     init_data_watchpoints(sl);
//
//                     DLOG("Rcmd: reset\n");
//                 } else {
//                     DLOG("Rcmd: %s\n", params);
//                 }
//
//             }
//
//             if (reply == NULL)
//                 reply = strdup("");
//
//             free(queryName);
//
//             break;
//         }
//
//         case 'v': {
//             char *params = NULL;
//             char *cmdName = strtok_r(packet, ":;", &params);
//
//             cmdName++; // vCommand -> Command
//
//             if (!strcmp(cmdName, "FlashErase")) {
//                 char *__s_addr, *s_length;
//                 char *tok = params;
//
//                 __s_addr   = strsep(&tok, ",");
//                 s_length = tok;
//
//                 unsigned addr = strtoul(__s_addr, NULL, 16),
//                          length = strtoul(s_length, NULL, 16);
//
//                 DLOG("FlashErase: addr:%08x,len:%04x\n",
//                      addr, length);
//
//                 // if(flash_add_block(addr, length, sl) < 0) {
//                 reply = strdup("E00");
//                 // } else {
//                 //     reply = strdup("OK");
//                 // }
//             } else if (!strcmp(cmdName, "FlashWrite")) {
//                 char *__s_addr, *data;
//                 char *tok = params;
//
//                 __s_addr = strsep(&tok, ":");
//                 data   = tok;
//
//                 unsigned addr = strtoul(__s_addr, NULL, 16);
//                 unsigned data_length = status - (data - packet);
//
//                 // Length of decoded data cannot be more than
//                 // encoded, as escapes are removed.
//                 // Additional byte is reserved for alignment fix.
//                 uint8_t *decoded = calloc(data_length + 1, 1);
//                 unsigned dec_index = 0;
//                 for (unsigned int i = 0; i < data_length; i++) {
//                     if (data[i] == 0x7d) {
//                         i++;
//                         decoded[dec_index++] = data[i] ^ 0x20;
//                     } else {
//                         decoded[dec_index++] = data[i];
//                     }
//                 }
//
//                 // Fix alignment
//                 if (dec_index % 2 != 0)
//                     dec_index++;
//
//                 DLOG("binary packet %d -> %d\n", data_length, dec_index);
//
//                 // if(flash_populate(addr, decoded, dec_index) < 0) {
//                 reply = strdup("E00");
//                 // } else {
//                 //     reply = strdup("OK");
//                 // }
//             } else if (!strcmp(cmdName, "FlashDone")) {
//                 // if(flash_go(sl) < 0) {
//                 reply = strdup("E00");
//                 // } else {
//                 //     reply = strdup("OK");
//                 // }
//             } else if (!strcmp(cmdName, "Kill")) {
//                 attached = 0;
//
//                 reply = strdup("OK");
//             }
//
//             if (reply == NULL)
//                 reply = strdup("");
//
//             break;
//         }
//
//         case 'c':
//             sl->run();
//
//             while (1) {
// //                 int status = gdb_check_for_interrupt(client);
// //                 if (status < 0) {
// //                     ELOG("cannot check for int: %d\n", status);
// // #ifdef __MINGW32__
// //                     win32_close_socket(sock);
// // #endif
// //                     return 1;
// //                 }
//
//                 if (sl->is_stop()){
//                     break;
//                 }
//                 else {
//                     ELOG("Continue: cannot check for int\n");
//                     return 1;
//                 }
//
//                 // if (status == 1) {
//                     // sl->halt();
//                     // break;
//                 // }
//
//
//                 usleep(100000);
//             }
//
//             reply = strdup("S05"); // TRAP
//             break;
//
//         case 's':
//             sl->step();
//
//             reply = strdup("S05"); // TRAP
//             break;
//
//         case '?':
//             if (attached) {
//                 reply = strdup("S05"); // TRAP
//             } else {
//                 /* Stub shall reply OK if not attached. */
//                 reply = strdup("OK");
//             }
//             break;
//
//         case 'g':
//             sl->read_all_regs(&regp);
//
//             reply = calloc(8 * 38 + 1, 1);
//             for (int i = 0; i < 32; i++)
//                 sprintf(&reply[i * 8], "%08x", htonl(regp.r[i]));
//             sprintf(&reply[32 * 8], "%08x", htonl(regp.status));
//             sprintf(&reply[33 * 8], "%08x", htonl(regp.lo));
//             sprintf(&reply[34 * 8], "%08x", htonl(regp.hi));
//             sprintf(&reply[35 * 8], "%08x", htonl(regp.badvaddr));
//             sprintf(&reply[36 * 8], "%08x", htonl(regp.cause));
//             sprintf(&reply[37 * 8], "%08x", htonl(regp.pc));
//
//             break;
//
//         case 'p': {
//             unsigned id = strtoul(&packet[1], NULL, 16);
//             unsigned myreg = 0xDEADDEAD;
//
//             // DLOG("[p] id=%d\n", id);
//             if (id < 32) {
//                 sl->read_cpu_reg(id, &regp);
//                 myreg = (regp.r[id]);
//             } else if (id == 37) { //PC
//                 sl->read_pc_reg(&regp);
//                 myreg = (regp.pc);
//             } else if (id == 33) { //LO
//                 sl->read_hilo_reg(&regp);
//                 myreg = (regp.lo);
//             } else if (id == 34) { //HI
//                 sl->read_hilo_reg(&regp);
//                 myreg = (regp.hi);
//             } else if (id == 32 || id == 35 || id ==36){ //CP0
//                 //TODO
//             } else {
//                 // reply = strdup("E00");
//                 myreg = 0;
//             }
//
//             if (!reply) {
//                 reply = calloc(8 + 1, 1);
//                 sprintf(reply, "%08x", htonl(myreg));
//             }
//             break;
//         }
//
//         case 'P': {
//             char* s_reg = &packet[1];
//             char* s_value = strstr(&packet[1], "=") + 1;
//
//             unsigned id   = strtoul(s_reg,   NULL, 16);
//             unsigned value = ntohl(strtoul(s_value, NULL, 16));
//
//             // DLOG("[P] reg=%d\n", reg);
//
//             if (0<id && id < 32) {
//                 sl->write_cpu_reg(id, value, &regp);
//             } else {
//                 reply = strdup("E00");
//             }
//
//             if (!reply) {
//                 reply = strdup("OK");
//             }
//
//             break;
//         }
//
//         case 'G':
//             for (int i = 0; i < 32; i++) {
//                 char str[9] = {0};
//                 strncpy(str, &packet[1 + i * 8], 8);
//                 uint32_t reg = strtoul(str, NULL, 16);
//                 // stlink_write_reg(sl, ntohl(reg), i);
//             }
//
//             reply = strdup("OK");
//             break;
//
//         case 'm': {
//             char* s_start = &packet[1];
//             char* s_count = strstr(&packet[1], ",") + 1;
//
//             mips_addr_t start = strtoul(s_start, NULL, 16);
//             unsigned     count = strtoul(s_count, NULL, 16);
//
//             if (start>=0xbe000000 && start<=0xbe000000+0x00800000){
//                 sl->read_mem32(start, count);
//
//                 reply = calloc(count * 2 + 1, 1);
//                 for (unsigned int i = 0; i < count; i++) {
//                     reply[i * 2 + 0] = hex[sl->q_buf[i] >> 4];
//                     reply[i * 2 + 1] = hex[sl->q_buf[i] & 0xf];
//                 }
//             }
//             else {
//                 unsigned adj_start = start % 4;
//                 unsigned count_rnd = (count + adj_start + 4 - 1) / 4 * 4;
//
//                 // DLOG("[m] start=%x count=%d\n", start - adj_start, count_rnd);
//                 sl->read_mem32(start - adj_start, count_rnd);
//
//                 reply = calloc(count * 2 + 1, 1);
//                 for (unsigned int i = 0; i < count; i++) {
//                     reply[i * 2 + 0] = hex[sl->q_buf[i + adj_start] >> 4];
//                     reply[i * 2 + 1] = hex[sl->q_buf[i + adj_start] & 0xf];
//                 }
//             }
//
//             break;
//         }
//
//         case 'M': {
//             char* s_start = &packet[1];
//             char* s_count = strstr(&packet[1], ",") + 1;
//             char* hexdata = strstr(packet, ":") + 1;
//
//             mips_addr_t start = strtoul(s_start, NULL, 16);
//             unsigned     count = strtoul(s_count, NULL, 16);
//
//             // DLOG("[M] start=%x count=%d hexdata=%s\n", start, count, hexdata);
//
//             if(((start%4 || count%4) && start<0xbe000000) || start%2 || count%2){
//                 reply = strdup("E00");
//                 break;
//             }
//
//             if(start>=0xbe000000 && start<=0xbe000000+0x00800000){
//                 // sl->write_mem32(start,4,"40000000");
//                 // sl->write_mem32(start,count,hexdata);
//                 // usleep(1000);
//                 // sl->write_mem32(0xbe000000,4,"ff000000");
//                 // reply = strdup("E00");
//             }
//             else{
//                 sl->write_mem32(start,count,hexdata);
//             }
//             reply = strdup("OK");
//             break;
//         }
//
//         case 'Z': {
//             char *endptr;
//             mips_addr_t addr = strtoul(&packet[3], &endptr, 16);
//             mips_addr_t len  = strtoul(&endptr[1], NULL, 16);
//
//             switch (packet[1]) {
//             case '0':
//             case '1':
//                 if (update_code_breakpoint(sl, addr, 1) < 0) {
//                     reply = strdup("E00");
//                 } else {
//                     reply = strdup("OK");
//                 }
//                 break;
//
//             case '2':   // insert write watchpoint
//             case '3':   // insert read  watchpoint
//             case '4': { // insert access watchpoint
//                 enum watchfun wf;
//                 if (packet[1] == '2') {
//                     wf = WATCHWRITE;
//                 } else if (packet[1] == '3') {
//                     wf = WATCHREAD;
//                 } else {
//                     wf = WATCHACCESS;
//                 }
//
//                 if (add_data_watchpoint(sl, wf, addr, len) < 0) {
//                     reply = strdup("E00");
//                 } else {
//                     reply = strdup("OK");
//                     break;
//                 }
//             }
//
//             default:
//                 reply = strdup("");
//             }
//             break;
//         }
//         case 'z': {
//             char *endptr;
//             mips_addr_t addr = strtoul(&packet[3], &endptr, 16);
//             //mips_addr_t len  = strtoul(&endptr[1], NULL, 16);
//
//             switch (packet[1]) {
//             case '0': // remove breakpoint
//             case '1': // remove breakpoint
//                 update_code_breakpoint(sl, addr, 0);
//                 reply = strdup("OK");
//                 break;
//
//             case '2' : // remove write watchpoint
//             case '3' : // remove read watchpoint
//             case '4' : // remove access watchpoint
//                 if (delete_data_watchpoint(sl, addr) < 0) {
//                     reply = strdup("E00");
//                 } else {
//                     reply = strdup("OK");
//                     break;
//                 }
//
//             default:
//                 reply = strdup("");
//             }
//             break;
//         }
//
//         case '!': {
//             /*
//              * Enter extended mode which allows restarting.
//              * We do support that always.
//              */
//
//             /*
//              * Also, set to persistent mode
//              * to allow GDB disconnect.
//              */
//             st->persistent = 1;
//
//             reply = strdup("OK");
//
//             break;
//         }
//
//         case 'R': {
//             /* Reset the core. */
//
//             sl->reset();
//             init_code_breakpoints(sl);
//             init_data_watchpoints(sl);
//
//             attached = 1;
//
//             reply = strdup("OK");
//
//             break;
//         }
//
//         default:
//             reply = strdup("");
//         }
//
//         if (reply) {
//             DLOG("send: %s\n", reply);
//
//             int result = gdb_send_packet(client, reply);
//             if (result != 0) {
//                 ELOG("cannot send: %d\n", result);
//                 free(reply);
//                 free(packet);
// #ifdef __MINGW32__
//                 win32_close_socket(sock);
// #endif
//                 return 1;
//             }
//
//             free(reply);
//         }
//
//         free(packet);
//     }
//
// #ifdef __MINGW32__
//     win32_close_socket(sock);
// #endif
//
//     return 0;
// }
