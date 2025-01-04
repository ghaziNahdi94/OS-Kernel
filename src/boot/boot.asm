ORG 0x7c00
BITS 16

CODE_SEGMENT equ gdt_code - gdt_start
DATA_SEGMENT equ gdt_data - gdt_start

_start:
    jmp short start
    nop

times 33 db 0               ;Some of machines bios override the first 33 bits of the bootloader so we set all at 0


start:
    jmp 0:_go

_go:
    cli                     ;Clear interrupt flags (critical operation)
    mov ax, 0x0
    mov ds, ax
    mov es, ax

    mov ax, 0x00
    mov ss, ax
    mov sp, 0x7c00
    sti                     ;Enable interrupt flags

load_protected_mode:
    ; Load GDT
    cli
    lgdt [gdt_ptr]

    ; Set the PE (Protection Enable) bit in CR0 to enter Protected Mode

    mov eax, cr0
    or eax, 0x1
    mov cr0, eax
    jmp CODE_SEGMENT:load32
    jmp $

gdt_start:
gdt_null:
    dd 0x0
    dd 0x0

gdt_code:  ;CS should be point to this
    ; Segment descriptor for code segment
    dw 0xffff           ; Limit 0-15 bits
    dw 0                ; Base 0-15 bits
    db 0                ; Base 16-23 bits
    db 0x9a             ; Access rights
    db 11001111b        ; Limit 16-19 bits
    db 0                ; Base 24-31 bits

gdt_data: ;DS, SS, ES, FS , GS
    ; Segment descriptor for data segment
    dw 0xffff           ; Limit 0-15 bits
    dw 0                ; Base 0-15 bits
    db 0                ; Base 16-23 bits
    db 0x92             ; Access rights
    db 11001111b        ; Limit 16-19 bits
    db 0                ; Base 24-31 bits

gdt_end:

gdt_ptr:
    dw gdt_end - gdt_start - 1  ;Size of the GDT
    dd gdt_start                ;Offset (GDT address)

[BITS 32]
load32:
    mov eax, 1
    mov ecx, 100
    mov edi, 0x0100000
    call ata_lba_read
    jmp CODE_SEGMENT:0x100000

;Driver to read from the hard disk  ==>> TO LOAD THE KERNEL CODE TO THE RAM
ata_lba_read:
    mov ebx, eax ;Backup the LBA
    ;Send the highest 8 bits of the lba to hard disk controller
    shr eax, 24
    or eax, 0xE0       ;Select the master drive
    mov dx, 0x1F6
    out dx, al
    ;Finish sending the highest 8 bits of the lba 

    ;Send the total sectors to read
    mov eax, ecx
    mov dx, 0x1F2
    out dx, al
    ;Finish sending the total sectors to read

    ;Send more bits of the LBA
    mov eax, ebx ; Restore the backup LBA
    mov dx, 0x1F3
    out dx, al
    ;Finish sending more bits of the LBA

    ;Send more bits of the LBA
    mov dx, 0x1F4
    mov eax, ebx    ; Restore the backup LBA
    shr eax, 8
    out dx, al
    ;Finish sending more bits of the LBA

    ;Send upper 16 bits of the LBA
    mov dx, 0x1F5
    mov eax, ebx    ; Restore the backup LBA
    shr eax, 16
    out dx, al
    ;Finish sending upper 16 bits of the LBA

    mov dx, 0x1F7
    mov al, 0x20
    out dx, al

.next_sector:
    push ecx

;Checking if we need to read
.try_again:
    mov dx, 0x1F7
    in al, dx
    test al, 8
    jz .try_again

;We need to read 256 words  at a time
    mov ecx, 256
    mov dx, 0x1F0
    rep insw 
    pop ecx
    loop .next_sector
    ;End of reading sectors into memory
    ret

times 510-($ - $$) db 0
dw 0XAA55