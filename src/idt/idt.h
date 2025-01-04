#ifndef IDT_H
#define IDT_H

#include <stdint.h>

struct idt_desc
{
    uint16_t offset1;       // Bits 0 - 15
    uint16_t selector;      //Selector of the GDT or LDT
    uint8_t zero;           //Unused and set to zero
    uint8_t type_attr;      //Descriptor Type and attributes  (P - DPL - S - TYPE) flags
    uint16_t offset2;       //Bits 16 - 31
} __attribute__((packed));

struct idtr_desc
{
    uint16_t limit;         //Size of the descriptor table - 1
    uint32_t base;          //Base Address of the start of the interruption descriptor table
} __attribute__((packed));;

void idt_init();

#endif