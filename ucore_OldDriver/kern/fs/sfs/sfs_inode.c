#include <defs.h>
#include <string.h>
#include <stdlib.h>
#include <list.h>
#include <stat.h>
#include <kmalloc.h>
#include <vfs.h>
#include <dev.h>
#include <sfs.h>
#include <inode.h>
#include <iobuf.h>
#include <bitmap.h>
#include <error.h>
#include <assert.h>

static const struct inode_ops sfs_node_dirops;
static const struct inode_ops sfs_node_fileops;

static void
lock_sin(struct sfs_inode *sin) {
    down(&(sin->sem));
}

static void
unlock_sin(struct sfs_inode *sin) {
    up(&(sin->sem));
}

static const struct inode_ops *
sfs_get_ops(uint32_t type) {
    switch (type) {
    case SFS_TYPE_DIR:
        return &sfs_node_dirops;
    case SFS_TYPE_FILE:
        return &sfs_node_fileops;
    }
    panic("invalid file type %d.\n", type);
}

static list_entry_t *
sfs_hash_list(struct sfs_fs *sfs, uint32_t ino) {
    return sfs->hash_list + sin_hashfn(ino);
}

static void
sfs_set_links(struct sfs_fs *sfs, struct sfs_inode *sin) {
    list_add(&(sfs->inode_list), &(sin->inode_link));
    list_add(sfs_hash_list(sfs, sin->ino), &(sin->hash_link));
}

static void
sfs_remove_links(struct sfs_inode *sin) {
    list_del(&(sin->inode_link));
    list_del(&(sin->hash_link));
}

static bool
sfs_block_inuse(struct sfs_fs *sfs, uint32_t ino) {
    // kprintf("sfs->super.blocks is %d and ino is %d\n", sfs->super.blocks, ino);
    if (ino != 0 && ino < sfs->super.blocks) {
        return !bitmap_test(sfs->freemap, ino);
    }
    panic("sfs_block_inuse: called out of range (0, %u) %u.\n", sfs->super.blocks, ino);
}

static int
sfs_block_alloc(struct sfs_fs *sfs, uint32_t *ino_store) {
    int ret;
    if ((ret = bitmap_alloc(sfs->freemap, ino_store)) != 0) {
        return ret;
    }
    assert(sfs->super.unused_blocks > 0);
    sfs->super.unused_blocks --, sfs->super_dirty = 1;
    // kprintf("%s\n", __func__);
    assert(sfs_block_inuse(sfs, *ino_store));
    return sfs_clear_block(sfs, *ino_store, 1);
}

static void
sfs_block_free(struct sfs_fs *sfs, uint32_t ino) {
    // kprintf("%s\n", __func__);
    assert(sfs_block_inuse(sfs, ino));
    bitmap_free(sfs->freemap, ino);
    sfs->super.unused_blocks ++, sfs->super_dirty = 1;
}

static int
sfs_create_inode(struct sfs_fs *sfs, struct sfs_disk_inode *din, uint32_t ino, struct inode **node_store) {
    struct inode *node;
    if ((node = alloc_inode(sfs_inode)) != NULL) {
        vop_init(node, sfs_get_ops(_SFS_INODE_GET_TYPE(din)), info2fs(sfs, sfs));
        struct sfs_inode *sin = vop_info(node, sfs_inode);
        sin->din = din, sin->ino = ino, sin->dirty = 0, sin->reclaim_count = 1;
        sem_init(&(sin->sem), 1);
        *node_store = node;
        return 0;
    }
    return -E_NO_MEM;
}

static struct inode *
lookup_sfs_nolock(struct sfs_fs *sfs, uint32_t ino) {
    struct inode *node;
    list_entry_t *list = sfs_hash_list(sfs, ino), *le = list;
    while ((le = list_next(le)) != list) {
        struct sfs_inode *sin = le2sin(le, hash_link);
        if (sin->ino == ino) {
            node = info2node(sin, sfs_inode);
            if (vop_ref_inc(node) == 1) {
                sin->reclaim_count ++;
            }
            return node;
        }
    }
    // while (1);
    return NULL;
}

int
sfs_load_inode(struct sfs_fs *sfs, struct inode **node_store, uint32_t ino) {
    // while (1);
    lock_sfs_fs(sfs);
    struct inode *node;
    if ((node = lookup_sfs_nolock(sfs, ino)) != NULL) {
        goto out_unlock;
    }

    int ret = -E_NO_MEM;
    struct sfs_disk_inode *din;
    if ((din = kmalloc(sizeof(struct sfs_disk_inode))) == NULL) {
        goto failed_unlock;
    }

    // kprintf("in %s: ino is %d\n", __func__, ino);
    // while (1);

    // kprintf("%s\n", __func__);
    assert(sfs_block_inuse(sfs, ino));
    if ((ret = sfs_rbuf(sfs, din, sizeof(struct sfs_disk_inode), ino, 0)) != 0) {
        goto failed_cleanup_din;
    }

    assert(_SFS_INODE_GET_NLINKS(din) != 0);
    if ((ret = sfs_create_inode(sfs, din, ino, &node)) != 0) {
        goto failed_cleanup_din;
    }
    sfs_set_links(sfs, vop_info(node, sfs_inode));

out_unlock:
    unlock_sfs_fs(sfs);
    *node_store = node;
    return 0;

failed_cleanup_din:
    kfree(din);
failed_unlock:
    unlock_sfs_fs(sfs);
    return ret;
}

static int
sfs_bmap_get_sub_nolock(struct sfs_fs *sfs, uint32_t *entp, uint32_t index, bool create, uint32_t *ino_store) {
    assert(index < SFS_BLK_NENTRY);
    int ret;
    uint32_t ent, ino = 0;
    off_t offset = index * sizeof(uint32_t);
    if ((ent = *entp) != 0) {
        if ((ret = sfs_rbuf(sfs, &ino, sizeof(uint32_t), ent, offset)) != 0) {
            return ret;
        }
        if (ino != 0 || !create) {
            goto out;
        }
    }
    else {
        if (!create) {
            goto out;
        }
        if ((ret = sfs_block_alloc(sfs, &ent)) != 0) {
            return ret;
        }
    }

    if ((ret = sfs_block_alloc(sfs, &ino)) != 0) {
        goto failed_cleanup;
    }
    if ((ret = sfs_wbuf(sfs, &ino, sizeof(uint32_t), ent, offset)) != 0) {
        sfs_block_free(sfs, ino);
        goto failed_cleanup;
    }

out:
    if (ent != *entp) {
        *entp = ent;
    }
    *ino_store = ino;
    return 0;

failed_cleanup:
    if (ent != *entp) {
        sfs_block_free(sfs, ent);
    }
    return ret;
}

static int
sfs_bmap_get_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t index, bool create, uint32_t *ino_store) {
    struct sfs_disk_inode *din = sin->din;
    int ret;
    uint32_t ent, ino;
    if (index < SFS_NDIRECT) {
        if ((ino = din->direct[index]) == 0 && create) {
            if ((ret = sfs_block_alloc(sfs, &ino)) != 0) {
                return ret;
            }
            din->direct[index] = ino;
            sin->dirty = 1;
        }
        // kprintf("index < SFS_NDIRECT\n");
        goto out;
    }

    index -= SFS_NDIRECT;
    if (index < SFS_BLK_NENTRY) {
        ent = din->indirect;
        if ((ret = sfs_bmap_get_sub_nolock(sfs, &ent, index, create, &ino)) != 0) {
            return ret;
        }
        if (ent != din->indirect) {
            assert(din->indirect == 0);
            din->indirect = ent;
            sin->dirty = 1;
        }
        // kprintf("index < SFS_BLK_NENTRY\n");
        goto out;
    }

    index -= SFS_BLK_NENTRY;
    if ((ent = ino) != 0) {
        if ((ret = sfs_bmap_get_sub_nolock(sfs, &ent, index % SFS_BLK_NENTRY, create, &ino)) != 0) {
            return ret;
        }
    }

out:
    assert(ino == 0 || sfs_block_inuse(sfs, ino));
    *ino_store = ino;
    return 0;
}

static int
sfs_bmap_free_sub_nolock(struct sfs_fs *sfs, uint32_t ent, uint32_t index) {
    // kprintf("%s\n", __func__);
    assert(sfs_block_inuse(sfs, ent) && index < SFS_BLK_NENTRY);
    int ret;
    uint32_t ino, zero = 0;
    off_t offset = index * sizeof(uint32_t);
    if ((ret = sfs_rbuf(sfs, &ino, sizeof(uint32_t), ent, offset)) != 0) {
        return ret;
    }
    if (ino != 0) {
        if ((ret = sfs_wbuf(sfs, &zero, sizeof(uint32_t), ent, offset)) != 0) {
            return ret;
        }
        sfs_block_free(sfs, ino);
    }
    return 0;
}

static int
sfs_bmap_free_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t index) {
    struct sfs_disk_inode *din = sin->din;
    int ret;
    uint32_t ent, ino;
    if (index < SFS_NDIRECT) {
        if ((ino = din->direct[index]) != 0) {
            sfs_block_free(sfs, ino);
            din->direct[index] = 0;
            sin->dirty = 1;
        }
        return 0;
    }

    index -= SFS_NDIRECT;
    if (index < SFS_BLK_NENTRY) {
        if ((ent = din->indirect) != 0) {
            if ((ret = sfs_bmap_free_sub_nolock(sfs, ent, index)) != 0) {
                return ret;
            }
        }
        return 0;
    }

    index -= SFS_BLK_NENTRY;
    return 0;
}

static int
sfs_bmap_load_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t index, uint32_t *ino_store) {
    struct sfs_disk_inode *din = sin->din;
    assert(index <= din->blocks);
    int ret;
    uint32_t ino;
    bool create = (index == din->blocks);
    // kprintf("%s\n", __func__);
    if ((ret = sfs_bmap_get_nolock(sfs, sin, index, create, &ino)) != 0) {
        return ret;
    }
    // kprintf("%s\n", __func__);
    assert(sfs_block_inuse(sfs, ino));
    if (create) {
        din->blocks ++;
    }
    if (ino_store != NULL) {
        *ino_store = ino;
    }
    return 0;
}

static int
sfs_bmap_truncate_nolock(struct sfs_fs *sfs, struct sfs_inode *sin) {
    struct sfs_disk_inode *din = sin->din;
    assert(din->blocks != 0);
    int ret;
    if ((ret = sfs_bmap_free_nolock(sfs, sin, din->blocks - 1)) != 0) {
        return ret;
    }
    din->blocks --;
    sin->dirty = 1;
    return 0;
}

static int
sfs_dirent_read_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, int slot, struct sfs_disk_entry *entry) {
    assert(_SFS_INODE_GET_TYPE(sin->din) == SFS_TYPE_DIR && (slot >= 0 && slot < sin->din->blocks));
    // kprintf("%s\n", __func__);
    int ret;
    uint32_t ino;
    if ((ret = sfs_bmap_load_nolock(sfs, sin, slot, &ino)) != 0) {
        return ret;
    }
    // kprintf("%s and ino is %d\n", __func__, ino);
    // if (ino == -1) {
    //     kprintf("%d\n", __LINE__);
    // }
    assert(sfs_block_inuse(sfs, ino));
    if ((ret = sfs_rbuf(sfs, entry, sizeof(struct sfs_disk_entry), ino, 0)) != 0) {
        return ret;
    }
    entry->name[SFS_MAX_FNAME_LEN] = '\0';
    // kprintf("%s finish inner\n", __func__);
    return 0;
}

static int
sfs_dirent_write_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, int slot, uint32_t ino, const char *name) {
	assert(_SFS_INODE_GET_TYPE(sin->din) == SFS_TYPE_DIR && (slot >= 0 && slot <= sin->din->blocks));
	struct sfs_disk_entry *entry;
	if ((entry = kmalloc(sizeof(struct sfs_disk_entry))) == NULL) {
		return -1;
	}
	memset(entry, 0, sizeof(struct sfs_disk_entry));

	if (ino != 0) {
		assert(strlen(name) <= SFS_MAX_FNAME_LEN);
		entry->ino = ino, strcpy(entry->name, name);
	}
	int ret;
	if ((ret = sfs_bmap_load_nolock(sfs, sin, slot, &ino)) != 0) {
		goto wirte_out;
	}
    // kprintf("heheh\n");
	assert(sfs_block_inuse(sfs, ino));
	ret = sfs_wbuf(sfs, entry, sizeof(struct sfs_disk_entry), ino, 0);
wirte_out:
	kfree(entry);
	return ret;
}

#define sfs_dirent_link_nolock_check(sfs, sin, slot, lnksin, name)                  \
    do {                                                                            \
        int err;                                                                    \
        if ((err = sfs_dirent_link_nolock(sfs, sin, slot, lnksin, name)) != 0) {    \
            warn("sfs_dirent_link error: %e.\n", err);                              \
        }                                                                           \
    } while (0)

#define sfs_dirent_unlink_nolock_check(sfs, sin, slot, lnksin)                      \
    do {                                                                            \
        int err;                                                                    \
        if ((err = sfs_dirent_unlink_nolock(sfs, sin, slot, lnksin)) != 0) {        \
            warn("sfs_dirent_unlink error: %e.\n", err);                            \
        }                                                                           \
    } while (0)

static int
sfs_dirent_search_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, const char *name, uint32_t *ino_store, int *slot, int *empty_slot) {
    assert(strlen(name) <= SFS_MAX_FNAME_LEN);
    struct sfs_disk_entry *entry;
    if ((entry = kmalloc(sizeof(struct sfs_disk_entry))) == NULL) {
        return -E_NO_MEM;
    }

#define set_pvalue(x, v)            do { if ((x) != NULL) { *(x) = (v); } } while (0)
    int ret, i, nslots = sin->din->blocks;
    set_pvalue(empty_slot, nslots);
    for (i = 0; i < nslots; i ++) {
        // kprintf("i is %d and nslots is %d\n", i, nslots);
        if ((ret = sfs_dirent_read_nolock(sfs, sin, i, entry)) != 0) {
            goto out;
        }
        // kprintf("%s:sfs_dirent_read_nolock end\n", __func__);
        if (entry->ino == 0) {
            set_pvalue(empty_slot, i);
            continue ;
        }
        if (strcmp(name, entry->name) == 0) {
            set_pvalue(slot, i);
            set_pvalue(ino_store, entry->ino);
            goto out;
        }
    }
#undef set_pvalue
    ret = -E_NOENT;
out:
    kfree(entry);
    // kprintf("%s --- finish\n", __func__);
    return ret;
}

static int
sfs_dirent_findino_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, uint32_t ino, struct sfs_disk_entry *entry) {
    int ret, i, nslots = sin->din->blocks;
    for (i = 0; i < nslots; i ++) {
        if ((ret = sfs_dirent_read_nolock(sfs, sin, i, entry)) != 0) {
            return ret;
        }
        // kprintf("%s\n", __func__);
        if (entry->ino == ino) {
            return 0;
        }
    }
    return -E_NOENT;
}

static int
sfs_lookup_once(struct sfs_fs *sfs, struct sfs_inode *sin, const char *name, struct inode **node_store, int *slot) {
    int ret;
    uint32_t ino;
    lock_sin(sin);
    {
        ret = sfs_dirent_search_nolock(sfs, sin, name, &ino, slot, NULL);
        // kprintf("%s\n", __func__);
    }
    unlock_sin(sin);
    if (ret == 0) {
        ret = sfs_load_inode(sfs, node_store, ino);
    }
    return ret;
}

static int
sfs_opendir(struct inode *node, uint32_t open_flags) {
    switch (open_flags & O_ACCMODE) {
    case O_RDONLY:
        break;
    case O_WRONLY:
    case O_RDWR:
    default:
        return -E_ISDIR;
    }
    if (open_flags & O_APPEND) {
        return -E_ISDIR;
    }
    return 0;
}

static int
sfs_openfile(struct inode *node, uint32_t open_flags) {
    return 0;
}

static int
sfs_close(struct inode *node) {
    return vop_fsync(node);
}

static int
sfs_io_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, void *buf, off_t offset, size_t *alenp, bool write) {
    struct sfs_disk_inode *din = sin->din;
    assert(_SFS_INODE_GET_TYPE(din) != SFS_TYPE_DIR);
    off_t endpos = offset + *alenp, blkoff;
    *alenp = 0;
    if (offset < 0 || offset >= SFS_MAX_FILE_SIZE || offset > endpos) {
        return -E_INVAL;
    }
    if (offset == endpos) {
        return 0;
    }
    if (endpos > SFS_MAX_FILE_SIZE) {
        endpos = SFS_MAX_FILE_SIZE;
    }
    if (!write) {
        if (offset >= din->size) {
            return 0;
        }
        if (endpos > din->size) {
            endpos = din->size;
        }
    }

    int (*sfs_buf_op)(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset);
    int (*sfs_block_op)(struct sfs_fs *sfs, void *buf, uint32_t blkno, uint32_t nblks);
    if (write) {
        sfs_buf_op = sfs_wbuf, sfs_block_op = sfs_wblock;
    }
    else {
        sfs_buf_op = sfs_rbuf, sfs_block_op = sfs_rblock;
    }

    int ret = 0;
    size_t size, alen = 0;
    uint32_t ino;
    uint32_t blkno = offset / SFS_BLKSIZE;
    uint32_t nblks = endpos / SFS_BLKSIZE - blkno;

  //LAB8:EXERCISE1 2009010989 HINT: call sfs_bmap_load_nolock, sfs_rbuf, sfs_rblock,etc. read different kind of blocks in file

    if((blkoff = offset % SFS_BLKSIZE)!= 0) {
        if(nblks){
          size = SFS_BLKSIZE - blkoff;
        }else{
          size  = endpos - offset;
        }
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_buf_op(sfs, buf, size, ino, blkoff)) != 0) {
            goto out;
        }
        // add
        if (write) {
            // kprintf("write secno %d\n", ino);
            int secno = ram2block(ino);
            swapper_block_changed(secno);
            swapper_block_late_sync(secno);
        }
        alen += size;
        if (nblks == 0) {
            goto out;
        }
        buf += size, blkno ++, nblks --;
    }

    size = SFS_BLKSIZE;
    while(nblks != 0){
        if((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if((ret = sfs_block_op(sfs, buf, ino, 1)) != 0) {
            goto out;
        }
        alen += size, buf += size, blkno ++, nblks --;
        // add
        if (write) {
            // kprintf("write secno %d\n", ino);
            int secno = ram2block(ino);
            swapper_block_changed(secno);
            swapper_block_late_sync(secno);
        }
    }

    if((size = endpos % SFS_BLKSIZE) != 0) {
        if ((ret = sfs_bmap_load_nolock(sfs, sin, blkno, &ino)) != 0) {
            goto out;
        }
        if ((ret = sfs_buf_op(sfs, buf, size, ino, 0)) != 0) {
            goto out;
        }
        alen += size;
        // add
        if (write) {
            // kprintf("write secno %d\n", ino);
            int secno = ram2block(ino);
            swapper_block_changed(secno);
            swapper_block_late_sync(secno);
        }
    }
out:
    *alenp = alen;
    if (offset + alen > sin->din->size) {
        sin->din->size = offset + alen;
        sin->dirty = 1;
    }
    return ret;
}

static inline int
sfs_io(struct inode *node, struct iobuf *iob, bool write) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    int ret;
    lock_sin(sin);
    {
        size_t alen = iob->io_resid;
        ret = sfs_io_nolock(sfs, sin, iob->io_base, iob->io_offset, &alen, write);
        if (alen != 0) {
            iobuf_skip(iob, alen);
        }
    }
    unlock_sin(sin);
    return ret;
}

static int
sfs_read(struct inode *node, struct iobuf *iob) {
    return sfs_io(node, iob, 0);
}

static int
sfs_write(struct inode *node, struct iobuf *iob) {
    return sfs_io(node, iob, 1);
}

static int
sfs_fstat(struct inode *node, struct stat *stat) {
    int ret;
    memset(stat, 0, sizeof(struct stat));
    if ((ret = vop_gettype(node, &(stat->st_mode))) != 0) {
        return ret;
    }
    struct sfs_disk_inode *din = vop_info(node, sfs_inode)->din;
    stat->st_nlinks = _SFS_INODE_GET_NLINKS(din);
    stat->st_blocks = din->blocks;
    stat->st_size = din->size;
    return 0;
}

static int
sfs_fsync(struct inode *node) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    int ret = 0;


    // if (sfs->super_dirty) {
    //     lock_sfs_fs(sfs);
    //     if (sfs->super_dirty) {
    //         sfs->super_dirty = 0;
    //         if ((ret = sfs_wbuf(sfs, sfs->freemap, sizeof(uint32_t) * 400, 1, 0)) != 0) {
    //             // sfs_wbuf(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset)
    //             sfs->super_dirty = 1;
    //         }
    //     }
    //     unlock_sfs_fs(sfs);
    // }
    if (sfs->super_dirty) {
        sfs_sync_super(sfs);
        sfs_sync_freemap(sfs);
        swapper_block_changed(0);
    }

    int secno = -1;

    if (sin->dirty) {
        lock_sin(sin);
        {
            if (sin->dirty) {
                sin->dirty = 0;
                if ((ret = sfs_wbuf(sfs, sin->din, sizeof(struct sfs_disk_inode), sin->ino, 0)) != 0) {
                    sin->dirty = 1;
                }
            }
        }
        // int secno = 0;
        // kprintf("in %s: sin->din is %d sin->ino is %d\n", __func__, sin->din, sin->ino);
        int tmp_din = sin->ino;
        while (tmp_din >= 0) {
            secno += 1; // start from `-1`
            tmp_din -= 32;
        }
        unlock_sin(sin);
    }

    // kprintf("secno is %d sfs->super_dirty is %s\n", secno, sfs->super_dirty ? "true" : "false");
    // assert((secno < 0 && !sfs->super_dirty) || (secno >= 0 && sfs->super_dirty));
    if (secno != 0) {
        // kprintf("sync is secno %d\n", secno);
        if (sfs->super_dirty) {
            sfs->super_dirty = 0;
            swapper_block_sync(0);
        }
        if (secno > 0) {
            swapper_block_sync(secno);
        }
    }
    if (secno == 0) {
        swapper_block_sync(0);
    }
    swapper_block_real_sync();
    // kprintf("super->unused_blocks is %d\n", sfs->super.unused_blocks);
    // uint16_t *begin = (uint16_t *)_initrd_begin;
    // int item = 0;
    // for (item = 0; item < 4000; ++item) {
    //     kprintf("0x%04x ", begin[item]);
    // }
    // kprintf("in %s: %d is %s and addr. of sfs is 0x%08x addr. of freemap is 0x%08x\n",
    // __func__, 436, sfs_block_inuse(sfs, 436)?"used":"free", sfs, sfs->freemap);
    return ret;
}

static int
sfs_namefile(struct inode *node, struct iobuf *iob) {
    struct sfs_disk_entry *entry;
    if (iob->io_resid <= 2 || (entry = kmalloc(sizeof(struct sfs_disk_entry))) == NULL) {
        return -E_NO_MEM;
    }

    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);

    int ret;
    char *ptr = iob->io_base + iob->io_resid;
    size_t alen, resid = iob->io_resid - 2;
    vop_ref_inc(node);
    while (1) {
        struct inode *parent;
        if ((ret = sfs_lookup_once(sfs, sin, "..", &parent, NULL)) != 0) {
            goto failed;
        }

        uint32_t ino = sin->ino;
        vop_ref_dec(node);
        if (node == parent) {
            vop_ref_dec(node);
            break;
        }

        node = parent, sin = vop_info(node, sfs_inode);
        assert(ino != sin->ino && _SFS_INODE_GET_TYPE(sin->din) == SFS_TYPE_DIR);

        lock_sin(sin);
        {
            ret = sfs_dirent_findino_nolock(sfs, sin, ino, entry);
        }
        unlock_sin(sin);

        if (ret != 0) {
            goto failed;
        }

        if ((alen = strlen(entry->name) + 1) > resid) {
            goto failed_nomem;
        }
        resid -= alen, ptr -= alen;
        memcpy(ptr, entry->name, alen - 1);
        ptr[alen - 1] = '/';
    }
    alen = iob->io_resid - resid - 2;
    ptr = memmove(iob->io_base + 1, ptr, alen);
    ptr[-1] = '/', ptr[alen] = '\0';
    iobuf_skip(iob, alen);
    kfree(entry);
    return 0;

failed_nomem:
    ret = -E_NO_MEM;
failed:
    vop_ref_dec(node);
    kfree(entry);
    return ret;
}

static int
sfs_getdirentry_sub_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, int slot, struct sfs_disk_entry *entry) {
    int ret, i, nslots = sin->din->blocks;
    // kprintf("%s %s %d din->blocks is %d\n", __FILE__, __func__, __LINE__, nslots);
    for (i = 0; i < nslots; i ++) {
        if ((ret = sfs_dirent_read_nolock(sfs, sin, i, entry)) != 0) {
            // kprintf("%s %s %d can not read entry\n", __FILE__, __func__, __LINE__);
            return ret;
        }
        // kprintf("%s\n", __func__);
        if (entry->ino != 0) {
            if (slot == 0) {
                return 0;
            }
            slot --;
        }
    }
    return -E_NOENT;
}

static int
sfs_getdirentry(struct inode *node, struct iobuf *iob) {
    struct sfs_disk_entry *entry;
    if ((entry = kmalloc(sizeof(struct sfs_disk_entry))) == NULL) {
        // kprintf("%s %s %d -E_NO_MEM\n", __FILE__, __func__, __LINE__);
        return -E_NO_MEM;
    }

    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);

    int ret, slot;
    off_t offset = iob->io_offset;
    if (offset < 0 || offset % sfs_dentry_size != 0) {
        // kprintf("%s %s %d -E_INVAL\n", __FILE__, __func__, __LINE__);
        kfree(entry);
        return -E_INVAL;
    }
    if ((slot = offset / sfs_dentry_size) > sin->din->blocks) {
        // kprintf("%s %s %d -E_NOENT\n", __FILE__, __func__, __LINE__);
        kfree(entry);
        return -E_NOENT;
    }
    lock_sin(sin);
    if ((ret = sfs_getdirentry_sub_nolock(sfs, sin, slot, entry)) != 0) {
        unlock_sin(sin);
        // kprintf("%s %s %d can not find!!! slot is %d\n", __FILE__, __func__, __LINE__, slot);
        goto out;
    }
    unlock_sin(sin);
    // kprintf("sfs_getdirentry\n");
    ret = iobuf_move(iob, entry->name, sfs_dentry_size, 1, NULL);
out:
    kfree(entry);
    return ret;
}

static int
sfs_reclaim(struct inode *node) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);

    int  ret = -E_BUSY;
    uint32_t ent;
    lock_sfs_fs(sfs);
    assert(sin->reclaim_count > 0);
    if ((-- sin->reclaim_count) != 0 || inode_ref_count(node) != 0) {
        goto failed_unlock;
    }
    if (_SFS_INODE_GET_NLINKS(sin->din) == 0) {
        if ((ret = vop_truncate(node, 0)) != 0) {
            goto failed_unlock;
        }
    }
    if (sin->dirty) {
        if ((ret = vop_fsync(node)) != 0) {
            goto failed_unlock;
        }
    }
    sfs_remove_links(sin);
    unlock_sfs_fs(sfs);

    if (_SFS_INODE_GET_NLINKS(sin->din) == 0) {
        sfs_block_free(sfs, sin->ino);
        if ((ent = sin->din->indirect) != 0) {
            sfs_block_free(sfs, ent);
        }
    }
    kfree(sin->din);
    vop_kill(node);
    return 0;

failed_unlock:
    unlock_sfs_fs(sfs);
    return ret;
}

static int
sfs_gettype(struct inode *node, uint32_t *type_store) {
    struct sfs_disk_inode *din = vop_info(node, sfs_inode)->din;
    switch (_SFS_INODE_GET_TYPE(din)) {
    case SFS_TYPE_DIR:
        *type_store = S_IFDIR;
        return 0;
    case SFS_TYPE_FILE:
        *type_store = S_IFREG;
        return 0;
    case SFS_TYPE_LINK:
        *type_store = S_IFLNK;
        return 0;
    }
    panic("invalid file type %d.\n", _SFS_INODE_GET_TYPE(din));
}

static int
sfs_tryseek(struct inode *node, off_t pos) {
    if (pos < 0 || pos >= SFS_MAX_FILE_SIZE) {
        return -E_INVAL;
    }
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    if (pos > sin->din->size) {
        return vop_truncate(node, pos);
    }
    return 0;
}
static int
sfs_truncfile(struct inode *node, off_t len) {
    if (len < 0 || len > SFS_MAX_FILE_SIZE) {
        return -E_INVAL;
    }
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    struct sfs_disk_inode *din = sin->din;

    int ret = 0;
    uint32_t nblks, tblks = ROUNDUP_DIV_2N(len, SFS_BLKSIZE_SHIFT);
    if (din->size == len) {
        assert(tblks == din->blocks);
        return 0;
    }

    lock_sin(sin);
    nblks = din->blocks;
    if (nblks < tblks) {
        while (nblks != tblks) {
            if ((ret = sfs_bmap_load_nolock(sfs, sin, nblks, NULL)) != 0) {
                goto out_unlock;
            }
            nblks ++;
        }
    }
    else if (tblks < nblks) {
        while (tblks != nblks) {
            if ((ret = sfs_bmap_truncate_nolock(sfs, sin)) != 0) {
                goto out_unlock;
            }
            nblks --;
        }
    }
    assert(din->blocks == tblks);
    din->size = len;
    sin->dirty = 1;

out_unlock:
    unlock_sin(sin);
    return ret;
}

static int
sfs_lookup(struct inode *node, char *path, struct inode **node_store) {
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    assert(*path != '\0' && *path != '/');
    vop_ref_inc(node);
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    if (_SFS_INODE_GET_TYPE(sin->din) != SFS_TYPE_DIR) {
        vop_ref_dec(node);
        return -E_NOTDIR;
    }
    struct inode *subnode;
    int ret = sfs_lookup_once(sfs, sin, path, &subnode, NULL);

	vop_ref_dec(node);
    if (ret != 0) {
        return ret;
    }
    *node_store = subnode;
    return 0;
}

static struct sfs_disk_inode *
alloc_disk_inode(unsigned short type) {
    struct sfs_disk_inode *din = kmalloc(sizeof(struct sfs_disk_inode));
    din->size = 0;
    din->__type__ = type;
    din->__nlinks__ = 0;
    din->blocks = 0;
    memset(din->direct, 0, SFS_NDIRECT * sizeof(uint32_t));
    din->indirect = 0;
}

static int
sfs_create(struct inode *node, const char *name, bool excl, struct inode **node_store) {
    // kprintf("ready to create a file\n");
    if (strlen(name) > SFS_MAX_FNAME_LEN) {
        return -1;
    }
    // sfs_create_inode(struct sfs_fs *sfs, struct sfs_disk_inode *din, uint32_t ino, struct inode **node_store)
    struct sfs_fs *sfs = fsop_info(vop_fs(node), sfs);
    struct sfs_inode *sin = vop_info(node, sfs_inode);
    int ret;
    // sfs_create_inode(struct sfs_fs *sfs, struct sfs_disk_inode *din, uint32_t ino, struct inode **node_store)
    struct inode *node_tmp = NULL;
    int empty_slot = -1;
    lock_sfs_fs(sfs);
    // sfs_block_alloc(struct sfs_fs *sfs, uint32_t *ino_store)
    sfs_dirent_search_nolock(sfs, sin, name, node_tmp, NULL, &empty_slot);
    // kprintf("%s\n", __func__);
    if (node_tmp) {
        node_store = node_tmp;
    } else {
        if (empty_slot < 0) {
            kprintf("no slot\n");
            return -1;
        }
        struct sfs_disk_inode *din = alloc_disk_inode(SFS_TYPE_FILE);
        int ino;
        sfs_block_alloc(sfs, &ino);
        // kprintf("%s\n", __func__);
        // if (sfs_block_inuse(sfs, ino)) {
        //     kprintf("be sure use\n");
        // } else {
        //     kprintf("not used\n");
        // }
        sfs_create_inode(sfs, din, ino, &node_tmp);
        ++ (din->__nlinks__);
        sfs_set_links(sfs, vop_info(node_tmp, sfs_inode));
        // kprintf("0x%08x\n", node_tmp);
        // sfs_namefile(struct inode *node, struct iobuf *iob)
        // sfs_dirent_write_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, int slot, uint32_t ino, const char *name)
        sfs_dirent_write_nolock(sfs, sin, empty_slot, ino, name);
        // ++ sin->din->blocks;
        int secno = ram2block(ino);
        swapper_block_changed(secno);
        swapper_block_late_sync(secno);
        // kprintf("sin->ino is %d\n", sin->ino);
        sin->dirty = 1;
        lock_sin(sin);
        {
            if (sin->dirty) {
                sin->dirty = 0;
                if ((ret = sfs_wbuf(sfs, sin->din, sizeof(struct sfs_disk_inode), sin->ino, 0)) != 0) {
                    sin->dirty = 1;
                }
            }
        }
        unlock_sin(sin);
        secno = ram2block(sin->ino);
        swapper_block_changed(secno);
        swapper_block_late_sync(secno);
        vop_info(node_tmp, sfs_inode)->dirty = 1;
        sfs->super_dirty = 1;
        // if ((ret = sfs_bmap_load_nolock(sfs, sin, slot, &ino)) != 0) {
        //     return ret;
        // }
        // assert(sfs_block_inuse(sfs, ino));
        // kprintf("ino is %d\n", ino);
        // kprintf("empty slot is %d\n", empty_slot);
        // kprintf("father ino is %d\n", sin->ino);
        *node_store = node_tmp;
    }
    unlock_sfs_fs(sfs);
    // sfs_create_inode(sfs, struct sfs_disk_inode *din, uint32_t ino, struct inode **node_store)
    return 0;
}

// static int
// sfs_dirent_search_nolock(struct sfs_fs *sfs, struct sfs_inode *sin, const char *name, uint32_t *ino_store, int *slot, int *empty_slot) {
//     assert(strlen(name) <= SFS_MAX_FNAME_LEN);
//     struct sfs_disk_entry *entry;
//     if ((entry = kmalloc(sizeof(struct sfs_disk_entry))) == NULL) {
//         return -E_NO_MEM;
//     }
//
// #define set_pvalue(x, v)            do { if ((x) != NULL) { *(x) = (v); } } while (0)
//     int ret, i, nslots = sin->din->blocks;
//     set_pvalue(empty_slot, nslots);
//     for (i = 0; i < nslots; i ++) {
//         if ((ret = sfs_dirent_read_nolock(sfs, sin, i, entry)) != 0) {
//             goto out;
//         }
//         if (entry->ino == 0) {
//             set_pvalue(empty_slot, i);
//             continue ;
//         }
//         if (strcmp(name, entry->name) == 0) {
//             set_pvalue(slot, i);
//             set_pvalue(ino_store, entry->ino);
//             goto out;
//         }
//     }
// #undef set_pvalue
//     ret = -E_NOENT;
// out:
//     kfree(entry);
//     return ret;
// }

// int
// sfs_load_inode(struct sfs_fs *sfs, struct inode **node_store, uint32_t ino) {
//     lock_sfs_fs(sfs);
//     struct inode *node;
//     if ((node = lookup_sfs_nolock(sfs, ino)) != NULL) {
//         goto out_unlock;
//     }
//      通过ino找到inode
//
//     int ret = -E_NO_MEM;
//     struct sfs_disk_inode *din;
//     if ((din = kmalloc(sizeof(struct sfs_disk_inode))) == NULL) {
//         goto failed_unlock;
//     }
//     造出sfs_disk_inode *din
//
//     assert(sfs_block_inuse(sfs, ino));
//     // sfs_rbuf(struct sfs_fs *sfs, void *buf, size_t len, uint32_t blkno, off_t offset)
//     if ((ret = sfs_rbuf(sfs, din, sizeof(struct sfs_disk_inode), ino, 0)) != 0) {
//         goto failed_cleanup_din;
//     }
//     应该是初始化, 稍微查一下rbuf的参数语义
//
//     assert(_SFS_INODE_GET_NLINKS(din) != 0);
//     if ((ret = sfs_create_inode(sfs, din, ino, &node)) != 0) {
//         goto failed_cleanup_din;
//     }
//     创建inode
//     sfs_set_links(sfs, vop_info(node, sfs_inode));
//     加入链中
//
// out_unlock:
//     unlock_sfs_fs(sfs);
//     *node_store = node;
//     return 0;
//
// failed_cleanup_din:
//     kfree(din);
// failed_unlock:
//     unlock_sfs_fs(sfs);
//     return ret;
// }

static int
sfs_dir_create(struct inode *node, const char *name, bool excl, struct inode **node_store) {
    kprintf("ready to create a dir\n");
    return 0;
}

static const struct inode_ops sfs_node_dirops = {
    .vop_magic                      = VOP_MAGIC,
    .vop_open                       = sfs_opendir,
    .vop_close                      = sfs_close,
    .vop_fstat                      = sfs_fstat,
    .vop_fsync                      = sfs_fsync,
    .vop_namefile                   = sfs_namefile,
    .vop_getdirentry                = sfs_getdirentry,
    .vop_reclaim                    = sfs_reclaim,
    .vop_gettype                    = sfs_gettype,
    .vop_lookup                     = sfs_lookup,
    // sfs expands
    .vop_create                     = sfs_create,
};

static const struct inode_ops sfs_node_fileops = {
    .vop_magic                      = VOP_MAGIC,
    .vop_open                       = sfs_openfile,
    .vop_close                      = sfs_close,
    .vop_read                       = sfs_read,
    .vop_write                      = sfs_write,
    .vop_fstat                      = sfs_fstat,
    .vop_fsync                      = sfs_fsync,
    .vop_reclaim                    = sfs_reclaim,
    .vop_gettype                    = sfs_gettype,
    .vop_tryseek                    = sfs_tryseek,
    .vop_truncate                   = sfs_truncfile,
};
