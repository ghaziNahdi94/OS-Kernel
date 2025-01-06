[BITS 32]
global _start
global problem

extern kernel_main

CODE_SEGMENT equ 0X08  ;Kernel code segment (for IDT selector)
DATA_SEGMENT equ 0X10  ;Kernel data segment (for IDT selector)

_start:
    mov ax, DATA_SEGMENT
    mov ds, ax
    mov ss, ax
    mov es, ax
    mov fs, ax
    mov gs, ax
    mov ebp, 0x00200000
    mov esp, ebp

    ; Enable A20 Line
    in al, 0x92
    or al, 2
    out 0x92, al

    ; Remap the master PIC
    mov al, 00010001b   ;Init bits
    out 0x20, al        ;Tell master PIC

    mov al, 0x20 ;Interrupt 0x20 is where master ISR should start
    out 0x21, al

    mov al, 00000001b
    out 0x21, al
    ;End Remap master PIC

    call kernel_main
    jmp $

times 512-($ - $$) db 0
message db 'Hello world !', 0
