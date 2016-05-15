#include <defs.h>
#include <string.h>
#include <stdio.h>
#include <syscall.h>

uint32_t str_to_ip_addr(const char* ip_addr_str)
{
    int len = strlen(ip_addr_str), i;
    uint32_t ip_addr = 0;
    uint8_t ip_addr_seg = 0;

    for (i=0; i<len; i+=1)
        if (ip_addr_str[i] == '.') {
            ip_addr = ip_addr << 8 | ip_addr_seg;
            ip_addr_seg = 0;
        } else
            ip_addr_seg = ip_addr_seg * 10 + ip_addr_str[i] - '0';

    if (ip_addr_str[len - 1] != '.')
        ip_addr = ip_addr << 8 | ip_addr_seg;

    return ip_addr;
}
