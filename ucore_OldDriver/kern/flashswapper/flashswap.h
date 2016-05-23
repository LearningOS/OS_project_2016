#ifndef __FLASH_SWAP__H
#define __FLASH_SWAP__H

#include "thumips.h"
#include "assert.h"
#include "ramdisk.h"

#define THINFLASH_SIZE             (8 << 20)
#define THINFLASH_SECTOR_SIZE      (128 << 10)
#define THINFLASH_UNIT_SIZE        (2)
#define THINFLASH_NR_SECTOR        (16) // only use 16 block in ucore now
// #define THINFLASH_SECTOR_UNIT   (THINFLASH_SECTOR_SIZE / THINFLASH_UNIT_SIZE)
#define THINFLASH_SECTOR_UNIT      (THINFLASH_SECTOR_SIZE >> 1)
#define THINFLASH_SECTOR_UNIT_MASK (0xFFFF)
// #define THINFLASH_SECTOR_RAM    (THINFLASH_SECTOR_SIZE / SECTSIZE)
#define THINFLASH_SECTOR_RAM       (256)

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

#define THINFLASH_SYNC_NO_NEED      (0x00)
#define THINFLASH_SYNC_SHOULD       (0x01)
#define THINFLASH_SYNC_LATE         (0x02)

#define FLASHMAGIC (0xABCE)

void swapper_init();
void swapper_block_changed(int secno);
void swapper_block_sync(int secno);
void swapper_block_late_sync(int secno);
void swapper_block_real_sync();
void swapper_all_block_sync();
int read_from_flash(void *begin, void *end);

int static addr2block(char *pos) {
    assert (pos >= _initrd_begin && pos < _initrd_end);
    int secno = 0;
    goto do_start;
    do {
        secno += 1;
    do_start:
        pos -= THINFLASH_SECTOR_SIZE;
    } while (pos >= _initrd_begin);
    return secno;
}

int static inline ram2block(uint32_t rno) {
    assert (rno >= 0 && rno < 500);
    return rno >> 5;
}

// extern int swapper_thread(void *arg);

// void thinflash_init_struct(struct ide_device* dev);

#endif /*__FLASH_SWAP__H*/
