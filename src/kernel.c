
#include "kernel.h"
#include "idt/idt.h"
#include "io/io.h"
#include <stdint.h>
#include <stddef.h>

uint16_t* video_mem = (uint16_t*) (0xB8000);
int row = 0;
int column = 0;
char color = 11;

extern void problem();

void kernel_main() {
    init_terminal();
    print("OS starting....\n");

    // Initialize the  interrupt descriptor table
    idt_init();

    for(int i=0; i<40000;i++){}
    // Enable the system interrupts
    enable_interrupts();
}

void init_terminal() {
    row = 0;
    column = 0;

    for(int line=0; line<VGA_HEIGHT; line++) {
        for(int column=0; column<VGA_WIDTH; column++) {
            video_mem[line * VGA_WIDTH + column] = terminal_make_char(' ', 1);
        }
    }
}

uint16_t terminal_make_char(char character, char color) {
    return (color << 8) | character;
}

size_t strlen(const char* string) {
    size_t length = 0;
    while(string[length]) {
        length++;
    }

    return length;
}

void terminal_put_char(int column, int row, char character, char color) {
    video_mem[row * VGA_WIDTH + column] = terminal_make_char(character, color);    
}

void terminal_print_char(char character, char color) {
    if(character == '\n') {
        row++;
        column = 0;
        return;
    }

    terminal_put_char(column, row, character, color);
    column++;

    if(column == VGA_WIDTH) {
        row++;
        column = 0;
    }
}

void print(char* string) {
    for(int i=0; i<strlen(string); i++) {
        terminal_print_char(string[i], color);
    }
}