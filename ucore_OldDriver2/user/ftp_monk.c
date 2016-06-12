#include "file.h"
int main() {
    int fd = open("ftp.txt", O_WRONLY | O_CREAT | O_EXCL);
    int i;
    for (int i = 0; i < 10000; ++i) {
        write(fd, "01234567", 8);
    }
    close(fd);
}
