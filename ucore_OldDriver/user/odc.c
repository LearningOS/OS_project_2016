#include "file.h"
#include "string.h"
#define COM_DATA (0xbfd00000 + 0x3F8)
#define COM_STAT (COM_DATA + 4)

#define STX (0x02)
#define ETX (0x03)
#define EOT (0x04)
#define ENQ (0x05)

#define DC1 (0x11)
#define DC2 (0x12)
#define DC3 (0x13)
#define DC4 (0x14)

typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

static inline void
outw(uint32_t port, uint32_t data) {
    *((volatile uintptr_t *) port) = data;
}

static inline uint32_t
inw(uint32_t port) {
    uint32_t data = *((volatile uintptr_t *) port);
    return data;
}

void wait_until_read_ready() {
	for (; ;) {
		int flag = inw(COM_STAT) & 0x2;
		if (flag != 0)
			break;
	}
}

void wait_until_write_ready() {
	for (; ;) {
		int flag = inw(COM_STAT) & 0x1;
		if (flag != 0)
			break;
	}
}

void write_byte(uint32_t data) {
	wait_until_write_ready();
	data &= 0xFF;
	outw(COM_DATA, data);
}

unsigned int read_byte() {
	wait_until_read_ready();
	uint32_t data = inw(COM_DATA);
	return data;
}

const char default_target[] = "a.out";
int main(int argc, char const *argv[]) {
    const char *target = NULL;
    if (argc == 2) {
        target = default_target;
    } else if (argc == 4 && strcmp(argv[2], "-o")){
        target = argv[3];
    } else {
        cprintf("usage: odc <src> [-o <des>]\n");
    }

    int fd = open(argv[1], O_RDONLY);
    if (fd < 0) {
        cprintf("can not open src this file\n");
        return -1;
    }

    int fd2 = open(target, O_WRONLY | O_CREAT | O_EXCL);
    if (fd2 < 0) {
        cprintf("fail to open des file\n");
        close(fd);
        return -1;
    }

    write_byte(ENQ);
    write_byte(STX);

    static char buffer[4096];
    int retLen;
    while ((retLen = read(fd, buffer, sizeof(buffer))) > 0) {
        int i = 0;
        for (; i < retLen; ++i) {
            write_byte(buffer[i]);
        }
    }
    close(fd);

    write_byte(ETX);
    write_byte(EOT);

    uint32_t d1 = read_byte();
    uint32_t d2 = read_byte();
    if (d1 != ENQ || d2 != STX) {
        cprintf("trans error.\nexit.\n");
        return 0;
    }

    int state = 0;
    int buffer_size = 0;
    while (1) {
        uint8_t d = read_byte();
        if (state == 0 && d == ETX) {
            state = 1;
            continue ;
        }
        if (state == 1 && d == EOT) {
            break ;
        }
        buffer[buffer_size ++] = d;
        if (buffer_size == 4096) {
            if (!write(fd2, buffer, buffer_size)) {
                cprintf("fail to write\n");
                close(fd2);
                return ;
            }
            buffer_size = 0;
        }
    }
    if (buffer_size) {
        if (!write(fd2, buffer, buffer_size)) {
            cprintf("fail to write\n");
        }
    }
    close(fd2);

    return 0;
}
