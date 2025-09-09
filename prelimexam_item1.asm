section .data

msg db 'Student Name: Angel Julliane I. Mangubat', 0xA
db 'Course: Bachelor of Science in Computer Science', 0xA
db 'Subject Code: 9407-AY 24-26 Computer Organization with Assembly Language', 0xA
db 'Subject Schedule: Tuesday, 2:00pm-5:00pm', 0xA
db 'School: University of Perpetual Help System - DALTA', 0xA
len equ $ - msg              ; Message length

section .text

global _start

_start:
; Write message to stdout
mov eax, 4      ; sys_write
mov ebx, 1      ; file descriptor 1 = stdout
mov ecx, msg    ; address of message
mov edx, len    ; length of message
int 0x80        ; call kernel

; Exit program
mov eax, 1      ; sys_exit
xor ebx, ebx    ; exit code 0
int 0x80
