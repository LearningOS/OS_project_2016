#include <arp.h>
#include <utils.h>
#include <defs.h>
#include <mac.h>
#include <tcp.h>
#include <ip.h>

int ARP_FIX_HDR[] = {
    0x00, 0x01,    //ethernet
    0x08, 0x00,    //IP
    0x06, 0x04,    //mac/IP size
    0x00,          //high bit of type (hack)
};
bool ip_inited = 0;

int arp_rx_data[2048];
int arp_rx_len;
int arp_tx_data[2048];
int arp_tx_len;

void arp_send(int arp_type)
{
    if (ip_inited == 0) {
        int2mem(REMOTE_IP_ADDR, ARP_IP_LEN, 0);
        ip_inited = 1;
    }

    eth_memcpy(mac_tx_data, ARP_FIX_HDR, 6 + 1);
    mac_tx_data[ARP_TYPE] = arp_type;
    eth_memcpy(mac_tx_data[ARP_SENDER_MAC], MAC_ADDR, ARP_MAC_LEN);
    eth_memcpy(mac_tx_data[ARP_SENDER_IP], IP_ADDR, ARP_IP_LEN);
    eth_memcpy(mac_tx_data[ARP_TARGET_MAC], REMOTE_MAC_ADDR, ARP_MAC_LEN);
    eth_memcpy(mac_tx_data[ARP_TARGET_IP], REMOTE_IP_ADDR, ARP_IP_LEN);
    mac_tx_len = ARP_HDR_LEN + arp_tx_len;
    eth_memcpy(mac_tx_data[ARP_HDR_LEN], arp_tx_data, arp_tx_len);
    type = ETHERNET_TYPE_ARP;

    mac_send();
}

void arp_recv()
{
    if (eth_memcmp(arp_rx_data[ARP_TARGET_IP], IP_ADDR, ARP_IP_LEN)
        && eth_memzero(arp_rx_data[ARP_TARGET_IP], ARP_IP_LEN))
        return;
    if (eth_memcmp(arp_rx_data[ARP_SENDER_IP], REMOTE_IP_ADDR, ARP_IP_LEN)
        && eth_memzero(REMOTE_IP_ADDR, ARP_IP_LEN))
        return;
    eth_memcpy(REMOTE_IP_ADDR, arp_rx_data[ARP_SENDER_IP], ARP_IP_LEN);
    ip_inited = 1;
    int arp_type = arp_rx_data[ARP_TYPE];

    tcp_rx_len = arp_rx_len - ARP_HDR_LEN;
    eth_memcpy(tcp_rx_data, arp_rx_data + ARP_HDR_LEN, tcp_rx_len);

    tcp_recv(arp_type);
}
