#include "flashswap.h"
#include "string.h"
#include "atomic.h"
#include "sync.h"
#include "fs.h"
#include "ramdisk.h"

#define THINFLASH_GET_BLOCK_HEAD(secno)  (flash_base + (secno) * THINFLASH_SECTOR_UNIT)
#define THINFLASH_GET_SRC_HEAD(secno) (ramdisk_begin + (secno) * THINFLASH_SECTOR_UNIT)

static uint16_t test_buf[THINFLASH_SECTOR_UNIT];
static uint16_t* const flash_base = 0xBE000000;
static uint16_t* const ramdisk_begin = (uint16_t*)_initrd_begin;
static int block_status[THINFLASH_NR_SECTOR + 1];
static int block_should_sync[THINFLASH_NR_SECTOR + 1];
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
    uint16_t x;
    do {
        *flash_base = THINFLASH_CMD_QUERY;
        x = *flash_base;
        // kprintf("x is %d\n", x);
    } while (!(x & THINFLASH_FINISH_BIT));
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

int swapper_thread(void *arg) { // const
    kprintf("%s is running!\n", __func__);
    bool has_task = 0;
    while (1) {
        // kprintf("do something\n");
        local_intr_save (intr_flag);
        // kprintf("save 0\n");
    thread_start:
        while (!erase_not_busy() && has_task) {
            // kprintf("restore 0\n");
            // kprintf("ya ba li: --- busy\n");
            // while (1);
            local_intr_restore (intr_flag);
            schedule();
            local_intr_save (intr_flag);
            // kprintf("save 1\n");
        }
        has_task = 0;
        for (int i = 0; i < THINFLASH_NR_SECTOR; ++i) {
            // kprintf("---- %d ----\n", i);
            switch (block_status[i]) {
                case THINFLASH_STATUS_DIRTY:
                    // kprintf("%d:DIRTY\n", i);
                    // kprintf("asynchronous erase %d\n", i);
                    block_status[i] = THINFLASH_STATUS_CLEANING;
                    erase_noblock(i);
                    has_task = 1;
                    goto thread_start;
                    break;
                case THINFLASH_STATUS_CLEANING:
                    // kprintf("%d:CLEANING\n", i);
                    block_status[i] = THINFLASH_STATUS_CLEAN;
                    break;
                case THINFLASH_STATUS_CLEAN:
                    // kprintf("%d:CLEAN\n", i);
                    if (block_should_sync[i] == THINFLASH_SYNC_SHOULD) {
                        kprintf("write block %d\n", i);
                        write_block(i, THINFLASH_GET_SRC_HEAD(i));
                        // int j;
                        // for (j = 0; j < THINFLASH_NR_SECTOR; ++j) {
                        //     kprintf("write block %d\n", j);
                        //     write_block(j, THINFLASH_GET_SRC_HEAD(j));
                        // }
                        block_status[i] = THINFLASH_STATUS_CONSISTENT;
                        block_should_sync[i] = THINFLASH_SYNC_NO_NEED;
                    }
                case THINFLASH_STATUS_CONSISTENT:
                default:
                    break;
            }
        }
        // kprintf("restore 1\n");
        local_intr_restore (intr_flag);
        schedule();
    }
}

void swapper_block_changed(int secno) {
    assert(secno >= 0 && secno < THINFLASH_NR_SECTOR);
    local_intr_save (intr_flag);
    if (block_status[secno] == THINFLASH_STATUS_CONSISTENT) {
        // kprintf("%d -- mark dirty\n");
        block_status[secno] = THINFLASH_STATUS_DIRTY;
    }
    // while (1);
    local_intr_restore (intr_flag);
}

void swapper_block_sync(int secno) {
    assert (secno >= 0 && secno < THINFLASH_NR_SECTOR);
    kprintf("swapper_block_sync at %d\n", secno);
    kprintf ("the status is %d\n", block_status[secno]);
    local_intr_save (intr_flag);
    if (block_status[secno] != THINFLASH_STATUS_CONSISTENT) {
        block_should_sync[secno] = THINFLASH_SYNC_SHOULD;
        kprintf("%d has been set to THINFLASH_SYNC_SHOULD\n", secno);
    }
    local_intr_restore (intr_flag);
}

void swapper_block_late_sync(int secno) {
    assert (secno >= 0 && secno < THINFLASH_NR_SECTOR);
    // kprintf("swapper_block_late_sync at %d\n", secno);
    local_intr_save (intr_flag);
    if (block_status[secno] != THINFLASH_STATUS_CONSISTENT) {
        block_should_sync[secno] = THINFLASH_SYNC_LATE;
    }
    local_intr_restore (intr_flag);
}

void swapper_block_real_sync() {
    local_intr_save (intr_flag);
    kprintf("swapper_block_real_sync\n");
    int secno;
    for (secno = 0; secno <= THINFLASH_NR_SECTOR; ++secno) {
        if (block_should_sync[secno] == THINFLASH_SYNC_LATE) {
            block_should_sync[secno] = THINFLASH_SYNC_SHOULD;
        }
    }
    local_intr_restore (intr_flag);
}

void swapper_all_block_sync() {
    local_intr_save (intr_flag);
    int i;
    for (i = 0; i < THINFLASH_NR_SECTOR; ++i) {
        if (block_status[i] != THINFLASH_STATUS_CONSISTENT) {
            block_should_sync[i] = THINFLASH_SYNC_SHOULD;;
        }
    }
    local_intr_restore (intr_flag);
}

int read_from_flash(void *begin, void *end) {
    // uint16_t *be = (uint16_t*)begin;
    // uint16_t *en = (uint16_t*)end;
    // if (be & THINFLASH_SECTOR_UNIT_MASK) {
    //     uint16_t *be_align = be & (~THINFLASH_SECTOR_UNIT_MASK);
    // }
    return ;
}

void swapper_init() {
    *flash_base = THINFLASH_CMD_READ;
    if (flash_base[THINFLASH_NR_SECTOR * THINFLASH_SECTOR_UNIT] == FLASHMAGIC) {
        int secno;
        for (secno = 0; secno < THINFLASH_NR_SECTOR; ++secno) {
            block_status[secno] = THINFLASH_STATUS_CONSISTENT;
            block_should_sync[secno] = 0;
        }
    } else {
        int secno;
        for (secno = 0; secno <= THINFLASH_NR_SECTOR; ++secno) {
            kprintf("erase block number %d ...\n", secno);
            erase_noblock(secno);
            block_status[secno] = THINFLASH_STATUS_CLEAN;
            // block_should_sync[secno] = THINFLASH_SYNC_NO_NEED;
            block_should_sync[secno] = THINFLASH_SYNC_SHOULD;
            wait_access();
        }
        block_should_sync[0] = THINFLASH_SYNC_SHOULD;
        // mark the FLASHMAGIC
        flash_base[THINFLASH_NR_SECTOR * THINFLASH_SECTOR_UNIT] = THINFLASH_CMD_WRITE;
        flash_base[THINFLASH_NR_SECTOR * THINFLASH_SECTOR_UNIT] = FLASHMAGIC;
    }
    kprintf("OK\n");
    // while (1);

    // kprintf("check erase\n");
    // for (secno = 0; secno < THINFLASH_NR_SECTOR; ++secno) {
    //     read_block(secno, test_buf);
    //     int unit;
    //     for (unit = 0; unit < THINFLASH_SECTOR_UNIT; ++unit) {
    //         if (test_buf[unit] != 0xFFFF) {
    //             kprintf("secno %d unit %d: %d\n", secno, unit, test_buf[unit]);
    //             assert(0);
    //         }
    //     }
    // }
    // kprintf("OK\n");

    int pid = kernel_thread(swapper_thread, NULL, 0);
    if (pid <= 0) {
        panic("create swapper_thread failed.\n");
    }

    // memset(block_status, 0, sizeof(block_status));

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
