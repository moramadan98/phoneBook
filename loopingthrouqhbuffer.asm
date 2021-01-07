section .data
   bufsize dd      1024
s1: db "amr gamal ramadan", 0
section .bss
   buf:     resb    1024
section  .text
  global  main

main:
    mov rbp, rsp; for correct debugging
  ;  mov rbp, rsp; for correct debugging
    ; open the file provided form cli in read mode
  ;  mov edi, 0
  ;  pop   rbx
  ;  pop   rbx
  ;  pop   rbx
  ;  mov   eax,  5
  ;  mov   ecx,  0
  ;  int   80h
    ; write the contents in to the buffer 'buf'
 ;   mov     eax,  3
 ;   mov     ebx,  eax
 ;   mov     ecx,  s1
 ;   mov     edx,  [bufsize]
 ;   int     80h
mov rdi,0
    ; write the value at buf+edi to STDOUT
    ; if equal to whitespace, done
    mov r8,rdi;start
loop:

    cmp byte [s1+rdi], 0
    je done
    cmp byte [s1+rdi],0x20
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
     ;code to get start and end of each word
     ;gamal code
    mov r8,rdi
    add r8,1
    jmp labe
       
done:
; exit the program

mov   eax,  1
mov   ebx,  0
int   80h