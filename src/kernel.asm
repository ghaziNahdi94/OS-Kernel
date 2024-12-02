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

    call clearAll
    mov ecx, message
    call print
    jmp $

print:
    mov ebx, 0xB8000
.iteration_print:
    mov al, byte [ecx]
    cmp al, 0
    je .finish_print
    mov byte [ebx], al
    mov al, 11
    mov byte [ebx + 1], al
    add ebx, 2
    inc ecx
    jmp .iteration_print
.finish_print:
    ret

clearAll:
    mov ebx, 0xB8000
    mov dl, 0
.iteration_clearAll:
    cmp dl, 400
    je .finish_clearAll
    mov al, ' '
    mov byte [ebx], al
    mov al, 1
    mov byte [ebx + 1], al
    add ebx, 2
    inc dl
    jmp .iteration_clearAll
.finish_clearAll:
    ret


    ;call kernel_main
    jmp $

times 512-($ - $$) db 0
message db 'Hello world !', 0
