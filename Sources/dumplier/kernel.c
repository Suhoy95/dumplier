#include "config.h"
#include "stdio.h"
#include "vga-terminal.h"

void kernel_main(void)
{
    vga_terminal_initialize();

    while (true) {
        printf("Hello, kernel World!\n");
    }
}
