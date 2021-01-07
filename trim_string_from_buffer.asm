%include "io64.inc"
section	.data
loadedBuffer db "AmrGamalRamadan",0
trimmedString times 16 db 0

section .bss

section .text
global main
main:
    mov rbp, rsp; for correct debugging
    
        ;parameters
        xor rsi,rsi
        xor rdx,rdx
        xor rdi,rdi
        
        mov rsi, loadedBuffer+3          ; rsi = start pos > [&Buffer + index of start]
        mov rdx, loadedBuffer+8          ; rdx = end pos ==> [&Buffer + index of end]        
        mov rdi, trimmedString            ; rdi = Distnation buffer 
        
        ;Func
        trimString:
        ;len = (end - start) ==> to ignore last char ($ or etc..)
        mov rbx, rdx             
        sub rbx, rsi
        ;inc rbx        
        
        xor rcx,rcx     ; i=0        
       ;for(i=0;i<len;i++)                       
        trimLoop:
        cmp rcx,rbx                  
        jge exit_trimString
        
        xor rax,rax
        ;des[i]=sor[i]
        mov al, BYTE[rsi + rcx]   
        mov BYTE[rcx + rdi],al
        inc rcx
        jmp trimLoop        
        exit_trimString:
        
        ; print the info 
        mov eax, 4
        mov ebx, 1   
        mov ecx, trimmedString
        mov edx, 10     ;bytes to print    
        int 0x80 
 
