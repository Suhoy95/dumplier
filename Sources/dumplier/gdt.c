#include "check.h"

/*                         STATIC TYPES AND CONSTANSTS                        */

const uint16_t gdtr_size = 4;
const uint32_t gdtr_offset = NULL;

typedef struct gdt_entry_simplified
{
    uint32_t base;
    uint32_t limit:20;
    uint32_t access:8;
    uint32_t flags:4;
} gdt_entry_simplified_t;


typedef enum gdt_access

/*                                  VARIABLES                                 */

/*                        STATIC FUNCTIONS DECLARATIONS                       */

/**
 * \param target A pointer to the 8-byte GDT entry
 * \param source An arbitrary structure describing the GDT entry
 */
void encodeGdtEntry(uint8_t *target, gdt_entry_simplified_t source)
{
    // Check the limit to make sure that it can be encoded
    if ((source.limit > 65536) && ((source.limit & 0xFFF) != 0xFFF)) {
        kerror("You can't do that!");
    }
    if (source.limit > 65536) {
        // Adjust granularity if required
        source.limit = source.limit >> 12;
        target[6] = 0xC0;
    } else {
        target[6] = 0x40;
    }

    // Encode the limit
    target[0] = source.limit & 0xFF;
    target[1] = (source.limit >> 8) & 0xFF;
    target[6] |= (source.limit >> 16) & 0xF;

    // Encode the base
    target[2] = source.base & 0xFF;
    target[3] = (source.base >> 8) & 0xFF;
    target[4] = (source.base >> 16) & 0xFF;
    target[7] = (source.base >> 24) & 0xFF;

    // And... Type
    target[5] = source.type;
}

/*                              EXPORT FUNCTIONS                              */

/*                              STATIC FUNCTIONS                              */
