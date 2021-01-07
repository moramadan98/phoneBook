section .data
  
s1: db "Amr", 10, "Gamal", 10, "Ramadan", 10,0

 
section  .text
  global  main

main:
   mov rbp, rsp; for correct debugging  
   mov rdi,0    
   mov r8,rdi;start
   mov r9,0 ;counter
   mov r12,2 ;index
   mov r13,0 ;detectiom
loop:
          cmp byte [s1+rdi],10
          je updatecounter
label2: 
          cmp byte [s1+rdi], 0
          je done
       
labe:   
    mov     eax,  4 ;print 
    mov     ebx,  1 ; bytes to print
    lea     ecx,  [s1+rdi]
    mov     edx,  1
    int     80h
    ; increment the loop counter
    add     rdi, 1
    
   jmp loop
updatecounter:
    add r9,1
    cmp r9,r12
    je gamal
    mov r8,rdi
    add r8,1
    jmp label2
gamal:  
    mov r13,1
    ;gamal code
    jmp done
       
done:
; exit the program

mov   eax,  1
mov   ebx,  0
int   80h