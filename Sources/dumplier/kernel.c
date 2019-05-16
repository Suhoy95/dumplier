#include "config.h"
#include "stdio.h"

#include "vga-terminal.h"
#include "cpuid.h"

void kernel_main(void)
{
    vga_terminal_initialize();

    do_intel();
}
