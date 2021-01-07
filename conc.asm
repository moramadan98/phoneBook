%include "io64.inc"
section .data
buffer:  times 10 db 0
a:   db "amer"       ; Length of each is 4, so add 4.
b:   db "rana"

section .text
global CMAIN
CMAIN:
   mov rax, [a]
mov [buffer], rax
mov rax, [b]
mov [buffer+4], rax

   mov eax, 4
   mov ebx, 1
   mov ecx, buffer
   mov edx, 10
   int  0x80