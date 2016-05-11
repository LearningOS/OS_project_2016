#ifndef __USER_LIBS_FILE_H__
#define __USER_LIBS_FILE_H__

#include <defs.h>

#define O_RDONLY            0           // open for reading only
#define O_WRONLY            1           // open for writing only
#define O_RDWR              2           // open for reading and writing
// then or in any of these:
#define O_CREAT             0x00000004  // create file if it does not exist
#define O_EXCL              0x00000008  // error if O_CREAT and the file exists
#define O_TRUNC             0x00000010  // truncate file upon open
#define O_APPEND            0x00000020  // append on each write
// additonal related definition
#define O_ACCMODE           3           // mask for O_RDONLY / O_WRONLY / O_RDWR

struct stat;

int open(const char *path, uint32_t open_flags);
int close(int fd);
int read(int fd, void *base, size_t len);
int write(int fd, void *base, size_t len);
int seek(int fd, off_t pos, int whence);
int fstat(int fd, struct stat *stat);
int fsync(int fd);
int dup(int fd);
int dup2(int fd1, int fd2);
int pipe(int *fd_store);
int mkfifo(const char *name, uint32_t open_flags);

void print_stat(const char *name, int fd, struct stat *stat);

#endif /* !__USER_LIBS_FILE_H__ */
