#include "flashswap.h"
#include "string.h"
#include "atomic.h"
#include "sync.h"
#include "fs.h"
#include "ramdisk.h"

#define THINFLASH_SIZE        (8 << 20)
#define THINFLASH_SECTOR_SIZE (128 << 10)
#define THINFLASH_UNIT_SIZE   (2)
#define THINFLASH_NR_SECTOR   (64)
#define THINFLASH_SECTOR_UNIT (THINFLASH_SECTOR_SIZE / THINFLASH_UNIT_SIZE)
#define THINFLASH_SECTOR_RAM  (THINFLASH_SECTOR_SIZE / SECTSIZE)

#define THINFLASH_CMD_GETCODE (0x90)
#define THINFLASH_CMD_READ    (0xFF)
#define THINFLASH_CMD_WRITE   (0x40)
#define THINFLASH_CMD_ERASE   (0xD0)
#define THINFLASH_CMD_QUERY   (0x70)
#define THINFLASH_MODE_ERASE  (0x20)
#define THINFLASH_FINISH_BIT  (0x80)

#define THINFLASH_STATUS_CONSISTENT (0x00)
#define THINFLASH_STATUS_CLEAN      (0x01)
#define THINFLASH_STATUS_CLEANING   (0x02)
#define THINFLASH_STATUS_DIRTY      (0x03)

#define THINFLASH_GET_BLOCK_HEAD(secno)  (flash_base + (secno) * THINFLASH_SECTOR_UNIT)
#define THINFLASH_GET_SRC_HEAD(secno) (ramdisk_begin + (secno) * THINFLASH_SECTOR_UNIT)

static uint16_t test_buf[THINFLASH_SECTOR_UNIT];
static uint16_t* const flash_base = 0xBE000000;
static uint16_t* const ramdisk_begin = (uint16_t*)_initrd_begin;
static char block_status[THINFLASH_NR_SECTOR];
static int last_busy_block = -1;
static int intr_flag;

// static lock_t status_access;

// do not need
static int read_block(size_t secno, uint16_t *dst)
{
    *flash_base = THINFLASH_CMD_READ;
    uint16_t *addr = THINFLASH_GET_BLOCK_HEAD(secno);
    int i;
    for (i = 0; i < THINFLASH_SECTOR_UNIT; ++i) {
        dst[i] = addr[i];
    }
    return 0;
}

static int write_block(size_t secno, const uint16_t *src)
{
    int i;
    uint16_t *addr = THINFLASH_GET_BLOCK_HEAD(secno);
    // local_intr_save (intr_flag);
    for (i = 0; i < THINFLASH_SECTOR_UNIT; ++i) {
        *addr = THINFLASH_CMD_WRITE;
        addr[i] = src[i];
        do {
            *addr = THINFLASH_CMD_QUERY;
        } while (!(*addr & THINFLASH_FINISH_BIT));
    }
    // local_intr_restore (intr_flag);
    return 0;
}

static void wait_access() { // only use when intr is not able to use
    do {
        *flash_base = THINFLASH_CMD_QUERY;
    } while (!(*flash_base & THINFLASH_FINISH_BIT));
    return ;
}

static bool erase_not_busy() {
    static uint16_t tmp;
    // local_intr_save (intr_flag);
    *flash_base = THINFLASH_CMD_QUERY;
    tmp = *flash_base;
    // local_intr_restore (intr_flag);
    return (tmp & THINFLASH_FINISH_BIT);
}

static int erase_noblock(uint32_t secno) {
    uint16_t *addr = (flash_base) + secno * THINFLASH_SECTOR_UNIT;
    // local_intr_save (intr_flag);
    *addr = THINFLASH_MODE_ERASE;
    *addr = THINFLASH_CMD_ERASE;
    // local_intr_restore (intr_flag);
    return 0;
}

void swapper_block_changed_trigger(int secno) {
    // if (try_lock(&erase_busy)) {
    //     block_status[secno] = THINFLASH_STATUS_CLEANING;
    //     erase_noblock(secno);
    // } else {
    //     block_status[secno] = THINFLASH_STATUS_DIRTY;
    // }
    // TODO: add write control strategy
    local_intr_save (intr_flag);
    block_status[secno] = THINFLASH_STATUS_DIRTY;
    local_intr_restore (intr_flag);
}

int swapper_thread(void *arg) { // const
    kprintf("%s is running!\n", __func__);
    while (1) {
        // kprintf("do something\n");
        local_intr_save (intr_flag);
        for (int i = 0; i < THINFLASH_NR_SECTOR; ++i) {
            switch (block_status[i]) {
                case THINFLASH_STATUS_DIRTY:
                    if (erase_not_busy()) {
                        block_status[i] = THINFLASH_STATUS_CLEANING;
                        erase_noblock(i);
                    }
                    break;
                case THINFLASH_STATUS_CLEANING:
                    if (erase_not_busy()) {
                        block_status[i] = THINFLASH_STATUS_CLEAN;
                    }
                    break;
                case THINFLASH_STATUS_CLEAN:
                    kprintf("a clean block\n");
                    // TODO: add write to flash block
                    write_block(i, THINFLASH_GET_SRC_HEAD(i));
                    block_status[i] = THINFLASH_STATUS_CONSISTENT;
                case THINFLASH_STATUS_CONSISTENT:
                default:
                    break;
            }
        }
        local_intr_restore (intr_flag);
        schedule();
    }
}

void swapper_block_changed(int secno) {
    assert(secno >= 0 && secno < THINFLASH_NR_SECTOR);
    if (block_status[secno] == THINFLASH_STATUS_CONSISTENT) {
        swapper_block_changed_trigger(secno);
    }
}

void swapper_init() {
    int secno;
    for (secno = 0; secno < THINFLASH_NR_SECTOR; ++secno) {
        kprintf("erase blokc number %d ...\n", secno);
        erase_noblock(secno);
        wait_access();
    }

    kprintf("check erase\n");
    for (secno = 0; secno < THINFLASH_NR_SECTOR; ++secno) {
        read_block(secno, test_buf);
        int unit;
        for (unit = 0; unit < THINFLASH_SECTOR_UNIT; ++unit) {
            if (test_buf[unit] != 0xFFFF) {
                kprintf("secno %d unit %d: %d\n", secno, unit, test_buf[unit]);
                assert(0);
            }
        }
    }
    kprintf("OK\n");

    int pid = kernel_thread(swapper_thread, NULL, 0);
    if (pid <= 0) {
        panic("create swapper_thread failed.\n");
    }

    memset(block_status, 0, sizeof(block_status));

    //
    // // check wirte & read
    // kprintf("check write and read\n");
    // for (secno = 0; secno < (dev->size); ++secno) {
    //     int unit;
    //     for (unit = 0; unit < THINFLASH_SECTOR_UNIT; ++unit) {
    //         test_buf[unit] = ((secno & 0xFF) << 8) | (unit & 0xFF) ;
    //     }
    //     thinflash_write(dev, secno, test_buf, 1);
    //     thinflash_read(dev, secno, test_buf, 1);
    //     for (unit = 0; unit < THINFLASH_SECTOR_UNIT; ++unit) {
    //         // kprintf("secno %d unit %d: %x\n", secno, unit, test_buf[unit]);
    //         if (test_buf[unit] != ((secno & 0xFF) << 8) | (unit & 0xFF)) {
    //             kprintf("check error\n");
    //             assert(0);
    //         }
    //     }
    // }
    // kprintf("OK\n");
    // while (1);
}
