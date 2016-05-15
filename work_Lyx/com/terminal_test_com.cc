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

#include <stdlib.h>
#include <unistd.h>
#include <fcntl.h>
#include <termios.h>
#include <signal.h>
#include <cstring>
#include <cstdint>
#include <iostream>
#include <thread>
#include <cstdint>
#include <string>
#include <CoreServices/CoreServices.h>
#include <mach/mach.h>
#include <mach/mach_time.h>
using namespace std;

// const int BAUD=230400; // self-OK
// const int BAUD=1228800; // self-Can't
// const int BAUD=460800; // self-OK
// const int BAUD=614400; // self-OK
// const int BAUD=921600; // self-half
const int BAUD=115200; // self-OK
// const int BAUD=9600;
const int TEST_ARG_A=131072;
const int TEST_ARG_B=8;

// block until receive a byte from serial port
uint8_t receive(const int com) {
	char buff[1];
	while (read(com, buff, 1) <= 0);
	return buff[0];
}

// send a byte to serial port
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

int hex_to_dig(char a){
	return (a>='0' && a<='9')?a-'0':a-'a'+10;
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
	// if((com = open("/dev/cu.usbserial-FT98RO7G" , O_RDWR | O_NONBLOCK)) == -1){
	// if((com = open("/dev/cu.usbserial-FT98DL8M" , O_RDWR | O_NONBLOCK)) == -1){
	if((com = open("/dev/tty.usbserial" , O_RDWR | O_NONBLOCK)) == -1){
		std::cout << "Error while opening serial port. " << std::endl;
		return 2;
	}

	// serial port settings
	struct termios port_settings;
	memset(&port_settings, 0, sizeof(port_settings));
	port_settings.c_iflag = 0;
	port_settings.c_oflag = 0;
	port_settings.c_cflag = CS8 | CREAD | CLOCAL | CSTOPB;
	port_settings.c_lflag = 0;
	port_settings.c_cc[VMIN] = 1;
	port_settings.c_cc[VTIME] = 5;
	cfsetospeed(&port_settings, BAUD);
	cfsetispeed(&port_settings, BAUD);
	tcsetattr(com, TCSANOW, &port_settings);

	std::cout << "Prepared to send and receive... " << std::endl;

	auto send_command = [&com]() {
		disable_waiting_for_enter();
		signal(SIGINT, restore);

		char a,b;

		while (1) {
			scanf("%c%c",&b,&a);
			printf("$0x%c%c\n",b,a);
			send((char)(hex_to_dig(b)*16+hex_to_dig(a)),com);
			usleep(10000);
			// char buff = getchar();
			// send(buff, com);
		}

		// for(;;){
		// 	char buff;
		// 	for(buff='\0';buff!='r';){
		// 		buff=getchar();
		// 	}
		// 	printf("Ok, Begin!\n");

		// 	uint64_t t1_0=0,t1=0,t2=0,td,tnsec,sum=0,tot=0;
		// 	mach_timebase_info_data_t sTimebaseInfo;
		// 	for(int t=0;t<TEST_ARG_A;++t){
		// 		for(int i=0;i<TEST_ARG_B;++i){
		// 			buff=i+'0';
		// 			t1=mach_absolute_time();
		// 			for(;;){
		// 				t2=mach_absolute_time();
		// 				td=t2-t1;
		// 				mach_timebase_info(&sTimebaseInfo);
		// 				tnsec=td*sTimebaseInfo.numer/sTimebaseInfo.denom;
		// 				if(tnsec>1000L*1000*1000/BAUD*10)break;
		// 			}
		// 			send(buff,com);
		// 			t1_0=mach_absolute_time();
		// 			mach_timebase_info(&sTimebaseInfo);
		// 			sum+=(t1_0-t1)*sTimebaseInfo.numer/sTimebaseInfo.denom;
		// 			tot+=1;
		// 		}
		// 	}
		// 	cout<<endl<<"Speed: "<<sum/tot<<" ns per byte"<<endl;
		// 	cout<<"Send Sum Time: "<<sum/1e9<<endl;
		// }
	};

	auto recv_data = [&com]() {
		int a,b,c,d;

		for(;;){
			// char _a=receive(com) & 0xff;
			// printf("%d",_a);
			a=receive(com) & 0xff;
			usleep(10000);
			b=receive(com) & 0xff;
			usleep(10000);
			c=receive(com) & 0xff;
			usleep(10000);
			d=receive(com) & 0xff;
			usleep(10000);
			printf("#0x%x\n",d*256*256*256+c*256*256+b*256+a);
		}
	};


	// auto recv_data = [&com]() {

	// 	uint64_t t1=0,t2=0,td,tnsec,sum=0,tot=0;
	// 	mach_timebase_info_data_t sTimebaseInfo;

	// 	for(;;){
	// 		for(int t=0;t<TEST_ARG_A;++t){
	// 			for(int i=0;i<TEST_ARG_B;++i){
	// 			if(t+i==0)
	// 				t1=mach_absolute_time();
	// 			char _a=receive(com) & 0xff;
	// 			printf("%c",_a);

	// 			fflush(stdout);
	// 			}
	// 		}
	// 		mach_timebase_info(&sTimebaseInfo);
	// 		t2=mach_absolute_time();


	// 		cout<<"Receive Sum Time: "<<(t2-t1)*sTimebaseInfo.numer/sTimebaseInfo.denom/1e9<<endl;
	// 	}
	// };

	// auto send_recv = [&com]() {
	// 	disable_waiting_for_enter();
	// 	signal(SIGINT, restore);

	// 	for(;;){
	// 		char buff;
	// 		for(buff='\0';buff!='r';){
	// 			buff=getchar();
	// 		}
	// 		printf("Ok, Begin!\n");

	// 		uint64_t t1_0=0,t1=0,t2=0,td,tnsec,sum=0,tot=0;
	// 		mach_timebase_info_data_t sTimebaseInfo;
	// 		for(int t=0;t<TEST_ARG_A;++t){
	// 			for(int i=0;i<TEST_ARG_B;++i){
	// 				buff=i+'0';
	// 				t1=mach_absolute_time();
	// 				send(buff,com);
	// 				char _a=receive(com) & 0xff;
	// 				printf("%c",_a);
	// 				// if(_a!=buff){
	// 				// 	printf("\nWrong!!\n");
	// 				// 	for(;;);
	// 				// }
	// 				t1_0=mach_absolute_time();
	// 				mach_timebase_info(&sTimebaseInfo);
	// 				sum+=(t1_0-t1)*sTimebaseInfo.numer/sTimebaseInfo.denom;
	// 				tot+=1;
	// 				fflush(stdout);
	// 			}
	// 		}
	// 		cout<<endl<<"Speed: "<<sum/tot<<" ns per byte"<<endl;
	// 		cout<<"Sum Time: "<<sum/1e9<<endl;
	// 	}
	// };


	std::thread send_thread(send_command);
	std::thread recv_thread(recv_data);
	// // std::thread send_recv_thread(send_recv);

	send_thread.join();
	recv_thread.join();
	// send_recv_thread.join();
	close(com);
	return 0;
}

