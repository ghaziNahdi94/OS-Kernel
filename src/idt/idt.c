#include "idt.h"
#include "config.h"
#include "memory/memory.h"
#include "kernel.h"

struct idt_desc idt_descriptors[TOTAL_INTERRUPTIONS];
struct idtr_desc idtr_descriptor;

extern void idt_load(struct idtr_desc* ptr);

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

    idt_set(0, idt_zero);

    //Load the interrupt descriptor table
    idt_load(&idtr_descriptor);
}

