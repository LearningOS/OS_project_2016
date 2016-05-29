#include <tcp.h>
#include <utils.h>
#include <ftp.h>
#include <ip.h>
#include <arp.h>

int tcp_rx_data[2048];
int tcp_rx_len;
int tcp_tx_data[2048];
int tcp_tx_len;
int tcp_src_port, tcp_dst_port;
int tcp_seq, tcp_ack;
bool tcp_is_ack;

int calc_checksum(int *data, int length)
{
	int sum = IP_PROTOCAL_TCP + length;

	int i;
	for (i=0; i<length; i+=2) {
		int val = data[i] << 8;
		if (i + 1 != length) val |= data[i + 1];
		sum += val;
	}

	sum = (sum >> 16) + (sum & 0xffff);
	sum = (sum >> 16) + (sum & 0xffff);
	sum = ~sum;
	return sum;
}

void tcp_send(int arp_type)
{
	int *data, *len;
	if (arp_type == 0) {
		data = ip_tx_data;
		len = &ip_tx_len;
	} else {
		data = arp_tx_data;
		len = &arp_tx_len;
	}

	int2mem(data + TCP_SRC_PORT, TCP_PORT_LEN, tcp_src_port);
	int2mem(data + TCP_DST_PORT, TCP_PORT_LEN, tcp_dst_port);
	data[TCP_FLAGS] = 0;

	if (tcp_is_ack == 0) {
		int2mem(data + TCP_SEQ, TCP_SEQ_ACK_LEN, tcp_seq);
		int2mem(data + TCP_ACK, TCP_SEQ_ACK_LEN, tcp_ack);
	} else {
		int2mem(data + TCP_SEQ, TCP_SEQ_ACK_LEN, 0);
		int2mem(data + TCP_ACK, TCP_SEQ_ACK_LEN, tcp_seq);
		data[TCP_FLAGS] |= TCP_FLAG_ACK;
	}

	data[TCP_DATA_OFFSET] = TCP_DATA_OFFSET_VAL;
	data[TCP_WINDOW] = 0;
	data[TCP_WINDOW + 1] = 0;
	data[TCP_CHECKSUM] = 0;
	data[TCP_CHECKSUM + 1] = 0;
	data[TCP_URGEN] = 0;
	data[TCP_URGEN + 1] = 0;

	*len = TCP_HDR_LEN + tcp_tx_len;
	eth_memcpy(data + TCP_HDR_LEN, tcp_tx_data, *len);

	int sum = calc_checksum(data, *len);
	data[TCP_CHECKSUM] = MSB(sum);
	data[TCP_CHECKSUM + 1] = LSB(sum);

	if (arp_type == 0)
		ip_send();
	else
		arp_send(arp_type);
}

void tcp_recv(int arp_type)
{
	int sum = calc_checksum(tcp_rx_data, tcp_rx_len);
	int checksum = (LSB(tcp_rx_data[TCP_CHECKSUM]) << 8
					| LSB(tcp_rx_data[TCP_CHECKSUM + 1]));
	if (sum == checksum) {
		rx_src_port = mem2int(tcp_rx_data + TCP_SRC_PORT, TCP_PORT_LEN);
		rx_dst_port = mem2int(tcp_rx_data + TCP_DST_PORT, TCP_PORT_LEN);
		rx_is_ack = (tcp_rx_data[TCP_FLAGS] & TCP_FLAG_ACK) != 0;
		rx_seq = mem2int(tcp_rx_data + TCP_SEQ, TCP_SEQ_ACK_LEN);
		rx_ack = mem2int(tcp_rx_data + TCP_ACK, TCP_SEQ_ACK_LEN);

		rx_len = tcp_rx_len - TCP_HDR_LEN;
		eth_memcpy(rx_data, tcp_rx_len + TCP_HDR_LEN, rx_len);
		ftp_recv(arp_type);
	}
}
