#ifndef _CONFIG_H
#define _CONFIG_H

#include <stddef.h>
#include <stdint.h>
#include <stdbool.h>

#if defined(__linux__)
#error "You are not using a cross-compiler, you will most certainly run into trouble"
#endif

#if !defined(__i386__)
#error "This tutorial needs to be compiled with a ix86-elf compiler"
#endif


#endif // #ifndef _CONFIG_H
