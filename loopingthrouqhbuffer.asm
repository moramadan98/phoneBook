section .data
  
s1: db "Amr", 10, "Gamal", 10, "Ramadan", 0

 
section  .text
  global  main

main:
    mov rbp, rsp; for correct debugging
  
    mov rdi,0
    
    mov r8,rdi;start
loop:

    cmp byte [s1+rdi], 0
    je done
    cmp byte [s1+rdi],10
    je update
   labe:
     
    mov     eax,  4 ;print 
    mov     ebx,  1 ; bytes to print
    lea     ecx,  [s1+rdi]
    mov     edx,  1
    int     80h
    ; increment the loop counter
    add     rdi, 1
    
   jmp loop
   update:  
     ;rdi end r8 start
     ;gamal will put his code here
    mov r8,rdi
    add r8,1
    jmp labe
       
done:
; exit the program

mov   eax,  1
mov   ebx,  0
int   80h
