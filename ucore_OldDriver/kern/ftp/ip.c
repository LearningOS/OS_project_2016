#include <ip.h>
#include <utils.h>
#include <defs.h>
#include <tcp.h>
#include <mac.h>

int IP_ADDR[IP_ADDR_LEN] = {192, 168, 1, 233};
int REMOTE_IP_ADDR[IP_ADDR_LEN];

int ip_rx_data[2048];
int ip_rx_len;
int ip_tx_data[2048];
int ip_tx_len;
int proto;

void ip_send()
{
    int length = IP_HDR_LEN + ip_tx_len;
    mac_tx_data[IP_VERSION] = IP_VERSION_VAL;
    mac_tx_data[IP_TOTAL_LEN] = MSB(length);
    mac_tx_data[IP_TOTAL_LEN + 1] = LSB(length);
    mac_tx_data[IP_FLAGS] = 0;
    mac_tx_data[IP_FLAGS + 1] = 0;
    mac_tx_data[IP_TTL] = 64;
    mac_tx_data[IP_PROTOCAL] = proto;
    eth_memcpy(mac_tx_data + IP_SRC, IP_ADDR, IP_ADDR_LEN);
    eth_memcpy(mac_tx_data + IP_DST, REMOTE_IP_ADDR, IP_ADDR_LEN);

    mac_send();
}

void ip_recv()
{
    if (eth_memcmp(ip_rx_data[IP_DST], IP_ADDR, IP_ADDR_LEN))
        return;
    if (eth_memcmp(ip_rx_data[IP_SRC], REMOTE_IP_ADDR, IP_ADDR_LEN))
        return;
    if (ip_rx_data[IP_VERSION] != IP_VERSION_VAL)
        return;

    int length = (ip_rx_data[IP_TOTAL_LEN] << 8) | ip_rx_data[IP_TOTAL_LEN + 1];
    if (ip_rx_data[IP_PROTOCAL] == IP_PROTOCAL_TCP) {
        tcp_rx_len = length - IP_HDR_LEN;
        eth_memcpy(tcp_rx_data, ip_rx_data + IP_HDR_LEN, tcp_rx_len);
        tcp_recv(0);
    }
}
