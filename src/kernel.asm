[BITS 32]
global _start

extern kernel_main

CODE_SEGMENT equ 0X08
DATA_SEGMENT equ 0X10

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

    call kernel_main
    jmp $

times 512-($ - $$) db 0
message db 'Hello world !', 0
