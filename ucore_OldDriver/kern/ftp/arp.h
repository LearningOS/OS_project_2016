#ifndef _H_ARP_
#define _H_ARP_ value

extern int arp_rx_data[2048];
extern int arp_rx_len;
extern int arp_tx_data[2048];
extern int arp_tx_len;

#define ETHERNET_TYPE_ARP 0x0806

#define ARP_TYPE 7
#define ARP_TYPE_REQUEST 0x1
#define ARP_TYPE_REPLY 0x2

#define ARP_SENDER_MAC 8
#define ARP_SENDER_IP 14
#define ARP_TARGET_MAC 18
#define ARP_TARGET_IP 24
#define ARP_MAC_LEN 6
#define ARP_IP_LEN 4
#define ARP_HDR_LEN 28

extern int IP_ADDR[ARP_IP_LEN];
extern int REMOTE_IP_ADDR[ARP_IP_LEN];

void arp_send(int arp_type);
void arp_recv();

#endif
