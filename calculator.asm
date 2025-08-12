section .data
    ; Define strings for user prompts and output
    msg1 db "Enter the first digit (0-9): ", 0
    len1 equ $ - msg1
    
    msg2 db "Enter the second digit (0-9): ", 0
    len2 equ $ - msg2
    
    msg3 db "The sum is: ", 0
    len3 equ $ - msg3

section .bss
    ; Reserve space to store the user's input and the final result
    input1 resb 2      ; 1 byte for the digit, 1 for the newline
    input2 resb 2      ; 1 byte for the digit, 1 for the newline
    result_str resb 3  ; Buffer for the final sum as a string (max "18\0")

section .text
    global _start

_start:
    ; --- PROMPT AND READ THE FIRST DIGIT ---
    ; sys_write to display the prompt
    mov eax, 4         ; sys_write system call number
    mov ebx, 1         ; file descriptor 1 (stdout)
    mov ecx, msg1      ; pointer to the message string
    mov edx, len1      ; length of the message
    int 0x80           ; call kernel
    
    ; sys_read to get the input
    mov eax, 3         ; sys_read system call number
    mov ebx, 0         ; file descriptor 0 (stdin)
    mov ecx, input1    ; buffer to store the input
    mov edx, 2         ; number of bytes to read (digit + newline)
    int 0x80           ; call kernel

    ; --- PROMPT AND READ THE SECOND DIGIT ---
    ; sys_write to display the prompt
    mov eax, 4         ; sys_write system call number
    mov ebx, 1         ; file descriptor 1 (stdout)
    mov ecx, msg2      ; pointer to the message string
    mov edx, len2      ; length of the message
    int 0x80           ; call kernel
    
    ; sys_read to get the input
    mov eax, 3         ; sys_read system call number
    mov ebx, 0         ; file descriptor 0 (stdin)
    mov ecx, input2    ; buffer to store the input
    mov edx, 2         ; number of bytes to read
    int 0x80           ; call kernel

    ; --- CONVERT ASCII TO NUMBER AND PERFORM ADDITION ---
    mov al, [input1]   ; Load the first digit's ASCII character into AL
    sub al, '0'        ; Subtract ASCII '0' to convert it to its numerical value
    
    mov bl, [input2]   ; Load the second digit's ASCII character into BL
    sub bl, '0'        ; Subtract ASCII '0' to convert it to its numerical value
    
    add al, bl         ; Add the two numbers. The sum (max 18) is now in AL.

    ; --- CONVERT THE SUM TO A STRING FOR PRINTING ---
    ; This is the same logic as the previous example, adapted for the new sum
    mov edi, result_str + 2 ; Set pointer to the end of the buffer
    mov byte [edi], 0       ; Add a null terminator
    
convert_loop:
    movzx eax, al      ; Move the sum from AL into EAX, zero-extending it
    mov bl, 10         ; Divisor is 10
    div bl             ; Divide EAX by 10. Quotient in AL, remainder in AH.
    
    add ah, '0'        ; Convert the remainder (a digit) to its ASCII character
    dec edi            ; Move the string pointer back one position
    mov [edi], ah      ; Store the ASCII character in the buffer
    
    mov al, al         ; Use the quotient from the division as the new number
    cmp al, 0          ; Check if the quotient is 0
    jne convert_loop   ; If not, loop again

    ; --- PRINT THE FINAL RESULT ---
    ; sys_write to print "The sum is: "
    mov eax, 4         ; sys_write system call number
    mov ebx, 1         ; file descriptor 1 (stdout)
    mov ecx, msg3      ; pointer to the message
    mov edx, len3      ; length of the message
    int 0x80           ; call kernel

    ; sys_write to print the converted sum
    mov eax, 4         ; sys_write system call number
    mov ebx, 1         ; file descriptor 1 (stdout)
    mov ecx, edi       ; pointer to the start of the converted string
    mov edx, 2         ; length of the result string (max "18")
    int 0x80           ; call kernel

    ; --- EXIT THE PROGRAM ---
    mov eax, 1         ; sys_exit system call number
    xor ebx, ebx       ; exit code 0
    int 0x80           ; call kernel
