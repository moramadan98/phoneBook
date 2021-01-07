%include "io64.inc"
section	.data
nam db "AmrGamalRamadan",0
res times 16 db 0

section .bss

section .text
global main
main:
    
        ;parameters
        xor r10,r10
        xor r11,r11    
        
        
            ;parameters
            xor rsi,rsi
            xor rdx,rdx
            xor rdi,rdi
            
            mov rsi, nam+3          ; rsi = start pos > [&Buffer + index of start]
            mov rdx, nam+8          ; rdx = end pos ==> [&Buffer + index of end]        
            mov rdi, res            ; rdi = Distnation buffer 
            
            ;Func
            cpyString:
            ;len = (end - start) 
            mov rbx, rdx             
            sub rbx, rsi
            ;inc rbx        
            
            xor rcx,rcx     ; i=0        
           ;for(i=0;i<len;i++)                       
            cpyLoop:
            cmp rcx,rbx                  
            jge exit_cpyString     ; ==> to ignore last char ($ or etc..)
            
            xor rax,rax
            ;des[i]=sor[i]
            mov al,0    
            mov BYTE[rsi + rcx],al
            inc rcx
            jmp cpyLoop        
            exit_cpyString:
            
            ; print the info 
            mov eax, 4
            mov ebx, 1   
            mov ecx, nam
            mov edx, 15     ;bytes to print    
            int 0x80 
 
