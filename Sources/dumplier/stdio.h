#ifndef _STDIO_H
#define _STDIO_H

#include "config.h"
#include "vga-terminal.h"

#define printf vga_terminal_writestring

#endif // _STDIO_H