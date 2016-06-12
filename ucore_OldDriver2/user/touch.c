#include <ulib.h>
#include <stdio.h>
#include <string.h>
#include <dir.h>
#include <file.h>
#include <stat.h>
#include <dirent.h>
#include <unistd.h>

int main(int argc, char const *argv[]) {
    if (argc != 2) {
        cprintf("usage: .....\n");
        return 0;
    }
    int fd = open(argv[1], O_RDONLY | O_CREAT);
    // cprintf("before close\n");
    close(fd);
    // cprintf("before cat\n");
    // cat(open(argv[1], O_RDONLY));
    return 0;
}
