[BITS 16]
[ORG 0x8000]

start:
    cli
    cld

    ; ===== 세그먼트 기준 통일 =====
    push cs
    pop ds
    push cs
    pop es

    ; ===== 스택 이동 (핵심) =====
    xor ax, ax
    mov ss, ax
    mov sp, 0x9000     ; Stage0/1 영역 완전히 벗어난 곳

    sti

    mov si, msg
    call print_string

hang:
    jmp hang

print_string:
    mov ah, 0x0E
.next:
    lodsb
    test al, al
    jz .done
    int 0x10
    jmp .next
.done:
    ret

msg db "Stage 1: Loaded from disk!", 0

times 512-($-$$) db 0
