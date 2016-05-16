#include <ulib.h>
#include <stdio.h>
#include <string.h>
#include <dir.h>
#include <file.h>
#include <stat.h>
#include <dirent.h>
#include <unistd.h>

int main(int argc, char const *argv[]) {
    if (argc != 3) {
        cprintf("usage: ....\n");
        return 0;
    }
    int fd = open(argv[1], O_WRONLY);
    write(fd, argv[2], strlen(argv[2]));
    close(fd);
    return 0;
}
