#ifndef __FLASH_SWAP__H
#define __FLASH_SWAP__H

#include "thumips.h"
#include "assert.h"

void swapper_init();
void swapper_block_changed(int secno);
// extern int swapper_thread(void *arg);

// void thinflash_init_struct(struct ide_device* dev);

#endif /*__FLASH_SWAP__H*/
