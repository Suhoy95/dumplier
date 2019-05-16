#ifndef _VGA_TERMINAL_H
#define _VGA_TERMINAL_H

#include "config.h"

void vga_terminal_initialize(void);
void vga_terminal_printf(const char *data, ...);

#endif // _VGA_TERMINAL_H
