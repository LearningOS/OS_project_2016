/******************************************************************************
 *  Copyright (c) 2014 Jinming Hu
 *  Distributed under the MIT license
 *  (See accompanying file LICENSE or copy at http://opensource.org/licenses/MIT)
 *
 *  Project: Cache Terminal
 *  Filename: chedan.cc
 *  Version: 1.0
 *  Author: Jinming Hu
 *  E-mail: hjm211324@gmail.com
 *  Date: Dec. 16, 2014
 *  Time: 19:03:47
 *  Description: compile with -lpthread to enable multithread
 *****************************************************************************/
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <signal.h>
#include <cstring>
#include <cstdint>
#include <iostream>
#include <thread>
#include <cstdint>
#include <cstdio>


// block until receive a byte from serial port
uint8_t receive(const int com) {
    char buff[1];
    while (read(com, buff, 1) <= 0);
    return buff[0];
}

// send a byte to serial port
volatile int jjjj = 0;
inline void send(const uint8_t x, const int com) {
    char buff[1];
    buff[0] = x;
    write(com, buff, 1);
}

static struct termios oldt;

void restore_terminal_settings() {
    tcsetattr(0, TCSANOW, &oldt);  /* Apply saved settings */
}

void restore(int) {
    // printf("restore\n");
    restore_terminal_settings();
    exit(0);
}


void disable_waiting_for_enter(void) {
    struct termios newt;

    /* Make terminal read 1 char at a time */
    tcgetattr(0, &oldt);  /* Save terminal settings */
    newt = oldt;  /* Init new settings */
    newt.c_lflag &= ~(ICANON | ECHO);  /* Change settings */
    tcsetattr(0, TCSANOW, &newt);  /* Apply settings */
    atexit(restore_terminal_settings); /* Make sure settings will be restored when program ends  */
}

int main(int argc,char** argv) {
    // if (argc != 2) {
    //     std::cout << "Usage: " << argv[0] << " <serial port>. " << std::endl;
    //     return 1;
    // }
    if (getuid()) {
        std::cout << "Need root privilage. " << std::endl;
        return 1;
    }

    int com;
    if((com = open("/dev/ttyUSB1" , O_RDWR | O_NONBLOCK)) == -1){
        std::cout << "Error while opening serial port. " << std::endl;
        return 2;
    }
    struct termios options;
    usleep(200000);
    // fcntl(fd, F_SETFL, FNDELAY);
    tcgetattr(com, &options);
    cfsetispeed(&options, B115200);
    cfsetospeed(&options, B115200);
    options.c_cflag |= (CLOCAL | CREAD);
    options.c_lflag &= ~(ICANON | ECHO | ECHOE | ISIG);
    tcsetattr(com, TCSANOW, &options);
    usleep(200000);
    tcflush(com,TCIOFLUSH);

    std::cout << "Prepared to send and receive... " << std::endl;


    auto send_command = [&com]() {
        disable_waiting_for_enter();
        signal(SIGINT, restore);

        // keep reading and sending
        while (1) {
            char buff = getchar();
            send(buff, com);
        }
    };

    const unsigned char STX (0x02);
    const unsigned char ETX (0x03);
    const unsigned char EOT (0x04);
    const unsigned char ENQ (0x05);

    auto send_file = [&com]() {
        system("cp obj/tmp.decaf decaf-dev/result/tmp.decaf");
        system("/usr/lib/jvm/java8/bin/java -jar decaf-dev/result/decaf.jar -l 4 decaf-dev/result/tmp.decaf > obj/tmp.S");
        system("/home/donghy/mips_gcc/bin/mips-sde-elf-gcc -mips32 -c -D__ASSEMBLY__ -g -EL -G0  obj/tmp.S  -o obj/tmp.o");
        system("/home/donghy/mips_gcc/bin/mips-sde-elf-ld  -T obj/user.ld  obj/tmp.o obj/libuser.a -o obj/tmp.out");
        FILE *fp = fopen("obj/tmp.out", "r");
        fseek(fp, 0, SEEK_END);
        unsigned int file_len = ftell(fp);
        printf("file_len is %d\n", file_len);
        fseek(fp, 0, SEEK_SET);
        send(ENQ, com);
        send(STX, com);
        unsigned file_len_tmp = file_len;
        unsigned char sub_len;
        // send((unsigned char)(file_len_tmp & 0xFF), com);
        sub_len = file_len_tmp & 0xFF;
        write(com, (void *)(&sub_len), 1);
        tcdrain(com);
        // printf("%d\n", file_len & 0xFF);
        file_len_tmp >>= 8;
        sub_len = file_len_tmp & 0xFF;
        write(com, (void *)(&sub_len), 1);
        tcdrain(com);
        file_len_tmp >>= 8;
        sub_len = file_len_tmp & 0xFF;
        write(com, (void *)(&sub_len), 1);
        tcdrain(com);
        file_len_tmp >>= 8;
        sub_len = file_len_tmp & 0xFF;
        write(com, (void *)(&sub_len), 1);
        tcdrain(com);
        // add receive
        // receive(com);
        char ch;
        int ch_sum = 0;
        int ch_count = 0;
        tcflush(com ,TCIFLUSH);
        for (int i = 0; i < file_len; ++i) {
            ch = fgetc(fp);
            int ret = write(com, (void *)(&ch), 1);
            tcdrain(com);
            ch_sum ++;
            ch_count ++;
            if (ch_count == 4096) {
                ch_count = 0;
                receive(com);
            }
        }
        fclose(fp);
        printf("finish compiling send char %d\n", ch_sum);
        fflush(stdout);
    };


    auto recv_data = [&com, &send_file]() {
        FILE *fp = NULL;
        int state = 0;
        int state2 = 0;
        while (1) {
            char d = receive(com) & 0xff;
            if (state == 0 && d == ENQ) {
                state = 1;
                state2 = 0;
                continue ;
            }
            if (state == 1 && d == STX) {
                fp = fopen("obj/tmp.decaf", "w");
                state = 2;
                state2 = 0;
                continue ;
            }
            if (state == 2) {
                if (state2 == 0 && d == ETX) {
                    // state = 2;
                    state2 = 1;
                    continue ;
                }
                if (state2 == 1 && d == EOT) {
                    state = 0;
                    state2 = 0;
                    fclose(fp);

                    // exit(1);
                    std::thread file_thread(send_file);
                    file_thread.join();
                    printf("file_thread exit...\n");

                    continue ;
                }
                fputc(d, fp);
                continue ;
            }
            printf("%c", d);
            fflush(stdout);
            state = 0;
            state2 = 0;
        }
    };

    std::thread send_thread(send_command);
    std::thread recv_thread(recv_data);

    send_thread.join();
    recv_thread.join();
    close(com);
    return 0;
}
