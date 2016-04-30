#include "nand_mtd.h"

void flash_write_cmd(unsigned char cmd) {
    return ;
}

void flash_write_addr(unsigned char addr) {
    return ;
}

void flash_enable_chip(int enable) {
    return ;
}

unsigned char flash_read_byte() {
    return 0;
}

void flash_write_byte(unsigned char byte) {
    return ;
}

void flash_wait_rdy() {
    return ;
}

void flash_write_full_addr (unsigned int row, unsigned int col) {
    return ;
}

int flash_ecc_calculate (const unsigned char *dat, size_t sz,
              unsigned char *ecc_code)
{

    return -1;
}

int flash_ecc_correct (unsigned char *dat, unsigned char *read_ecc,
            unsigned char *isnull)
{

    return -1;
}

/* size of data buffer>=pg_size, size of spare buffer>=spare_size */
int flash_read_page (struct nand_chip * chip, unsigned page_id,
          unsigned char *data, unsigned char *spare,
          int *eccStatus)
{

    return -1;
}

/* spare data only contain user data, ecc auto-appended */
int flash_write_page (struct nand_chip * chip, unsigned pageId,
           const unsigned char *data, unsigned dataLength,
           const unsigned char *spare, unsigned spareLength)
{
    return -1;
}

int flash_erase_block (struct nand_chip * chip, unsigned blkID) {
    return -1;
}
/* return 0 if bad */
int flash_check_block (struct nand_chip * chip, unsigned blkID) {
    return -1;
}
/* mark bad blk */
int flash_mark_badblock (struct nand_chip * chip, unsigned blkID) {
    return -1;
}

struct nand_chip flash_chip = {
    .write_cmd = flash_write_cmd,
	.write_addr = flash_write_addr,
	.enable_chip = flash_enable_chip,
	.read_byte = flash_read_byte,
	.write_byte = flash_write_byte,
	.wait_rdy = flash_wait_rdy,
	.write_full_addr = flash_write_full_addr,
	.ecc_calculate = flash_ecc_calculate,
	.ecc_correct = flash_ecc_correct,
	.read_page = flash_read_page,
	.write_page = flash_write_page,
	.erase_block = flash_erase_block,
	.check_block = flash_check_block,
	.mark_badblock = flash_mark_badblock,
    .ecclayout = NULL,
    .badblock_offset = 0x00,
	.spare_size = 0,
	.blk_cnt = 64,
	.pages_per_blk = 4,
	.blk_shift = 0,
	.pg_size = 131072 >> 2,
	.pg_size_shift = 0,
};

struct nand_chip *get_nand_chip() {
    return &flash_chip;
}

int check_nandflash() {
    return 1;
}
