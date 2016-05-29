#include <ftp.h>
#include <utils.h>
#include <tcp.h>

char* arp_response = "ARP RESPONSE";
char* ack_data = "ACK";
#define ARP_RESPONSE_LEN 12
#define ACK_DATA_LEN 3

int rx_data[2048];
int rx_len;
int tx_data[2048];
int tx_len;

int rx_src_port, rx_dst_port;
int rx_seq, rx_ack;
bool rx_is_ack;

int data_port = -1;
int send_seq = 0, send_ack, recv_ack;

void set_data_port(int val)
{
    data_port = val;
}

void ftp_cntl_send(bool is_ack, int arp_type)
{
    tcp_dst_port = FTP_CONNECTION_PORT;
    tcp_src_port = FTP_CONNECTION_PORT;

    tcp_is_ack = is_ack;
    if (is_ack == 0) {
        tcp_ack = send_seq;
        send_ack = send_seq;
        send_seq += tx_len;
        tcp_seq = send_seq;
    } else {
        tcp_seq = recv_ack;
    }

    tcp_tx_len = tx_len;
    eth_memcpy(tcp_tx_data, tx_data, tcp_tx_len);
    tcp_send(arp_type);
}

void ftp_data_send(bool is_ack, int arp_type)
{
    if (data_port < 1024)
        return;

    tcp_dst_port = data_port;
    tcp_src_port = data_port;

    tcp_is_ack = is_ack;
    if (is_ack == 0) {
        tcp_ack = send_seq;
        send_ack = send_seq;
        send_seq += tx_len;
        tcp_seq = send_seq;
    } else {
        tcp_seq = recv_ack;
    }

    tcp_tx_len = tx_len;
    eth_memcpy(tcp_tx_data, tx_data, tcp_tx_len);
    tcp_send(arp_type);
}

void ftp_recv(int arp_type)
{
    int port_type;
    if (rx_src_port == FTP_CONNECTION_PORT && rx_dst_port == FTP_CONNECTION_PORT)
        port_type = 1;
    else if (rx_src_port == data_port && rx_dst_port == data_port)
        port_type = 2;
    else
        return;

    if (arp_type == 1) {
        tx_len = ARP_RESPONSE_LEN;
        int i;
        for (i=0; i<ARP_RESPONSE_LEN; i+=1)
            tx_data[i] = arp_response[i];
        ftp_cntl_send(0, 2);
    } else if (arp_type == 2) {
        //nothing to do?
    } else if (rx_is_ack == 0) {
        if (rx_ack == recv_ack) {
            recv_ack = rx_seq;
            tx_len = ACK_DATA_LEN;
            int i;
            for (i=0; i<ACK_DATA_LEN; i+=1)
                tx_data[i] = ack_data[i];
            if (port_type == 1)
                ftp_cntl_send(1, 0);
            else
                ftp_data_send(1, 0);
        }
    } else {
        //nothing to do?
    }
}
