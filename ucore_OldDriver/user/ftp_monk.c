#include "file.h"
int main() {
    char test_buf[] = "abcde";
    int fd = open("ftp.txt", O_WRONLY | O_CREAT);
    for (int i = 0; i < 1000 * 100; ++i) {
        write(fd, test_buf, 5);
        yield();
    }
    close(fd);
}
