section .asm

global readByte
global readWord
global writeByte
global writeWord

readByte:
    push ebp
    mov ebp, esp

    xor eax, eax
    mov edx, [ebp + 8]
    in al, dx

    pop ebp
    ret

readWord:
    push ebp
    mov ebp, esp

    xor eax, eax
    mov edx, [ebp + 8]
    in ax, dx

    pop ebp
    ret

writeByte:
    push ebp
    mov ebp, esp

    mov edx, [ebp + 12]
    mov eax, [ebp + 8]
    out dx, al

    pop ebp
    ret

writeWord:
    push ebp
    mov ebp, esp
    mov edx, [ebp + 12]
    mov eax, [ebp + 8]
    out dx, ax

    pop ebp
    ret