section .bss
    numbuf resb 16        ; buffer for input
    outbuf resb 32        ; buffer for output
    outlen resq 1

section .text
    global _start

_start:
    ; ---- read number from user ----
    mov rax, 0            ; sys_read
    mov rdi, 0
    mov rsi, numbuf
    mov rdx, 16
    syscall

    ; convert ASCII -> integer
    mov rsi, numbuf
    call atoi
    mov rsi, rax          ; keep number in RSI

    ; ---- call procedure to double ----
    call double_it        ; RSI = RSI * 2

    ; ---- print result ----
    call itoa

    mov rax, 1            ; sys_write
    mov rdi, 1
    mov rsi, outbuf
    mov rdx, [outlen]
    syscall

    ; exit
    mov rax, 60
    xor rdi, rdi
    syscall

; ---------------- procedure ----------------
double_it:
    add rsi, rsi          ; RSI = RSI * 2
    ret                   ; return to caller

; ---------------- atoi ----------------
; input: rsi = buffer with ASCII digits
; output: rax = integer
atoi:
    xor rax, rax
.next:
    mov bl, [rsi]
    cmp bl, 10            ; newline?
    je .done
    cmp bl, 0
    je .done
    sub bl, '0'
    imul rax, rax, 10
    add rax, rbx
    inc rsi
    jmp .next
.done:
    ret

; ---------------- itoa ----------------
; input: rsi = integer
; output: outbuf = ascii+newline
itoa:
    mov rax, rsi
    mov rdi, outbuf + 31
    mov byte [rdi], 10
    mov rcx, 1
    dec rdi
    cmp rax, 0
    jne .loop
    mov byte [rdi], '0'
    inc rcx
    jmp .done
.loop:
    xor rdx, rdx
    mov rbx, 10
    div rbx
    add dl, '0'
    mov [rdi], dl
    dec rdi
    inc rcx
    test rax, rax
    jnz .loop
    inc rdi
.done:
    mov rsi, rdi
    mov rdi, outbuf
    mov rbx, rcx
    mov [outlen], rbx
.copy:
    mov al, [rsi]
    mov [rdi], al
    inc rsi
    inc rdi
    dec rcx
    jnz .copy
    ret
