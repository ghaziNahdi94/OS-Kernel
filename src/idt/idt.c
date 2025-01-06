#include "idt.h"
#include "config.h"
#include "memory/memory.h"
#include "kernel.h"
#include "io/io.h"

extern void idt_load(struct idtr_desc* ptr);
extern void no_interrupt();
extern void int21h();

struct idt_desc idt_descriptors[TOTAL_INTERRUPTIONS];
struct idtr_desc idtr_descriptor;


void no_interrupt_handler() {
    writeByte(0x20, 0x20);
}

void int21h_handler() {
    print("Keyboard pressed !!\n");
    writeByte(0x20, 0x20);
}

void idt_zero() {
    print("Divide by Zero error\n");
}

void idt_set(int interrupt_nbr, void* address) {
    struct idt_desc* desc = &idt_descriptors[interrupt_nbr];
    desc->offset1 = (uint32_t) address & 0x0000FFFF;
    desc->selector = 0x08; // 0x08 = KERNEL_CODE_SEGMENT
    desc->zero = 0x00;
    desc->type_attr = 0xEE; 
    desc->offset2 = (uint32_t) address >> 16;
}

void idt_init() {
    memset(idt_descriptors, 0, sizeof(idt_descriptors));
    idtr_descriptor.limit = sizeof(idt_descriptors) - 1;
    idtr_descriptor.base = (uint32_t) idt_descriptors;

    for(int i = 0; i < TOTAL_INTERRUPTIONS; i++) {
        idt_set(i, no_interrupt);
    }

    idt_set(0, idt_zero);
    idt_set(0x21, int21h);

    //Load the interrupt descriptor table
    idt_load(&idtr_descriptor);
}

