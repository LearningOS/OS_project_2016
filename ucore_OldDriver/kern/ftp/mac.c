#include <mac.h>
#include <utils.h>
#include <defs.h>
#include <ethernet.h>
#include <arp.h>
#include <ip.h>

int MAC_ADDR[ETHERNET_MAC_LEN] = {0xf0, 0xde, 0xf1, 0x44, 0x55, 0x66};
int REMOTE_MAC_ADDR[ETHERNET_MAC_LEN];
bool mac_inited = 0;

int mac_rx_data[2048];
int mac_rx_len;
int mac_tx_data[2048];
int mac_tx_len;
int type;

void mac_send()
{
    if (mac_inited == 0) {
        int2mem(REMOTE_MAC_ADDR, ETHERNET_MAC_LEN, 0);
        mac_inited = 1;
    }

    eth_memcpy(ethernet_tx_data + ETHERNET_DST_MAC, REMOTE_MAC_ADDR, ETHERNET_MAC_LEN);
    eth_memcpy(ethernet_tx_data + ETHERNET_SRC_MAC, MAC_ADDR, ETHERNET_MAC_LEN);
    ethernet_tx_data[ETHERNET_TYPE] = MSB(type);
    ethernet_tx_data[ETHERNET_TYPE + 1] = LSB(type);

    ethernet_tx_len = ETHERNET_HDR_LEN + mac_tx_len;
    eth_memcpy(ethernet_tx_data + ETHERNET_HDR_LEN, mac_tx_data, mac_tx_len);

    ethernet_send();
}

void mac_recv()
{
    if (eth_memcmp(mac_rx_data[ETHERNET_DST_MAC], MAC_ADDR, ETHERNET_MAC_LEN)
        && eth_memzero(mac_rx_data[ETHERNET_DST_MAC], ETHERNET_MAC_LEN))
        return;
    if (eth_memcmp(mac_rx_data[ETHERNET_SRC_MAC], REMOTE_MAC_ADDR, ETHERNET_MAC_LEN)
        && eth_memzero(REMOTE_MAC_ADDR, ETHERNET_MAC_LEN))
        return;
    eth_memcpy(REMOTE_MAC_ADDR, mac_rx_data[ETHERNET_SRC_MAC], ETHERNET_MAC_LEN);
    mac_inited = 1;

    int type = (mac_rx_data[ETHERNET_TYPE] << 8) | mac_rx_data[ETHERNET_TYPE + 1];
    if (type == ETHERNET_TYPE_ARP) {
        arp_rx_len = mac_rx_len - ETHERNET_HDR_LEN;
        eth_memcpy(arp_rx_data, mac_rx_data + ETHERNET_HDR_LEN, arp_rx_len);
        arp_recv();
    }
    if (type == ETHERNET_TYPE_IP) {
        ip_rx_len = mac_rx_len - ETHERNET_HDR_LEN;
        eth_memcpy(ip_rx_data, mac_rx_data + ETHERNET_HDR_LEN, ip_rx_len);
        ip_recv();
    }
}
