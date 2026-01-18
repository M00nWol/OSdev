;===========================
; Stage  0 Bootloader
;===========================
; BIOS loads this sector to 0x7C00
; Real mode(16-bit)
;===========================

[BITS 16]
[ORG 0x7C00]

start:
    cli                ; 인터럽트 끄기
    xor ax, ax         ; AX 레지스터를 0으로 초기화
    mov ds, ax         ; 데이터 세그먼트 설정
    mov es, ax         ; 추가 세그먼트 설정
    mov ss, ax         ; 스택 세그먼트 설정
    mov sp, 0x7C00     ; 스택 포인터 설정
    sti                ; 인터럽트 켜기

    mov si, message
    call print_string

hang:
    jmp hang            ; 여기서 멈춤


;===========================
; BIOS TTY 출력
;===========================
print_string:
    mov ah, 0x0E        ; BIOS teletype
.next:
    lodsb               ; AL = [SI]
    cmp al, 0
    je .done
    int 0x10
    jmp .next
.done:
    ret


message db "HELLO FROM MY OS", 0


;===========================
; BOOT signature
;===========================
times 510-($-$$) db 0
dw 0xAA55