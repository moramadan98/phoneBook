section .data
  
s1: db "Amr", 10, "Gamal", 10, "Ramadan", 0

 
section  .text
  global  main

main:
     mov rdi,0  
loop:

    cmp byte [s1+rdi], 0
    je done
    mov byte [s1+rdi],0
    add     rdi, 1
    jmp loop      
done:
mov   eax,  1 ; exit the program
mov   ebx,  0
int   80h