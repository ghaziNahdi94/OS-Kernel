section .asm

global idt_load
idt_load:
    push ebp
    mov ebp, esp

    mov ebx, [ebp+8]   ;+8 pointer to the first argument of the function (+4 pointer to the return value of the function)
    lidt [ebx]

    pop ebp
    ret
