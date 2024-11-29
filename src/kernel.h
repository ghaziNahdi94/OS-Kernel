#ifndef KERNEL_H
#define KERNEL_H

    #include <stdint.h>
    #include <stddef.h>

    #define VGA_WIDTH 80
    #define VGA_HEIGHT 20

    void init_terminal();
    void kernel_main();
    uint16_t terminal_make_char(char character, char color);
    size_t strlen(const char* string);
    void terminal_put_char(int column, int row, char character, char color);
    void terminal_print_char(char character, char color);
    void print(char* string);
#endif