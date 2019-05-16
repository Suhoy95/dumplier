#include "config.h"
#include "stdio.h"
#include "vga-terminal.h"

void kernel_main(void)
{
    vga_terminal_initialize();

    for (size_t i = 0; i < 30; i++) {
        printf("Hello %d, kernel %s!\n", i, "World");
    }
}
