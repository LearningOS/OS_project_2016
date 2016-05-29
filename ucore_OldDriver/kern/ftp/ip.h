#ifndef _H_IP_
#define _H_IP_ value

extern int ip_rx_data[2048];
extern int ip_rx_len;
extern int ip_tx_data[2048];
extern int ip_tx_len;
extern int proto;

#define ETHERNET_TYPE_IP 0x0800

#define IP_VERSION 0
#define IP_VERSION_VAL (0x45) // version and header len

#define IP_TOTAL_LEN 2
#define IP_IDENTIF 4
#define IP_FLAGS 6
#define IP_TTL 8
#define IP_PROTOCAL 9

#define IP_SRC 12
#define IP_DST 16
#define IP_ADDR_LEN 4
#define IP_HDR_LEN 20

extern int IP_ADDR[IP_ADDR_LEN];
extern int REMOTE_IP_ADDR[IP_ADDR_LEN];

void ip_send();
void ip_recv();

#endif
