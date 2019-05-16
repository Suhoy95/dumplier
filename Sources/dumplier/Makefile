# Put your Cross-Compiler here
CC=~/bin/gcc-8.3.0-i686-elf/bin/i686-elf-gcc
AS=~/bin/gcc-8.3.0-i686-elf/bin/i686-elf-as
CFLAGS=-std=gnu99 -ffreestanding -O2 -Wall -Wextra

OBJS= boot.o kernel.o vga-terminal.o strings.o

all: dumplier.bin

dumplier.bin: $(OBJS)
	$(CC) -T linker.ld -o $@ -ffreestanding -O2 -nostdlib $^ -lgcc

clean:
	rm -rf *.o dumplier.bin
