#include "stdlib.h"

char *itoa(int value, char *str, int base)
{
    char *char_ptr = str;
    char *begin = str;
    char *end;

    if (value < 0)
    {
        *char_ptr = '-';
        char_ptr++;
        begin++;
        value *= -1;
    }

    if (value == 0)
    {
        *char_ptr = '0';
        *(char_ptr + 1) = '\0';
        return str;
    }

    while (value > 0)
    {
        *char_ptr = '0' + value % base;
        char_ptr++;
        value /= base;
    }

    *char_ptr = '\0';
    end = char_ptr - 1;

    while (begin < end)
    {
        char tmp = *begin;
        *begin = *end;
        *end = tmp;
        begin++;
        end--;
    }

    return str;
}