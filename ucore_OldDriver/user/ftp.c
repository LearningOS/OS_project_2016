#include <stdio.h>
#include <string.h>
#include <ulib.h>
#include <addr.h>

int start_ftp(const char* ip_addr_str)
{
    uint32_t ip_addr = str_to_ip_addr(ip_addr_str);
}

int main(int argc, char** argv)
{
    assert(argc > 1);
    return start_ftp(argv[1]);
}
