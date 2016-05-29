#ifndef _H_FTP_
#define _H_FTP_ value

#include <defs.h>

extern int rx_data[2048];
extern int rx_len;
extern int tx_data[2048];
extern int tx_len;

extern int rx_src_port, rx_dst_port;
extern int rx_seq, rx_ack;
extern bool rx_is_ack;

#define FTP_CONNECTION_PORT 21

void set_data_port(int val);
void ftp_cntl_send(bool is_ack, int arp_type);
void ftp_data_send(bool is_ack, int arp_type);
void ftp_recv(int arp_type);

#endif
