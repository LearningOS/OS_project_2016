#ifndef _H_MAC_
#define _H_MAC_ value

extern int mac_rx_data[2048];
extern int mac_rx_len;
extern int mac_tx_data[2048];
extern int mac_tx_len;
extern int type;

#define ETHERNET_DST_MAC 0
#define ETHERNET_SRC_MAC 6
#define ETHERNET_TYPE 12
#define ETHERNET_MAC_LEN 6
#define ETHERNET_TYPE_LEN 2
#define ETHERNET_HDR_LEN 14

#define mac_rx_type ((mac_rx_data[12] << 8) | mac_rx_data[13])

extern int MAC_ADDR[ETHERNET_MAC_LEN];
extern int REMOTE_MAC_ADDR[ETHERNET_MAC_LEN];

void mac_send();
void mac_recv();

#endif
