#include "vga-terminal.h"
#include "strings.h"

/*                         STATIC TYPES AND CONSTANSTS                        */
enum vga_color {
    VGA_COLOR_BLACK = 0,
    VGA_COLOR_BLUE = 1,
    VGA_COLOR_GREEN = 2,
    VGA_COLOR_CYAN = 3,
    VGA_COLOR_RED = 4,
    VGA_COLOR_MAGENTA = 5,
    VGA_COLOR_BROWN = 6,
    VGA_COLOR_LIGHT_GREY = 7,
    VGA_COLOR_DARK_GREY = 8,
    VGA_COLOR_LIGHT_BLUE = 9,
    VGA_COLOR_LIGHT_GREEN = 10,
    VGA_COLOR_LIGHT_CYAN = 11,
    VGA_COLOR_LIGHT_RED = 12,
    VGA_COLOR_LIGHT_MAGENTA = 13,
    VGA_COLOR_LIGHT_BROWN = 14,
    VGA_COLOR_WHITE = 15,
};

static const size_t VGA_WIDTH = 80;
static const size_t VGA_HEIGHT = 25;

/*                               VGA VARIABLES                                */
static size_t vga_terminal_row;
static size_t vga_terminal_column;
static uint8_t vga_terminal_color;
static uint16_t* vga_terminal_buffer;

/*                        STATIC FUNCTIONS DECLARATIONS                       */
static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg);
static inline uint16_t vga_entry(unsigned char uc, uint8_t color);
static void vga_terminal_putchar(char c);

/*                              EXPORT FUNCTIONS                              */
void vga_terminal_initialize(void)
{
    vga_terminal_row = 0;
    vga_terminal_column = 0;

    /*
     * "But we are hackers,
     *          and hackers have black terminals with green font colors."
     *                                                          - John Nunemaker
     */
    vga_terminal_color = vga_entry_color(VGA_COLOR_LIGHT_GREEN, VGA_COLOR_BLACK);
    vga_terminal_buffer = (uint16_t*) 0xB8000;
    for (size_t y = 0; y < VGA_HEIGHT; y++) {
        for (size_t x = 0; x < VGA_WIDTH; x++) {
            const size_t index = y * VGA_WIDTH + x;
            vga_terminal_buffer[index] = vga_entry(' ', vga_terminal_color);
        }
    }
}

void vga_terminal_writestring(const char* str)
{
    size_t data_len = strlen(str);
    for (size_t i = 0; i < data_len; i++)
        vga_terminal_putchar(str[i]);
}

/*                              STATIC FUNCTIONS                              */
static inline uint8_t vga_entry_color(enum vga_color fg, enum vga_color bg)
{
    return fg | bg << 4;
}

static inline uint16_t vga_entry(unsigned char uc, uint8_t color)
{
    return (uint16_t) uc | (uint16_t) color << 8;
}

static void vga_terminal_putchar(char c)
{
    if (c == '\n') {
        ++vga_terminal_row;
        vga_terminal_column = 0;

        if (vga_terminal_row == VGA_HEIGHT) {
            vga_terminal_row = 0;
        }
        return;
    }

    const size_t index = vga_terminal_row * VGA_WIDTH + vga_terminal_column;
    vga_terminal_buffer[index] = vga_entry(c, vga_terminal_color);

    if (++vga_terminal_column == VGA_WIDTH) {
        vga_terminal_column = 0;

        if (++vga_terminal_row == VGA_HEIGHT) {
            vga_terminal_row = 0;
        }
    }
}
