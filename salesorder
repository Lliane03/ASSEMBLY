; sales64_single_line.asm
; Tutorialspoint compatible: read 3 quantities in one line

section .data
    prompt      db "Enter quantities for items A B C (separated by spaces): ",0
    prompt_len  equ $-prompt

    total_msg   db "Total Sales Order = "
    total_msg_len equ $-total_msg

    newline     db 10

    price1      dq 50
    price2      dq 30
    price3      dq 20

    total       dq 0

section .bss
    inputbuf    resb 32
    outbuf      resb 32

section .text
    global _start

_start:
    ; --- print prompt ---
    mov rax,1
    mov rdi,1
    mov rsi,prompt
    mov rdx,prompt_len
    syscall

    ; --- read input line ---
    mov rax,0
    mov rdi,0
    mov rsi,inputbuf
    mov rdx,32
    syscall

    mov rsi,inputbuf
    call parse_three_numbers   ; RAX,RBX,RCX = quantities

    ; --- compute total ---
    mov rdx,[price1]
    imul rax,rdx
    mov r8,rax

    mov rdx,[price2]
    imul rbx,rdx
    add r8,rbx

    mov rdx,[price3]
    imul rcx,rdx
    add r8,rcx

    mov [total],r8

    ; --- print newline ---
    mov rax,1
    mov rdi,1
    mov rsi,newline
    mov rdx,1
    syscall

    ; --- print total label ---
    mov rax,1
    mov rdi,1
    mov rsi,total_msg
    mov rdx,total_msg_len
    syscall

    ; --- convert total to string ---
    mov rax,[total]
    call int_to_ascii        ; RSI = pointer, RDX = length

    ; --- print result ---
    mov rax,1
    mov rdi,1
    syscall

    ; --- exit ---
    mov rax,60
    xor rdi,rdi
    syscall


; =====================================================
; parse_three_numbers
; IN:  RSI = pointer to input line
; OUT: RAX, RBX, RCX = quantities
; =====================================================
parse_three_numbers:
    xor rax,rax
    xor rbx,rbx
    xor rcx,rcx
    xor r8,r8       ; temp
    mov r9,0        ; counter: 0=A,1=B,2=C

.next_char:
    mov dl,[rsi]
    cmp dl,10       ; newline -> end
    je .done
    cmp dl,0
    je .done
    cmp dl,' '
    je .next_number
    sub dl,'0'
    imul r8,r8,10
    add r8,rdx
    jmp .inc_ptr

.next_number:
    cmp r9,0
    je .store_a
    cmp r9,1
    je .store_b
    cmp r9,2
    je .store_c
    jmp .inc_ptr

.store_a:
    mov rax,r8
    xor r8,r8
    inc r9
    jmp .inc_ptr

.store_b:
    mov rbx,r8
    xor r8,r8
    inc r9
    jmp .inc_ptr

.store_c:
    mov rcx,r8
    xor r8,r8
    inc r9
    jmp .inc_ptr

.inc_ptr:
    inc rsi
    jmp .next_char

.done:
    ; store last number if not yet stored
    cmp r9,0
    je .store_a
    cmp r9,1
    je .store_b
    cmp r9,2
    je .store_c
    ret


; =====================================================
; int_to_ascii (64-bit)
; IN:  RAX = number
; OUT: RSI = pointer, RDX = length
; =====================================================
int_to_ascii:
    mov rcx,10
    mov rdi,outbuf
    add rdi,31
    mov byte [rdi],0
    mov rdx,0

    cmp rax,0
    jne .digits
    mov byte [rdi-1],'0'
    mov rsi,rdi-1
    mov rdx,1
    ret

.digits:
.loop:
    xor rdx,rdx
    div rcx
    add dl,'0'
    dec rdi
    mov [rdi],dl
    inc rdx
    test rax,rax
    jnz .loop

    mov rsi,rdi
    ret
