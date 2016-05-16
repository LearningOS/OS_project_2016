#include "thinflash.h"
#define THINFLASH_CMD_GETCODE (0x90)
#define THINFLASH_CMD_READ (0xFF)
#define THINFLASH_CMD_WRITE (0x40)
#define THINFLASH_CMD_ERASE (0xD0)
#define THINFLASH_CMD_QUERY (0x70)
#define THINFLASH_MODE_ERASE (0x20)
#define THINFLASH_FINISH_BIT (0x80)

#define MIN(a, b) (((a) < (b)) ? (a) : (b))

static uint16_t test_buf[THINFLASH_SECTOR_UNIT];

bool
check_init_thinflash() {
    return 1;
}

static int thinflash_read(struct ide_device* dev, size_t secno, void *dst, size_t nsecs)
{
    if (!dev->valid) {
        return -1;
    }
    nsecs = MIN(nsecs, dev->size-secno);
    if(nsecs < 0) {
        return -1;
    }
    *((uint16_t*)(dev->iobase)) = THINFLASH_CMD_READ;
    int len = nsecs * THINFLASH_SECTOR_UNIT;
    uint16_t *dst_tmp = (uint16_t*)dst;
    int i;
    for (i = 0; i < len; ++i) {
        dst_tmp[i] = *((uint16_t*)(dev->iobase) + i);
    }
    return 0;
}

static int thinflash_write(struct ide_device* dev, size_t secno, const void *src, size_t nsecs)
{
    if (!dev->valid) {
        return -1;
    }
    nsecs = MIN(nsecs, dev->size - secno);
    if (nsecs < 0) {
        return -1;
    }
    uint16_t *src_tmp = (uint16_t*)src;
    int len = nsecs * THINFLASH_SECTOR_UNIT;
    int i;
    uint16_t *addr = (uint16_t*)(dev->iobase) + secno * THINFLASH_CMD_WRITE;
    for (i = 0; i < len; ++i) {
        *addr = THINFLASH_CMD_WRITE;
        addr[i] = src_tmp[i];
        do {
            *addr = THINFLASH_CMD_QUERY;
        } while (!(*addr & THINFLASH_FINISH_BIT));
    }
    return 0;
}

static int thinflash_erase(struct ide_device* dev, uint32_t secno) {
    if (secno < 0 || secno >= dev->size) {
        return -1;
    }
    uint16_t *addr = ((uint16_t*)(dev->iobase) + secno * THINFLASH_SECTOR_UNIT);
    *addr = THINFLASH_MODE_ERASE;
    *addr = THINFLASH_CMD_ERASE;
    do {
        *addr = THINFLASH_CMD_QUERY;
    } while (!(*addr & THINFLASH_FINISH_BIT));
    return 0;
}

static void thinflash_init(struct ide_device* dev){
    kprintf("%s(): inittf found, magic: 0x%08x, 0x%08x secs\n", __func__, *(uint32_t*)(dev->iobase), dev->size);
    int secno;
    for (secno = 0; secno < (dev->size); ++secno) {
        kprintf("erase %d ...\n", secno);
        if (thinflash_erase(dev, secno) != 0) {
            kprintf("in %s: %d secno fail to erase\n");
            assert(0);
        }
    }

    // check erase
    kprintf("check erase\n");
    for (secno = 0; secno < (dev->size); ++secno) {
        thinflash_read(dev, secno, test_buf, 1);
        int unit;
        for (unit = 0; unit < THINFLASH_SECTOR_UNIT; ++unit) {
            if (test_buf[unit] != 0xFFFF) {
                kprintf("secno %d unit %d: %d\n", secno, unit, test_buf[unit]);
                assert(0);
            }
        }
    }
    kprintf("OK\n");

    // check wirte & read
    kprintf("check write and read\n");
    for (secno = 0; secno < (dev->size); ++secno) {
        int unit;
        for (unit = 0; unit < THINFLASH_SECTOR_UNIT; ++unit) {
            test_buf[unit] = ((secno & 0xFF) << 8) | (unit & 0xFF) ;
        }
        thinflash_write(dev, secno, test_buf, 1);
        thinflash_read(dev, secno, test_buf, 1);
        for (unit = 0; unit < THINFLASH_SECTOR_UNIT; ++unit) {
            // kprintf("secno %d unit %d: %x\n", secno, unit, test_buf[unit]);
            if (test_buf[unit] != ((secno & 0xFF) << 8) | (unit & 0xFF)) {
                kprintf("check error\n");
                assert(0);
            }
        }
    }
    kprintf("OK\n");
}

void thinflash_init_struct(struct ide_device* dev)
{
    memset(dev, 0, sizeof(struct ide_device));
    // if(CHECK_INITRD_EXIST()){
    // }
    dev->valid = 1;
    dev->sets = ~0;
    dev->size = THINFLASH_NR_SECTOR;
    dev->iobase = (THINFLASH_BASE);
    strcpy(dev->model, "thinflash");
    // debug-for-transplant
    kprintf("set dev->init with thinflash\n");

    dev->init = thinflash_init;
    dev->read_secs = thinflash_read;
    dev->write_secs = thinflash_write;
    dev->erase_secs = thinflash_erase;
}
