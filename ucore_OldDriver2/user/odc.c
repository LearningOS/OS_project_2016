#include "file.h"
#include "string.h"
#include "ulib.h"
#define COM_DATA (0xbfd00000 + 0x3F8)
#define COM_STAT (COM_DATA + 4)

#define BUFFER_SIZE (4096)

#define STX (0x02)
#define ETX (0x03)
#define EOT (0x04)
#define ENQ (0x05)

typedef unsigned int uint32_t;
typedef unsigned char uint8_t;

#define ST0_IE			0x00000001
#define get_status(x) __asm volatile("mfc0 %0,$12" : "=r" (x))
#define set_status(x) __asm volatile("mtc0 %0,$12" :: "r" (x))

/* intr_enable - enable irq interrupt */
void
intr_enable(void) {
	uint32_t x;
	get_status(x);
	x |= ST0_IE;
	set_status(x);

}

/* intr_disable - disable irq interrupt */
void
intr_disable(void) {
	uint32_t x;
	get_status(x);
	x &= ~ST0_IE;
	set_status(x);
}
#define __read_32bit_c0_register(source, sel)				\
({ int __res;								\
	if (sel == 0)							\
		__asm__ __volatile__(					\
			"mfc0\t%0, " #source "\n\t"			\
			: "=r" (__res));				\
	else								\
		__asm__ __volatile__(					\
			".set\tmips32\n\t"				\
			"mfc0\t%0, " #source ", " #sel "\n\t"		\
			".set\tmips0\n\t"				\
			: "=r" (__res));				\
	__res;								\
})
#define read_c0_status()	__read_32bit_c0_register($12, 0)

static inline bool
__intr_save(void) {
  if (!(read_c0_status() & ST0_IE)) {
    return 0;
  }
  intr_disable();
  return 1;
}

static inline void
__intr_restore(bool flag) {
    if (flag) {
        intr_enable();
    }
}

#define local_intr_restore(x)   do {__intr_restore(x);  } while (0)
#define local_intr_save(x)      do { x = __intr_save(); } while (0)

static inline void
outw(uint32_t port, uint32_t data) {
    *((volatile uintptr_t *) port) = data;
}

static inline uint32_t
inw(uint32_t port) {
    uint32_t data = *((volatile uintptr_t *) port);
    return data;
}

static inline uint8_t
inb(uint32_t port) {
    uint8_t data = *((volatile uint8_t*) port);
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

unsigned char read_byte() {
	wait_until_read_ready();
	uint8_t data = inb(COM_DATA) & 0xFF;
	return data;
}

const char default_target[] = "a.out";
int main(int argc, char **argv) {
    char *target = NULL;
    if (argc == 2) {
        target = default_target;
    } else if (argc == 4 && strcmp(argv[2], "-o") == 0){
        target = argv[3];
    } else {
        cprintf("usage: odc <src> [-o <des>]\n");
        return -1;
    }

    int fd = open(argv[1], O_RDONLY);
    if (fd < 0) {
        cprintf("can not open src this file\n");
        return -1;
    }

    int fd2 = open(target, O_WRONLY | O_CREAT);
    if (fd2 < 0) {
        cprintf("fail to open des file or the file has been existed\n");
        close(fd);
        return -1;
    }

    write_byte(ENQ);
    write_byte(STX);


    static char buffer[BUFFER_SIZE];
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

    int flag_intr = 0;
    local_intr_save(flag_intr);

    uint8_t d1 = read_byte();
    uint8_t d2 = read_byte();
    if (d1 != ENQ || d2 != STX) {
        cprintf("trans error.\nexit.\n");
        return 0;
    }
    uint8_t l0 = read_byte();
    uint8_t l1 = read_byte();
    uint8_t l2 = read_byte();
    uint8_t l3 = read_byte();

    uint32_t file_len = (uint32_t)l0 + ((uint32_t)(l1) << 8) + ((uint32_t)(l2) << 16) + ((uint32_t)(l3) << 24);
    int buffer_size = 0;
    int i;
    for (i = 0; i < file_len; ++i) {
		// if (i == 0) {
		// 	write_byte(0xFF);
		// }
        uint8_t d = read_byte();
        buffer[buffer_size ++] = d;
        if (buffer_size == BUFFER_SIZE) {
            if (!write(fd2, buffer, buffer_size)) {
                assert(0);
                close(fd2);
                return ;
            }
            buffer_size = 0;
			write_byte(0xFF);
        }
    }
    if (buffer_size) {
        if (!write(fd2, buffer, buffer_size)) {
            assert(0);
        }
    }
    local_intr_restore(flag_intr);
    close(fd2);
    cprintf("odc exit...\n");

    return 0;
}
