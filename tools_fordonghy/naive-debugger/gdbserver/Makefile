PRG := naive-debugger
OBJS = gdb-remote.o gdb-server.o uglylogging.o naive_mips.o

CFLAGS+=-g -std=gnu99 -I../src
LDFLAGS=-L..

# libusb location
LDFLAGS+=`pkg-config --libs libusb-1.0`
CFLAGS+=`pkg-config --cflags libusb-1.0`

all: $(PRG)

$(PRG): $(OBJS)
	$(CC) -o $@  $^ $(LDFLAGS)

clean:
	rm -rf $(OBJS)
	rm -rf $(PRG)

.PHONY: clean all
