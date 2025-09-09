.done_count:
    mov eax, 4           ; sys_write
    mov ebx, 1           ; stdout
    int 0x80
    popa
    ret

; read_num - read number from stdin, results in eax
read_num:
    push ebx
    push ecx
    push edx

    mov eax, 3           ; sys_read
    mov ebx, 0           ; stdin
    mov ecx, buffer
    mov edx, 16          ; max bytes
    int 0x80

    ; Convert string to number (in eax)
    mov esi, buffer
    xor eax, eax         ; clear result

.convert_loop:
    mov bl, [esi]
    cmp bl, 10           ; newline?
    je .done_convert
    cmp bl, '0'
    jb .done_convert
    cmp bl, '9'
    ja .done_convert

    sub bl, '0'
    imul eax, eax, 10
    add eax, ebx
    inc esi
    jmp .convert_loop

.done_convert:
    pop edx
    pop ecx
    pop ebx
    ret

; read_op - reads one digit operation from stdin (1-4)
read_op:
    push ebx
    push ecx
    push edx

    mov eax, 3
    mov ebx, 0
    mov ecx, buffer
    mov edx, 2           ; read one char + newline
    int 0x80

    mov al, [buffer]
    sub al, '0'          ; convert ASCII to number

    pop edx
    pop ecx
    pop ebx
    ret

; print_num - prints number in eax (unsigned integer)
print_num:
    pusha
    mov edi, buffer + 15 ; point to end of buffer (buffer is 16 bytes)
    mov ecx, 0           ; digit count

    mov ebx, 10          ; divisor for decimal

    cmp eax, 0
    jne .convert_digits
    ; if eax==0 just print '0'
    mov byte [edi], '0'
    inc ecx
    jmp .print_digits

.convert_digits:
.convert_loop:
    xor edx, edx
    div ebx              ; eax = eax / 10, edx = eax % 10
    add dl, '0'
    dec edi
    mov [edi], dl
    inc ecx
    test eax, eax
    jnz .convert_loop

.print_digits:
    mov eax, 4           ; sys_write
    mov ebx, 1           ; stdout
    mov ecx, edi         ; pointer to start of number string
    mov edx, ecx
    add edx, ecx         ; wrong, must count digits properly

    ; Actually, we have digit count in ecx,
    ; edx = length = ecx
    mov edx, ecx
    int 0x80

    ; Cleanup
    popa
    ret
