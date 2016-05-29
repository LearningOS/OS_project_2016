#ifndef _H_TCP_
#define _H_TCP_ value

#include <defs.h>

#define TCP_CLOSED 1
#define TCP_SYNC_RECVED 2
#define TCP_ESTABLISHED 3
#define TCP_FIN_SENT 4

extern int tcp_rx_data[2048];
extern int tcp_rx_len;
extern int tcp_tx_data[2048];
extern int tcp_tx_len;
extern int tcp_src_port, tcp_dst_port;
extern int tcp_seq, tcp_ack;
extern bool tcp_is_ack;

#define IP_PROTOCAL_TCP 0x06

#define TCP_SRC_PORT 0
#define TCP_DST_PORT 2
#define TCP_SEQ 4
#define TCP_ACK 8
#define TCP_DATA_OFFSET 12
#define TCP_FLAGS 13
#define TCP_WINDOW 14
#define TCP_CHECKSUM 16
#define TCP_URGEN 18
#define TCP_PORT_LEN 2
#define TCP_SEQ_ACK_LEN 4
#define TCP_HDR_LEN 20
#define TCP_DATA_OFFSET_VAL (0x50)

#define TCP_FLAG_CWR 0x80
#define TCP_FLAG_ECE 0x40
#define TCP_FLAG_URG 0x20
#define TCP_FLAG_ACK 0x10
#define TCP_FLAG_PSH 0x08
#define TCP_FLAG_RST 0x04
#define TCP_FLAG_SYN 0x02
#define TCP_FLAG_FIN 0x01

void tcp_send(int arp_type);
void tcp_recv(int arp_type);

#endif
