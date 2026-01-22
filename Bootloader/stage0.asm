[BITS 16]
[ORG 0x7C00]

;===========================
; Stage  0 Bootloader
;===========================
; BIOS loads this sector to 0x7C00
; Real mode(16-bit)
;===========================
start:
    cli                ; 인터럽트 끄기
    cld
    xor ax, ax         ; AX 레지스터를 0으로 초기화
    mov ds, ax         ; 데이터 세그먼트 설정
    mov es, ax         ; 추가 세그먼트 설정
    mov ss, ax         ; 스택 세그먼트 설정
    mov sp, 0x7C00     ; 스택 포인터 설정

    mov [boot_drive], dl
    sti                ; 인터럽트 켜기

    mov si, boot_msg
    call print_string

;===========================
; Load Stage1 (LBA 1) to 0x8000
;===========================
load_stage1:
    mov dl, [boot_drive]

    ; 1 목적지 주소 먼저 세팅
    xor ax, ax
    mov es, ax
    mov bx, 0x8000

    ; 2️ INT 13h 파라미터 세팅
    mov ah, 0x02        ; BIOS Read Sector
    mov al, 1           ; sector count
    mov ch, 0           ; cylinder
    mov cl, 2           ; sector (LBA 1)
    mov dh, 0           ; head

    int 0x13
    jc disk_error

    jmp 0x0000:0x8000

;===========================
; disk error 처리
;===========================
disk_error:
    mov si, disk_msg
    call print_string
    jmp $

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


boot_msg db "Stage 0: Bootloader check\n", 0
disk_msg db "DISK READ ERROR", 0
boot_drive db 0
;===========================
; BOOT signature
;===========================
times 510-($-$$) db 0
dw 0xAA55