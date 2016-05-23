#ifndef __THIN_FLASH__H
#define __THIN_FLASH__H

#include "thumips.h"
#include "ide.h"
#include "assert.h"

#define THINFLASH_SIZE        (8 << 20)
#define THINFLASH_SECTOR_SIZE (128 << 10)
#define THINFLASH_UNIT_SIZE   (2)
#define THINFLASH_NR_SECTOR   (64)
#define THINFLASH_SECTOR_UNIT (THINFLASH_SECTOR_SIZE / THINFLASH_UNIT_SIZE)

#define THINFLASH_BASE (uint16_t*)(0xBE000000)

bool check_inittf();

void thinflash_init_struct(struct ide_device* dev);

#endif /*__THIN_FLASH__H*/
