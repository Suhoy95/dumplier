#include "strings.h"

size_t strlen(const char* str)
{
    char* char_ptr = str;
    while (*char_ptr != '\0') {
        ++char_ptr;
    }
    return char_ptr - str;
}

