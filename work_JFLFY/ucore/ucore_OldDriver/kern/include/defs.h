#ifndef __LIBS_DEFS_H__
#define __LIBS_DEFS_H__

#ifndef NULL
#define NULL ((void *)0)
#endif


#define ENOMEM          12      /* Out of Memory */
#define EINVAL          22      /* Invalid argument */
#define ENOSPC          28      /* No space left on device */
#define CHAR_BIT        8
#define JFFS2_ACL_VERSION               0x0001

typedef unsigned gfp_t;
#define __force __attribute__((force))
#define __GFP_IO        ((__force gfp_t)0x40u)
#define __GFP_FS        ((__force gfp_t)0x80u)
#define __GFP_RECLAIM ((__force gfp_t)(0x400000u|0x2000000u))
#define GFP_KERNEL    (__GFP_RECLAIM | __GFP_IO | __GFP_FS)

#define __always_inline inline __attribute__((always_inline))
#define __noinline __attribute__((noinline))
#define __noreturn __attribute__((noreturn))

static inline void * ERR_PTR(long error) {
    return (void *) error;
}

/* Represents true-or-false values */
typedef int bool;

/* Explicitly-sized versions of integer types */
typedef char int8_t;
typedef unsigned char uint8_t;
// jffs2-for-transplant
typedef unsigned short u16;
typedef unsigned char u8;
//typedef short int16_t;
//typedef unsigned short uint16_t;
// #define uint16_t uint16_t_ERROR_TYPE
// #define int16_t int16_t_ERROR_TYPE
// jffs2-for-transplant
// typedef uint16_t uint16_t_ERROR_TYPE;
// typedef int16_t int16_t_ERROR_TYPE;

// jffs2-for-transplant
typedef short int16_t;
typedef unsigned short uint16_t;

typedef int int32_t;
typedef unsigned int uint32_t;
typedef long long int64_t;
typedef unsigned long long uint64_t;
// Transplant
typedef uint32_t mode_t;
typedef uint32_t dev_t;

//jffs2-for-transplant
// typedef struct {
//     uint32_t v32;
// } __attribute__((packed)) jint32_t;
//
// typedef struct {
//     uint32_t m;
// } __attribute__((packed)) jmode_t;
//
// typedef struct {
//     uint16_t v16;
// } __attribute__((packed)) jint16_t;
typedef long long loff_t;
typedef unsigned short umode_t;
typedef unsigned char u_char;

/* *
 * Pointers and addresses are 32 bits long.
 * We use pointer types to represent addresses,
 * uintptr_t to represent the numerical values of addresses.
 * */
typedef int32_t intptr_t;
typedef uint32_t uintptr_t;

/* size_t is used for memory object sizes */
typedef uintptr_t size_t;

/* off_t is used for file offsets and lengths */
typedef intptr_t off_t;

/* used for page numbers */
typedef size_t ppn_t;

/* *
 * Rounding operations (efficient when n is a power of 2)
 * Round down to the nearest multiple of n
 * */
/*
#define ROUNDDOWN(a, n) ({                                          \
            size_t __a = (size_t)(a);                               \
            (typeof(a))(__a - __a % (n));                           \
        })
*/
#define ROUNDDOWN_2N(a,n) (( ((size_t)a) >> (n) ) << (n))

/* Round up to the nearest multiple of n */
#define ROUNDUP_2N(a, n) ({                                            \
            size_t __n = (size_t)(n);                               \
            (typeof(a))(ROUNDDOWN_2N((size_t)(a) + (1<<__n) - 1, __n));     \
        })


/* Round up the result of dividing of n */
#define ROUNDUP_DIV_2N(a, n) ({                                        \
uint32_t __n = (1<<(uint32_t)(n));                           \
(typeof(a))(((a) + __n - 1) >> (n));                     \
})


/* Return the offset of 'member' relative to the beginning of a struct type */
#define offsetof(type, member)                                      \
    ((size_t)(&((type *)0)->member))

/* *
 * to_struct - get the struct from a ptr
 * @ptr:    a struct pointer of member
 * @type:   the type of the struct this is embedded in
 * @member: the name of the member within the struct
 * */
#define to_struct(ptr, type, member)                               \
    ((type *)((char *)(ptr) - offsetof(type, member)))

#endif /* !__LIBS_DEFS_H__ */
